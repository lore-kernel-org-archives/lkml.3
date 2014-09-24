Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaIXPBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:01:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIXPBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:01:01 -0400
Date: Wed, 24 Sep 2014 08:00:10 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-e735b9db12d76d45f74aee78bd63bbd2f8f480e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zheng.z.yan@intel.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1409872109-31645-2-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Add Haswell-EP uncore support
Git-Commit-ID: e735b9db12d76d45f74aee78bd63bbd2f8f480e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e735b9db12d76d45f74aee78bd63bbd2f8f480e1
Gitweb:     http://git.kernel.org/tip/e735b9db12d76d45f74aee78bd63bbd2f8f480e1
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Thu, 4 Sep 2014 16:08:26 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:21 +0200

perf/x86/intel/uncore: Add Haswell-EP uncore support

The uncore subsystem in Haswell-EP is similar to Sandy/Ivy
Bridge-EP. There are some differences in config register
encoding and pci device IDs. The Haswell-EP uncore also
supports a few new events. Add the Haswell-EP driver to
the snbep split driver.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
[ Add missing break. Add imc events. Add cbox nc/isoc/c6. ]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/1409872109-31645-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   7 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |   2 +
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 608 ++++++++++++++++++++-
 3 files changed, 615 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 812ec5d..2b0fa02 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -883,6 +883,9 @@ static int __init uncore_pci_init(void)
 	case 62: /* Ivy Bridge-EP */
 		ret = ivbep_uncore_pci_init();
 		break;
+	case 63: /* Haswell-EP */
+		ret = hswep_uncore_pci_init();
+		break;
 	case 42: /* Sandy Bridge */
 		ret = snb_uncore_pci_init();
 		break;
@@ -1190,7 +1193,9 @@ static int __init uncore_cpu_init(void)
 	case 62: /* Ivy Bridge-EP */
 		ivbep_uncore_cpu_init();
 		break;
-
+	case 63: /* Haswell-EP */
+		hswep_uncore_cpu_init();
+		break;
 	default:
 		return 0;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 1d7e894..18eb78b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -332,6 +332,8 @@ int snbep_uncore_pci_init(void);
 void snbep_uncore_cpu_init(void);
 int ivbep_uncore_pci_init(void);
 void ivbep_uncore_cpu_init(void);
+int hswep_uncore_pci_init(void);
+void hswep_uncore_cpu_init(void);
 
 /* perf_event_intel_uncore_nhmex.c */
 void nhmex_uncore_cpu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 6606ed0..a4fe9fa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -163,6 +163,53 @@
 #define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
 				((1ULL << (n)) - 1)))
 
+/* Haswell-EP Ubox */
+#define HSWEP_U_MSR_PMON_CTR0			0x705
+#define HSWEP_U_MSR_PMON_CTL0			0x709
+#define HSWEP_U_MSR_PMON_FILTER			0x707
+
+#define HSWEP_U_MSR_PMON_UCLK_FIXED_CTL		0x703
+#define HSWEP_U_MSR_PMON_UCLK_FIXED_CTR		0x704
+
+#define HSWEP_U_MSR_PMON_BOX_FILTER_TID		(0x1 << 0)
+#define HSWEP_U_MSR_PMON_BOX_FILTER_CID		(0x1fULL << 1)
+#define HSWEP_U_MSR_PMON_BOX_FILTER_MASK \
+					(HSWEP_U_MSR_PMON_BOX_FILTER_TID | \
+					 HSWEP_U_MSR_PMON_BOX_FILTER_CID)
+
+/* Haswell-EP CBo */
+#define HSWEP_C0_MSR_PMON_CTR0			0xe08
+#define HSWEP_C0_MSR_PMON_CTL0			0xe01
+#define HSWEP_C0_MSR_PMON_BOX_CTL			0xe00
+#define HSWEP_C0_MSR_PMON_BOX_FILTER0		0xe05
+#define HSWEP_CBO_MSR_OFFSET			0x10
+
+
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_TID		(0x3fULL << 0)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_LINK	(0xfULL << 6)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_STATE	(0x7fULL << 17)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_NID		(0xffffULL << 32)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_ISOC	(0x1ULL << 63)
+
+
+/* Haswell-EP Sbox */
+#define HSWEP_S0_MSR_PMON_CTR0			0x726
+#define HSWEP_S0_MSR_PMON_CTL0			0x721
+#define HSWEP_S0_MSR_PMON_BOX_CTL			0x720
+#define HSWEP_SBOX_MSR_OFFSET			0xa
+#define HSWEP_S_MSR_PMON_RAW_EVENT_MASK		(SNBEP_PMON_RAW_EVENT_MASK | \
+						 SNBEP_CBO_PMON_CTL_TID_EN)
+
+/* Haswell-EP PCU */
+#define HSWEP_PCU_MSR_PMON_CTR0			0x717
+#define HSWEP_PCU_MSR_PMON_CTL0			0x711
+#define HSWEP_PCU_MSR_PMON_BOX_CTL		0x710
+#define HSWEP_PCU_MSR_PMON_BOX_FILTER		0x715
+
+
 DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(event_ext, event, "config:0-7,21");
 DEFINE_UNCORE_FORMAT_ATTR(umask, umask, "config:8-15");
@@ -175,13 +222,21 @@ DEFINE_UNCORE_FORMAT_ATTR(occ_sel, occ_sel, "config:14-15");
 DEFINE_UNCORE_FORMAT_ATTR(occ_invert, occ_invert, "config:30");
 DEFINE_UNCORE_FORMAT_ATTR(occ_edge, occ_edge, "config:14-51");
 DEFINE_UNCORE_FORMAT_ATTR(filter_tid, filter_tid, "config1:0-4");
+DEFINE_UNCORE_FORMAT_ATTR(filter_tid2, filter_tid, "config1:0");
+DEFINE_UNCORE_FORMAT_ATTR(filter_tid3, filter_tid, "config1:0-5");
+DEFINE_UNCORE_FORMAT_ATTR(filter_cid, filter_cid, "config1:5");
 DEFINE_UNCORE_FORMAT_ATTR(filter_link, filter_link, "config1:5-8");
+DEFINE_UNCORE_FORMAT_ATTR(filter_link2, filter_link, "config1:6-8");
 DEFINE_UNCORE_FORMAT_ATTR(filter_nid, filter_nid, "config1:10-17");
 DEFINE_UNCORE_FORMAT_ATTR(filter_nid2, filter_nid, "config1:32-47");
 DEFINE_UNCORE_FORMAT_ATTR(filter_state, filter_state, "config1:18-22");
 DEFINE_UNCORE_FORMAT_ATTR(filter_state2, filter_state, "config1:17-22");
+DEFINE_UNCORE_FORMAT_ATTR(filter_state3, filter_state, "config1:17-23");
 DEFINE_UNCORE_FORMAT_ATTR(filter_opc, filter_opc, "config1:23-31");
 DEFINE_UNCORE_FORMAT_ATTR(filter_opc2, filter_opc, "config1:52-60");
+DEFINE_UNCORE_FORMAT_ATTR(filter_nc, filter_nc, "config1:62");
+DEFINE_UNCORE_FORMAT_ATTR(filter_c6, filter_c6, "config1:61");
+DEFINE_UNCORE_FORMAT_ATTR(filter_isoc, filter_isoc, "config1:63");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band0, filter_band0, "config1:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band1, filter_band1, "config1:8-15");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band2, filter_band2, "config1:16-23");
@@ -857,7 +912,6 @@ static void snbep_qpi_enable_event(struct intel_uncore_box *box, struct perf_eve
 	if (reg1->idx != EXTRA_REG_NONE) {
 		int idx = box->pmu->pmu_idx + SNBEP_PCI_QPI_PORT0_FILTER;
 		struct pci_dev *filter_pdev = uncore_extra_pci_dev[box->phys_id][idx];
-		WARN_ON_ONCE(!filter_pdev);
 		if (filter_pdev) {
 			pci_write_config_dword(filter_pdev, reg1->reg,
 						(u32)reg1->config);
@@ -1643,3 +1697,555 @@ int ivbep_uncore_pci_init(void)
 	return 0;
 }
 /* end of IvyTown uncore support */
+
+/* Haswell-EP uncore support */
+static struct attribute *hswep_uncore_ubox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_thresh5.attr,
+	&format_attr_filter_tid2.attr,
+	&format_attr_filter_cid.attr,
+	NULL,
+};
+
+static struct attribute_group hswep_uncore_ubox_format_group = {
+	.name = "format",
+	.attrs = hswep_uncore_ubox_formats_attr,
+};
+
+static int hswep_ubox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	reg1->reg = HSWEP_U_MSR_PMON_FILTER;
+	reg1->config = event->attr.config1 & HSWEP_U_MSR_PMON_BOX_FILTER_MASK;
+	reg1->idx = 0;
+	return 0;
+}
+
+static struct intel_uncore_ops hswep_uncore_ubox_ops = {
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= hswep_ubox_hw_config,
+	.get_constraint		= uncore_get_constraint,
+	.put_constraint		= uncore_put_constraint,
+};
+
+static struct intel_uncore_type hswep_uncore_ubox = {
+	.name			= "ubox",
+	.num_counters		= 2,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 44,
+	.fixed_ctr_bits		= 48,
+	.perf_ctr		= HSWEP_U_MSR_PMON_CTR0,
+	.event_ctl		= HSWEP_U_MSR_PMON_CTL0,
+	.event_mask		= SNBEP_U_MSR_PMON_RAW_EVENT_MASK,
+	.fixed_ctr		= HSWEP_U_MSR_PMON_UCLK_FIXED_CTR,
+	.fixed_ctl		= HSWEP_U_MSR_PMON_UCLK_FIXED_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &hswep_uncore_ubox_ops,
+	.format_group		= &hswep_uncore_ubox_format_group,
+};
+
+static struct attribute *hswep_uncore_cbox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_tid_en.attr,
+	&format_attr_thresh8.attr,
+	&format_attr_filter_tid3.attr,
+	&format_attr_filter_link2.attr,
+	&format_attr_filter_state3.attr,
+	&format_attr_filter_nid2.attr,
+	&format_attr_filter_opc2.attr,
+	&format_attr_filter_nc.attr,
+	&format_attr_filter_c6.attr,
+	&format_attr_filter_isoc.attr,
+	NULL,
+};
+
+static struct attribute_group hswep_uncore_cbox_format_group = {
+	.name = "format",
+	.attrs = hswep_uncore_cbox_formats_attr,
+};
+
+static struct event_constraint hswep_uncore_cbox_constraints[] = {
+	UNCORE_EVENT_CONSTRAINT(0x01, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x09, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x11, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x36, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x38, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x3b, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x3e, 0x1),
+	EVENT_CONSTRAINT_END
+};
+
+static struct extra_reg hswep_uncore_cbox_extra_regs[] = {
+	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
+				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2134, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4037, 0x40ff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4028, 0x40ff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4032, 0x40ff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4029, 0x40ff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4033, 0x40ff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x402A, 0x40ff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x12),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2335, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8335, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2135, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8135, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4436, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4836, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4a36, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2136, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8136, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5036, 0xffff, 0x8),
+	EVENT_EXTRA_END
+};
+
+static u64 hswep_cbox_filter_mask(int fields)
+{
+	u64 mask = 0;
+	if (fields & 0x1)
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_TID;
+	if (fields & 0x2)
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_LINK;
+	if (fields & 0x4)
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_STATE;
+	if (fields & 0x8)
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_NID;
+	if (fields & 0x10) {
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_OPC;
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_NC;
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_C6;
+		mask |= HSWEP_CB0_MSR_PMON_BOX_FILTER_ISOC;
+	}
+	return mask;
+}
+
+static struct event_constraint *
+hswep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	return __snbep_cbox_get_constraint(box, event, hswep_cbox_filter_mask);
+}
+
+static int hswep_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct extra_reg *er;
+	int idx = 0;
+
+	for (er = hswep_uncore_cbox_extra_regs; er->msr; er++) {
+		if (er->event != (event->hw.config & er->config_mask))
+			continue;
+		idx |= er->idx;
+	}
+
+	if (idx) {
+		reg1->reg = HSWEP_C0_MSR_PMON_BOX_FILTER0 +
+			    HSWEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
+		reg1->config = event->attr.config1 & hswep_cbox_filter_mask(idx);
+		reg1->idx = idx;
+	}
+	return 0;
+}
+
+static void hswep_cbox_enable_event(struct intel_uncore_box *box,
+				  struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+
+	if (reg1->idx != EXTRA_REG_NONE) {
+		u64 filter = uncore_shared_reg_config(box, 0);
+		wrmsrl(reg1->reg, filter & 0xffffffff);
+		wrmsrl(reg1->reg + 1, filter >> 32);
+	}
+
+	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
+}
+
+static struct intel_uncore_ops hswep_uncore_cbox_ops = {
+	.init_box		= snbep_uncore_msr_init_box,
+	.disable_box		= snbep_uncore_msr_disable_box,
+	.enable_box		= snbep_uncore_msr_enable_box,
+	.disable_event		= snbep_uncore_msr_disable_event,
+	.enable_event		= hswep_cbox_enable_event,
+	.read_counter		= uncore_msr_read_counter,
+	.hw_config		= hswep_cbox_hw_config,
+	.get_constraint		= hswep_cbox_get_constraint,
+	.put_constraint		= snbep_cbox_put_constraint,
+};
+
+static struct intel_uncore_type hswep_uncore_cbox = {
+	.name			= "cbox",
+	.num_counters		= 4,
+	.num_boxes		= 18,
+	.perf_ctr_bits		= 44,
+	.event_ctl		= HSWEP_C0_MSR_PMON_CTL0,
+	.perf_ctr		= HSWEP_C0_MSR_PMON_CTR0,
+	.event_mask		= SNBEP_CBO_MSR_PMON_RAW_EVENT_MASK,
+	.box_ctl		= HSWEP_C0_MSR_PMON_BOX_CTL,
+	.msr_offset		= HSWEP_CBO_MSR_OFFSET,
+	.num_shared_regs	= 1,
+	.constraints		= hswep_uncore_cbox_constraints,
+	.ops			= &hswep_uncore_cbox_ops,
+	.format_group		= &hswep_uncore_cbox_format_group,
+};
+
+static struct attribute *hswep_uncore_sbox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_tid_en.attr,
+	&format_attr_inv.attr,
+	&format_attr_thresh8.attr,
+	NULL,
+};
+
+static struct attribute_group hswep_uncore_sbox_format_group = {
+	.name = "format",
+	.attrs = hswep_uncore_sbox_formats_attr,
+};
+
+static struct intel_uncore_type hswep_uncore_sbox = {
+	.name			= "sbox",
+	.num_counters		= 4,
+	.num_boxes		= 4,
+	.perf_ctr_bits		= 44,
+	.event_ctl		= HSWEP_S0_MSR_PMON_CTL0,
+	.perf_ctr		= HSWEP_S0_MSR_PMON_CTR0,
+	.event_mask		= HSWEP_S_MSR_PMON_RAW_EVENT_MASK,
+	.box_ctl		= HSWEP_S0_MSR_PMON_BOX_CTL,
+	.msr_offset		= HSWEP_SBOX_MSR_OFFSET,
+	.ops			= &snbep_uncore_msr_ops,
+	.format_group		= &hswep_uncore_sbox_format_group,
+};
+
+static int hswep_pcu_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	int ev_sel = hwc->config & SNBEP_PMON_CTL_EV_SEL_MASK;
+
+	if (ev_sel >= 0xb && ev_sel <= 0xe) {
+		reg1->reg = HSWEP_PCU_MSR_PMON_BOX_FILTER;
+		reg1->idx = ev_sel - 0xb;
+		reg1->config = event->attr.config1 & (0xff << reg1->idx);
+	}
+	return 0;
+}
+
+static struct intel_uncore_ops hswep_uncore_pcu_ops = {
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= hswep_pcu_hw_config,
+	.get_constraint		= snbep_pcu_get_constraint,
+	.put_constraint		= snbep_pcu_put_constraint,
+};
+
+static struct intel_uncore_type hswep_uncore_pcu = {
+	.name			= "pcu",
+	.num_counters		= 4,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 48,
+	.perf_ctr		= HSWEP_PCU_MSR_PMON_CTR0,
+	.event_ctl		= HSWEP_PCU_MSR_PMON_CTL0,
+	.event_mask		= SNBEP_PCU_MSR_PMON_RAW_EVENT_MASK,
+	.box_ctl		= HSWEP_PCU_MSR_PMON_BOX_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &hswep_uncore_pcu_ops,
+	.format_group		= &snbep_uncore_pcu_format_group,
+};
+
+static struct intel_uncore_type *hswep_msr_uncores[] = {
+	&hswep_uncore_ubox,
+	&hswep_uncore_cbox,
+	&hswep_uncore_sbox,
+	&hswep_uncore_pcu,
+	NULL,
+};
+
+void hswep_uncore_cpu_init(void)
+{
+	if (hswep_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
+		hswep_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
+	uncore_msr_uncores = hswep_msr_uncores;
+}
+
+static struct intel_uncore_type hswep_uncore_ha = {
+	.name		= "ha",
+	.num_counters   = 5,
+	.num_boxes	= 2,
+	.perf_ctr_bits	= 48,
+	SNBEP_UNCORE_PCI_COMMON_INIT(),
+};
+
+static struct uncore_event_desc hswep_uncore_imc_events[] = {
+	INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0x00,umask=0x00"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
+	{ /* end: all zeroes */ },
+};
+
+static struct intel_uncore_type hswep_uncore_imc = {
+	.name		= "imc",
+	.num_counters   = 5,
+	.num_boxes	= 8,
+	.perf_ctr_bits	= 48,
+	.fixed_ctr_bits	= 48,
+	.fixed_ctr	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
+	.fixed_ctl	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
+	.event_descs	= hswep_uncore_imc_events,
+	SNBEP_UNCORE_PCI_COMMON_INIT(),
+};
+
+static struct intel_uncore_ops hswep_uncore_irp_ops = {
+	.init_box	= snbep_uncore_pci_init_box,
+	.disable_box	= snbep_uncore_pci_disable_box,
+	.enable_box	= snbep_uncore_pci_enable_box,
+	.disable_event	= ivbep_uncore_irp_disable_event,
+	.enable_event	= ivbep_uncore_irp_enable_event,
+	.read_counter	= ivbep_uncore_irp_read_counter,
+};
+
+static struct intel_uncore_type hswep_uncore_irp = {
+	.name			= "irp",
+	.num_counters		= 4,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 48,
+	.event_mask		= SNBEP_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
+	.ops			= &hswep_uncore_irp_ops,
+	.format_group		= &snbep_uncore_format_group,
+};
+
+static struct intel_uncore_type hswep_uncore_qpi = {
+	.name			= "qpi",
+	.num_counters		= 5,
+	.num_boxes		= 3,
+	.perf_ctr_bits		= 48,
+	.perf_ctr		= SNBEP_PCI_PMON_CTR0,
+	.event_ctl		= SNBEP_PCI_PMON_CTL0,
+	.event_mask		= SNBEP_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &snbep_uncore_qpi_ops,
+	.format_group		= &snbep_uncore_qpi_format_group,
+};
+
+static struct event_constraint hswep_uncore_r2pcie_constraints[] = {
+	UNCORE_EVENT_CONSTRAINT(0x10, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x11, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x13, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x23, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x24, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x25, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x26, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x27, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x28, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x29, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2a, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x2b, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2c, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2d, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x32, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x33, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x34, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x35, 0x3),
+	EVENT_CONSTRAINT_END
+};
+
+static struct intel_uncore_type hswep_uncore_r2pcie = {
+	.name		= "r2pcie",
+	.num_counters   = 4,
+	.num_boxes	= 1,
+	.perf_ctr_bits	= 48,
+	.constraints	= hswep_uncore_r2pcie_constraints,
+	SNBEP_UNCORE_PCI_COMMON_INIT(),
+};
+
+static struct event_constraint hswep_uncore_r3qpi_constraints[] = {
+	UNCORE_EVENT_CONSTRAINT(0x01, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x07, 0x7),
+	UNCORE_EVENT_CONSTRAINT(0x08, 0x7),
+	UNCORE_EVENT_CONSTRAINT(0x09, 0x7),
+	UNCORE_EVENT_CONSTRAINT(0x0a, 0x7),
+	UNCORE_EVENT_CONSTRAINT(0x0e, 0x7),
+	UNCORE_EVENT_CONSTRAINT(0x10, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x11, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x12, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x13, 0x1),
+	UNCORE_EVENT_CONSTRAINT(0x14, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x15, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x1f, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x20, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x21, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x22, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x23, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x25, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x26, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x28, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x29, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2c, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2d, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2e, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2f, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x31, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x32, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x33, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x34, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x36, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x37, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x38, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x39, 0x3),
+	EVENT_CONSTRAINT_END
+};
+
+static struct intel_uncore_type hswep_uncore_r3qpi = {
+	.name		= "r3qpi",
+	.num_counters   = 4,
+	.num_boxes	= 3,
+	.perf_ctr_bits	= 44,
+	.constraints	= hswep_uncore_r3qpi_constraints,
+	SNBEP_UNCORE_PCI_COMMON_INIT(),
+};
+
+enum {
+	HSWEP_PCI_UNCORE_HA,
+	HSWEP_PCI_UNCORE_IMC,
+	HSWEP_PCI_UNCORE_IRP,
+	HSWEP_PCI_UNCORE_QPI,
+	HSWEP_PCI_UNCORE_R2PCIE,
+	HSWEP_PCI_UNCORE_R3QPI,
+};
+
+static struct intel_uncore_type *hswep_pci_uncores[] = {
+	[HSWEP_PCI_UNCORE_HA]	= &hswep_uncore_ha,
+	[HSWEP_PCI_UNCORE_IMC]	= &hswep_uncore_imc,
+	[HSWEP_PCI_UNCORE_IRP]	= &hswep_uncore_irp,
+	[HSWEP_PCI_UNCORE_QPI]	= &hswep_uncore_qpi,
+	[HSWEP_PCI_UNCORE_R2PCIE]	= &hswep_uncore_r2pcie,
+	[HSWEP_PCI_UNCORE_R3QPI]	= &hswep_uncore_r3qpi,
+	NULL,
+};
+
+static DEFINE_PCI_DEVICE_TABLE(hswep_uncore_pci_ids) = {
+	{ /* Home Agent 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f30),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_HA, 0),
+	},
+	{ /* Home Agent 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f38),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_HA, 1),
+	},
+	{ /* MC0 Channel 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fb0),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 0),
+	},
+	{ /* MC0 Channel 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fb1),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 1),
+	},
+	{ /* MC0 Channel 2 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fb4),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 2),
+	},
+	{ /* MC0 Channel 3 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fb5),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 3),
+	},
+	{ /* MC1 Channel 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fd0),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 4),
+	},
+	{ /* MC1 Channel 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fd1),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 5),
+	},
+	{ /* MC1 Channel 2 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fd4),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 6),
+	},
+	{ /* MC1 Channel 3 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fd5),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IMC, 7),
+	},
+	{ /* IRP */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f39),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_IRP, 0),
+	},
+	{ /* QPI0 Port 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f32),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_QPI, 0),
+	},
+	{ /* QPI0 Port 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f33),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_QPI, 1),
+	},
+	{ /* QPI1 Port 2 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f3a),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_QPI, 2),
+	},
+	{ /* R2PCIe */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f34),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_R2PCIE, 0),
+	},
+	{ /* R3QPI0 Link 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f36),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_R3QPI, 0),
+	},
+	{ /* R3QPI0 Link 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f37),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_R3QPI, 1),
+	},
+	{ /* R3QPI1 Link 2 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f3e),
+		.driver_data = UNCORE_PCI_DEV_DATA(HSWEP_PCI_UNCORE_R3QPI, 2),
+	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f86),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT0_FILTER),
+	},
+	{ /* QPI Port 1 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2f96),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT1_FILTER),
+	},
+	{ /* end: all zeroes */ }
+};
+
+static struct pci_driver hswep_uncore_pci_driver = {
+	.name		= "hswep_uncore",
+	.id_table	= hswep_uncore_pci_ids,
+};
+
+int hswep_uncore_pci_init(void)
+{
+	int ret = snbep_pci2phy_map_init(0x2f1e);
+	if (ret)
+		return ret;
+	uncore_pci_uncores = hswep_pci_uncores;
+	uncore_pci_driver = &hswep_uncore_pci_driver;
+	return 0;
+}
+/* end of Haswell-EP uncore support */
