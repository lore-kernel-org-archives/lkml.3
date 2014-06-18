Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaFRQ0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:26:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:47110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbaFRQ0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="559649023"
Message-ID: <53A1BD95.10701@intel.com>
Date: Wed, 18 Jun 2014 09:25:57 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <53A1A942.1090001@zytor.com>
In-Reply-To: <53A1A942.1090001@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------070706040202000507010002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070706040202000507010002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/18/2014 07:59 AM, H. Peter Anvin wrote:
> On 06/18/2014 07:35 AM, Dave Hansen wrote:
>> It looks like static_cpu_has() is the right thing to use instead of
>> boot_cpu_has().  But, this doesn't just obfuscate things.
>>
>> We actually _want_ the compiler to cull code out when the config option
>> is off.  Things like do_bounds() will see code savings with _some_ kind
>> of #ifdef rather than using static_cpu_has().
>>
>> So, we can either use the well worn, consistent with other features in
>> x86, cpu_has_$foo approach.  Or, we can roll our own macros.
> 
> We could do something like:
> 
> #define MPX_ENABLED (IS_ENABLED(CONFIG_X86_MPX) &&
> static_cpu_has(X86_FEATURE_MPX))

How about something like the attached patch?

This lets us use static_cpu_has() for the checks, and allows us to
easily add new checks for other features that might be compile-time
disabled.

--------------070706040202000507010002
Content-Type: text/x-patch;
 name="x86-disabled_mask.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-disabled_mask.patch"



---

 b/arch/x86/include/asm/cpufeature.h |   26 ++++++++++++++++++++------
 b/arch/x86/kernel/mpx.c             |    4 ++--
 b/arch/x86/kernel/traps.c           |    2 +-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-disabled_mask arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-disabled_mask	2014-06-18 08:48:41.329750895 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-06-18 09:19:19.143546973 -0700
@@ -339,12 +339,6 @@ extern const char * const x86_power_flag
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
-#ifdef CONFIG_X86_INTEL_MPX
-#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
-#else
-#define cpu_has_mpx 0
-#endif /* CONFIG_X86_INTEL_MPX */
-
 #ifdef CONFIG_X86_64
 
 #undef  cpu_has_vme
@@ -367,6 +361,22 @@ extern const char * const x86_power_flag
 
 #endif /* CONFIG_X86_64 */
 
+/*
+ * Add features and their corresponding config options here
+ * if you want to have the compiler optimize out code that
+ * uses them.
+ *
+ * You should not use this function directly.  Use
+ * static_cpu_has() so that you also benefit from alternatives
+ * when the features are enabled.
+ */
+static __always_inline int __cpu_feature_compile_enabled(u16 bit)
+{
+	if (bit == X86_FEATURE_MPX)
+		return IS_ENABLED(CONFIG_X86_MPX);
+	return 0;
+}
+
 #if __GNUC__ >= 4
 extern void warn_pre_alternatives(void);
 extern bool __static_cpu_has_safe(u16 bit);
@@ -378,6 +388,8 @@ extern bool __static_cpu_has_safe(u16 bi
  */
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
+	if (!__cpu_feature_compile_enabled(bit))
+		return 0;
 #ifdef CC_HAVE_ASM_GOTO
 
 #ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
@@ -458,6 +470,8 @@ static __always_inline __pure bool __sta
 
 static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 {
+	if (!__cpu_feature_compile_enabled(bit))
+		return 0;
 #ifdef CC_HAVE_ASM_GOTO
 /*
  * We need to spell the jumps to the compiler because, depending on the offset,
diff -puN arch/x86/kernel/traps.c~x86-disabled_mask arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~x86-disabled_mask	2014-06-18 09:14:23.686340296 -0700
+++ b/arch/x86/kernel/traps.c	2014-06-18 09:14:53.698681684 -0700
@@ -280,7 +280,7 @@ dotraplinkage void do_bounds(struct pt_r
 	if (!user_mode(regs))
 		die("bounds", regs, error_code);
 
-	if (!cpu_has_mpx) {
+	if (static_cpu_has(X86_FEATURE_MPX)) {
 		/* The exception is not from Intel MPX */
 		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
 		goto exit;
diff -puN arch/x86/kernel/mpx.c~x86-disabled_mask arch/x86/kernel/mpx.c
--- a/arch/x86/kernel/mpx.c~x86-disabled_mask	2014-06-18 09:14:23.739342667 -0700
+++ b/arch/x86/kernel/mpx.c	2014-06-18 09:22:32.091172228 -0700
@@ -26,7 +26,7 @@ int mpx_register(struct task_struct *tsk
 {
 	struct mm_struct *mm = tsk->mm;
 
-	if (!cpu_has_mpx)
+	if (!static_cpu_has(X86_FEATURE_MPX))
 		return -EINVAL;
 
 	/*
@@ -51,7 +51,7 @@ int mpx_unregister(struct task_struct *t
 {
 	struct mm_struct *mm = current->mm;
 
-	if (!cpu_has_mpx)
+	if (!static_cpu_has(X86_FEATURE_MPX))
 		return -EINVAL;
 
 	mm->bd_addr = NULL;
_

--------------070706040202000507010002--
