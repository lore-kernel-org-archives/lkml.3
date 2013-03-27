Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3C0Xvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:51:31 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:37995
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483Ab3C0Xva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:51:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizd799hzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCFLN-02-49Y-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Date: Wed, 27 Mar 2013 18:51:23 -0500
Message-ID: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu.c |  161 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 134 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 98f555d..477cfbb 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -592,7 +592,6 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&invalidate_iotlb_all);
 	amd_iommu_stats_add(&pri_requests);
 }
-
 #endif
 
 /****************************************************************************
@@ -601,6 +600,99 @@ static void amd_iommu_stats_init(void)
  *
  ****************************************************************************/
 
+struct _event_log_flags {
+	u32	gn:1, /* 16 */
+		nx:1, /* 17 */
+		us:1, /* 18 */
+		 i:1, /* 19 */
+		pr:1, /* 20 */
+		rw:1, /* 21 */
+		pe:1, /* 22 */
+		rz:1, /* 23 */
+		tr:1, /* 24 */
+		type:3, /* [27:25] */
+		_reserved_:20; /* Reserved */
+};
+
+static const char * const _invalid_transaction_desc[] = {
+	/* 000 */"Read request or non-posted write in the interrupt "
+		 "addres range",
+	/* 001 */"Pretranslated transaction received from an I/O device "
+		 "that has I=0 or V=0 in DTE",
+	/* 010 */"Port I/O space transaction received from an I/O device "
+		 "that has IoCtl=00b in DTE",
+	/* 011 */"Posted write to invalid address range",
+	/* 100 */"Invalid read request or non-posted write",
+	/* 101 */"Posted write to the interrupt/EOI range from an I/O "
+		 "device that has IntCtl=00b in DTE",
+	/* 110 */"Posted write to a reserved interrupt address range",
+	/* 111 */"Invalid transaction to the system management address range",
+};
+
+static const char * const _invalid_translation_desc[] = {
+	/* 000 */"Translation request received from an I/O device that has "
+		 "I=0, or has V=0, or has V=1 and TV=0 in DTE",
+	/* 001 */"Translation request in invalid address range",
+	/* 010 */"Invalid translation request",
+	/* 011 */"Reserved",
+	/* 100 */"Reserved",
+	/* 101 */"Reserved",
+	/* 110 */"Reserved",
+	/* 111 */"Reserved",
+};
+
+static void dump_flags(int flags, int ev_type)
+{
+	struct _event_log_flags *p = (struct _event_log_flags *) &flags;
+	u32 err_type = p->type;
+
+	pr_err("AMD-Vi: Flags details:\n");
+	pr_err("AMD-Vi:    Guest / Nested  : %u\n", p->gn);
+	pr_err("AMD-Vi:    No Execute      : %u\n", p->nx);
+	pr_err("AMD-Vi:    User-Supervisor : %u\n", p->us);
+	pr_err("AMD-Vi:    Interrupt       : %u\n", p->i);
+	pr_err("AMD-Vi:    Present         : %u\n", p->pr);
+	pr_err("AMD-Vi:    Read / Write    : %u\n", p->rw);
+	pr_err("AMD-Vi:    Permission      : %u\n", p->pe);
+	pr_err("AMD-Vi:    Reserv bit not zero / Illegal level encoding : %u\n",
+		p->rz);
+	pr_err("AMD-Vi:    Translation / Transaction : %u\n",
+		p->tr);
+	pr_err("AMD-Vi:    Type of error   : (0x%x) ", err_type);
+
+	if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
+	    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
+	    (ev_type == EVENT_TYPE_CMD_HARD_ERR)) {
+		/* Only supports up to 2 bits */
+		err_type &= 0x3;
+		switch (err_type) {
+		case 0:
+			pr_err("Reserved\n");
+			break;
+		case 1:
+			pr_err("Master Abort\n");
+			break;
+		case 2:
+			pr_err("Target Abort\n");
+			break;
+		case 3:
+			pr_err("Data Error\n");
+			break;
+		}
+	} else if (ev_type == EVENT_TYPE_INV_DEV_REQ) {
+		if (p->tr == 0) {
+			if (err_type < ARRAY_SIZE(_invalid_translation_desc))
+				printk("%s\n",
+					_invalid_translation_desc[err_type]);
+		} else {
+			if (err_type < ARRAY_SIZE(_invalid_transaction_desc))
+				printk("%s\n",
+					_invalid_transaction_desc[err_type]);
+		}
+	}
+	pr_err("AMD-Vi:    (Note: Please refer to AMD IOMMU specification for details.)\n");
+}
+
 static void dump_dte_entry(u16 devid)
 {
 	int i;
@@ -619,31 +711,10 @@ static void dump_command(unsigned long phys_addr)
 		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
 }
 
-static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
+static void iommu_print_event(int type, int devid, int domid,
+			      int flags, u64 address)
 {
-	int type, devid, domid, flags;
-	volatile u32 *event = __evt;
-	int count = 0;
-	u64 address;
-
-retry:
-	type    = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
-	devid   = (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
-	domid   = (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
-	flags   = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
-	address = (u64)(((u64)event[3]) << 32) | event[2];
-
-	if (type == 0) {
-		/* Did we hit the erratum? */
-		if (++count == LOOP_TIMEOUT) {
-			pr_err("AMD-Vi: No event written to event log\n");
-			return;
-		}
-		udelay(1);
-		goto retry;
-	}
-
-	printk(KERN_ERR "AMD-Vi: Event logged [");
+	pr_err("AMD-Vi: Event logged [");
 
 	switch (type) {
 	case EVENT_TYPE_ILL_DEV:
@@ -651,6 +722,7 @@ retry:
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_flags(flags, type);
 		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
@@ -658,18 +730,22 @@ retry:
 		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       domid, address, flags);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_DEV_TAB_ERR:
 		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_PAGE_TAB_ERR:
 		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
 		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       domid, address, flags);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
@@ -678,6 +754,7 @@ retry:
 	case EVENT_TYPE_CMD_HARD_ERR:
 		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
 		       "flags=0x%04x]\n", address, flags);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_IOTLB_INV_TO:
 		printk("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
@@ -690,11 +767,40 @@ retry:
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
 		break;
 	default:
-		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
+		printk("UNKNOWN type=0x%02x]\n", type);
+	}
+}
+
+static void iommu_handle_event(struct amd_iommu *iommu, void *__evt)
+{
+	int type, devid, domid, flags;
+	u32 *event = __evt;
+	int count = 0;
+	u64 address;
+
+retry:
+	type    = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
+	devid   = (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
+	domid   = (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
+	flags   = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
+	address = (u64)(((u64)event[3]) << 32) | event[2];
+
+	if (type == 0) {
+		/* Did we hit the erratum? */
+		if (++count == LOOP_TIMEOUT) {
+			pr_err("AMD-Vi: No event written to event log\n");
+			return;
+		}
+		udelay(1);
+		goto retry;
 	}
 
+	iommu_print_event(type, devid, domid, flags, address);
+
 	memset(__evt, 0, 4 * sizeof(u32));
 }
 
@@ -709,7 +815,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
 	while (head != tail) {
-		iommu_print_event(iommu, iommu->evt_buf + head);
+		iommu_handle_event(iommu, iommu->evt_buf + head);
 		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
 	}
 
@@ -3270,6 +3376,7 @@ static int __init alloc_passthrough_domain(void)
 
 	return 0;
 }
+
 static int amd_iommu_domain_init(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
-- 
1.7.10.4


