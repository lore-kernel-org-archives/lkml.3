Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaFWNmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:42:55 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:45059 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756074AbaFWNmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2729:3138:3139:3140:3141:3142:3352:3865:3866:3867:4225:4250:4321:4385:4419:4605:5007:6119:6261:8603:9592:10004:10026:10848:11026:11473:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lead59_8cb806731cd3b
X-Filterd-Recvd-Size: 3414
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        netdev@vger.kernel.org
Subject: [PATCH 13/22] qlogic: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:41 -0700
Message-Id: <5aceec27b2390a68fb96d31fc5753d9b58d82627.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c |  4 +---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c        | 11 +++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
index 6f6be57..b8d5270 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -129,14 +129,12 @@ netxen_get_minidump_template(struct netxen_adapter *adapter)
 		return NX_RCODE_INVALID_ARGS;
 	}
 
-	addr = pci_alloc_consistent(adapter->pdev, size, &md_template_addr);
-
+	addr = pci_zalloc_consistent(adapter->pdev, size, &md_template_addr);
 	if (!addr) {
 		dev_err(&adapter->pdev->dev, "Unable to allocate dmable memory for template.\n");
 		return -ENOMEM;
 	}
 
-	memset(addr, 0, size);
 	memset(&cmd, 0, sizeof(cmd));
 	memset(&cmd.rsp, 1, sizeof(struct _cdrp_cmd));
 	cmd.req.cmd = NX_CDRP_CMD_GET_TEMP_HDR;
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index b40050e..d836ace 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -2727,23 +2727,22 @@ static void ql_free_shadow_space(struct ql_adapter *qdev)
 static int ql_alloc_shadow_space(struct ql_adapter *qdev)
 {
 	qdev->rx_ring_shadow_reg_area =
-	    pci_alloc_consistent(qdev->pdev,
-				 PAGE_SIZE, &qdev->rx_ring_shadow_reg_dma);
+		pci_zalloc_consistent(qdev->pdev, PAGE_SIZE,
+				      &qdev->rx_ring_shadow_reg_dma);
 	if (qdev->rx_ring_shadow_reg_area == NULL) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Allocation of RX shadow space failed.\n");
 		return -ENOMEM;
 	}
-	memset(qdev->rx_ring_shadow_reg_area, 0, PAGE_SIZE);
+
 	qdev->tx_ring_shadow_reg_area =
-	    pci_alloc_consistent(qdev->pdev, PAGE_SIZE,
-				 &qdev->tx_ring_shadow_reg_dma);
+		pci_zalloc_consistent(qdev->pdev, PAGE_SIZE,
+				      &qdev->tx_ring_shadow_reg_dma);
 	if (qdev->tx_ring_shadow_reg_area == NULL) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Allocation of TX shadow space failed.\n");
 		goto err_wqp_sh_area;
 	}
-	memset(qdev->tx_ring_shadow_reg_area, 0, PAGE_SIZE);
 	return 0;
 
 err_wqp_sh_area:
-- 
1.8.1.2.459.gbcd45b4.dirty

