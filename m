Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3EVTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:16:58 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7883 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185Ab3EVTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:16:56 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN7S70-02-93R-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <ddutile@redhat.com>, <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 3/3] iommu/amd: Remove old event printing logic
Date: Wed, 22 May 2013 14:15:55 -0500
Message-ID: <1369250155-12226-4-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Remove old event printing logic and hook up with the new event
handling logic in amd_iommu_fault.c

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu.c |   85 ++++-----------------------------------------
 1 file changed, 6 insertions(+), 79 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 21d02b0..44032d4 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -88,13 +88,6 @@ int amd_iommu_max_glx_val = -1;
 
 static struct dma_map_ops amd_iommu_dma_ops;
 
-/*
- * general struct to manage commands send to an IOMMU
- */
-struct iommu_cmd {
-	u32 data[4];
-};
-
 struct kmem_cache *amd_iommu_irq_cache;
 
 static void update_domain(struct protection_domain *domain);
@@ -596,28 +589,10 @@ static void amd_iommu_stats_init(void)
  *
  ****************************************************************************/
 
-static void dump_dte_entry(u16 devid)
-{
-	int i;
-
-	for (i = 0; i < 4; ++i)
-		pr_err("AMD-Vi: DTE[%d]: %016llx\n", i,
-			amd_iommu_dev_table[devid].data[i]);
-}
-
-static void dump_command(unsigned long phys_addr)
-{
-	struct iommu_cmd *cmd = phys_to_virt(phys_addr);
-	int i;
-
-	for (i = 0; i < 4; ++i)
-		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
-}
-
-static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
+static void iommu_handle_event(struct amd_iommu *iommu, void *__evt)
 {
 	int type, devid, domid, flags;
-	volatile u32 *event = __evt;
+	u32 *event = __evt;
 	int count = 0;
 	u64 address;
 
@@ -638,57 +613,7 @@ retry:
 		goto retry;
 	}
 
-	printk(KERN_ERR "AMD-Vi: Event logged [");
-
-	switch (type) {
-	case EVENT_TYPE_ILL_DEV:
-		printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
-		dump_dte_entry(devid);
-		break;
-	case EVENT_TYPE_IO_FAULT:
-		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
-		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       domid, address, flags);
-		break;
-	case EVENT_TYPE_DEV_TAB_ERR:
-		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
-		break;
-	case EVENT_TYPE_PAGE_TAB_ERR:
-		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
-		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       domid, address, flags);
-		break;
-	case EVENT_TYPE_ILL_CMD:
-		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
-		dump_command(address);
-		break;
-	case EVENT_TYPE_CMD_HARD_ERR:
-		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
-		       "flags=0x%04x]\n", address, flags);
-		break;
-	case EVENT_TYPE_IOTLB_INV_TO:
-		printk("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
-		       "address=0x%016llx]\n",
-		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address);
-		break;
-	case EVENT_TYPE_INV_DEV_REQ:
-		printk("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
-		break;
-	default:
-		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
-	}
+	amd_iommu_handle_fault(iommu, address, type, flags, devid, domid);
 
 	memset(__evt, 0, 4 * sizeof(u32));
 }
@@ -701,7 +626,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
 	while (head != tail) {
-		iommu_print_event(iommu, iommu->evt_buf + head);
+		iommu_handle_event(iommu, iommu->evt_buf + head);
 		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
 	}
 
@@ -814,6 +739,7 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 		 */
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 	}
+
 	return IRQ_HANDLED;
 }
 
@@ -3248,6 +3174,7 @@ static int __init alloc_passthrough_domain(void)
 
 	return 0;
 }
+
 static int amd_iommu_domain_init(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
-- 
1.7.10.4


