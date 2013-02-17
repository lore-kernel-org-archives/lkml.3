Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3BQPhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:37:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3BQPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:37:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH 02/11] ARM: samsung: fix assembly syntax for new gas
Date: Sun, 17 Feb 2013 15:37:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-3-git-send-email-arnd@arndb.de> <20130217003826.GB2317@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130217003826.GB2317@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302171537.13341.arnd@arndb.de>
X-Provags-ID: V02:K0:x1AEwEhglPDJQ5JyGwn+9n+FsZEqGwn0J6+akKyFBXU
 +S7t8CTZl/wS8yb/t4wy5o8Fng/DsmM+EGtnU/BFI1Wa+1Cxep
 zakdhdgWEbH8//hO9PCjf/eqfBplMpl1LCGKbCT1vKrCOByz4k
 jcgna2ptsNzQpCWa+gAxNO7jOA7mmcFPv9cF3hBcLo4uBYHoDp
 1MtTOqpW7tIRaaTomJC8UdeF8Pr2H4V6JQxMBVQds/dQUpLVk5
 Vp/ZflT3rGXcIvXaMMV7bNZ0FyKuygY8k0XMIK3fUgMxI6Hqq2
 Z+cMcWqcamI77Tnx5XwwNgomGyTH1fFrvFqH/cyWqhOGUpLSS9
 z2duZyfaIHHNSD7OHtYo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2013, Aaro Koskinen wrote:
> Hi,
> 
> On Thu, Feb 14, 2013 at 02:49:18PM +0100, Arnd Bergmann wrote:
> > Recent assembler versions complain about extraneous
> > whitespace inside [] brackets. This fixes all of
> > these instances for the samsung platforms. We should
> > backport this to all kernels that might need to
> > be built with new binutils.
> 
> Which binutils version is this?

I saw it first on the ubuntu binutils-arm-linux-gnueabihf-2.23.1-
0ubuntu6cross1.89 binaries but have now successfully bisected it to
the below commit that introduced the kernel build breakage in the
upstream binutils-2_23-branch.

The changelog comment is rather unhelpful for determining whether
it was intentional or not, and I can't make any sense out of the
source code.

	Arnd

8<--------

commit 65faec7cb829c58b20a5f26ee2908ac35165fc58
Author: Roland McGrath <roland@gnu.org>
Date:   Tue Nov 20 17:58:28 2012 +0000

    gas/
    	* config/tc-arm.c (arm_symbol_chars): New variable.
    	* config/tc-arm.h (tc_symbol_chars): New macro, defined to that.
    
    gas/testsuite/
    	* gas/arm/macro-pld.s: New file.
    	* gas/arm/macro-pld.d: New file.

diff --git a/gas/ChangeLog b/gas/ChangeLog
index 8a950ec..f4f834d 100644
--- a/gas/ChangeLog
+++ b/gas/ChangeLog
@@ -9,6 +9,11 @@
 	* config/tc-aarch64.c (first_error_fmt): Add ATTRIBUTE_UNUSED to the
 	local variable "ret".
 
+2012-11-20  Roland McGrath  <mcgrathr@google.com>
+
+	* config/tc-arm.c (arm_symbol_chars): New variable.
+	* config/tc-arm.h (tc_symbol_chars): New macro, defined to that.
+
 2012-11-07  James Murray <jsm@jsm-net.demon.co.uk>
 
 	* config/tc-m68hc11.c: Fix R_M68HC12_16B relocation for movb/w
diff --git a/gas/config/tc-arm.c b/gas/config/tc-arm.c
index 91b29ac..5bf7d89 100644
--- a/gas/config/tc-arm.c
+++ b/gas/config/tc-arm.c
@@ -321,6 +321,11 @@ static int implicit_it_mode = IMPLICIT_IT_MODE_ARM;
 
 static bfd_boolean unified_syntax = FALSE;
 
+/* An immediate operand can start with #, and ld*, st*, pld operands
+   can contain [ and ].  We need to tell APP not to elide whitespace
+   before a [, which can appear as the first operand for pld.  */
+const char arm_symbol_chars[] = "#[]";
+
 enum neon_el_type
 {
   NT_invtype,
@@ -10225,7 +10230,7 @@ do_t_branch (void)
 }
 
 /* Actually do the work for Thumb state bkpt and hlt.  The only difference
-   between the two is the maximum immediate allowed - which is passed in 
+   between the two is the maximum immediate allowed - which is passed in
    RANGE.  */
 static void
 do_t_bkpt_hlt1 (int range)
@@ -14660,7 +14665,7 @@ do_vfp_nsyn_cvtz (void)
 }
 
 static void
-do_vfp_nsyn_cvt_fpv8 (enum neon_cvt_flavour flavour, 
+do_vfp_nsyn_cvt_fpv8 (enum neon_cvt_flavour flavour,
 		      enum neon_cvt_mode mode)
 {
   int sz, op;
@@ -14720,9 +14725,9 @@ do_neon_cvt_1 (enum neon_cvt_mode mode)
   /* PR11109: Handle round-to-zero for VCVT conversions.  */
   if (mode == neon_cvt_mode_z
       && ARM_CPU_HAS_FEATURE (cpu_variant, fpu_arch_vfp_v2)
-      && (flavour == neon_cvt_flavour_s32_f32 
-	  || flavour == neon_cvt_flavour_u32_f32 
-	  || flavour == neon_cvt_flavour_s32_f64 
+      && (flavour == neon_cvt_flavour_s32_f32
+	  || flavour == neon_cvt_flavour_u32_f32
+	  || flavour == neon_cvt_flavour_s32_f64
 	  || flavour == neon_cvt_flavour_u32_f64)
       && (rs == NS_FD || rs == NS_FF))
     {
diff --git a/gas/config/tc-arm.h b/gas/config/tc-arm.h
index da6469c..3a0fab0 100644
--- a/gas/config/tc-arm.h
+++ b/gas/config/tc-arm.h
@@ -82,6 +82,9 @@ struct fix;
 /* We support double slash line-comments for compatibility with the ARM AArch64 Assembler.  */
 #define DOUBLESLASH_LINE_COMMENTS
 
+#define tc_symbol_chars arm_symbol_chars
+extern const char arm_symbol_chars[];
+
 #define TC_FORCE_RELOCATION(FIX) arm_force_relocation (FIX)
 
 extern unsigned int arm_frag_max_var (struct frag *);
diff --git a/gas/testsuite/ChangeLog b/gas/testsuite/ChangeLog
index 5bc1c32..09d654e 100644
--- a/gas/testsuite/ChangeLog
+++ b/gas/testsuite/ChangeLog
@@ -1,3 +1,8 @@
+2012-11-20  Roland McGrath  <mcgrathr@google.com>
+
+	* gas/arm/macro-pld.s: New file.
+	* gas/arm/macro-pld.d: New file.
+
 2012-10-09  Nagajyothi Eggone  <nagajyothi.eggone@amd.com>
 
 	* gas/i386/i386.exp: Run bdver3 test cases.
diff --git a/gas/testsuite/gas/arm/macro-pld.d b/gas/testsuite/gas/arm/macro-pld.d
new file mode 100644
index 0000000..8f9d86c8
--- /dev/null
+++ b/gas/testsuite/gas/arm/macro-pld.d
@@ -0,0 +1,8 @@
+#objdump: -dr
+
+.*:     file format .*
+
+Disassembly of section \.text:
+
+0+ <.*>:
+\s*0:\s+f5d0f000\s+pld\s+\[r0\]
diff --git a/gas/testsuite/gas/arm/macro-pld.s b/gas/testsuite/gas/arm/macro-pld.s
new file mode 100644
index 0000000..cf4df8b
--- /dev/null
+++ b/gas/testsuite/gas/arm/macro-pld.s
@@ -0,0 +1,4 @@
+.macro foo arg, rest:vararg
+	\rest
+.endm
+	foo r0, pld [r0]
