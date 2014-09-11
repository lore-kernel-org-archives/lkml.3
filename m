Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaIKVP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:15:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:39385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaIKVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,507,1406617200"; 
   d="scan'208";a="598291667"
Subject: [PATCH 1/3] x86: axe the lightly-used cpu_has_pae
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        fenghua.yu@intel.com, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com, bp@suse.de
From: Dave Hansen <dave@sr71.net>
Date: Thu, 11 Sep 2014 14:15:11 -0700
References: <20140911211510.D032EC3B@viggo.jf.intel.com>
In-Reply-To: <20140911211510.D032EC3B@viggo.jf.intel.com>
Message-Id: <20140911211511.AD76E774@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

cpu_has_pae is only referenced in one place: the X86_32 kexec
code (in a file not even built on 64-bit).  It hardly warrants
its own macro, or the trouble we go to ensuring that it can't
be called in X86_64 code.

Axe the macro and replace it with a direct cpu feature check.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
---

 b/arch/x86/include/asm/cpufeature.h  |    4 ----
 b/arch/x86/kernel/machine_kexec_32.c |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-axe-cpu_has_pae arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-axe-cpu_has_pae	2014-08-13 13:39:06.903716185 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-08-13 13:39:19.610291207 -0700
@@ -300,7 +300,6 @@ extern const char * const x86_bug_flags[
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
-#define cpu_has_pae		boot_cpu_has(X86_FEATURE_PAE)
 #define cpu_has_pge		boot_cpu_has(X86_FEATURE_PGE)
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_sep		boot_cpu_has(X86_FEATURE_SEP)
@@ -358,9 +357,6 @@ extern const char * const x86_bug_flags[
 #undef  cpu_has_vme
 #define cpu_has_vme		0
 
-#undef  cpu_has_pae
-#define cpu_has_pae		___BUG___
-
 #undef  cpu_has_k6_mtrr
 #define cpu_has_k6_mtrr		0
 
diff -puN arch/x86/kernel/machine_kexec_32.c~x86-axe-cpu_has_pae arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~x86-axe-cpu_has_pae	2014-08-13 13:39:06.905716275 -0700
+++ b/arch/x86/kernel/machine_kexec_32.c	2014-08-13 13:39:06.937717723 -0700
@@ -247,7 +247,8 @@ void machine_kexec(struct kimage *image)
 	/* now call it */
 	image->start = relocate_kernel_ptr((unsigned long)image->head,
 					   (unsigned long)page_list,
-					   image->start, cpu_has_pae,
+					   image->start,
+					   boot_cpu_has(X86_FEATURE_PAE),
 					   image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
_
