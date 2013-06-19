Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039Ab3FSUcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:32:50 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:57998
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714Ab3FSUct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:32:49 -0400
X-Originating-IP: [86.2.11.244]
X-Spam: 0
X-Authority: v=2.0 cv=RN7rhPe+ c=1 sm=1 a=n6O9K/ebToSnNVE6TGWEMw==:17
 a=8K7ZGGXbcFcA:10 a=uObrxnre4hsA:10 a=NLZqzBF-AAAA:8 a=OhQpT39T2TcA:10
 a=We_4mzogsPHxyJYa4jMA:9 a=_dQi-Dcv4p4A:10 a=boe2G4Tv7GBy5Vhl:21
 a=bSdpiwFpxDxzuqUX:21 a=n6O9K/ebToSnNVE6TGWEMw==:117
From: Stephen Moorby <steve.moorby@ntlworld.com>
To: davem@davemloft.net, sasha.levin@oracle.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, jiri@resnulli.us,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Stephen Moorby <steve.moorby@ntlworld.com>
Subject: [PATCH 1/1] net/x25: fix address parsing bug in x25_parse_address_block.
Date: Wed, 19 Jun 2013 21:32:36 +0100
Message-Id: <1371673956-471-1-git-send-email-steve.moorby@ntlworld.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This problem was discovered when a linux box was incorrectly rejecting
calls from some X.25 equipment.  The problem was diagnosed to an incorrect
address length calculation in 'x25_parse_address_block', the calculation
did not account for the address digits being BCD encoded.  The correct
calculation is already performed on line 155.

Patched on linux-next 18-Jun-2013
Tested on 2.6.32-45-generic

Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>
---
 net/x25/af_x25.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 1d964e2..eb6c1f9 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -98,7 +98,8 @@ int x25_parse_address_block(struct sk_buff *skb,
 	}
 
 	len = *skb->data;
-	needed = 1 + (len >> 4) + (len & 0x0f);
+	/* need 1 for address length + bytes for BCD encoding of 2 addresses */
+	needed = 1 + (((len >> 4) + (len & 0x0f) + 1) >> 1);
 
 	if (!pskb_may_pull(skb, needed)) {
 		/* packet is too short to hold the addresses it claims
-- 
1.8.1.2

