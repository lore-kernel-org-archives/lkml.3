Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaAPNkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaAPNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:59 -0500
Date: Thu, 16 Jan 2014 05:39:23 -0800
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, rric@kernel.org
In-Reply-To: <1389797849-5565-1-git-send-email-rric.net@gmail.com>
References: <1389797849-5565-1-git-send-email-rric.net@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd/ibs:
  Fix waking up from S3 for AMD family 10h
Git-Commit-ID: bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:39:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6
Gitweb:     http://git.kernel.org/tip/bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6
Author:     Robert Richter <rric@kernel.org>
AuthorDate: Wed, 15 Jan 2014 15:57:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:19:50 +0100

perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

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
Cc: <stable@vger.kernel.org> v3.2..
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1389797849-5565-1-git-send-email-rric.net@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 53 +++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..4b8e4d3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ptrace.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/apic.h>
 
@@ -816,6 +817,18 @@ out:
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
+static inline void perf_ibs_pm_init(void) { }
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
