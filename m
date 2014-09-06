Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbaIFEjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 00:39:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIFEjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 00:39:05 -0400
Date: Fri, 05 Sep 2014 21:39:02 -0700 (PDT)
Message-Id: <20140905.213902.1124686922505260665.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: prashant@broadcom.com, bpoirier@suse.de, mchan@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140905.171306.1460013939580748402.davem@davemloft.net>
References: <1409960135.18724.33.camel@prashant>
	<1409961810.26422.149.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140905.171306.1460013939580748402.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Sep 2014 21:39:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 05 Sep 2014 17:13:06 -0700 (PDT)

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 05 Sep 2014 17:03:30 -0700
> 
>> Instead of this private helper (and pretty limited one btw), we could
>> add a core function, that would build skbs with order-0 fragments.
>> 
>> Instead of skb_linearize(), I guess many call sites could instead use
>> this new helper.
>> 
>> Because as you said, skb_linearize() of one 64KB GSO packet can ask
>> order-5 allocations, and this generally does not work reliably.
> 
> xen-netback could make use of this helper too.

I was curious what it might look like so I cobbled the following
completely untested patch together :-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index da1378a..eba0ad6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -955,6 +955,67 @@ struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 EXPORT_SYMBOL(skb_copy);
 
 /**
+ *	skb_copy_pskb	-	copy sk_buff into a paged skb
+ *	@oskb: buffer to copy
+ *	@gfp_mask: allocation priority
+ *
+ *	Normalize a paged skb into one that maximally uses order
+ *	zero pages in it's fragment array.  This is used to canonicalize
+ *	spaghetti SKBs that use the page array inefficiently (f.e. only
+ *	one byte per page frag).
+ */
+
+struct sk_buff *skb_copy_pskb(const struct sk_buff *oskb, gfp_t gfp_mask)
+{
+	unsigned int data_len = oskb->data_len;
+	int offset, npages, i;
+	struct sk_buff *skb;
+
+	npages = (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+	if (npages > MAX_SKB_FRAGS)
+		return NULL;
+
+	skb = __alloc_skb(skb_end_offset(oskb), gfp_mask,
+			  skb_alloc_rx_flag(oskb), NUMA_NO_NODE);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, skb_headroom(oskb));
+	skb_put(skb, skb_headlen(oskb));
+	skb_copy_from_linear_data(oskb, skb->data, skb->len);
+
+	copy_skb_header(skb, oskb);
+
+	skb->truesize += data_len;
+	offset = skb_headlen(oskb);
+	for (i = 0; i < npages; i++) {
+		struct page *page = alloc_page(gfp_mask);
+		unsigned int chunk;
+		u8 *vaddr;
+
+		if (!page) {
+			kfree(skb);
+			skb = NULL;
+			break;
+		}
+
+		chunk = min_t(unsigned int, data_len, PAGE_SIZE);
+		skb_fill_page_desc(skb, i, page, 0, chunk);
+
+		vaddr = kmap_atomic(page);
+		skb_copy_bits(oskb, offset, vaddr, chunk);
+		kunmap_atomic(vaddr);
+
+		offset += chunk;
+		data_len -= chunk;
+		skb->data_len += chunk;
+	}
+
+	return skb;
+}
+EXPORT_SYMBOL(skb_copy_pskb);
+
+/**
  *	__pskb_copy_fclone	-  create copy of an sk_buff with private head.
  *	@skb: buffer to copy
  *	@headroom: headroom of new skb
