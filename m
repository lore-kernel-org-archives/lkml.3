Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3FYSfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:35:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3FYSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:35:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Schnall <mischnal@google.com>, Eric Dumazet <edumazet@google.com>,
        Bernhard Beck <bbeck@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/27] tcp: fix tcp_md5_hash_skb_data()
Date: Tue, 25 Jun 2013 11:35:25 -0700
Message-Id: <20130625183518.416599403@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 54d27fcb338bd9c42d1dfc5a39e18f6f9d373c2e ]

TCP md5 communications fail [1] for some devices, because sg/crypto code
assume page offsets are below PAGE_SIZE.

This was discovered using mlx4 driver [2], but I suspect loopback
might trigger the same bug now we use order-3 pages in tcp_sendmsg()

[1] Failure is giving following messages.

huh, entered softirq 3 NET_RX ffffffff806ad230 preempt_count 00000100,
exited with 00000101?

[2] mlx4 driver uses order-2 pages to allocate RX frags

Reported-by: Matt Schnall <mischnal@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Bernhard Beck <bbeck@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3055,8 +3055,11 @@ int tcp_md5_hash_skb_data(struct tcp_md5
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const struct skb_frag_struct *f = &shi->frags[i];
-		struct page *page = skb_frag_page(f);
-		sg_set_page(&sg, page, skb_frag_size(f), f->page_offset);
+		unsigned int offset = f->page_offset;
+		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
+
+		sg_set_page(&sg, page, skb_frag_size(f),
+			    offset_in_page(offset));
 		if (crypto_hash_update(desc, &sg, skb_frag_size(f)))
 			return 1;
 	}


