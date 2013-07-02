Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3GBLTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:19:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3GBLH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:07:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Bernhard Beck <bbeck@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 05/50] tcp: fix tcp_md5_hash_skb_data()
Date: Tue,  2 Jul 2013 12:06:53 +0100
Message-Id: <1372763258-20664-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 54d27fcb338bd9c42d1dfc5a39e18f6f9d373c2e upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1a763b7..75936ee 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3294,8 +3294,11 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
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
-- 
1.8.1.2

