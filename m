Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaFWNFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaFWNFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Collins <ben.c@servergy.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 93/93] [SCSI] megaraid: Use resource_size_t for PCI resources, not long
Date: Mon, 23 Jun 2014 14:03:12 +0100
Message-Id: <1403528592-2163-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Collins <ben.c@servergy.com>

commit 11f8a7b31f2140b0dc164bb484281235ffbe51d3 upstream.

The assumption that sizeof(long) >= sizeof(resource_size_t) can lead to
truncation of the PCI resource address, meaning this driver didn't work
on 32-bit systems with 64-bit PCI adressing ranges.

Signed-off-by: Ben Collins <ben.c@servergy.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 1 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 04a42a505852..2f5875834eec 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1460,7 +1460,6 @@ struct megasas_instance {
 	u32 *reply_queue;
 	dma_addr_t reply_queue_h;
 
-	unsigned long base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 97b418146473..54beaca5f684 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3499,6 +3499,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	u32 max_sectors_1;
 	u32 max_sectors_2;
 	u32 tmp_sectors, msix_enable, scratch_pad_2;
+	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
@@ -3507,14 +3508,14 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Find first memory bar */
 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
-	instance->base_addr = pci_resource_start(instance->pdev, instance->bar);
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
 		return -EBUSY;
 	}
 
-	instance->reg_set = ioremap_nocache(instance->base_addr, 8192);
+	base_addr = pci_resource_start(instance->pdev, instance->bar);
+	instance->reg_set = ioremap_nocache(base_addr, 8192);
 
 	if (!instance->reg_set) {
 		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
-- 
1.9.1

