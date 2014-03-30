Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaC3PGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 11:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbaC3PGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 11:06:48 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 3/3] x86: microcode: remove unused parameter and redundant variable
Date: Sun, 30 Mar 2014 16:09:34 +0200
Message-Id: <1396188574-2067-3-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
References: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two trivial cleanups:

get_matching_sig()'s rev parameter is unused and can be removed.

In apply_microcode(), cpu == cpu_num always. Merge them. Move BUG check
before all other operations so that function call does not interfere
with register scheduling, saving a few bytes of code.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 arch/x86/include/asm/microcode_intel.h      |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c       | 16 ++++++++--------
 arch/x86/kernel/cpu/microcode/intel_early.c |  2 +-
 arch/x86/kernel/cpu/microcode/intel_lib.c   |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index f64ccfd..e27eba4 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -59,7 +59,7 @@ struct extended_sigtable {
 extern int
 get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev, bool report_old);
 extern int microcode_sanity_check(void *mc, int print_err);
-extern int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev);
+extern int get_matching_sig(unsigned int csig, int cpf, void *mc);
 extern int
 update_match_revision(struct microcode_header_intel *mc_header, int rev);
 
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 9ce22b0..a37f179 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -127,19 +127,19 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	return get_matching_microcode(csig, cpf, mc_intel, crev, /*report_old:*/ 1);
 }
 
-int apply_microcode(int cpu)
+int apply_microcode(int cpu_num)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
 	unsigned int val[2];
-	int cpu_num = raw_smp_processor_id();
-	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-
-	uci = ucode_cpu_info + cpu;
-	mc_intel = uci->mc;
+	struct cpuinfo_x86 *c;
 
 	/* We should bind the task to the CPU */
-	BUG_ON(cpu_num != cpu);
+	BUG_ON(cpu_num != raw_smp_processor_id());
+
+	c = &cpu_data(cpu_num);
+	uci = ucode_cpu_info + cpu_num;
+	mc_intel = uci->mc;
 
 	if (mc_intel == NULL)
 		return 0;
@@ -149,7 +149,7 @@ int apply_microcode(int cpu)
 	 * microcode patch in mc_intel when it is newer than the one on this
 	 * CPU.
 	 */
-	if (get_matching_mc(mc_intel, cpu) == 0)
+	if (get_matching_mc(mc_intel, cpu_num) == 0)
 		return 0;
 
 	/* write microcode via MSR 0x79 */
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 3a2ad0a..14b120b 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -276,7 +276,7 @@ static void _save_mc(struct microcode_intel **mc_saved, u8 *ucode_ptr,
 		pf = mc_saved_header->pf;
 		new_rev = mc_header->rev;
 
-		if (get_matching_sig(sig, pf, ucode_ptr, new_rev)) {
+		if (get_matching_sig(sig, pf, ucode_ptr)) {
 			found = 1;
 			if (update_match_revision(mc_header, new_rev)) {
 				/*
diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
index e8c02cb..eeec94b 100644
--- a/arch/x86/kernel/cpu/microcode/intel_lib.c
+++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(microcode_sanity_check);
  * return 0 - no update found
  * return 1 - found update
  */
-int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev)
+int get_matching_sig(unsigned int csig, int cpf, void *mc)
 {
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header;
@@ -174,7 +174,7 @@ int get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev, bool r
 		return 0;
 	}
 
-	if (!get_matching_sig(csig, cpf, mc, rev)) {
+	if (!get_matching_sig(csig, cpf, mc)) {
 		if (report_old)
 			pr_info("microcode: no microcode with"
 				" sig=0x%x, pf=0x%x found\n", csig, cpf);
-- 
1.8.1.4

