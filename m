Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaF1Rrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:47:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbaF1Rrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 35/43] skbuff: add an api to orphan frags
Date: Sat, 28 Jun 2014 10:46:26 -0700
Message-Id: <20140628174451.386819756@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit a353e0ce0fd42d8859260666d1e9b10f2abd4698 upstream.

Many places do
       if ((skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY))
		skb_copy_ubufs(skb, gfp_mask);
to copy and invoke frag destructors if necessary.
Add an inline helper for this.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/skbuff.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1674,6 +1674,22 @@ static inline void skb_orphan(struct sk_
 }
 
 /**
+ *	skb_orphan_frags - orphan the frags contained in a buffer
+ *	@skb: buffer to orphan frags from
+ *	@gfp_mask: allocation mask for replacement pages
+ *
+ *	For each frag in the SKB which needs a destructor (i.e. has an
+ *	owner) create a copy of that frag and release the original
+ *	page by calling the destructor.
+ */
+static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
+{
+	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY)))
+		return 0;
+	return skb_copy_ubufs(skb, gfp_mask);
+}
+
+/**
  *	__skb_queue_purge - empty a list
  *	@list: list to empty
  *


