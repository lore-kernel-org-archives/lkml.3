Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbbAIDf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:35:29 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41687 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbbAIDf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:35:26 -0500
From: Cyril Bur <cyrilbur@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, drjones@redhat.com, dzickus@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, fabf@skynet.be, atomlin@redhat.com,
        benzh@chromium.org, schwidefsky@de.ibm.com,
        Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH v2 2/2] powerpc: add running_clock for powerpc to prevent spurious softlockup warnings
Date: Fri,  9 Jan 2015 14:34:38 +1100
Message-Id: <1420774478-16760-3-git-send-email-cyrilbur@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420774478-16760-1-git-send-email-cyrilbur@gmail.com>
References: <1420774478-16760-1-git-send-email-cyrilbur@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010903-0017-0000-0000-000000A47CEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On POWER8 virtualised kernels the VTB register can be read to have a view of
time that only increases while the guest is running. This will prevent guests
from seeing time jump if a guest is paused for significant amounts of time.

On POWER7 and below virtualised kernels stolen time is subtracted from
local_clock as a best effort approximation. This will not eliminate spurious
warnings in the case of a suspended guest but may reduce the occurance in the
case of softlockups due to host over commit.

Bare metal kernels should avoid reading the VTB as KVM does not restore sane
values when not executing, the approxmation is fine as host kernels won't
observe any stolen time.

Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
---
V2:
   Replaced the use of sched_clock_with local_clock it was used originally in
the softlockup detector.
   Added #ifdef CONFIG_PPC_PSERIES and optimised the non lpar + vtb cases.

---
 arch/powerpc/kernel/time.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index fa7c4f1..fd35e5b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -621,6 +621,38 @@ unsigned long long sched_clock(void)
 	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
 }
 
+
+#ifdef CONFIG_PPC_PSERIES
+
+/*
+ * Running clock - attempts to give a view of time passing for a virtualised
+ * kernels.
+ * Uses the VTB register if available otherwise a next best guess.
+ */
+unsigned long long running_clock(void)
+{
+	/*
+	 * Don't read the VTB as a host since KVM does not switch in host timebase
+	 * into the VTB when it takes a guest off the CPU, reading the VTB would
+	 * result in reading 'last switched out' guest VTB.
+	 *
+	 * Host kernels are often compiled with CONFIG_PSERIES checked, it would be
+	 * unsafe to rely only on the #ifdef above.
+	 */
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    cpu_has_feature(CPU_FTR_ARCH_207S))
+		return mulhdu(get_vtb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
+
+	/*
+	 * This is a next best approximation without a VTB.
+	 * On a host which is running bare metal there should never be any stolen
+	 * time and on a host which doesn't do any virtualisation TB *should* equal
+	 * VTB so it makes no difference anyway.
+	 */
+	return local_clock() - cputime_to_nsecs(kcpustat_this_cpu->cpustat[CPUTIME_STEAL]);
+}
+#endif
+
 static int __init get_freq(char *name, int cells, unsigned long *val)
 {
 	struct device_node *cpu;
-- 
1.9.1

