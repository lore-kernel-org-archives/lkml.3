Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaFWNnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:43:00 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:54265 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756103AbaFWNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:196:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1542:1622:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:4321:4419:4605:5007:6119:6261:7903:8603:9592:10004:10026:10848:11026:11232:11473:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fork10_8db0cca117347
X-Filterd-Recvd-Size: 3030
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/22] ipw2100: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:43 -0700
Message-Id: <300ca978edde7122af48aae0f6de0d06730c5fbc.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index dfc6dfc..1ab8e50 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -3449,8 +3449,9 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 		return -ENOMEM;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		v = pci_alloc_consistent(priv->pci_dev,
-					 sizeof(struct ipw2100_cmd_header), &p);
+		v = pci_zalloc_consistent(priv->pci_dev,
+					  sizeof(struct ipw2100_cmd_header),
+					  &p);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: PCI alloc failed for msg "
@@ -3459,8 +3460,6 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 			break;
 		}
 
-		memset(v, 0, sizeof(struct ipw2100_cmd_header));
-
 		priv->msg_buffers[i].type = COMMAND;
 		priv->msg_buffers[i].info.c_struct.cmd =
 		    (struct ipw2100_cmd_header *)v;
@@ -4336,16 +4335,12 @@ static int status_queue_allocate(struct ipw2100_priv *priv, int entries)
 	IPW_DEBUG_INFO("enter\n");
 
 	q->size = entries * sizeof(struct ipw2100_status);
-	q->drv =
-	    (struct ipw2100_status *)pci_alloc_consistent(priv->pci_dev,
-							  q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_WARNING("Can not allocate status queue.\n");
 		return -ENOMEM;
 	}
 
-	memset(q->drv, 0, q->size);
-
 	IPW_DEBUG_INFO("exit\n");
 
 	return 0;
@@ -4374,13 +4369,12 @@ static int bd_queue_allocate(struct ipw2100_priv *priv,
 
 	q->entries = entries;
 	q->size = entries * sizeof(struct ipw2100_bd);
-	q->drv = pci_alloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_INFO
 		    ("can't allocate shared memory for buffer descriptors\n");
 		return -ENOMEM;
 	}
-	memset(q->drv, 0, q->size);
 
 	IPW_DEBUG_INFO("exit\n");
 
-- 
1.8.1.2.459.gbcd45b4.dirty

