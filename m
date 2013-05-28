Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab3E1XnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:43:20 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:14103
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759267Ab3E1XnT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:43:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dIc89bh146fI1102I1432I1414J168aJzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h93fhd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MNJ8JX-01-QUI-02
X-M-MSG: 
Date: Tue, 28 May 2013 18:43:07 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] x86/microcode: early microcode patch loading
 support on AMD
Message-ID: <20130528234307.GA20622@jshin-Toonie>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-4-git-send-email-jacob.shin@amd.com>
 <20130528224529.GC29233@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130528224529.GC29233@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:45:29AM +0200, Borislav Petkov wrote:
> On Thu, May 23, 2013 at 10:40:18AM -0500, Jacob Shin wrote:
> > Add support for early microcode patch loading on AMD.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/Kconfig                       |   16 +-
> >  arch/x86/include/asm/microcode.h       |    1 -
> >  arch/x86/include/asm/microcode_amd.h   |   17 ++
> >  arch/x86/include/asm/microcode_intel.h |    1 +
> >  arch/x86/kernel/microcode_amd.c        |  338 ++++++++++++++++++++++++++++----
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
> 
> Why? We want to load ucode early by default.
> 
> >  	depends on MICROCODE_INTEL && BLK_DEV_INITRD
> > +
> > +config MICROCODE_AMD_EARLY
> > +	def_bool n
> 
> ditto.
> 
> > +	depends on MICROCODE_AMD && BLK_DEV_INITRD
> > +
> > +config MICROCODE_EARLY
> > +	bool "Early load microcode"
> > +	depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
> > +	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
> > +	select MICROCODE_AMD_EARLY if MICROCODE_AMD
> 
> It looks to me the BLK_DEV_INITRD dependency should be moved here and the
> respective early loading code should be dependent on the cpu support...
> 
> Crap, this whole microcode Kconfig menu needs a bit of scrubbing.
> 
> Anyway, this whole Kconfig microcode section could use a simplification
> but this is not the subject of this patchset - I'll try to address it
> after this, as stated in another mail.

Yes, I'll simplify the Kconfig as you suggested in your ealier email.

> 
> [ … ]
> 
> > diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> > index efdec7c..cda647e 100644
> > --- a/arch/x86/kernel/microcode_amd.c
> > +++ b/arch/x86/kernel/microcode_amd.c
> > @@ -27,10 +27,13 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/pci.h>
> > +#include <linux/earlycpio.h>
> 
> Looks like this include is not needed.
> 
> >  #include <asm/microcode.h>
> > +#include <asm/microcode_amd.h>
> >  #include <asm/processor.h>
> >  #include <asm/msr.h>
> > +#include <asm/setup.h>
> 
> ditto.
> 
> At least I can't seem to trigger any build failures when I comment them
> out.

Hm.. I couldn't build without it at some point, I'll take them out but they
might be indrectly included anyways.

> 
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
> > @@ -173,9 +181,17 @@ static struct ucode_patch *find_patch(unsigned int cpu)
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
> 
> Why do we even need this? Hotplug should take care of reappying
> microcode on all cores.

It is needed because otherwise BSP does not reapply microcode on resume, see
microcode_core.c BSP resume code path.

> 
> >  	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
> >  
> >  	return 0;
> > @@ -215,24 +231,14 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
> >  	return patch_size;
> >  }
> >  
> > -static int apply_microcode_amd(int cpu)
> > +static int _apply_microcode_amd(int cpu, void *data, struct cpuinfo_x86 *c,
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
> 
> Right, come to think of it, we don't use this uci->mc thing anywhere
> except in mc_bp_resume. But even there, we call ->apply_microcode()
> which on AMD searches the patch in the patch cache so no need for this
> assignment at all.

Right, but at least we need a non-zero value, I can stick "1" in there I guess.
Whatever you prefer.

> 
> >  	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
> >  
> > @@ -247,18 +253,37 @@ static int apply_microcode_amd(int cpu)
> >  	/* verify patch application was successful */
> >  	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
> >  	if (rev != mc_amd->hdr.patch_id) {
> > -		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
> > -		       cpu, mc_amd->hdr.patch_id);
> > +		if (!silent)
> > +			pr_err("CPU%d: update failed for patch_level=0x%08x\n",
> > +				cpu, mc_amd->hdr.patch_id);
> >  		return -1;
> >  	}
> >  
> > -	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
> > +	if (!silent)
> > +		pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
> >  	uci->cpu_sig.rev = rev;
> >  	c->microcode = rev;
> >  
> >  	return 0;
> >  }
> >  
> > +static int apply_microcode_amd(int cpu)
> > +{
> > +	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > +	struct ucode_cpu_info *uci;
> > +	struct ucode_patch *p;
> > +
> > +	BUG_ON(raw_smp_processor_id() != cpu);
> > +
> > +	uci = ucode_cpu_info + cpu;
> > +
> > +	p = find_patch(cpu);
> > +	if (!p)
> > +		return 0;
> > +
> > +	return _apply_microcode_amd(cpu, p->data, c, uci, false);
> > +}
> > +
> >  static int install_equiv_cpu_table(const u8 *buf)
> >  {
> >  	unsigned int *ibuf = (unsigned int *)buf;
> > @@ -398,6 +423,44 @@ static enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
> >  	return UCODE_OK;
> >  }
> >  
> > +#if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
> > +#define MPB_MAX_SIZE F15H_MPB_MAX_SIZE
> 
> Is this an obscure way to say "I want the biggest patch size required,
> thus I'm taking the 4K size of F15h?
> 
> Please make it explicit:
> 
> #define MPB_MAX_SIZE PAGE_SIZE
> 
> If some future family decided it needs bigger microcode, then we can
> adjust it.

Okay will do.

> 
> > +static u8 bsp_mpb[MPB_MAX_SIZE];
> > +#endif
> > +static enum ucode_state request_microcode_fw(int cpu, const struct firmware *fw)
> 
> This function has the same name as one of the members in the
> microcode_ops. Misleading. Remember, this is code to be stared at by
> humans not be simply virtual addresses jumped to by a prefetcher.

Okay, will do.

> 
> > +{
> > +	enum ucode_state ret = UCODE_ERROR;
> > +
> > +	if (*(u32 *)fw->data != UCODE_MAGIC) {
> > +		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
> > +		return ret;
> > +	}
> 
> AFAICT, this function can be called early and we want to avoid printk
> there...

You're right, will change.

> 
> > +
> > +	/* free old equiv table */
> > +	free_equiv_cpu_table();
> 
> Huh, we use the equiv table in the initrd early, we can't free it.
> 
> > +
> > +	ret = load_microcode_amd(cpu, fw->data, fw->size);
> > +	if (ret != UCODE_OK)
> > +		cleanup();
> > +
> > +#if defined(CONFIG_MICROCODE_AMD_EARLY) && defined(CONFIG_X86_32)
> > +	/*
> > +	 * on X86_32 early load, while CPU hotplugging on, we cannot traverse
> > +	 * pcache since paging is not turneded on yet. so stash away BSP's MPB
> > +	 * when a new fw file is installed.
> > +	 */
> 
> This comment needs a bit of scrubbing, spell- and readability check.
> 
> And it says we cannot traverse the pcache and yet we traverse it with
> find_patch().
> 
> ???

What I meant was that we can traverse it now, but on 32 bits, later when we
go into suspend and resume, we since we load before paging is turned on, we
cannot traverse through equiv_cpu_table and pcache.

> 
> > +	if (cpu_data(cpu).cpu_index == boot_cpu_data.cpu_index) {
> > +		struct ucode_patch *p;
> > +
> > +		p = find_patch(cpu);
> > +		if (p)
> > +			memcpy(bsp_mpb, p->data, min_t(u32, ksize(p->data),
> > +						       MPB_MAX_SIZE));
> > +	}
> > +#endif
> > +	return ret;
> > +}
> > +
> >  /*
> >   * AMD microcode firmware naming convention, up to family 15h they are in
> >   * the legacy file:
> > @@ -419,7 +482,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
> >  {
> >  	char fw_name[36] = "amd-ucode/microcode_amd.bin";
> >  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > -	enum ucode_state ret = UCODE_NFOUND;
> > +	enum ucode_state ret;
> >  	const struct firmware *fw;
> >  
> >  	/* reload ucode container only on the boot cpu */
> > @@ -431,26 +494,11 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
> >  
> >  	if (request_firmware(&fw, (const char *)fw_name, device)) {
> >  		pr_err("failed to load file %s\n", fw_name);
> > -		goto out;
> > +		return UCODE_NFOUND;
> >  	}
> >  
> > -	ret = UCODE_ERROR;
> > -	if (*(u32 *)fw->data != UCODE_MAGIC) {
> > -		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
> > -		goto fw_release;
> > -	}
> > -
> > -	/* free old equiv table */
> > -	free_equiv_cpu_table();
> > -
> > -	ret = load_microcode_amd(cpu, fw->data, fw->size);
> > -	if (ret != UCODE_OK)
> > -		cleanup();
> > -
> > - fw_release:
> > +	ret = request_microcode_fw(cpu, fw);
> >  	release_firmware(fw);
> > -
> > - out:
> >  	return ret;
> >  }
> >  
> > @@ -475,6 +523,214 @@ static struct microcode_ops microcode_amd_ops = {
> >  	.microcode_fini_cpu               = microcode_fini_cpu_amd,
> >  };
> >  
> > +#ifdef CONFIG_MICROCODE_AMD_EARLY
> > +/*
> > + * Early Loading Support
> > + */
> > +
> > +static void __cpuinit collect_cpu_info_amd_early(struct cpuinfo_x86 *c,
> > +						 struct ucode_cpu_info *uci)
> > +{
> > +	u32 rev, eax;
> > +
> > +	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
> > +	eax = cpuid_eax(0x00000001);
> > +
> > +	uci->cpu_sig.sig = eax;
> > +	uci->cpu_sig.rev = rev;
> > +	c->microcode = rev;
> > +	c->x86 = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
> > +}
> > +
> > +/*
> > + * microcode patch container file is prepended to the initrd in cpio format.
> > + * see Documentation/x86/early-microcode.txt
> > + */
> > +static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
> > +
> > +static struct cpio_data __init
> > +request_firmware_in_initrd(void)
> 
> This function naming is wrong - we're not requesting but we're searching
> for the ucode blob in the initrd. So "find_ucode_in_initrd()" would be a
> more fitting name.

Okay will change.

> 
> > +{
> > +	long offset = 0;
> > +
> > +	return find_cpio_data(ucode_path,
> > +			(void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET),
> > +			boot_params.hdr.ramdisk_size, &offset);
> > +}
> > +
> > +static struct cpio_data __init request_firmware_in_initrd_early(void)
> 
> ditto.
> 
> > +{
> > +#ifdef CONFIG_X86_32
> 
> Now this could well use a comment about why we're using physical
> addresses on 32-bit.

Okay.

> 
> > +	struct boot_params *boot_params_p;
> > +	long offset = 0;
> > +
> > +	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
> > +	return find_cpio_data((char *)__pa_nodebug(ucode_path),
> > +			(void *)boot_params_p->hdr.ramdisk_image,
> > +			boot_params_p->hdr.ramdisk_size, &offset);
> > +#else
> > +	return request_firmware_in_initrd();
> > +#endif
> > +}
> > +
> > +static int __init
> > +find_equiv_cpu_table_early(const u8 *buf, struct equiv_cpu_entry **eq)
> > +{
> > +	unsigned int *ibuf = (unsigned int *)buf;
> > +	unsigned int type = ibuf[1];
> > +	unsigned int size = ibuf[2];
> > +
> > +	if (type != UCODE_EQUIV_CPU_TABLE_TYPE || !size)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * during BSP load, vmalloc() is not available yet.
> > +	 * so just use equivalent cpu table in initrd memory in place,
> > +	 * no need to copy it. on X86_64, first AP to load will actually
> > +	 * "install" the equiv_cpu_table. on X86_32, before mm frees up initrd.
> > +	 */
> 
> This comment needs scrubbing like block formatting, converting it into
> real sentences and actually trying to explain what do you mean with that
> last part "on X86_32..." - I can't read that. IOW, something like that:
> 
>         /*
>          * vmalloc() is not available early, while the microcode is loaded on
>          * the BSP. So just use the equivalent cpu table in the initrd, without
>          * copying it. On x86_64, the first AP to load will actually "install"
> 	 * the equiv_cpu_table while on X86_32...
>          */

Okay will try and word it better.

> 
> > +	*eq = (struct equiv_cpu_entry *)(buf + CONTAINER_HDR_SZ);
> > +
> > +	/* add header length */
> 
> No need for it - CONTAINER_HDR_SZ should be descriptive enough a name.
> 
> > +	return size + CONTAINER_HDR_SZ;
> > +}
> > +
> > +static enum ucode_state __init
> > +load_microcode_amd_early(int cpu, const u8 *data, size_t size)
> 
> Btw, this function is called only from load_ucode_amd_bsp, so call it
> accordingly: __load_ucode_amd_bsp() or so.

Okay.

> 
> > +{
> > +	unsigned int leftover;
> > +	u8 *fw = (u8 *)data;
> > +	int offset;
> > +	u16 equiv_id;
> > +	struct equiv_cpu_entry *eq;
> > +	struct cpuinfo_x86 c;
> 
> This looks wrong - so you're creating a variable on the stack just so
> that you can pass it to _apply_microcode_amd(). After the function
> finishes, all the assignments to it are gone.
> 
> Looks like bad design to me.
> 
> > +	struct ucode_cpu_info uci;
> > +
> > +	collect_cpu_info_amd_early(&c, &uci);
> > +
> > +	offset = find_equiv_cpu_table_early(data, &eq);
> > +	if (offset < 0)
> > +		return UCODE_ERROR;
> > +	fw += offset;
> > +	leftover = size - offset;
> > +
> > +	if (*(u32 *)fw != UCODE_UCODE_TYPE)
> > +		return UCODE_ERROR;
> > +
> > +	equiv_id = _find_equiv_id(eq, &uci);
> > +	if (!equiv_id)
> > +		return UCODE_NFOUND;
> > +
> > +	while (leftover) {
> > +		struct microcode_amd *mc;
> > +		int patch_size = *(u32 *)(fw + 4);
> > +
> > +		/*
> > +		 * during BSP load, vmalloc() is not available yet,
> > +		 * so simply find and apply the matching microcode patch in
> > +		 * initrd memory in place. on X86_64, first AP to load will
> > +		 * actually "cache" the patches in kernel memory.
> > +		 */
> > +		mc = (struct microcode_amd *)(fw + SECTION_HDR_SIZE);
> > +		if (equiv_id == mc->hdr.processor_rev_id)
> > +			if (_apply_microcode_amd(cpu, mc, &c, &uci, true) == 0)
> 
> 			if (!_apply...())
> 
> > +				break;
> > +
> > +		offset    = patch_size + SECTION_HDR_SIZE;
> > +		fw	 += offset;
> > +		leftover -= offset;
> > +	}
> > +
> > +	return UCODE_OK;
> > +}
> > +
> > +static void collect_cpu_info_amd_early_bsp(void *arg)
> > +{
> > +	unsigned int cpu = smp_processor_id();
> > +	struct cpuinfo_x86 dummy;
> > +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> > +	collect_cpu_info_amd_early(&dummy, uci);
> > +}
> > +
> > +int __init save_microcode_in_initrd_amd(void)
> 
> Ok, I don't understand:
> 
> We do all the collect_cpu_info and microcode loading both on the BSP and
> the APs. Why do we need to do that here too?
> 
> This is called later from save_microcode_in_initrd() which is an
> initcall but by that time microcode has been applied already everywhere.
> So why do it here too? I'm guessing so that you can stash away the
> ucode.
> 
> Also, this function is called on the AP path if we don't have an
> equiv_table. Sounds to me, the BSP could do this work for the remaining
> APs and they could simply apply the patches.

BSP cannot vmalloc() for both 32 and 64 bits, so we cannot "install"
equiv_cpu_table, also cannot create pcache yet.

> 
> > +{
> > +	struct cpio_data cd;
> > +	struct firmware fw;
> > +	struct ucode_cpu_info *uci = ucode_cpu_info + boot_cpu_data.cpu_index;
> > +
> > +	if (equiv_cpu_table)
> > +		return 0;
> > +
> > +	cd = request_firmware_in_initrd();
> > +	if (!cd.data)
> > +		return -EINVAL;
> > +
> > +	fw.data = cd.data;
> > +	fw.size = cd.size;
> > +
> > +	if (!uci->cpu_sig.sig)
> > +		smp_call_function_single(boot_cpu_data.cpu_index,
> > +					 collect_cpu_info_amd_early_bsp, NULL,
> > +					 1);
> > +
> > +	if (request_microcode_fw(boot_cpu_data.cpu_index, &fw) != UCODE_OK)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +void __init load_ucode_amd_bsp(void)
> > +{
> > +	unsigned int cpu = smp_processor_id();
> > +	struct cpio_data fw = request_firmware_in_initrd_early();
> > +
> > +	if (!fw.data)
> > +		return;
> > +
> > +	load_microcode_amd_early(cpu, fw.data, fw.size);
> > +}
> > +
> > +#ifdef CONFIG_X86_32
> > +/*
> > + * on X86_32 AP load, since paging is turned off and vmalloc() is not available
> > + * yet, we cannot install the equivalent cpu table nor cache the microcode
> > + * patches in kernel memory, so just take the BSP code path. unless we are
> > + * CPU hotplugging on (i.e. resume from suspend), which then we will load from
> > + * bsp_mpb instead.
> > + */
> > +void __cpuinit load_ucode_amd_ap(void)
> > +{
> > +	unsigned int cpu = smp_processor_id();
> > +	struct microcode_amd *mc;
> > +	struct cpuinfo_x86 c;
> > +	struct ucode_cpu_info uci;
> > +
> > +	mc = (struct microcode_amd *)__pa_nodebug(bsp_mpb);
> > +	if (mc->hdr.patch_id && mc->hdr.processor_rev_id)
> > +		_apply_microcode_amd(cpu, mc, &c, &uci, true);
> > +	else
> > +		load_ucode_amd_bsp();
> 
> What's going on here? The _ap() function does load...bsp()?

On 32 bits, APs cannot vmalloc(), so we take the same code path as the BSPs
loading from initrd memory, and not installing equiv_cpu_table and not creating
pcache.

> 
> This whole code looks really convoluted to me and I'm going to stop
> trying to understand what's going on. Please do a careful analysis of
> what calls what, when. Then, carve out shared functionality carefully
> into a function and call that function exactly what it does.
> 
> AFAICT, from reading the code, there a couple of things you need to do
> (correct me if I'm missing anything):
> 
> * load ucode on the BSP
> 
> * load ucode on the APs
> 
> * save the ucode image from initrd
> 
> But you have functions like _apply_microcode_amd where just so that you
> can reuse functionality, you create the passing arguments on the stack
> just so that it works. And this is not optimal.
> 
> A better design, IHMO, would be to carve out *only* the application
> functionality, i.e. the RD/WRMSR dance and call it __apply_microcode
> which you can call from the early code. The rest of the glue should go
> in another function which actually saves c->microcode, etc.
> 
> This makes it very hard to follow the code and is not a proper design.
> 
> And it should be very clear just by looking at the function, when and
> how is this function called.
> 
> Please add more thought and care when designing this for the next
> version.
> 
> You could also split this patch so that it is more clear what happens.
> 
> Another thing to consider is, for example, which work is done only once
> and should thus be done only on the BSP so that the if-clauses on the AP
> path can be removed.
> 
> Also, avoid repetitive work like save_microcode_in_initrd_amd() which is
> done from the initcall and on the APs. I don't think this is needed so
> it shouldn't happen.
> 
> And so on, and so on.

Okay I'll just rewrite the the whole thing tomorrow,

I'll separate out the early stuff by itself into microcode_amd_early.c

And try and word the comments clearer.

Thanks.

