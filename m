Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbaKTHqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:46:52 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:51375 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaKTHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:46:51 -0500
Date: Thu, 20 Nov 2014 08:46:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20141120074645.GA4092@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 68055915c1c22489f9658bd2b7391bb11b2cf4e4 perf/x86/intel/uncore: Fix boot crash on SBOX PMU on Haswell-EP

Misc fixes: two Intel uncore driver fixes, a CPU-hotplug fix and 
a build dependencies fix.

 Thanks,

	Ingo

------------------>
Andi Kleen (2):
      perf/x86/intel/uncore: Fix IRP uncore register offsets on Haswell EP
      perf/x86/intel/uncore: Fix boot crash on SBOX PMU on Haswell-EP

Mark Rutland (1):
      perf: Fix corruption of sibling list with hotplug

Peter Zijlstra (Intel) (1):
      perf/x86: Fix embarrasing typo


 arch/x86/Kconfig                                   |  2 +-
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 49 ++++++++++++++++++++--
 kernel/events/core.c                               |  8 ++--
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a6774ac9..41a503c15862 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -144,7 +144,7 @@ config INSTRUCTION_DECODER
 
 config PERF_EVENTS_INTEL_UNCORE
 	def_bool y
-	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI
+	depends on PERF_EVENTS && CPU_SUP_INTEL && PCI
 
 config OUTPUT_FORMAT
 	string
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index adf138eac85c..f9ed429d6e4f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -486,14 +486,17 @@ static struct attribute_group snbep_uncore_qpi_format_group = {
 	.attrs = snbep_uncore_qpi_formats_attr,
 };
 
-#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
-	.init_box	= snbep_uncore_msr_init_box,		\
+#define __SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
 	.disable_box	= snbep_uncore_msr_disable_box,		\
 	.enable_box	= snbep_uncore_msr_enable_box,		\
 	.disable_event	= snbep_uncore_msr_disable_event,	\
 	.enable_event	= snbep_uncore_msr_enable_event,	\
 	.read_counter	= uncore_msr_read_counter
 
+#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	__SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),			\
+	.init_box	= snbep_uncore_msr_init_box		\
+
 static struct intel_uncore_ops snbep_uncore_msr_ops = {
 	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
@@ -1919,6 +1922,30 @@ static struct intel_uncore_type hswep_uncore_cbox = {
 	.format_group		= &hswep_uncore_cbox_format_group,
 };
 
+/*
+ * Write SBOX Initialization register bit by bit to avoid spurious #GPs
+ */
+static void hswep_uncore_sbox_msr_init_box(struct intel_uncore_box *box)
+{
+	unsigned msr = uncore_msr_box_ctl(box);
+
+	if (msr) {
+		u64 init = SNBEP_PMON_BOX_CTL_INT;
+		u64 flags = 0;
+		int i;
+
+		for_each_set_bit(i, (unsigned long *)&init, 64) {
+			flags |= (1ULL << i);
+			wrmsrl(msr, flags);
+		}
+	}
+}
+
+static struct intel_uncore_ops hswep_uncore_sbox_msr_ops = {
+	__SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.init_box		= hswep_uncore_sbox_msr_init_box
+};
+
 static struct attribute *hswep_uncore_sbox_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1944,7 +1971,7 @@ static struct intel_uncore_type hswep_uncore_sbox = {
 	.event_mask		= HSWEP_S_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= HSWEP_S0_MSR_PMON_BOX_CTL,
 	.msr_offset		= HSWEP_SBOX_MSR_OFFSET,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &hswep_uncore_sbox_msr_ops,
 	.format_group		= &hswep_uncore_sbox_format_group,
 };
 
@@ -2025,13 +2052,27 @@ static struct intel_uncore_type hswep_uncore_imc = {
 	SNBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
+static unsigned hswep_uncore_irp_ctrs[] = {0xa0, 0xa8, 0xb0, 0xb8};
+
+static u64 hswep_uncore_irp_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 count = 0;
+
+	pci_read_config_dword(pdev, hswep_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
+	pci_read_config_dword(pdev, hswep_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&count + 1);
+
+	return count;
+}
+
 static struct intel_uncore_ops hswep_uncore_irp_ops = {
 	.init_box	= snbep_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
 	.enable_box	= snbep_uncore_pci_enable_box,
 	.disable_event	= ivbep_uncore_irp_disable_event,
 	.enable_event	= ivbep_uncore_irp_enable_event,
-	.read_counter	= ivbep_uncore_irp_read_counter,
+	.read_counter	= hswep_uncore_irp_read_counter,
 };
 
 static struct intel_uncore_type hswep_uncore_irp = {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2b02c9fda790..1cd5eef1fcdd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1562,8 +1562,10 @@ static void perf_remove_from_context(struct perf_event *event, bool detach_group
 
 	if (!task) {
 		/*
-		 * Per cpu events are removed via an smp call and
-		 * the removal is always successful.
+		 * Per cpu events are removed via an smp call. The removal can
+		 * fail if the CPU is currently offline, but in that case we
+		 * already called __perf_remove_from_context from
+		 * perf_event_exit_cpu.
 		 */
 		cpu_function_call(event->cpu, __perf_remove_from_context, &re);
 		return;
@@ -8117,7 +8119,7 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 
 static void __perf_event_exit_context(void *__info)
 {
-	struct remove_event re = { .detach_group = false };
+	struct remove_event re = { .detach_group = true };
 	struct perf_event_context *ctx = __info;
 
 	perf_pmu_rotate_stop(ctx->pmu);
