Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3EXTvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:51:37 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:16014
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756311Ab3EXTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:51:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MNBJ3G-02-GEC-02
X-M-MSG: 
Date: Fri, 24 May 2013 14:50:01 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] x86/microcode: early microcode patch loading
 support on AMD
Message-ID: <20130524195001.GA19155@jshin-Toonie>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-4-git-send-email-jacob.shin@amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712205633D85A@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205633D85A@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 03:33:38PM +0000, Yu, Fenghua wrote:
> > From: Jacob Shin [mailto:jacob.shin@amd.com]
> > Add support for early microcode patch loading on AMD.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/Kconfig                       |   16 +-
> >  arch/x86/include/asm/microcode.h       |    1 -
> >  arch/x86/include/asm/microcode_amd.h   |   17 ++
> >  arch/x86/include/asm/microcode_intel.h |    1 +
> >  arch/x86/kernel/microcode_amd.c        |  338
> > ++++++++++++++++++++++++++++----
> >  arch/x86/kernel/microcode_core_early.c |    7 +
> >  6 files changed, 333 insertions(+), 47 deletions(-)
> >  create mode 100644 arch/x86/include/asm/microcode_amd.h
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 3a5bced..fab72e7 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1090,8 +1090,18 @@ config MICROCODE_INTEL_LIB
> >  	depends on MICROCODE_INTEL
> > 
> >  config MICROCODE_INTEL_EARLY
> > -	bool "Early load microcode"
> > +	def_bool n
> >  	depends on MICROCODE_INTEL && BLK_DEV_INITRD
> > +
> > +config MICROCODE_AMD_EARLY
> > +	def_bool n
> > +	depends on MICROCODE_AMD && BLK_DEV_INITRD
> > +
> > +config MICROCODE_EARLY
> > +	bool "Early load microcode"
> > +	depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
> > +	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
> > +	select MICROCODE_AMD_EARLY if MICROCODE_AMD
> >  	default y
> >  	help
> >  	  This option provides functionality to read additional microcode
> > data
> > @@ -1099,10 +1109,6 @@ config MICROCODE_INTEL_EARLY
> >  	  microcode to CPU's as early as possible. No functional change
> > if no
> >  	  microcode data is glued to the initrd, therefore it's safe to
> > say Y.
> > 
> > -config MICROCODE_EARLY
> > -	def_bool y
> > -	depends on MICROCODE_INTEL_EARLY
> > -
> >  config X86_MSR
> >  	tristate "/dev/cpu/*/msr - Model-specific register support"
> >  	---help---
> > diff --git a/arch/x86/include/asm/microcode.h
> > b/arch/x86/include/asm/microcode.h
> > index 6825e2e..f4be4cc 100644
> > --- a/arch/x86/include/asm/microcode.h
> > +++ b/arch/x86/include/asm/microcode.h
> > @@ -58,7 +58,6 @@ static inline void __exit exit_amd_microcode(void) {}
> >  #endif
> > 
> >  #ifdef CONFIG_MICROCODE_EARLY
> > -#define MAX_UCODE_COUNT 128
> >  extern void __init load_ucode_bsp(void);
> >  extern __init void load_ucode_ap(void);
> >  extern int __init save_microcode_in_initrd(void);
> > diff --git a/arch/x86/include/asm/microcode_amd.h
> > b/arch/x86/include/asm/microcode_amd.h
> > new file mode 100644
> > index 0000000..376123c
> > --- /dev/null
> > +++ b/arch/x86/include/asm/microcode_amd.h
> > @@ -0,0 +1,17 @@
> > +#ifndef _ASM_X86_MICROCODE_AMD_H
> > +#define _ASM_X86_MICROCODE_AMD_H
> > +
> > +#ifdef CONFIG_MICROCODE_AMD_EARLY
> > +extern void __init load_ucode_amd_bsp(void);
> > +extern void __cpuinit load_ucode_amd_ap(void);
> > +extern int __init save_microcode_in_initrd_amd(void);
> > +#else
> > +static inline void __init load_ucode_amd_bsp(void) {}
> > +static inline void __cpuinit load_ucode_amd_ap(void) {}
> > +static inline int __init save_microcode_in_initrd_amd(void)
> > +{
> > +	return -EINVAL;
> > +}
> > +#endif
> > +
> > +#endif /* _ASM_X86_MICROCODE_AMD_H */
> > diff --git a/arch/x86/include/asm/microcode_intel.h
> > b/arch/x86/include/asm/microcode_intel.h
> > index 538e407..db4a2f9 100644
> > --- a/arch/x86/include/asm/microcode_intel.h
> > +++ b/arch/x86/include/asm/microcode_intel.h
> > @@ -64,6 +64,7 @@ extern int
> >  update_match_revision(struct microcode_header_intel *mc_header, int
> > rev);
> > 
> >  #ifdef CONFIG_MICROCODE_INTEL_EARLY
> > +#define MAX_UCODE_COUNT 128
> >  extern void __init load_ucode_intel_bsp(void);
> >  extern void __cpuinit load_ucode_intel_ap(void);
> >  extern void show_ucode_info_early(void);
> > diff --git a/arch/x86/kernel/microcode_amd.c
> > b/arch/x86/kernel/microcode_amd.c
> > index efdec7c..cda647e 100644
> > --- a/arch/x86/kernel/microcode_amd.c
> > +++ b/arch/x86/kernel/microcode_amd.c
> > @@ -27,10 +27,13 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/pci.h>
> > +#include <linux/earlycpio.h>
> > 
> >  #include <asm/microcode.h>
> > +#include <asm/microcode_amd.h>
> >  #include <asm/processor.h>
> >  #include <asm/msr.h>
> > +#include <asm/setup.h>
> > 
> >  MODULE_DESCRIPTION("AMD Microcode Update Driver");
> >  MODULE_AUTHOR("Peter Oruba");
> > @@ -84,23 +87,28 @@ struct ucode_patch {
> > 
> >  static LIST_HEAD(pcache);
> > 
> > -static u16 find_equiv_id(unsigned int cpu)
> > +static u16 _find_equiv_id(struct equiv_cpu_entry *eq,
> > +			  struct ucode_cpu_info *uci)
> >  {
> > -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> >  	int i = 0;
> > 
> > -	if (!equiv_cpu_table)
> > +	if (!eq)
> >  		return 0;
> > 
> > -	while (equiv_cpu_table[i].installed_cpu != 0) {
> > -		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
> > -			return equiv_cpu_table[i].equiv_cpu;
> > +	while (eq[i].installed_cpu != 0) {
> > +		if (uci->cpu_sig.sig == eq[i].installed_cpu)
> > +			return eq[i].equiv_cpu;
> > 
> >  		i++;
> >  	}
> >  	return 0;
> >  }
> > 
> > +static u16 find_equiv_id(unsigned int cpu)
> > +{
> > +	return _find_equiv_id(equiv_cpu_table, ucode_cpu_info + cpu);
> > +}
> > +
> >  static u32 find_cpu_family_by_equiv_cpu(u16 equiv_cpu)
> >  {
> >  	int i = 0;
> > @@ -173,9 +181,17 @@ static struct ucode_patch *find_patch(unsigned int
> > cpu)
> >  static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
> >  {
> >  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> > +	struct ucode_patch *p;
> > 
> >  	csig->sig = cpuid_eax(0x00000001);
> >  	csig->rev = c->microcode;
> > +
> > +	/* if a patch was early loaded, tell microcode_core.c about it */
> > +	p = find_patch(cpu);
> > +	if (p && (p->patch_id == csig->rev))
> > +		uci->mc = p->data;
> > +
> >  	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
> > 
> >  	return 0;
> > @@ -215,24 +231,14 @@ static unsigned int verify_patch_size(int cpu,
> > u32 patch_size,
> >  	return patch_size;
> >  }
> > 
> > -static int apply_microcode_amd(int cpu)
> > +static int _apply_microcode_amd(int cpu, void *data, struct
> > cpuinfo_x86 *c,
> > +				struct ucode_cpu_info *uci, bool silent)
> >  {
> > -	struct cpuinfo_x86 *c = &cpu_data(cpu);
> >  	struct microcode_amd *mc_amd;
> > -	struct ucode_cpu_info *uci;
> > -	struct ucode_patch *p;
> >  	u32 rev, dummy;
> > 
> > -	BUG_ON(raw_smp_processor_id() != cpu);
> > -
> > -	uci = ucode_cpu_info + cpu;
> > -
> > -	p = find_patch(cpu);
> > -	if (!p)
> > -		return 0;
> > -
> > -	mc_amd  = p->data;
> > -	uci->mc = p->data;
> > +	mc_amd  = data;
> > +	uci->mc = data;
> > 
> >  	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
> > 
> > @@ -247,18 +253,37 @@ static int apply_microcode_amd(int cpu)
> >  	/* verify patch application was successful */
> >  	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
> >  	if (rev != mc_amd->hdr.patch_id) {
> > -		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
> > -		       cpu, mc_amd->hdr.patch_id);
> > +		if (!silent)
> > +			pr_err("CPU%d: update failed for
> > patch_level=0x%08x\n",
> > +				cpu, mc_amd->hdr.patch_id);
> >  		return -1;
> >  	}
> > 
> > -	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
> > +	if (!silent)
> > +		pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
> 
> In 32-bit, this info won't be printed. Then microcode is silently updated. This may make it difficult for user to catch new microcode update info. And this is not consistent to 64-bit which prints the info.
> 
> You might print this info later when printk is usable like Intel ucode does.

Okay, will do.

> 
> >  	uci->cpu_sig.rev = rev;
> >  	c->microcode = rev;
> > 
> >  	return 0;
> >  }
> > 
> > +static int apply_microcode_amd(int cpu)
> 
> This apply_microcode_amd(int cpu) can be simplified as apply_microcode_amd(void).

Actually, this function is part of the microcode_ops (non-early
loading called by microcode_core.c) so I cannot change the function
parameters.

Thanks!

