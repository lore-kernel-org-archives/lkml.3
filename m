Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaB1VGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:06:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbaB1VGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:06:53 -0500
Date: Fri, 28 Feb 2014 16:06:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 11/11] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20140228210611.GB17195@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-12-git-send-email-vgoyal@redhat.com>
 <20140228172857.GG4326@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140228172857.GG4326@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 06:28:57PM +0100, Borislav Petkov wrote:

[..]
> > +/* Memory to backup during crash kdump */
> > +#define KEXEC_BACKUP_SRC_START	(0UL)
> > +#define KEXEC_BACKUP_SRC_END	(655360UL)	/* 640K */
> 
> I guess
> 
> #define KEXEC_BACKUP_SRC_END	(640 * 1024UL)
> 
> should be more clear.

Will Change.

[..]
> > +/* Alignment required for elf header segment */
> > +#define ELF_CORE_HEADER_ALIGN   4096
> > +
> > +/* This primarily reprsents number of split ranges due to exclusion */
> > +#define CRASH_MAX_RANGES	16
> > +
> > +struct crash_mem_range {
> > +	unsigned long long start, end;
> 
> u64?

Ok, that's shorter. Can use that.

[..]
> > +
> > +/* Used while prepareing memory map entries for second kernel */
> 
> s/prepareing/preparing/

Yep typo. Will fix.

[..]
> > +static int get_gart_ranges_callback(u64 start, u64 end, void *arg)
> > +{
> > +	struct crash_elf_data *ced = arg;
> > +
> > +	ced->gart_start = start;
> > +	ced->gart_end = end;
> > +
> > +	/* Not expecting more than 1 gart aperture */
> > +	return 1;
> > +}
> > +
> > +
> > +/* Gather all the required information to prepare elf headers for ram regions */
> > +static int fill_up_ced(struct crash_elf_data *ced, struct kimage *image)
> 
> All other functions have nice, spelled out names but not this one :)
> 
> Why not fill_up_crash_elf_data()?

Will change it.

> 
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
> > +
> 
> superfluous newline.

Will remove.

[..]
> > +int load_crashdump_segments(struct kimage *image)
> > +{
> > +	unsigned long src_start, src_sz;
> > +	unsigned long elf_addr, elf_sz;
> > +	int ret;
> > +
> > +	/*
> > +	 * Determine and load a segment for backup area. First 640K RAM
> > +	 * region is backup source
> > +	 */
> > +
> > +	ret = walk_system_ram_res(KEXEC_BACKUP_SRC_START, KEXEC_BACKUP_SRC_END,
> > +				image, determine_backup_region);
> > +
> > +	/* Zero or postive return values are ok */
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	src_start = image->arch.backup_src_start;
> > +	src_sz = image->arch.backup_src_sz;
> > +
> > +	/* Add backup segment. */
> > +	if (src_sz) {
> > +		ret = kexec_add_buffer(image, __va(src_start), src_sz, src_sz,
> > +					PAGE_SIZE, 0, -1, 0,
> > +					&image->arch.backup_load_addr);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	/* Prepare elf headers and add a segment */
> > +	ret = prepare_elf_headers(image, &elf_addr, &elf_sz);
> > +	if (ret)
> > +		return ret;
> > +
> > +	image->arch.elf_headers = elf_addr;
> > +	image->arch.elf_headers_sz = elf_sz;
> > +
> > +	ret = kexec_add_buffer(image, (char *)elf_addr, elf_sz, elf_sz,
> 
> For some reason, my compiler complains here:
> 
> arch/x86/kernel/crash.c: In function ‘load_crashdump_segments’:
> arch/x86/kernel/crash.c:704:6: warning: ‘elf_sz’ may be used uninitialized in this function [-Wuninitialized]
> arch/x86/kernel/crash.c:704:24: warning: ‘elf_addr’ may be used uninitialized in this function [-Wuninitialized]
> 
> It is likely bogus, though.

Hmm..., I did not see these warnings with my setup. elf_addr and elf_sz
will be initialized by prepare_elf_headers(). Not sure why compiler is
complaining.

[..]
> > +	pr_debug("Final command line is:%s\n", cmdline_ptr);
> 
> one space after ":"

Ok. will do.

> 
> The rest looks ok to me, but that doesn't mean a whole lot considering
> my very limited kexec knowledge.

Thanks for review. We need many eyes on this patch set. I will make
changes and post another version for review.

Thanks
Vivek
