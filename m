Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3IISWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:22:36 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:47960 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3IISWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:22:34 -0400
Message-ID: <201309091822.r89IMXmA032018@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 9 Sep 2013 14:11:54 -0400
Subject: [PATCH] net: tilegx driver: avoid compiler warning
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "id" variable was being incremented in common code, but only
initialized and used in IPv4 code.  We move the increment to the IPv4
code too, and then legitimately use the uninitialized_var() macro to
avoid the gcc 4.6 warning that 'id' may be used uninitialized.
Note that gcc 4.7 does not warn.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilegx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 949076f..13e6fff 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -1734,7 +1734,8 @@ static void tso_headers_prepare(struct sk_buff *skb, unsigned char *headers,
 	unsigned int data_len = skb->len - sh_len;
 	unsigned char *data = skb->data;
 	unsigned int ih_off, th_off, p_len;
-	unsigned int isum_seed, tsum_seed, id, seq;
+	unsigned int isum_seed, tsum_seed, seq;
+	unsigned int uninitialized_var(id);
 	int is_ipv6;
 	long f_id = -1;    /* id of the current fragment */
 	long f_size = skb_headlen(skb) - sh_len;  /* current fragment size */
@@ -1781,7 +1782,7 @@ static void tso_headers_prepare(struct sk_buff *skb, unsigned char *headers,
 		} else {
 			ih = (struct iphdr *)(buf + ih_off);
 			ih->tot_len = htons(sh_len + p_len - ih_off);
-			ih->id = htons(id);
+			ih->id = htons(id++);
 			ih->check = csum_long(isum_seed + ih->tot_len +
 					      ih->id) ^ 0xffff;
 		}
@@ -1818,7 +1819,6 @@ static void tso_headers_prepare(struct sk_buff *skb, unsigned char *headers,
 			slot++;
 		}
 
-		id++;
 		seq += p_len;
 
 		/* The last segment may be less than gso_size. */
-- 
1.8.3.1

