Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3JMMCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:02:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3JMMC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:02:26 -0400
Date: Sun, 13 Oct 2013 05:02:15 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381450698-28710-2-git-send-email-keescook@chromium.org>
References: <1381450698-28710-2-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, boot: Rename get_flags() and check_flags()
  to *_cpuflags()
Git-Commit-ID: 6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 13 Oct 2013 05:02:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb
Gitweb:     http://git.kernel.org/tip/6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 13 Oct 2013 04:08:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Oct 2013 04:08:56 -0700

x86, boot: Rename get_flags() and check_flags() to *_cpuflags()

When a function is used in more than one file it may not be possible
to immediately tell from context what the intended meaning is.  As
such, it is more important that the naming be self-evident.  Thus,
change get_flags() to get_cpuflags().

For consistency, change check_flags() to check_cpuflags() even though
it is only used in cpucheck.c.

Link: http://lkml.kernel.org/r/1381450698-28710-2-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/cpuflags.c |  2 +-
 arch/x86/boot/cpucheck.c            | 14 +++++++-------
 arch/x86/boot/cpuflags.c            |  2 +-
 arch/x86/boot/cpuflags.h            |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/cpuflags.c b/arch/x86/boot/compressed/cpuflags.c
index 931cba6..aa31346 100644
--- a/arch/x86/boot/compressed/cpuflags.c
+++ b/arch/x86/boot/compressed/cpuflags.c
@@ -4,7 +4,7 @@
 
 bool has_cpuflag(int flag)
 {
-	get_flags();
+	get_cpuflags();
 
 	return test_bit(flag, cpu.flags);
 }
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index e1f3c16..100a9a1 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -68,7 +68,7 @@ static int is_transmeta(void)
 }
 
 /* Returns a bitmask of which words we have error bits in */
-static int check_flags(void)
+static int check_cpuflags(void)
 {
 	u32 err;
 	int i;
@@ -101,8 +101,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 	if (has_eflag(X86_EFLAGS_AC))
 		cpu.level = 4;
 
-	get_flags();
-	err = check_flags();
+	get_cpuflags();
+	err = check_cpuflags();
 
 	if (test_bit(X86_FEATURE_LM, cpu.flags))
 		cpu.level = 64;
@@ -121,8 +121,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		eax &= ~(1 << 15);
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
-		get_flags();	/* Make sure it really did something */
-		err = check_flags();
+		get_cpuflags();	/* Make sure it really did something */
+		err = check_cpuflags();
 	} else if (err == 0x01 &&
 		   !(err_flags[0] & ~(1 << X86_FEATURE_CX8)) &&
 		   is_centaur() && cpu.model >= 6) {
@@ -137,7 +137,7 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
 		set_bit(X86_FEATURE_CX8, cpu.flags);
-		err = check_flags();
+		err = check_cpuflags();
 	} else if (err == 0x01 && is_transmeta()) {
 		/* Transmeta might have masked feature bits in word 0 */
 
@@ -152,7 +152,7 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		    : : "ecx", "ebx");
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
-		err = check_flags();
+		err = check_cpuflags();
 	}
 
 	if (err_flags_ptr)
diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
index b02544a..a9fcb7c 100644
--- a/arch/x86/boot/cpuflags.c
+++ b/arch/x86/boot/cpuflags.c
@@ -65,7 +65,7 @@ static inline void cpuid(u32 id, u32 *a, u32 *b, u32 *c, u32 *d)
 	);
 }
 
-void get_flags(void)
+void get_cpuflags(void)
 {
 	u32 max_intel_level, max_amd_level;
 	u32 tfms;
diff --git a/arch/x86/boot/cpuflags.h b/arch/x86/boot/cpuflags.h
index 9bb4e25..ea97697 100644
--- a/arch/x86/boot/cpuflags.h
+++ b/arch/x86/boot/cpuflags.h
@@ -14,6 +14,6 @@ extern struct cpu_features cpu;
 extern u32 cpu_vendor[3];
 
 int has_eflag(unsigned long mask);
-void get_flags(void);
+void get_cpuflags(void);
 
 #endif
