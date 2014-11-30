Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaK3Kll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:41:41 -0500
Received: from mout.gmx.net ([212.227.15.19]:50955 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaK3Klj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:41:39 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH] ioc3: fix incorrect use of htons/ntohs
Date: Sun, 30 Nov 2014 11:40:54 +0100
Message-Id: <1417344054-4374-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:NiX33ILS5w7Kxg3QDE4Zyk//+pN24RBypE7DT/SveQYN5VMFOKu
 EWdhpB6lGnfAmQaJWYwaAg7BuzKPnW72qN6PgHrZmkgsCF+g+yJVVoNdn8PJJ9R24u0EYut
 bGCplhp5Cs3MLA0KN1elS2yQQI4TTu0eKTP5nDETOKYNAIflos6iaUJ4QvAm4o9clSsF25h
 9AiuwYfLt+cPyYv61l6zw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The protocol type in the ip header struct is a single byte variable. So there
is no need to swap bytes depending on host endianness.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---

Please note that I could not test this, since I dont have access to the
concerning hardware.

 drivers/net/ethernet/sgi/ioc3-eth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 7a254da..0bb303d 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -540,8 +540,7 @@ static void ioc3_tcpudp_checksum(struct sk_buff *skb, uint32_t hwsum, int len)
 
 	/* Same as tx - compute csum of pseudo header  */
 	csum = hwsum +
-	       (ih->tot_len - (ih->ihl << 2)) +
-	       htons((uint16_t)ih->protocol) +
+	       (ih->tot_len - (ih->ihl << 2)) + ih->protocol +
 	       (ih->saddr >> 16) + (ih->saddr & 0xffff) +
 	       (ih->daddr >> 16) + (ih->daddr & 0xffff);
 
@@ -1417,7 +1416,7 @@ static int ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		const struct iphdr *ih = ip_hdr(skb);
-		const int proto = ntohs(ih->protocol);
+		const int proto = ih->protocol;
 		unsigned int csoff;
 		uint32_t csum, ehsum;
 		uint16_t *eh;
-- 
1.9.1

