Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937014Ab3DJP5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:57:55 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:47728
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935423Ab3DJP5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:57:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizd799hzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0ML1R04-02-8S9-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/2 V5] iommu/amd: Add logic to decode AMD IOMMU event flag
Date: Wed, 10 Apr 2013 10:57:39 -0500
Message-ID: <1365609459-3378-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
This should simplify debugging IOMMU errors.  Also, dump DTE information in some additional
cases.

Example (default): The flags is now decoded.
AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=51:00.0 address=0x0000000000000000 flags:G Nx Usr I P W N-Pm Rsv Tl type(0x7)]
AMD-Vi: DTE[0..3]: 600000dfa760b403 0000000000000014 200000dfaba60c11 0000000000000000

Example (amd-iommu=verbose): The flags and error types are decoded
AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=51:00.0 address=0x0000000000000000 flags:G Nx Usr I P W N-Pm Rsv Tl]
AMD-Vi: Error type details: (0x7) Invalid transaction to the system management address range
AMD-Vi: DTE[0..3]: 600000dfa760b403 0000000000000014 200000dfaba60c11 0000000000000000

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
V5:
	* Keeping flag decode in 1 line (as requested by Joerg)
	* Use "amd-iommu=verbose" for additional printing
V4:
	* Change print out format to reduce noise
	* Remove "(Note:...)"
V3:
	* Move comments to end of line
	* Shorten the print out to be within one line
V2:
	* Fix printing format to reduce noise
	* Use string table instead of switch/case
	* Use pr_cont instead of printk

---
 drivers/iommu/amd_iommu.c |  215 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 168 insertions(+), 47 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b287ca3..beb61dd 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -601,13 +601,118 @@ static void amd_iommu_stats_init(void)
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
+static const char * const _invalid_trnsac_desc[] = {
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
+static const char * const _invalid_trnslt_desc[] = {
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
+static void dump_detail_error(struct _event_log_flags *p, int ev_type)
+{
+	u32 err_type = p->type;
+
+	pr_err("AMD-Vi: Error type details: (0x%x) ", err_type);
+	if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
+	    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
+	    (ev_type == EVENT_TYPE_CMD_HARD_ERR)) {
+		if (err_type < ARRAY_SIZE(_type_field_encodings)) {
+			pr_cont("%s\n",
+				_type_field_encodings[err_type]);
+		}
+	} else if (ev_type == EVENT_TYPE_INV_DEV_REQ) {
+		if (p->tr == 0) {
+			if (err_type < ARRAY_SIZE(_invalid_trnslt_desc))
+				pr_cont("%s\n",
+					_invalid_trnslt_desc[err_type]);
+		} else {
+			if (err_type < ARRAY_SIZE(_invalid_trnsac_desc))
+				pr_cont("%s\n",
+					_invalid_trnsac_desc[err_type]);
+		}
+	}
+}
+
+static void dump_flags(int flags, int ev_type)
+{
+	struct _event_log_flags *p = (struct _event_log_flags *) &flags;
+	u32 err_type = p->type;
+
+	pr_cont(" flags:%s %s %s %s %s %s %s %s %s",
+		(p->gn ? "G" : "N"),
+		(p->nx ? "Nx" : "Ex"),
+		(p->us ? "Usr" : "Sup"),
+		(p->i  ? "I" : "M"),
+		(p->pr ? "P" : "NP"),
+		(p->rw ? "W" : "R"),
+		(p->pe ? "N-Pm" : "Pm"),
+		(p->rz ? "Rsv" : "Ill"),
+		(p->tr ? "Tl" : "Ta"));
+
+	/* Error type only needed for certain events */
+	if (!amd_iommu_verbose) {
+		if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
+		    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
+		    (ev_type == EVENT_TYPE_CMD_HARD_ERR) ||
+		    (ev_type == EVENT_TYPE_INV_DEV_REQ))
+			pr_cont(" type(0x%x)]\n", err_type);
+	} else {
+		pr_cont("]\n");
+		dump_detail_error(p, ev_type);
+	}
+}
+
 static void dump_dte_entry(u16 devid)
 {
 	int i;
 
+	pr_err("AMD-Vi: DTE[0..3]:");
 	for (i = 0; i < 4; ++i)
-		pr_err("AMD-Vi: DTE[%d]: %016llx\n", i,
-			amd_iommu_dev_table[devid].data[i]);
+		pr_cont(" %016llx", amd_iommu_dev_table[devid].data[i]);
+	pr_cont("\n");
 }
 
 static void dump_command(unsigned long phys_addr)
@@ -619,81 +724,96 @@ static void dump_command(unsigned long phys_addr)
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
-		       "address=0x%016llx flags=0x%04x]\n",
+		pr_cont("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
+		       "address=0x%016llx",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
+		       address);
+		dump_flags(flags, type);
 		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
-		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
-		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
+		pr_cont("IO_PAGE_FAULT device=%02x:%02x.%x "
+		       "domain=0x%04x address=0x%016llx",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       domid, address, flags);
+		       domid, address);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_DEV_TAB_ERR:
-		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
+		pr_cont("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+		       "address=0x%016llx",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
+		       address);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_PAGE_TAB_ERR:
-		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
-		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
+		pr_cont("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+		       "domain=0x%04x address=0x%016llx",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       domid, address, flags);
+		       domid, address);
+		dump_flags(flags, type);
 		break;
 	case EVENT_TYPE_ILL_CMD:
-		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		pr_cont("ILLEGAL_COMMAND_ERROR address=0x%016llx\n",
+			address);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
-		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
-		       "flags=0x%04x]\n", address, flags);
+		pr_cont("COMMAND_HARDWARE_ERROR address=0x%016llx",
+			address);
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
-		       "address=0x%016llx flags=0x%04x]\n",
+		pr_cont("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
+		       "address=0x%016llx",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
+		       address);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
 		break;
 	default:
-		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
+		pr_cont("UNKNOWN type=0x%02x\n", type);
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
@@ -709,7 +829,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
 	while (head != tail) {
-		iommu_print_event(iommu, iommu->evt_buf + head);
+		iommu_handle_event(iommu, iommu->evt_buf + head);
 		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
 	}
 
@@ -3268,6 +3388,7 @@ static int __init alloc_passthrough_domain(void)
 
 	return 0;
 }
+
 static int amd_iommu_domain_init(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
-- 
1.7.10.4


