Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaELBnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34715 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbaELBnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:20 -0400
Message-Id: <20140512003202.548150410@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Bernhard Beck <bbeck@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 046/143] tcp: fix tcp_md5_hash_skb_data()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6232462..fc18410 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2826,7 +2826,11 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const struct skb_frag_struct *f = &shi->frags[i];
-		sg_set_page(&sg, f->page, f->size, f->page_offset);
+		unsigned int offset = f->page_offset;
+		struct page *page = f->page + (offset >> PAGE_SHIFT);
+
+		sg_set_page(&sg, page, f->size,
+			    offset_in_page(offset));
 		if (crypto_hash_update(desc, &sg, f->size))
 			return 1;
 	}
-- 
1.7.12.2.21.g234cd45.dirty



