Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaJMHkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:40:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62614 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaJMHkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:40:31 -0400
Date: Mon, 13 Oct 2014 09:40:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode tree changes for v3.18
Message-ID: <20141013074025.GA15070@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

   # HEAD: 44afe6029422da55918d8156c6900dbf5259533b Merge tag 'microcode_cleanups' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/microcode

Misc smaller cleanups.

 Thanks,

	Ingo

------------------>
Henrique de Moraes Holschuh (5):
      x86, microcode, amd: Fix missing static declaration
      x86, microcode, intel: Add missing static declarations
      x86, microcode, intel: Fix typos
      x86, microcode, intel: Rename apply_microcode and declare it static
      x86, microcode, intel: Fix total_size computation


 arch/x86/include/asm/microcode_intel.h      |  2 +-
 arch/x86/kernel/cpu/microcode/amd_early.c   |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c       |  4 ++--
 arch/x86/kernel/cpu/microcode/intel_early.c | 10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 9067166409bf..bbe296e0bce1 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -43,7 +43,7 @@ struct extended_sigtable {
 #define DWSIZE			(sizeof(u32))
 
 #define get_totalsize(mc) \
-	(((struct microcode_intel *)mc)->hdr.totalsize ? \
+	(((struct microcode_intel *)mc)->hdr.datasize ? \
 	 ((struct microcode_intel *)mc)->hdr.totalsize : \
 	 DEFAULT_UCODE_TOTALSIZE)
 
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 617a9e284245..7aa1acc79789 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -27,7 +27,7 @@ static u32 ucode_new_rev;
 u8 amd_ucode_patch[PATCH_MAX_SIZE];
 static u16 this_equiv_id;
 
-struct cpio_data ucode_cpio;
+static struct cpio_data ucode_cpio;
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio format.
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index a276fa75d9b5..c6826d1e8082 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -127,7 +127,7 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	return get_matching_microcode(csig, cpf, mc_intel, crev);
 }
 
-int apply_microcode(int cpu)
+static int apply_microcode_intel(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
@@ -314,7 +314,7 @@ static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
-	.apply_microcode                  = apply_microcode,
+	.apply_microcode                  = apply_microcode_intel,
 	.microcode_fini_cpu               = microcode_fini_cpu,
 };
 
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 18f739129e72..b88343f7a3b3 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -28,8 +28,8 @@
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 
-unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
-struct mc_saved_data {
+static unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
+static struct mc_saved_data {
 	unsigned int mc_saved_count;
 	struct microcode_intel **mc_saved;
 } mc_saved_data;
@@ -415,7 +415,7 @@ static void __ref show_saved_mc(void)
 	struct ucode_cpu_info uci;
 
 	if (mc_saved_data.mc_saved_count == 0) {
-		pr_debug("no micorcode data saved.\n");
+		pr_debug("no microcode data saved.\n");
 		return;
 	}
 	pr_debug("Total microcode saved: %d\n", mc_saved_data.mc_saved_count);
@@ -506,7 +506,7 @@ int save_mc_for_early(u8 *mc)
 
 	if (mc_saved && mc_saved_count)
 		memcpy(mc_saved_tmp, mc_saved,
-		       mc_saved_count * sizeof(struct mirocode_intel *));
+		       mc_saved_count * sizeof(struct microcode_intel *));
 	/*
 	 * Save the microcode patch mc in mc_save_tmp structure if it's a newer
 	 * version.
@@ -526,7 +526,7 @@ int save_mc_for_early(u8 *mc)
 	show_saved_mc();
 
 	/*
-	 * Free old saved microcod data.
+	 * Free old saved microcode data.
 	 */
 	if (mc_saved) {
 		for (i = 0; i < mc_saved_count_init; i++)
