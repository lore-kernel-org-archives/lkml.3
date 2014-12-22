Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaLVFHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 00:07:07 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45256 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaLVFHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 00:07:03 -0500
From: Cyril Bur <cyrilbur@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, drjones@redhat.com, dzickus@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org, Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH 2/2] powerpc: add running_clock for powerpc to prevent spurious softlockup warnings
Date: Mon, 22 Dec 2014 16:06:04 +1100
Message-Id: <1419224764-11384-3-git-send-email-cyrilbur@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122205-0025-0000-0000-000000CA8535
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On POWER8 virtualised kernels the VTB register can be read to have a view of
time that only increases while the guest is running. This will prevent guests
from seeing time jump if a guest is paused for significant amounts of time.

On POWER7 and below virtualised kernels stolen time is subtracted from
sched_clock as a best effort approximation. This will not eliminate spurious
warnings in the case of a suspended guest but may reduce the occurance in the
case of softlockups due to host over commit.

Bare metal kernels should avoid reading the VTB as KVM does not restore sane
values when not executing. sched_clock is returned in this case.

Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
---
 arch/powerpc/kernel/time.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index fa7c4f1..9ba13ec 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -621,6 +621,30 @@ unsigned long long sched_clock(void)
 	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
 }
 
+unsigned long long running_clock(void)
+{
+	/*
+	 * Don't read the VTB as a host since KVM does not switch in host timebase
+	 * into the VTB when it takes a guest off the CPU, reading the VTB would
+	 * result in reading 'last switched out' guest VTB.
+	 */
+
+	if (firmware_has_feature(FW_FEATURE_LPAR)) {
+		if (cpu_has_feature(CPU_FTR_ARCH_207S))
+			return mulhdu(get_vtb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
+
+		/* This is a next best approximation without a VTB. */
+		return sched_clock() - cputime_to_nsecs(kcpustat_this_cpu->cpustat[CPUTIME_STEAL]);
+	}
+
+	/*
+	 * On a host which doesn't do any virtualisation TB *should* equal VTB so
+	 * it makes no difference anyway.
+	 */
+
+	return sched_clock();
+}
+
 static int __init get_freq(char *name, int cells, unsigned long *val)
 {
 	struct device_node *cpu;
-- 
1.9.1

