Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaAOO6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:58:23 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:61289 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:58:21 -0500
From: Robert Richter <rric.net@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] perf, ibs: Fix waking up from S3 for AMD family 10h
Date: Wed, 15 Jan 2014 15:57:29 +0100
Message-Id: <1389797849-5565-1-git-send-email-rric.net@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rric@kernel.org>

On AMD family 10h we see following error messages while waking up from
S3 for all non-boot CPUs leading to a failed IBS initialization:

 Enabling non-boot CPUs ...
 smpboot: Booting Node 0 Processor 1 APIC 0x1
 [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector 0x400, but the register is already in use for vector 0xf9 on another cpu
 perf: IBS APIC setup failed on cpu #1
 process: Switch to broadcast mode on CPU1
 CPU1 is up
 ...
 ACPI: Waking up from system sleep state S3

Reason for this is that during suspend the LVT offset for the IBS
vector gets lost and needs to be reinialized while resuming.

The offset is read from the IBSCTL msr. On family 10h the offset needs
to be 1 as offset 0 is used for the MCE threshold interrupt, but
firmware assings it for IBS to 0 too. The kernel needs to reprogram
the vector. The msr is a readonly node msr, but a new value can be
written via pci config space access. The reinitialization is
implemented for family 10h in setup_ibs_ctl() which is forced during
IBS setup.

This patch fixes IBS setup after waking up from S3 by adding
resume/supend hooks for the boot cpu which does the offset
reinitialization.

Marking it as stable to let distros pick up this fix.

Cc: <stable@vger.kernel.org> v3.2..
Signed-off-by: Robert Richter <rric@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 53 +++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..09c5cb9 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ptrace.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/apic.h>
 
@@ -816,6 +817,18 @@ static int force_ibs_eilvt_setup(void)
 	return ret;
 }
 
+void ibs_eilvt_setup(void)
+{
+	/*
+	 * Force LVT offset assignment for family 10h: The offsets are
+	 * not assigned by the BIOS for this family, so the OS is
+	 * responsible for doing it. If the OS assignment fails, fall
+	 * back to BIOS settings and try to setup this.
+	 */
+	if (boot_cpu_data.x86 == 0x10)
+		force_ibs_eilvt_setup();
+}
+
 static inline int get_ibs_lvt_offset(void)
 {
 	u64 val;
@@ -851,6 +864,36 @@ static void clear_APIC_ibs(void *dummy)
 		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
 }
 
+#ifdef CONFIG_PM
+
+static int perf_ibs_suspend(void)
+{
+	clear_APIC_ibs(NULL);
+	return 0;
+}
+
+static void perf_ibs_resume(void)
+{
+	ibs_eilvt_setup();
+	setup_APIC_ibs(NULL);
+}
+
+static struct syscore_ops perf_ibs_syscore_ops = {
+	.resume		= perf_ibs_resume,
+	.suspend	= perf_ibs_suspend,
+};
+
+static void perf_ibs_pm_init(void)
+{
+	register_syscore_ops(&perf_ibs_syscore_ops);
+}
+
+#else
+
+static inline void perf_ibs_pm_init(void) {}
+
+#endif
+
 static int
 perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
@@ -877,18 +920,12 @@ static __init int amd_ibs_init(void)
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	/*
-	 * Force LVT offset assignment for family 10h: The offsets are
-	 * not assigned by the BIOS for this family, so the OS is
-	 * responsible for doing it. If the OS assignment fails, fall
-	 * back to BIOS settings and try to setup this.
-	 */
-	if (boot_cpu_data.x86 == 0x10)
-		force_ibs_eilvt_setup();
+	ibs_eilvt_setup();
 
 	if (!ibs_eilvt_valid())
 		goto out;
 
+	perf_ibs_pm_init();
 	get_online_cpus();
 	ibs_caps = caps;
 	/* make ibs_caps visible to other cpus: */
-- 
1.8.4.2

