Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaIHRtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:49:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44711 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376AbaIHRrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:55 -0400
X-Sasl-enc: dVqeR7w1VOn/W4jJ+wdKXqzkG435Q47KlcdnWSbdv77j 1410197880
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 2/8] x86, microcode, intel: don't update each HT core twice
Date: Mon,  8 Sep 2014 14:37:48 -0300
Message-Id: <1410197875-19252-3-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression introduced by 506ed6b53e00ba303ad778122f08e1fca7cf5efb,
"x86, intel: Output microcode revision in /proc/cpuinfo", which added a
cache of the thread microcode revision to cpu_data()->microcode and
switched the microcode driver to using the cached value.

This caused the driver to needlessly update each processor core twice
when hyper-threading is enabled (once per hardware thread).  The early
microcode update code that runs during BSP/AP setup does not have this
problem.

Intel microcode update operations are extremely expensive.  The WRMSR
79H instruction could take anywhere from a hundred-thousand to several
million cycles to successfully apply a microcode update, depending on
processor model and microcode update size.

To avoid updating the same core twice per microcode update run, refresh
the microcode revision of each CPU (hardware thread) before deciding
whether it needs an update or not.

A silent version of collect_cpu_info() is required for this fix,
otherwise the logs produced by a microcode update run would be twice as
long and very confusing.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel.c |   39 ++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index c6826d1..2c629d1 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -87,7 +87,7 @@ MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
-static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
+static void __collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
 	unsigned int val[2];
@@ -102,7 +102,19 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
-	csig->rev = c->microcode;
+	/* get the current microcode revision from MSR 0x8B */
+	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+	sync_core();
+	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+
+	csig->rev = val[1];
+	c->microcode = val[1];  /* re-sync */
+}
+
+static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
+{
+	__collect_cpu_info(cpu_num, csig);
+
 	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
 		cpu_num, csig->sig, csig->pf, csig->rev);
 
@@ -118,7 +130,10 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	struct cpu_signature cpu_sig;
 	unsigned int csig, cpf, crev;
 
-	collect_cpu_info(cpu, &cpu_sig);
+	/* NOTE: cpu_data()->microcode will be outdated on HT
+	 * processors during an update run, it must be refreshed
+	 * from MSR 0x8B */
+	__collect_cpu_info(cpu, &cpu_sig);
 
 	csig = cpu_sig.sig;
 	cpf = cpu_sig.pf;
@@ -145,23 +160,21 @@ static int apply_microcode_intel(int cpu)
 		return 0;
 
 	/*
-	 * Microcode on this CPU could be updated earlier. Only apply the
-	 * microcode patch in mc_intel when it is newer than the one on this
-	 * CPU.
+	 * Microcode on this CPU might be already up-to-date.  Only apply
+	 * the microcode patch in mc_intel when it is newer than the one
+	 * on this CPU.
 	 */
 	if (get_matching_mc(mc_intel, cpu) == 0)
 		return 0;
 
-	/* write microcode via MSR 0x79 */
+	/* write microcode via MSR 0x79. THIS IS VERY EXPENSIVE */
 	wrmsr(MSR_IA32_UCODE_WRITE,
-	      (unsigned long) mc_intel->bits,
-	      (unsigned long) mc_intel->bits >> 16 >> 16);
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-
-	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
+		lower_32_bits((unsigned long) mc_intel->bits),
+		upper_32_bits((unsigned long) mc_intel->bits));
 
 	/* get the current revision from MSR 0x8B */
+	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+	sync_core();
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
 	if (val[1] != mc_intel->hdr.rev) {
-- 
1.7.10.4

