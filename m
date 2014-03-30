Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaC3OKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 10:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaC3OJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 10:09:59 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 1/3] x86: microcode: report if CPU has up-to-date microcode
Date: Sun, 30 Mar 2014 16:09:32 +0200
Message-Id: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, successful microcode uploads clearly
indicate that it was done:

microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
microcode: CPU1 updated to revision 0x29, date = 2013-06-12

whereas if microcode was not uploaded, it is not clear why:

microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x29
(nothing more)

So, what was it? No microcode file? No microcode for this sig/pf?
CPU already has microcode with this (or newer) revision?

In practice, it means that I need to ask people to provide me
with more information ("do you have microcode package installed?
which version is it?" etc).

This change adds a message which covers "CPU is up-to-date" and
"no microcode for your CPU in this file" cases:

microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x29
microcode: CPU rev 0x29 is same or newer than 0x29 in microcode data

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 arch/x86/include/asm/microcode_intel.h      |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c       |  4 ++--
 arch/x86/kernel/cpu/microcode/intel_early.c |  2 +-
 arch/x86/kernel/cpu/microcode/intel_lib.c   | 18 +++++++++++++++---
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 9067166..f64ccfd 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -57,7 +57,7 @@ struct extended_sigtable {
 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
 
 extern int
-get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev);
+get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev, bool report_old);
 extern int microcode_sanity_check(void *mc, int print_err);
 extern int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev);
 extern int
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index a276fa7..ef8b17c 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -124,7 +124,7 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	cpf = cpu_sig.pf;
 	crev = cpu_sig.rev;
 
-	return get_matching_microcode(csig, cpf, mc_intel, crev);
+	return get_matching_microcode(csig, cpf, mc_intel, crev, /*report_old:*/ 1);
 }
 
 int apply_microcode(int cpu)
@@ -221,7 +221,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 
 		csig = uci->cpu_sig.sig;
 		cpf = uci->cpu_sig.pf;
-		if (get_matching_microcode(csig, cpf, mc, new_rev)) {
+		if (get_matching_microcode(csig, cpf, mc, new_rev, /*report_old:*/ 1)) {
 			vfree(new_mc);
 			new_rev = mc_header.rev;
 			new_mc  = mc;
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 18f7391..3a2ad0a 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -53,7 +53,7 @@ generic_load_microcode_early(struct microcode_intel **mc_saved_p,
 
 		mc_header = (struct microcode_header_intel *)ucode_ptr;
 		mc_size = get_totalsize(mc_header);
-		if (get_matching_microcode(csig, cpf, ucode_ptr, new_rev)) {
+		if (get_matching_microcode(csig, cpf, ucode_ptr, new_rev, /*report_old:*/ 0)) {
 			new_rev = mc_header->rev;
 			new_mc  = ucode_ptr;
 		}
diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
index ce69320..e8c02cb 100644
--- a/arch/x86/kernel/cpu/microcode/intel_lib.c
+++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
@@ -162,13 +162,25 @@ int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev)
  * return 0 - no update found
  * return 1 - found update
  */
-int get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev)
+int get_matching_microcode(unsigned int csig, int cpf, void *mc, int rev, bool report_old)
 {
 	struct microcode_header_intel *mc_header = mc;
 
-	if (!update_match_revision(mc_header, rev))
+	if (!update_match_revision(mc_header, rev)) {
+		if (report_old)
+			pr_info("microcode: CPU rev 0x%x is same or newer"
+				" than 0x%x in microcode data\n",
+				rev, mc_header->rev);
 		return 0;
+	}
+
+	if (!get_matching_sig(csig, cpf, mc, rev)) {
+		if (report_old)
+			pr_info("microcode: no microcode with"
+				" sig=0x%x, pf=0x%x found\n", csig, cpf);
+		return 0;
+	}
 
-	return get_matching_sig(csig, cpf, mc, rev);
+	return 1;
 }
 EXPORT_SYMBOL_GPL(get_matching_microcode);
-- 
1.8.1.4

