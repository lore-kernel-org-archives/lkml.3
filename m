Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBLI1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:27:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50210 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbaBLIOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:04 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Robert Richter" <rric@kernel.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.660321057@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 73/79] perf/x86/amd/ibs: Fix waking up from S3 for AMD
 family 10h
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rric@kernel.org>

commit bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6 upstream.

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

Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1389797849-5565-1-git-send-email-rric.net@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 53 +++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -9,6 +9,7 @@
 #include <linux/perf_event.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/apic.h>
 
@@ -209,6 +210,18 @@ out:
 	return ret;
 }
 
+static void ibs_eilvt_setup(void)
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
@@ -244,6 +257,36 @@ static void clear_APIC_ibs(void *dummy)
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
+static inline void perf_ibs_pm_init(void) { }
+
+#endif
+
 static int __cpuinit
 perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
@@ -270,18 +313,12 @@ static __init int amd_ibs_init(void)
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

