Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3FZCuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:50:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab3FZCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bernhard Beck" <bbeck@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Matt Schnall" <mischnal@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.607250960@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [12/26] tcp: fix tcp_md5_hash_skb_data()
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fe381c2..ec8b4b7e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3037,8 +3037,11 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
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

