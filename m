Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3EaD1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:27:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3EaD1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:27:47 -0400
Date: Thu, 30 May 2013 20:27:36 -0700
From: tip-bot for Jacob Shin <tipbot@zytor.com>
Message-ID: <tip-f2b3ee820a9f2368d7f8842ad7da062dfe86e199@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1369940959-2077-3-git-send-email-jacob.shin@amd.com>
References: <1369940959-2077-3-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode:
  Vendor abstract out save_microcode_in_initrd()
Git-Commit-ID: f2b3ee820a9f2368d7f8842ad7da062dfe86e199
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2b3ee820a9f2368d7f8842ad7da062dfe86e199
Gitweb:     http://git.kernel.org/tip/f2b3ee820a9f2368d7f8842ad7da062dfe86e199
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Thu, 30 May 2013 14:09:17 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 May 2013 20:19:25 -0700

x86, microcode: Vendor abstract out save_microcode_in_initrd()

Currently save_microcode_in_initrd() is declared in vendor neutural
microcode.h file, but defined in vendor specific
microcode_intel_early.c file. Vendor abstract it out to
microcode_core_early.c with a wrapper function.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1369940959-2077-3-git-send-email-jacob.shin@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/microcode_intel.h  |  2 ++
 arch/x86/kernel/microcode_core_early.c  | 10 ++++++++++
 arch/x86/kernel/microcode_intel_early.c |  2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 5356f92..87a0853 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -67,10 +67,12 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
 extern void __init load_ucode_intel_bsp(void);
 extern void __cpuinit load_ucode_intel_ap(void);
 extern void show_ucode_info_early(void);
+extern int __init save_microcode_in_initrd_intel(void);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline __cpuinit void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
+static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 833d51d..0d19ac5 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -98,3 +98,13 @@ void __cpuinit load_ucode_ap(void)
 	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_ap();
 }
+
+int __init save_microcode_in_initrd(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor == X86_VENDOR_INTEL && c->x86 >= 6)
+		return save_microcode_in_initrd_intel();
+
+	return 0;
+}
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index a07f0a0..dabef95 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -699,7 +699,7 @@ static int __cpuinit apply_microcode_early(struct mc_saved_data *mc_saved_data,
  * This function converts microcode patch offsets previously stored in
  * mc_saved_in_initrd to pointers and stores the pointers in mc_saved_data.
  */
-int __init save_microcode_in_initrd(void)
+int __init save_microcode_in_initrd_intel(void)
 {
 	unsigned int count = mc_saved_data.mc_saved_count;
 	struct microcode_intel *mc_saved[MAX_UCODE_COUNT];
