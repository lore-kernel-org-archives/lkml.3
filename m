Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3EVTQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:16:55 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:58013
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185Ab3EVTQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:16:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzd799hc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN7S6Y-02-93P-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <ddutile@redhat.com>, <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/3] iommu/amd: Add error handling/reporting/filtering logic
Date: Wed, 22 May 2013 14:15:54 -0500
Message-ID: <1369250155-12226-3-git-send-email-suravee.suthikulpanit@amd.com>
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

Add error handling/reporting/filtering logic which uses the user-specified
amd_iommu_log option to determine the log reporting behavior.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/Makefile          |    2 +-
 drivers/iommu/amd_iommu_fault.c |  368 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_init.c  |    2 +
 drivers/iommu/amd_iommu_proto.h |    6 +
 drivers/iommu/amd_iommu_types.h |   10 ++
 5 files changed, 387 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/amd_iommu_fault.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index ef0e520..b18da7c 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
-obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
+obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o amd_iommu_fault.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
diff --git a/drivers/iommu/amd_iommu_fault.c b/drivers/iommu/amd_iommu_fault.c
new file mode 100644
index 0000000..0bf380d
--- /dev/null
+++ b/drivers/iommu/amd_iommu_fault.c
@@ -0,0 +1,368 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/time.h>
+
+#include "amd_iommu_proto.h"
+#include "amd_iommu_types.h"
+
+#define AMD_IOMMU_ERR_THRESHOLD    10
+#define AMD_IOMMU_ERR_PERIOD_SEC   5
+#define AMD_IOMMU_SUP_PERIOD_SEC   30
+
+enum dev_error_state {
+	DEV_ERR_NONE,
+	DEV_ERR_PROBATION,
+	DEV_ERR_SUPPRESS,
+};
+
+struct dte_err_info {
+	struct list_head list;
+	struct amd_iommu *iommu;
+	u16 devid;
+	enum dev_error_state state;
+	u32 err_cnt;
+	unsigned long last_err_sec;
+	unsigned long suppress_sec;
+};
+
+struct _iommu_event_flags {
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
+static void dump_detail_error(struct _iommu_event_flags *p, int ev_type)
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
+	struct _iommu_event_flags *p = (struct _iommu_event_flags *) &flags;
+	u32 err_type = p->type;
+
+	pr_cont(" flg=%s %s %s %s %s %s %s %s %s",
+		(p->gn ? "G" : "N"),
+		(p->nx ? "Nx" : "Ex"),
+		(p->us ? "Usr" : "Sup"),
+		(p->i  ? "I" : "M"),
+		(p->pr ? "P" : "NP"),
+		(p->rw ? "W" : "R"),
+		(p->pe ? "NPm" : "Pm"),
+		(p->rz ? "Rsv" : "Ill"),
+		(p->tr ? "Tl" : "Ta"));
+
+	/* Error type only needed for certain events */
+	if (amd_iommu_log_level < AMD_IOMMU_LOG_VERBOSE) {
+		if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
+		    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
+		    (ev_type == EVENT_TYPE_CMD_HARD_ERR) ||
+		    (ev_type == EVENT_TYPE_INV_DEV_REQ))
+			pr_cont(" (0x%x)\n", err_type);
+	} else {
+		pr_cont("\n");
+		dump_detail_error(p, ev_type);
+	}
+}
+
+static void dump_dte_entry(u16 devid)
+{
+	if (amd_iommu_log_level < AMD_IOMMU_LOG_VERBOSE)
+		return;
+
+	pr_err("AMD-Vi: DTE[0:3]:%016llx %016llx %016llx %016llx\n",
+		amd_iommu_dev_table[devid].data[0],
+		amd_iommu_dev_table[devid].data[1],
+		amd_iommu_dev_table[devid].data[2],
+		amd_iommu_dev_table[devid].data[3]);
+}
+
+static void dump_command(unsigned long phys_addr)
+{
+	struct iommu_cmd *cmd = phys_to_virt(phys_addr);
+
+	if (amd_iommu_log_level < AMD_IOMMU_LOG_VERBOSE)
+		return;
+
+	pr_err("AMD-Vi: CMD[0:3]:%08x %08x %08x %08x\n",
+		cmd->data[0], cmd->data[1], cmd->data[2], cmd->data[3]);
+}
+
+void amd_iommu_print_event(int type, int devid, int domid,
+			   int flags, u64 address)
+{
+	pr_err("AMD-Vi: Event=");
+
+	switch (type) {
+	case EVENT_TYPE_ILL_DEV:
+		pr_cont("ILLEGAL_DEV_TBL_ENTRY dev=%x:%x.%x addr=0x%llx",
+		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
+		break;
+	case EVENT_TYPE_IO_FAULT:
+		pr_cont("IO_PAGE_FAULT dev=%x:%x.%x dom=0x%x addr=0x%llx",
+		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       domid, address);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
+		break;
+	case EVENT_TYPE_DEV_TAB_ERR:
+		pr_cont("DEV_TAB_HW_ERR dev=%x:%x.%x addr=0x%llx",
+		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address);
+		dump_flags(flags, type);
+		break;
+	case EVENT_TYPE_PAGE_TAB_ERR:
+		pr_cont("PAGE_TAB_HW_ERR dev=%x:%x.%x dom=0x%4x addr=0x%llx",
+		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       domid, address);
+		dump_flags(flags, type);
+		break;
+	case EVENT_TYPE_ILL_CMD:
+		pr_cont("ILLEGAL_CMD_ERR addr=0x%llx\n",
+			address);
+		dump_command(address);
+		break;
+	case EVENT_TYPE_CMD_HARD_ERR:
+		pr_cont("CMD_HW_ERR addr=0x%llx",
+			address);
+		dump_flags(flags, type);
+		break;
+	case EVENT_TYPE_IOTLB_INV_TO:
+		pr_cont("IOTLB_INV_TIMEOUT dev=%x:%x.%x addr=0x%llx\n",
+		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address);
+		break;
+	case EVENT_TYPE_INV_DEV_REQ:
+		pr_cont("INVALID_DEVICE_REQUEST dev=%x:%x.%x addr=0x%llx",
+		       PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address);
+		dump_flags(flags, type);
+		dump_dte_entry(devid);
+		break;
+	default:
+		pr_cont("UNKNOWN type=0x%x\n", type);
+	}
+}
+
+LIST_HEAD(amd_dte_err_list);	/* list of all DTE in probation state */
+
+void amd_iommu_clear_all_dev_faults(void)
+{
+	struct dte_err_info *entry, *next;
+	list_for_each_entry_safe(entry, next, &amd_dte_err_list, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
+
+static struct dte_err_info *_get_dte_error_info(struct amd_iommu *iommu,
+						 u16 devid)
+{
+	struct dte_err_info *entry;
+
+	list_for_each_entry(entry, &amd_dte_err_list, list) {
+		if (entry->devid != devid)
+			continue;
+		return entry;
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return entry;
+
+	entry->iommu = iommu;
+	entry->devid = devid;
+	entry->state = DEV_ERR_NONE;
+	entry->err_cnt = 0;
+	entry->last_err_sec = get_seconds();
+	entry->suppress_sec = 0;
+	list_add(&entry->list, &amd_dte_err_list);
+
+	return entry;
+}
+
+static bool _check_suppress_device(struct dte_err_info *derr)
+{
+	bool ret = false;
+
+	/* Check if the error period is reached */
+	if ((get_seconds() - derr->last_err_sec) > AMD_IOMMU_ERR_PERIOD_SEC) {
+		/* Reset err,int counters */
+		derr->err_cnt = 0;
+		return ret;
+	}
+
+	/* We suppress device error log if the number of errors reaches
+	 * the ERR_THRESHOLD within x sec.
+	 */
+	if (derr->err_cnt >= AMD_IOMMU_ERR_THRESHOLD)
+		ret = true;
+
+	return ret;
+}
+
+static int _iommu_handle_dev_fault(struct amd_iommu *iommu, u64 address,
+	int type, int flags, int devid, int domid)
+{
+	int ret = 0;
+	struct dte_err_info *derr = _get_dte_error_info(iommu, devid);
+
+	derr->err_cnt++;
+
+	/* For debug mode, we don't do any filtering */
+	if (amd_iommu_log_level == AMD_IOMMU_LOG_DEBUG) {
+		amd_iommu_print_event(type, devid, domid, flags, address);
+		return ret;
+	}
+
+	if (derr->state == DEV_ERR_SUPPRESS) {
+		/* Check if the suppress period has passed */
+		if ((get_seconds() - derr->suppress_sec >=
+				AMD_IOMMU_SUP_PERIOD_SEC)) {
+			derr->state = DEV_ERR_PROBATION;
+			derr->suppress_sec = 0;
+			derr->err_cnt = 1;
+			derr->last_err_sec = get_seconds();
+			amd_iommu_print_event(type, devid, domid,
+						flags, address);
+		}
+	} else {
+		amd_iommu_print_event(type, devid, domid, flags, address);
+		if (_check_suppress_device(derr)) {
+			pr_err("AMD-Vi: Warning: IOMMU error threshold (%u) "
+				"reached for device=%x:%x.%x. Suppress for "
+				"%d secs.!!!\n",
+				derr->err_cnt,
+				PCI_BUS_NUM(derr->devid),
+				PCI_SLOT(derr->devid),
+				PCI_FUNC(derr->devid),
+				AMD_IOMMU_SUP_PERIOD_SEC);
+
+			derr->state = DEV_ERR_SUPPRESS;
+			derr->suppress_sec = get_seconds();
+		}
+	}
+
+	return ret;
+}
+
+int amd_iommu_handle_fault(struct amd_iommu *iommu,
+			u64 address, int type, int flags,
+			int devid, int domid)
+{
+	int ret = -EINVAL;
+
+	switch (type) {
+	/* Events which report device specific errors */
+	case EVENT_TYPE_IO_FAULT:
+	case EVENT_TYPE_ILL_DEV:
+	case EVENT_TYPE_INV_DEV_REQ:
+	case EVENT_TYPE_INV_PPR_REQ:
+		ret = _iommu_handle_dev_fault(iommu,
+			address, type, flags, devid, domid);
+		break;
+	/* Events which report commands errors */
+	case EVENT_TYPE_ILL_CMD:
+		panic("AMD-Vi: Illegal IOMMU command. This has caused"
+		      "IOMMU to stop functioning.\n");
+		break;
+	/* Events which report hardware errors */
+	case EVENT_TYPE_DEV_TAB_ERR:
+	case EVENT_TYPE_PAGE_TAB_ERR:
+	case EVENT_TYPE_CMD_HARD_ERR:
+	{
+		amd_iommu_print_event(type, devid, domid, flags, address);
+		panic("AMD-Vi: IOMMU hardware error.\n");
+		break;
+	}
+	default:
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 66e3722..145d6ab 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1682,6 +1682,8 @@ static void __init free_on_init_error(void)
 	gart_iommu_init();
 
 #endif
+
+	amd_iommu_clear_all_dev_faults();
 }
 
 /* SB IOAPIC is always on this device in AMD systems */
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index c294961..eab830d 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -63,6 +63,12 @@ extern struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev);
 extern int amd_iommu_complete_ppr(struct pci_dev *pdev, int pasid,
 				  int status, int tag);
 
+extern int amd_iommu_handle_fault(struct amd_iommu *iommu,
+				  u64 address, int type, int flags,
+				  int devid, int domid);
+
+extern void amd_iommu_clear_all_dev_faults(void);
+
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 85b7a65..982411d 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -116,6 +116,7 @@
 #define EVENT_TYPE_CMD_HARD_ERR	0x6
 #define EVENT_TYPE_IOTLB_INV_TO	0x7
 #define EVENT_TYPE_INV_DEV_REQ	0x8
+#define EVENT_TYPE_INV_PPR_REQ	0x9
 #define EVENT_DEVID_MASK	0xffff
 #define EVENT_DEVID_SHIFT	0
 #define EVENT_DOMID_MASK	0xffff
@@ -172,6 +173,7 @@
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
 #define DEV_ENTRY_TRANSLATION   0x01
+#define DEV_ENTRY_GUEST_TRANSLATION   0x37
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
 #define DEV_ENTRY_NO_PAGE_FAULT	0x62
@@ -179,6 +181,7 @@
 #define DEV_ENTRY_SYSMGT1       0x68
 #define DEV_ENTRY_SYSMGT2       0x69
 #define DEV_ENTRY_IRQ_TBL_EN	0x80
+#define DEV_ENTRY_IG		0x85
 #define DEV_ENTRY_INIT_PASS     0xb8
 #define DEV_ENTRY_EINT_PASS     0xb9
 #define DEV_ENTRY_NMI_PASS      0xba
@@ -626,6 +629,13 @@ struct dev_table_entry {
 };
 
 /*
+ * general struct to manage commands send to an IOMMU
+ */
+struct iommu_cmd {
+	u32 data[4];
+};
+
+/*
  * One entry for unity mappings parsed out of the ACPI table.
  */
 struct unity_map_entry {
-- 
1.7.10.4


