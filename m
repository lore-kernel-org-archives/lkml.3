Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967002AbaFROVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966979AbaFROVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:21:45 -0400
Date: Wed, 18 Jun 2014 10:20:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 12/13] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20140618142058.GA16552@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-13-git-send-email-vgoyal@redhat.com>
 <20140617214310.GC20603@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617214310.GC20603@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:43:10PM +0200, Borislav Petkov wrote:

[..]
> > diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
> > new file mode 100644
> > index 0000000..2dd2eb8
> > --- /dev/null
> > +++ b/arch/x86/include/asm/crash.h
> > @@ -0,0 +1,9 @@
> > +#ifndef _ASM_X86_CRASH_H
> > +#define _ASM_X86_CRASH_H
> > +
> > +int load_crashdump_segments(struct kimage *image);
> 
> I guess crash_load_segments(..) as you're prefixing the other exported
> functions with "crash_".

Ok, I can make that change.

[..]
> > +/* Alignment required for elf header segment */
> > +#define ELF_CORE_HEADER_ALIGN   4096
> > +
> > +/* This primarily reprsents number of split ranges due to exclusion */
> 
> "represents"

Will do.

> 
> > +#define CRASH_MAX_RANGES	16
> > +
> > +struct crash_mem_range {
> > +	u64 start, end;
> > +};
> > +
> > +struct crash_mem {
> > +	unsigned int nr_ranges;
> > +	struct crash_mem_range ranges[CRASH_MAX_RANGES];
> > +};
> > +
> > +/* Misc data about ram ranges needed to prepare elf headers */
> > +struct crash_elf_data {
> > +	struct kimage *image;
> > +	/*
> > +	 * Total number of ram ranges we have after various ajustments for
> 
> "adjustments"

Will do.

[..]
> > @@ -39,6 +82,7 @@ int in_crash_kexec;
> >   */
> >  crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss = NULL;
> >  EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
> > +unsigned long crash_zero_bytes;
> 
> Ah, that's the empty_zero_page...

Ok, will look into moving to empty_zero_page.

[..]
> > +static int fill_up_crash_elf_data(struct crash_elf_data *ced,
> > +					struct kimage *image)
> > +{
> > +	unsigned int nr_ranges = 0;
> > +
> > +	ced->image = image;
> > +
> > +	walk_system_ram_range(0, -1, &nr_ranges,
> > +				get_nr_ram_ranges_callback);
> > +
> > +	ced->max_nr_ranges = nr_ranges;
> > +
> > +	/*
> > +	 * We don't create ELF headers for GART aperture as an attempt
> > +	 * to dump this memory in second kernel leads to hang/crash.
> > +	 * If gart aperture is present, one needs to exclude that region
> > +	 * and that could lead to need of extra phdr.
> > +	 */
> > +	walk_ram_res("GART", IORESOURCE_MEM, 0, -1,
> > +				ced, get_gart_ranges_callback);
> > +
> > +	/*
> > +	 * If we have gart region, excluding that could potentially split
> > +	 * a memory range, resulting in extra header. Account for  that.
> > +	 */
> > +	if (ced->gart_end)
> > +		ced->max_nr_ranges++;
> > +
> > +	/* Exclusion of crash region could split memory ranges */
> > +	ced->max_nr_ranges++;
> > +
> > +	/* If crashk_low_res is there, another range split possible */
> 
> You mean "is not 0"?

Yes. Will make comment more clear.

> 
> > +	if (crashk_low_res.end != 0)
> > +		ced->max_nr_ranges++;
> > +
> > +	return 0;
> 
> Returns unconditional 0 - make function void then.

Will do.

[..]
> > +		if (mstart > start && mend < end) {
> > +			/* Split original range */
> > +			mem->ranges[i].end = mstart - 1;
> > +			temp_range.start = mend + 1;
> > +			temp_range.end = end;
> > +		} else if (mstart != start)
> > +			mem->ranges[i].end = mstart - 1;
> > +		else
> > +			mem->ranges[i].start = mend + 1;
> > +		break;
> > +	}
> > +
> > +	/* If a split happend, add the split in array */
> 
> "happened" ... "split to array"

Ok. Will fix.


> 
> > +	if (!temp_range.end)
> > +		return 0;
> > +
> > +	/* Split happened */
> > +	if (i == CRASH_MAX_RANGES - 1) {
> > +		pr_err("Too many crash ranges after split\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Location where new range should go */
> > +	j = i + 1;
> > +	if (j < mem->nr_ranges) {
> > +		/* Move over all ranges one place */
> 
> 			...  all ranges one slot towards the end */
> 

Will change.

[..]
> > +static int prepare_elf64_headers(struct crash_elf_data *ced,
> > +		void **addr, unsigned long *sz)
> > +{
> > +	Elf64_Ehdr *ehdr;
> > +	Elf64_Phdr *phdr;
> > +	unsigned long nr_cpus = num_possible_cpus(), nr_phdr, elf_sz;
> > +	unsigned char *buf, *bufp;
> > +	unsigned int cpu;
> > +	unsigned long long notes_addr;
> > +	int ret;
> > +
> > +	/* extra phdr for vmcoreinfo elf note */
> > +	nr_phdr = nr_cpus + 1;
> > +	nr_phdr += ced->max_nr_ranges;
> > +
> > +	/*
> > +	 * kexec-tools creates an extra PT_LOAD phdr for kernel text mapping
> > +	 * area on x86_64 (ffffffff80000000 - ffffffffa0000000).
> > +	 * I think this is required by tools like gdb. So same physical
> > +	 * memory will be mapped in two elf headers. One will contain kernel
> > +	 * text virtual addresses and other will have __va(physical) addresses.
> > +	 */
> > +
> > +	nr_phdr++;
> > +	elf_sz = sizeof(Elf64_Ehdr) + nr_phdr * sizeof(Elf64_Phdr);
> > +	elf_sz = ALIGN(elf_sz, ELF_CORE_HEADER_ALIGN);
> > +
> > +	buf = vzalloc(elf_sz);
> 
> Since you get zeroed memory, you can save yourself all assignments to 0
> below and thus slim this already terse function.

Will do.

[..]
> > +static int add_e820_entry(struct boot_params *params, struct e820entry *entry)
> > +{
> > +	unsigned int nr_e820_entries;
> > +
> > +	nr_e820_entries = params->e820_entries;
> > +	if (nr_e820_entries >= E820MAX)
> > +		return 1;
> 
> You're not testing for the error condition in any call site. Are we sure
> we will never hit E820MAX?

Actually there can be. Right now I am just handling the case of passing
as many e820 enties as can fit in bootparams and ignoring rest. Ideally
momory ranges more than E820MAX should be passed through setup data and I
have not handled that case yet.

Very few systems should run into that kind of scenario. I was thinking
that once these patches are in, I can look into enabling passing of
more than E820MAX entries using setup data.

I will put a TODO comment.

> 
> > +
> > +	memcpy(&params->e820_map[nr_e820_entries], entry,
> > +			sizeof(struct e820entry));
> > +	params->e820_entries++;
> > +	return 0;
> > +}
> > +
> > +static int memmap_entry_callback(u64 start, u64 end, void *arg)
> > +{
> > +	struct crash_memmap_data *cmd = arg;
> > +	struct boot_params *params = cmd->params;
> > +	struct e820entry ei;
> > +
> > +	ei.addr = start;
> > +	ei.size = end - start + 1;
> > +	ei.type = cmd->type;
> > +	add_e820_entry(params, &ei);
> > +
> > +	return 0;
> > +}
> > +
> > +static int memmap_exclude_ranges(struct kimage *image, struct crash_mem *cmem,
> > +		unsigned long long mstart, unsigned long long mend)
> 
> Arg alignment... multiple occurrences in this patch.

Will fix.

> 
> > +{
> > +	unsigned long start, end;
> > +	int ret = 0;
> > +
> > +	memset(cmem->ranges, 0, sizeof(cmem->ranges));
> > +
> > +	cmem->ranges[0].start = mstart;
> > +	cmem->ranges[0].end = mend;
> > +	cmem->nr_ranges = 1;
> > +
> > +	/* Exclude Backup region */
> > +	start = image->arch.backup_load_addr;
> > +	end = start + image->arch.backup_src_sz - 1;
> > +	ret = exclude_mem_range(cmem, start, end);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Exclude elf header region */
> > +	start = image->arch.elf_load_addr;
> > +	end = start + image->arch.elf_headers_sz - 1;
> > +	ret = exclude_mem_range(cmem, start, end);
> > +	return ret;
> 
> 	return exclude_mem_range(cmem, start, end);

Will change.

> 
> > +}
> > +
> > +/* Prepare memory map for crash dump kernel */
> > +int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
> > +{
> > +	int i, ret = 0;
> > +	unsigned long flags;
> > +	struct e820entry ei;
> > +	struct crash_memmap_data cmd;
> > +	struct crash_mem *cmem;
> > +
> > +	cmem = vzalloc(sizeof(struct crash_mem));
> > +	if (!cmem)
> > +		return -ENOMEM;
> 
> You're getting zeroed memory already but you're zeroing it out again
> above in memmap_exclude_ranges().

Will remove extra zeoring.

[..]
> > +	/* Exclude some ranges from crashk_res and add rest to memmap */
> > +	ret = memmap_exclude_ranges(image, cmem, crashk_res.start,
> > +						crashk_res.end);
> > +	if (ret)
> > +		goto out;
> > +
> > +	for (i = 0; i < cmem->nr_ranges; i++) {
> > +		ei.addr = cmem->ranges[i].start;
> > +		ei.size = cmem->ranges[i].end - ei.addr + 1;
> > +		ei.type = E820_RAM;
> > +
> > +		/* If entry is less than a page, skip it */
> > +		if (ei.size < PAGE_SIZE)
> > +			continue;
> 
> You can do the size assignment and check first so that you don't have to
> do the rest if it is a less than a page.
> 

Ok, will do.

> > +		add_e820_entry(params, &ei);
> > +	}
> > +
> > +out:
> > +	vfree(cmem);
> > +	return ret;
> 
> This retval is not checked at the callsite in
> kexec_setup_boot_parameters().

Will check return code at call site.

[..]
> >  /*
> >   * Defines lowest physical address for various segments. Not sure where
> > @@ -130,11 +133,28 @@ void *bzImage64_load(struct kimage *image, char *kernel,
> >  		return ERR_PTR(-EINVAL);
> >  	}
> >  
> > +	/*
> > +	 * In case of crash dump, we will append elfcorehdr=<addr> to
> > +	 * command line. Make sure it does not overflow
> > +	 */
> > +	if (cmdline_len + MAX_ELFCOREHDR_STR_LEN > header->cmdline_size) {
> > +		ret = -EINVAL;
> 
> No need to assign anything to ret if you return ERR_PTR below.

Yep. Will remove it.

> 
> > +		pr_debug("Kernel command line too long\n");
> 
> This error message needs to differ from the one above - say something
> about "error appending elfcorehdr=...", for example.

Ok, Will fix it.

[..]
> > +	/* Setup copying of backup region */
> > +	if (image->type == KEXEC_TYPE_CRASH) {
> > +		ret = kexec_purgatory_get_set_symbol(image, "backup_dest",
> > +				&image->arch.backup_load_addr,
> > +				sizeof(image->arch.backup_load_addr), 0);
> > +		if (ret)
> > +			return ret;
> > +
> > +		ret = kexec_purgatory_get_set_symbol(image, "backup_src",
> > +				&image->arch.backup_src_start,
> > +				sizeof(image->arch.backup_src_start), 0);
> > +		if (ret)
> > +			return ret;
> > +
> > +		ret = kexec_purgatory_get_set_symbol(image, "backup_sz",
> > +				&image->arch.backup_src_sz,
> > +				sizeof(image->arch.backup_src_sz), 0);
> 
> Arg alignment is funny.

Will change.

Thanks
Vivek
