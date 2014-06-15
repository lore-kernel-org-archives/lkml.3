Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaFOUjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:39:20 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:49880 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752830AbaFOUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:4049:4117:4250:4321:4385:4605:5007:6119:6261:7875:7903:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toad32_6d530d92d5825
X-Filterd-Recvd-Size: 6918
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 23/26] qla4xxx: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:52 -0700
Message-Id: <2ab83dad6b2203529f2382050ff813297386a855.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |  5 ++---
 drivers/scsi/qla4xxx/ql4_mbx.c  | 21 +++++++++------------
 drivers/scsi/qla4xxx/ql4_nx.c   |  5 ++---
 drivers/scsi/qla4xxx/ql4_os.c   | 12 +++++-------
 4 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 6f12f85..9fa5e13 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -153,15 +153,14 @@ int qla4xxx_get_sys_info(struct scsi_qla_host *ha)
 	dma_addr_t sys_info_dma;
 	int status = QLA_ERROR;
 
-	sys_info = dma_alloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
-				      &sys_info_dma, GFP_KERNEL);
+	sys_info = dma_zalloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
+				       &sys_info_dma, GFP_KERNEL);
 	if (sys_info == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 			      ha->host_no, __func__));
 
 		goto exit_get_sys_info_no_free;
 	}
-	memset(sys_info, 0, sizeof(*sys_info));
 
 	/* Get flash sys info */
 	if (qla4xxx_get_flash(ha, sys_info_dma, FLASH_OFFSET_SYS_INFO,
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0a3312c..f8fd4ca 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -625,15 +625,14 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 	int status = QLA_ERROR;
 
-	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
-					sizeof(struct addr_ctrl_blk),
-					&init_fw_cb_dma, GFP_KERNEL);
+	init_fw_cb = dma_zalloc_coherent(&ha->pdev->dev,
+					 sizeof(struct addr_ctrl_blk),
+					 &init_fw_cb_dma, GFP_KERNEL);
 	if (init_fw_cb == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to alloc init_cb\n",
 			      ha->host_no, __func__));
 		goto exit_init_fw_cb_no_free;
 	}
-	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
 
 	/* Get Initialize Firmware Control Block. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
@@ -710,9 +709,9 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 
-	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
-					sizeof(struct addr_ctrl_blk),
-					&init_fw_cb_dma, GFP_KERNEL);
+	init_fw_cb = dma_zalloc_coherent(&ha->pdev->dev,
+					 sizeof(struct addr_ctrl_blk),
+					 &init_fw_cb_dma, GFP_KERNEL);
 	if (init_fw_cb == NULL) {
 		printk("scsi%ld: %s: Unable to alloc init_cb\n", ha->host_no,
 		       __func__);
@@ -720,7 +719,6 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 	}
 
 	/* Get Initialize Firmware Control Block. */
-	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
 	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: Failed to get init_fw_ctrl_blk\n",
@@ -1342,16 +1340,15 @@ int qla4xxx_about_firmware(struct scsi_qla_host *ha)
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 	int status = QLA_ERROR;
 
-	about_fw = dma_alloc_coherent(&ha->pdev->dev,
-				      sizeof(struct about_fw_info),
-				      &about_fw_dma, GFP_KERNEL);
+	about_fw = dma_zalloc_coherent(&ha->pdev->dev,
+				       sizeof(struct about_fw_info),
+				       &about_fw_dma, GFP_KERNEL);
 	if (!about_fw) {
 		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Unable to alloc memory "
 				  "for about_fw\n", __func__));
 		return status;
 	}
 
-	memset(about_fw, 0, sizeof(struct about_fw_info));
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 9dbdb4b..bd9212a 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -4050,15 +4050,14 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 	dma_addr_t sys_info_dma;
 	int status = QLA_ERROR;
 
-	sys_info = dma_alloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
-				      &sys_info_dma, GFP_KERNEL);
+	sys_info = dma_zalloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
+				       &sys_info_dma, GFP_KERNEL);
 	if (sys_info == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 		    ha->host_no, __func__));
 		return status;
 	}
 
-	memset(sys_info, 0, sizeof(*sys_info));
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3202063..e0713e0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2693,16 +2693,15 @@ qla4xxx_iface_set_param(struct Scsi_Host *shost, void *data, uint32_t len)
 	uint32_t rem = len;
 	struct nlattr *attr;
 
-	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
-					sizeof(struct addr_ctrl_blk),
-					&init_fw_cb_dma, GFP_KERNEL);
+	init_fw_cb = dma_zalloc_coherent(&ha->pdev->dev,
+					 sizeof(struct addr_ctrl_blk),
+					 &init_fw_cb_dma, GFP_KERNEL);
 	if (!init_fw_cb) {
 		ql4_printk(KERN_ERR, ha, "%s: Unable to alloc init_cb\n",
 			   __func__);
 		return -ENOMEM;
 	}
 
-	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
@@ -4201,15 +4200,14 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 			  sizeof(struct shadow_regs) +
 			  MEM_ALIGN_VALUE +
 			  (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
-	ha->queues = dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
-					&ha->queues_dma, GFP_KERNEL);
+	ha->queues = dma_zalloc_coherent(&ha->pdev->dev, ha->queues_len,
+					 &ha->queues_dma, GFP_KERNEL);
 	if (ha->queues == NULL) {
 		ql4_printk(KERN_WARNING, ha,
 		    "Memory Allocation failed - queues.\n");
 
 		goto mem_alloc_error_exit;
 	}
-	memset(ha->queues, 0, ha->queues_len);
 
 	/*
 	 * As per RISC alignment requirements -- the bus-address must be a
-- 
1.8.1.2.459.gbcd45b4.dirty

