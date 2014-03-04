Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaCDFFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:05:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34737 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaCDFFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:05:03 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140304050122.GA3740@localhost>
References: <20140228140043.GA12157@debian.local> <20140302205619.GA8676@rhlx01.hs-esslingen.de> <20140303080432.GA25489@localhost> <20140303192939.GD31265@pd.tnic> <20140304050122.GA3740@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Re: [PATCH] x86: set Pentium M as PAE capable
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 03 Mar 2014 21:04:19 -0800
To: Chris Bainbridge <chris.bainbridge@gmail.com>,
        Borislav Petkov <bp@alien8.de>
CC: Andreas Mohr <andi@lisas.de>, Dennis Mungai <dmngaie@gmail.com>,
        x86@kernel.org, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, devzero@web.de
Message-ID: <5e866e2a-ea92-43f8-ae67-23f6052c91c8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forcepae is descriptive.

On March 3, 2014 9:01:30 PM PST, Chris Bainbridge <chris.bainbridge@gmail.com> wrote:
>On Mon, Mar 03, 2014 at 08:29:39PM +0100, Borislav Petkov wrote:
>> On Mon, Mar 03, 2014 at 03:04:35PM +0700, Chris Bainbridge wrote:
>> > On 3 March 2014 02:05, Roland Kletzing <devzero@web.de> wrote:
>> > > i would recommend adding the newly introduced param to
>> > > Documentation/kernel-
>> > > parameters.txt , though.
>> > 
>> > Done.
>> > 
>> > Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
>> > ---
>> > diff --git a/Documentation/kernel-parameters.txt
>b/Documentation/kernel-parameters.txt
>> > index b9e9bd8..388b5e9 100644
>> > --- a/Documentation/kernel-parameters.txt
>> > +++ b/Documentation/kernel-parameters.txt
>> > @@ -962,6 +962,13 @@ bytes respectively. Such letter suffixes can
>also be entirely omitted.
>> >  			parameter will force ia64_sal_cache_flush to call
>> >  			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
>> >  
>> > +	forcepae [X86-32]
>> > +			Forcefully enable Physical Address Extension (PAE).
>> > +			Many Pentium M systems disable PAE but may have a
>> > +			functionally usable PAE implementation.
>> > +			Note: This parameter is unsupported, may cause unknown
>> 
>> What does "unsupported" mean here exactly?
>
>It was supposed to have the dual meaning that neither the kernel
>developers or Intel are going to help you if it doesn't work. But
>perhaps it is unnecessary - being tainted implies that the kernel
>developers won't help, and Intel certainly won't be interested.
>
>> 
>> This function is called check_cpuflags() now. You probably want to
>redo
>> your patch against tip/master, i.e.:
>> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git#master
>> 
>
>Done, new patch is against tip.
>
>> > +		}
>> > +		else {
>> > +			puts("ERROR: PAE is disabled on this Pentium M\n"
>> > +				"(PAE can potentially be enabled with "
>> > +				"kernel parameter\n"
>> > +				"\"forcepae\" - this is unsupported, may "
>> > +				"cause unknown\n"
>> > +				"problems, and will taint the kernel)\n");
>> 
>> This string could definitely violate the 80 cols rule so that it is
>much
>> more readable:
>> 
>> 		}
>> 		else
>> 			puts("WARNING: PAE disabled. Use \"forcepae\" to enable at your
>own risk!\n");
>> 
>> I've shortened it to the most relevant info only. No need to say
>we're
>> tainting the kernel because LOCKDEP_NOW_UNRELIABLE will cause that
>> anyway below.
>
>Ok I changed it to: "WARNING: PAE disabled. Use parameter 'pae' to
>enable at your own risk!\n""
>
>> > diff --git a/arch/x86/kernel/cpu/intel.c
>b/arch/x86/kernel/cpu/intel.c
>> > index bbe1b8b..271686d 100644
>> > --- a/arch/x86/kernel/cpu/intel.c
>> > +++ b/arch/x86/kernel/cpu/intel.c
>> > @@ -196,6 +196,14 @@ static void intel_smp_check(struct cpuinfo_x86
>*c)
>> >  	}
>> >  }
>> >  
>> > +static int forcepae;
>> > +static int __init forcepae_setup(char *__unused)
>> > +{
>> > +	forcepae = 1;
>> > +	return 1;
>> > +}
>> > +__setup("forcepae", forcepae_setup);
>> 
>> Yeah, why not simply call it "pae"? It is smaller and the letter
>> combination is not used yet and it means the same.
>
>I don't see any reason not to just use "pae" "forcepae" is perhaps a
>bit
>more descriptive but the other text in the patch clearly describes the
>parameter so it doesn't really matter.
>
>> >  static void intel_workarounds(struct cpuinfo_x86 *c)
>> >  {
>> >  	unsigned long lo, hi;
>> > @@ -226,6 +234,17 @@ static void intel_workarounds(struct
>cpuinfo_x86 *c)
>> >  		clear_cpu_cap(c, X86_FEATURE_SEP);
>> >  
>> >  	/*
>> > +	 * PAE CPUID issue: many Pentium M report no PAE but may have a
>> > +	 * functionally usable PAE implementation.
>> > +	 * Forcefully enable PAE if kernel parameter "forcepae" is
>present.
>> > +	 */
>> > +	if (forcepae) {
>> > +		printk(KERN_WARNING "PAE forced!\n");
>> > +		set_cpu_cap(c, X86_FEATURE_PAE);
>> > +		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
>> 
>> Right, this implies Dave's patch is preceding yours. I guess hpa can
>> fish it out from the thread when applying.
>
>I will include Dave's patch, it is trivial. 
>
>New patch with all above changes follows.
>
>Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
>---
>
>diff --git a/Documentation/kernel-parameters.txt
>b/Documentation/kernel-parameters.txt
>index 580a60c..7d57a5a 100644
>--- a/Documentation/kernel-parameters.txt
>+++ b/Documentation/kernel-parameters.txt
>@@ -2307,6 +2307,13 @@ bytes respectively. Such letter suffixes can
>also be entirely omitted.
> 	OSS		[HW,OSS]
> 			See Documentation/sound/oss/oss-parameters.txt
> 
>+	pae [X86-32]
>+			Forcefully enable Physical Address Extension (PAE).
>+			Many Pentium M systems disable PAE but may have a
>+			functionally usable PAE implementation.
>+			Warning: use of this parameter will taint the kernel
>+			and may cause unknown problems.
>+
> 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
> 			timeout > 0: seconds before rebooting
> 			timeout = 0: wait forever
>diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
>index 100a9a1..740d2d1 100644
>--- a/arch/x86/boot/cpucheck.c
>+++ b/arch/x86/boot/cpucheck.c
>@@ -67,6 +67,13 @@ static int is_transmeta(void)
> 	       cpu_vendor[2] == A32('M', 'x', '8', '6');
> }
> 
>+static int is_intel(void)
>+{
>+	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
>+	       cpu_vendor[1] == A32('i', 'n', 'e', 'I') &&
>+	       cpu_vendor[2] == A32('n', 't', 'e', 'l');
>+}
>+
> /* Returns a bitmask of which words we have error bits in */
> static int check_cpuflags(void)
> {
>@@ -153,6 +160,19 @@ int check_cpu(int *cpu_level_ptr, int
>*req_level_ptr, u32 **err_flags_ptr)
> 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
> 
> 		err = check_cpuflags();
>+	} else if (err == 0x01 &&
>+		   !(err_flags[0] & ~(1 << X86_FEATURE_PAE)) &&
>+		   is_intel() && cpu.level == 6 &&
>+		   (cpu.model == 9 || cpu.model == 13)) {
>+		/* PAE is disabled on this Pentium M but can be forced */
>+		if (cmdline_find_option_bool("pae")) {
>+			puts("WARNING: Forcing PAE in CPU flags\n");
>+			set_bit(X86_FEATURE_PAE, cpu.flags);
>+			err = check_cpuflags();
>+		}
>+		else {
>+			puts("WARNING: PAE disabled. Use parameter 'pae' to enable at your
>own risk!\n");
>+		}
> 	}
> 
> 	if (err_flags_ptr)
>diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>index c67ffa6..7ec4119 100644
>--- a/arch/x86/kernel/cpu/amd.c
>+++ b/arch/x86/kernel/cpu/amd.c
>@@ -218,7 +218,7 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
> 	 */
> 	WARN_ONCE(1, "WARNING: This combination of AMD"
> 		" processors is not suitable for SMP.\n");
>-	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
>+	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
> }
> 
> static void init_amd_k7(struct cpuinfo_x86 *c)
>diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>index ea56e7c..cc0d048 100644
>--- a/arch/x86/kernel/cpu/intel.c
>+++ b/arch/x86/kernel/cpu/intel.c
>@@ -195,6 +195,14 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
> 	}
> }
> 
>+static int pae;
>+static int __init pae_setup(char *__unused)
>+{
>+	pae = 1;
>+	return 1;
>+}
>+__setup("pae", pae_setup);
>+
> static void intel_workarounds(struct cpuinfo_x86 *c)
> {
> 	unsigned long lo, hi;
>@@ -225,6 +233,17 @@ static void intel_workarounds(struct cpuinfo_x86
>*c)
> 		clear_cpu_cap(c, X86_FEATURE_SEP);
> 
> 	/*
>+	 * PAE CPUID issue: many Pentium M report no PAE but may have a
>+	 * functionally usable PAE implementation.
>+	 * Forcefully enable PAE if kernel parameter "pae" is present.
>+	 */
>+	if (pae) {
>+		printk(KERN_WARNING "PAE forced!\n");
>+		set_cpu_cap(c, X86_FEATURE_PAE);
>+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
>+	}
>+
>+	/*
> 	 * P4 Xeon errata 037 workaround.
>	 * Hardware prefetcher may cause stale data to be loaded into the
>cache.
> 	 */
>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>index 196d1ea..08fb024 100644
>--- a/include/linux/kernel.h
>+++ b/include/linux/kernel.h
>@@ -458,7 +458,7 @@ extern enum system_states {
> 
> #define TAINT_PROPRIETARY_MODULE	0
> #define TAINT_FORCED_MODULE		1
>-#define TAINT_UNSAFE_SMP		2
>+#define TAINT_CPU_OUT_OF_SPEC		2
> #define TAINT_FORCED_RMMOD		3
> #define TAINT_MACHINE_CHECK		4
> #define TAINT_BAD_PAGE			5
>diff --git a/kernel/module.c b/kernel/module.c
>index b99e801..8dc7f5e 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -1015,7 +1015,7 @@ static size_t module_flags_taint(struct module
>*mod, char *buf)
> 		buf[l++] = 'C';
> 	/*
> 	 * TAINT_FORCED_RMMOD: could be added.
>-	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
>+	 * TAINT_CPU_OUT_OF_SPEC, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
> 	 * apply to modules.
> 	 */
> 	return l;
>diff --git a/kernel/panic.c b/kernel/panic.c
>index 3eb0ffb..cca8a91 100644
>--- a/kernel/panic.c
>+++ b/kernel/panic.c
>@@ -199,7 +199,7 @@ struct tnt {
> static const struct tnt tnts[] = {
> 	{ TAINT_PROPRIETARY_MODULE,	'P', 'G' },
> 	{ TAINT_FORCED_MODULE,		'F', ' ' },
>-	{ TAINT_UNSAFE_SMP,		'S', ' ' },
>+	{ TAINT_CPU_OUT_OF_SPEC,	'S', ' ' },
> 	{ TAINT_FORCED_RMMOD,		'R', ' ' },
> 	{ TAINT_MACHINE_CHECK,		'M', ' ' },
> 	{ TAINT_BAD_PAGE,		'B', ' ' },

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
