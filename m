Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab3DCAH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:07:26 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:37280 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994Ab3DCAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:07:25 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z551biz154dId799hzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKNKC9-01-8M1-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
Date: Tue, 2 Apr 2013 19:06:50 -0500
Message-ID: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com>
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

This is an example:
AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 domain=0x0000 address=0x0000000000000000 flags=0x0fff]
AMD-Vi: Flags details: Guest NX=1 User Intr Present Write No-Perm Rsrv-Bit Translation
AMD-Vi: Type of error: (0x7) 
AMD-Vi: (Note: Please refer to AMD IOMMU specification for details.)
AMD-Vi: DTE[0]: 6000003fa75e2403
AMD-Vi: DTE[1]: 0000000000000014
AMD-Vi: DTE[2]: 2000003fa5e09011
AMD-Vi: DTE[3]: 0000000000000000

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
Changelog:
V3:
	* Move comments to end of line
	* Shorten the print out to be within one line
V2:
	* Fix printing format to reduce noise
	* Use string table instead of switch/case
	* Use pr_cont instead of printk

 drivers/iommu/amd_iommu.c |  171 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 137 insertions(+), 34 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b287ca3..593a1a3 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -601,6 +601,94 @@ static void amd_iommu_stats_init(void)
  *
  ****************************************************************************/
 
+struct _event_log_flags {
+	u32	gn:1,		/* 16 */
+		nx:1,		/* 17 */
+		us:1,		/* 18 */
+		 i:1,		/* 19 */
+		pr:1,		/* 20 */
+		rw:1,		/* 21 */
+		pe:1,		/* 22 */
+		rz:1,		/* 23 */
+		tr:1,		/* 24 */
+		type:3,		/* [27:25] */
+		_reserved_:20;	/* Reserved */
+};
+
+static const char * const _type_field_encodings[] = {
+	"Reserved",		/* 00 */
+	"Master Abort",		/* 01 */
+	"Target Abort",		/* 10 */
+	"Data Error",		/* 11 */
+};
+
+static const char * const _invalid_transaction_desc[] = {
+	"Read request or non-posted write in the interrupt "
+		 "addres range",				/* 000 */
+	"Pretranslated transaction received from an "
+		"I/O device that has I=0 or V=0 in DTE",	/* 001 */
+	"Port I/O space transaction received from an "
+		"I/O device that has IoCtl=00b in DTE",		/* 010 */
+	"Posted write to invalid address range",		/* 011 */
+	"Invalid read request or non-posted write",		/* 100 */
+	"Posted write to the interrupt/EOI range from an "
+		"I/O device that has IntCtl=00b in DTE",	/* 101 */
+	"Posted write to a reserved interrupt address range",	/* 110 */
+	"Invalid transaction to the system management "
+		"address range",				/* 111 */
+};
+
+static const char * const _invalid_translation_desc[] = {
+	"Translation request received from an I/O device "
+		"that has I=0, or has V=0, or has V=1 and "
+		"TV=0 in DTE",					/* 000 */
+	"Translation request in invalid address range",		/* 001 */
+	"Invalid translation request",				/* 010 */
+	"Reserved",						/* 011 */
+	"Reserved",						/* 100 */
+	"Reserved",						/* 101 */
+	"Reserved",						/* 110 */
+	"Reserved",						/* 111 */
+};
+
+static void dump_flags(int flags, int ev_type)
+{
+	struct _event_log_flags *p = (struct _event_log_flags *) &flags;
+	u32 err_type = p->type;
+
+	pr_err("AMD-Vi: Flags details: %s NX=%u %s %s %s %s %s %s %s\n",
+		(p->gn ? "Guest" : "Nested"),
+		(p->nx),
+		(p->us ? "User" : "Super"),
+		(p->i ? "Intr" : "Mem"),
+		(p->pr ? "Present" : "Absent"),
+		(p->rw ? "Write" : "Read"),
+		(p->pe ? "No-Perm" : "Has-Perm"),
+		(p->rz ? "Rsrv-Bit" : "Ill-Level"),
+		(p->tr ? "Translation" : "Transaction"));
+
+	pr_err("AMD-Vi: Type of error: (0x%x) ", err_type);
+	if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
+	    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
+	    (ev_type == EVENT_TYPE_CMD_HARD_ERR)) {
+		if (err_type < ARRAY_SIZE(_type_field_encodings)) {
+			pr_cont("%s\n",
+				_type_field_encodings[err_type]);
+		}
+	} else if (ev_type == EVENT_TYPE_INV_DEV_REQ) {
+		if (p->tr == 0) {
+			if (err_type < ARRAY_SIZE(_invalid_translation_desc))
+				pr_cont("%s\n",
+					_invalid_translation_desc[err_type]);
+		} else {
+			if (err_type < ARRAY_SIZE(_invalid_transaction_desc))
+				pr_cont("%s\n",
+					_invalid_transaction_desc[err_type]);
+		}
+	}
+	pr_err("AMD-Vi: (Note: Please refer to AMD IOMMU specification for details.)\n");
+}
+
 static void dump_dte_entry(u16 devid)
 {
 	int i;
@@ -619,81 +707,95 @@ static void dump_command(unsigned long phys_addr)
 		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
 }
 
-static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
+void amd_iommu_print_event(int type, int devid, int domid,
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
-		printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
+		pr_cont("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_flags(flags, type);
 		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
-		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
+		pr_cont("IO_PAGE_FAULT device=%02x:%02x.%x "
 		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       domid, address, flags);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_DEV_TAB_ERR:
-		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+		pr_cont("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_PAGE_TAB_ERR:
-		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+		pr_cont("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
 		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       domid, address, flags);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_ILL_CMD:
-		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		pr_cont("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
-		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
+		pr_cont("COMMAND_HARDWARE_ERROR address=0x%016llx "
 		       "flags=0x%04x]\n", address, flags);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_IOTLB_INV_TO:
-		printk("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
+		pr_cont("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
 		       "address=0x%016llx]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address);
 		break;
 	case EVENT_TYPE_INV_DEV_REQ:
-		printk("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
+		pr_cont("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
 		break;
 	default:
-		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
+		pr_cont("UNKNOWN type=0x%02x]\n", type);
 	}
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
+	}
+
+	amd_iommu_print_event(type, devid, domid, flags, address);
 
 	memset(__evt, 0, 4 * sizeof(u32));
 }
@@ -709,7 +811,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
 	while (head != tail) {
-		iommu_print_event(iommu, iommu->evt_buf + head);
+		iommu_handle_event(iommu, iommu->evt_buf + head);
 		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
 	}
 
@@ -3268,6 +3370,7 @@ static int __init alloc_passthrough_domain(void)
 
 	return 0;
 }
+
 static int amd_iommu_domain_init(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
-- 
1.7.10.4


