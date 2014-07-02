Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaGBQ34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:29:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:61985 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbaGBQ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="537835546"
Subject: [PATCH 1/4] x86: axe the lightly-used cpu_has_pae
To: bp@alien8.de
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 02 Jul 2014 09:29:26 -0700
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
In-Reply-To: <20140702162925.B07A3AB9@viggo.jf.intel.com>
Message-Id: <20140702162926.3F2DAC08@viggo.jf.intel.com>
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
---

 b/arch/x86/include/asm/cpufeature.h  |    4 ----
 b/arch/x86/kernel/machine_kexec_32.c |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-axe-cpu_has_pae arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-axe-cpu_has_pae	2014-07-02 09:16:20.852254443 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-07-02 09:16:20.857254668 -0700
@@ -286,7 +286,6 @@ extern const char * const x86_power_flag
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
-#define cpu_has_pae		boot_cpu_has(X86_FEATURE_PAE)
 #define cpu_has_pge		boot_cpu_has(X86_FEATURE_PGE)
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_sep		boot_cpu_has(X86_FEATURE_SEP)
@@ -344,9 +343,6 @@ extern const char * const x86_power_flag
 #undef  cpu_has_vme
 #define cpu_has_vme		0
 
-#undef  cpu_has_pae
-#define cpu_has_pae		___BUG___
-
 #undef  cpu_has_mp
 #define cpu_has_mp		1
 
diff -puN arch/x86/kernel/machine_kexec_32.c~x86-axe-cpu_has_pae arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~x86-axe-cpu_has_pae	2014-07-02 09:16:20.853254488 -0700
+++ b/arch/x86/kernel/machine_kexec_32.c	2014-07-02 09:16:20.857254668 -0700
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
