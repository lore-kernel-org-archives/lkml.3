Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaGHTjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:39:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54113 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755683AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Collins" <ben.c@servergy.com>,
        "Sumit Saxena" <sumit.saxena@lsi.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.166439967@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 118/125] [SCSI] megaraid: Use resource_size_t for PCI
 resources, not long
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Collins <ben.c@servergy.com>

commit 11f8a7b31f2140b0dc164bb484281235ffbe51d3 upstream.

The assumption that sizeof(long) >= sizeof(resource_size_t) can lead to
truncation of the PCI resource address, meaning this driver didn't work
on 32-bit systems with 64-bit PCI adressing ranges.

Signed-off-by: Ben Collins <ben.c@servergy.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 1 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1295,7 +1295,6 @@ struct megasas_instance {
 	u32 *reply_queue;
 	dma_addr_t reply_queue_h;
 
-	unsigned long base_addr;
 	struct megasas_register_set __iomem *reg_set;
 
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3499,6 +3499,7 @@ static int megasas_init_fw(struct megasa
 	u32 max_sectors_1;
 	u32 max_sectors_2;
 	u32 tmp_sectors, msix_enable;
+	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
@@ -3507,14 +3508,14 @@ static int megasas_init_fw(struct megasa
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

