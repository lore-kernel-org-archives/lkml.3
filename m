Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaIKVeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:34:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIKVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:34:36 -0400
Date: Thu, 11 Sep 2014 14:34:11 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-c8128cceb4f4b02c53096cb173628184c7e9bc36@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dave.hansen@linux.intel.com, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <20140911211511.AD76E774@viggo.jf.intel.com>
References: <20140911211511.AD76E774@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86: Axe the lightly-used cpu_has_pae
Git-Commit-ID: c8128cceb4f4b02c53096cb173628184c7e9bc36
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

Commit-ID:  c8128cceb4f4b02c53096cb173628184c7e9bc36
Gitweb:     http://git.kernel.org/tip/c8128cceb4f4b02c53096cb173628184c7e9bc36
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 11 Sep 2014 14:15:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 11 Sep 2014 14:30:01 -0700

x86: Axe the lightly-used cpu_has_pae

cpu_has_pae is only referenced in one place: the X86_32 kexec
code (in a file not even built on 64-bit).  It hardly warrants
its own macro, or the trouble we go to ensuring that it can't
be called in X86_64 code.

Axe the macro and replace it with a direct cpu feature check.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20140911211511.AD76E774@viggo.jf.intel.com
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h  | 4 ----
 arch/x86/kernel/machine_kexec_32.c | 3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb9b258..7b50875 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -300,7 +300,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
-#define cpu_has_pae		boot_cpu_has(X86_FEATURE_PAE)
 #define cpu_has_pge		boot_cpu_has(X86_FEATURE_PGE)
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_sep		boot_cpu_has(X86_FEATURE_SEP)
@@ -358,9 +357,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #undef  cpu_has_vme
 #define cpu_has_vme		0
 
-#undef  cpu_has_pae
-#define cpu_has_pae		___BUG___
-
 #undef  cpu_has_k6_mtrr
 #define cpu_has_k6_mtrr		0
 
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 1667b1d..72e8e31 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -247,7 +247,8 @@ void machine_kexec(struct kimage *image)
 	/* now call it */
 	image->start = relocate_kernel_ptr((unsigned long)image->head,
 					   (unsigned long)page_list,
-					   image->start, cpu_has_pae,
+					   image->start,
+					   boot_cpu_has(X86_FEATURE_PAE),
 					   image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
