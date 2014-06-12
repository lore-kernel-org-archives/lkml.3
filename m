Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaFLXWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:22:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaFLXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Collins <ben.c@servergy.com>, Sumit Saxena <sumit.saxena@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 15/18] SCSI: megaraid: Use resource_size_t for PCI resources, not long
Date: Thu, 12 Jun 2014 16:22:19 -0700
Message-Id: <20140612232213.609756669@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232212.960235342@linuxfoundation.org>
References: <20140612232212.960235342@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Collins <ben.c@servergy.com>

commit 11f8a7b31f2140b0dc164bb484281235ffbe51d3 upstream.

The assumption that sizeof(long) >= sizeof(resource_size_t) can lead to
truncation of the PCI resource address, meaning this driver didn't work
on 32-bit systems with 64-bit PCI adressing ranges.

Signed-off-by: Ben Collins <ben.c@servergy.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas.h      |    1 -
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
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
@@ -3461,6 +3461,7 @@ static int megasas_init_fw(struct megasa
 	u32 max_sectors_1;
 	u32 max_sectors_2;
 	u32 tmp_sectors, msix_enable;
+	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
@@ -3469,14 +3470,14 @@ static int megasas_init_fw(struct megasa
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


