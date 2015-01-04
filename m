Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbbADBuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 20:50:24 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:39899 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751478AbbADBuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 20:50:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3866:3867:4321:5007:6261:6642:9592:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ant27_1fb1a0a4a1956
X-Filterd-Recvd-Size: 2036
Message-ID: <1420336216.2619.9.camel@perches.com>
Subject: [PATCH net-next] qlcnic: Fix dump_skb output
From: Joe Perches <joe@perches.com>
To: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2015 17:50:16 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use normal facilities to avoid printing each byte
on a separate line.

Now emits at KERN_DEBUG instead of KERN_INFO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 18e5de7..d166e53 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -10,6 +10,7 @@
 #include <net/ip.h>
 #include <linux/ipv6.h>
 #include <net/checksum.h>
+#include <linux/printk.h>
 
 #include "qlcnic.h"
 
@@ -1465,14 +1466,14 @@ void qlcnic_post_rx_buffers(struct qlcnic_adapter *adapter,
 
 static void dump_skb(struct sk_buff *skb, struct qlcnic_adapter *adapter)
 {
-	int i;
-	unsigned char *data = skb->data;
-
-	pr_info(KERN_INFO "\n");
-	for (i = 0; i < skb->len; i++) {
-		QLCDB(adapter, DRV, "%02x ", data[i]);
-		if ((i & 0x0f) == 8)
-			pr_info(KERN_INFO "\n");
+	if (adapter->ahw->msg_enable & NETIF_MSG_DRV) {
+		char prefix[30];
+
+		scnprintf(prefix, sizeof(prefix), "%s: %s: ",
+			  dev_name(&adapter->pdev->dev), __func__);
+
+		print_hex_dump_debug(prefix, DUMP_PREFIX_NONE, 16, 1,
+				     skb->data, skb->len, true);
 	}
 }
 


