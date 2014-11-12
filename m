Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaKLBT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:19:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaKLBT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:19:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karl Beldan <karl.beldan@rivierawaves.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 013/319] net: tso: fix unaligned access to crafted TCP header in helper API
Date: Wed, 12 Nov 2014 10:12:31 +0900
Message-Id: <20141112010954.866824591@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Beldan <karl.beldan@rivierawaves.com>

[ Upstream commit a63ba13eec092b70d4e5522d692eaeb2f9747387 ]

The crafted header start address is from a driver supplied buffer, which
one can reasonably expect to be aligned on a 4-bytes boundary.
However ATM the TSO helper API is only used by ethernet drivers and
the tcp header will then be aligned to a 2-bytes only boundary from the
header start address.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/tso.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -1,6 +1,7 @@
 #include <linux/export.h>
 #include <net/ip.h>
 #include <net/tso.h>
+#include <asm/unaligned.h>
 
 /* Calculate expected number of TX descriptors */
 int tso_count_descs(struct sk_buff *skb)
@@ -23,7 +24,7 @@ void tso_build_hdr(struct sk_buff *skb,
 	iph->id = htons(tso->ip_id);
 	iph->tot_len = htons(size + hdr_len - mac_hdr_len);
 	tcph = (struct tcphdr *)(hdr + skb_transport_offset(skb));
-	tcph->seq = htonl(tso->tcp_seq);
+	put_unaligned_be32(tso->tcp_seq, &tcph->seq);
 	tso->ip_id++;
 
 	if (!is_last) {


