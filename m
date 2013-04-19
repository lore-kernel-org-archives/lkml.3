Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3DSRV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:21:26 -0400
Received: from relay1.blacknight.com ([78.153.203.204]:58342 "EHLO
	relay1.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3DSRVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:21:25 -0400
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        fenghua.yu@intel.com
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Subject: [PATCH] x86: Add check for P5 to microcode_intel_early
Date: Fri, 19 Apr 2013 18:23:03 +0100
Message-Id: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectural MSRs associated with microcode are for P6 or higher.
Add a check to early microcode to detect < P6.

Without a check for < P6 - we end up reading from unimplemented MSRs
on Pentium.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>
---
 arch/x86/kernel/microcode_intel_early.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index d893e8e..e1ff9bf 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -396,6 +396,9 @@ static int __cpuinit collect_cpu_info_early(struct ucode_cpu_info *uci)
 	x86 = get_x86_family(csig.sig);
 	x86_model = get_x86_model(csig.sig);
 
+	if (x86 < 6)
+		return UCODE_ERROR;
+
 	if ((x86_model >= 5) || (x86 > 6)) {
 		/* get processor flags from MSR 0x17 */
 		native_rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
@@ -428,9 +431,13 @@ static void __ref show_saved_mc(void)
 		pr_debug("no micorcode data saved.\n");
 		return;
 	}
-	pr_debug("Total microcode saved: %d\n", mc_saved_data.mc_saved_count);
 
-	collect_cpu_info_early(&uci);
+	if (collect_cpu_info_early(&uci) == UCODE_ERROR) {
+		pr_debug("microcode unavailable on this architecture\n");
+		return;
+	}
+
+	pr_debug("Total microcode saved: %d\n", mc_saved_data.mc_saved_count);
 
 	sig = uci.cpu_sig.sig;
 	pf = uci.cpu_sig.pf;
@@ -609,7 +616,8 @@ void __cpuinit show_ucode_info_early(void)
 	struct ucode_cpu_info uci;
 
 	if (delay_ucode_info) {
-		collect_cpu_info_early(&uci);
+		if (collect_cpu_info_early(&uci) == UCODE_ERROR)
+			return;
 		print_ucode_info(&uci, current_mc_date);
 		delay_ucode_info = 0;
 	}
@@ -724,7 +732,8 @@ _load_ucode_intel_bsp(struct mc_saved_data *mc_saved_data,
 		      unsigned long initrd_end_early,
 		      struct ucode_cpu_info *uci)
 {
-	collect_cpu_info_early(uci);
+	if (collect_cpu_info_early(uci) == UCODE_ERROR)
+		return;
 	scan_microcode(initrd_start_early, initrd_end_early, mc_saved_data,
 		       mc_saved_in_initrd, uci);
 	load_microcode(mc_saved_data, mc_saved_in_initrd,
@@ -789,7 +798,9 @@ void __cpuinit load_ucode_intel_ap(void)
 	if (mc_saved_data_p->mc_saved_count == 0)
 		return;
 
-	collect_cpu_info_early(&uci);
+	if (collect_cpu_info_early(&uci) == UCODE_ERROR)
+		return;
+
 	load_microcode(mc_saved_data_p, mc_saved_in_initrd_p,
 		       initrd_start_addr, &uci);
 	apply_microcode_early(mc_saved_data_p, &uci);
-- 
1.7.10.4

