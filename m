Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3KCMbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:31:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab3KCMbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:31:48 -0500
Date: Sun, 3 Nov 2013 20:31:15 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH 10/11] EFI: Runtime services virtual mapping
Message-ID: <20131103123115.GA5313@dhcp-16-126.nay.redhat.com>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
 <1383236709-19716-11-git-send-email-bp@alien8.de>
 <20131101032551.GC4378@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101032551.GC4378@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 at 11:25am, Dave Young wrote:
> On 10/31/13 at 05:25pm, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > We map the EFI regions needed for runtime services non-contiguously,
> > with preserved alignment on virtual addresses starting from -4G down
> > for a total max space of 64G. This way, we provide for stable runtime
> > services addresses across kernels so that a kexec'd kernel can still use
> > them.
> > 
> > Thus, they're mapped in a separate pagetable so that we don't pollute
> > the kernel namespace.
> > 
> > Add an efi= kernel command line parameter for passing miscellaneous
> > options and chicken bits from the command line.
> > 
> > While at it, add a chicken bit called "efi=old_map" which can be used as
> > a fallback to the old runtime services mapping method in case there's
> > some b0rkage with a particular EFI implementation (haha, it is hard to
> > hold up the sarcasm here...).
> > 
> > Also, add the UEFI RT VA space to Documentation/x86/x86_64/mm.txt.
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > ---
> >  Documentation/kernel-parameters.txt  |   6 ++
> >  Documentation/x86/x86_64/mm.txt      |   7 +++
> >  arch/x86/include/asm/efi.h           |  64 ++++++++++++++------
> >  arch/x86/include/asm/pgtable_types.h |   3 +-
> >  arch/x86/platform/efi/efi.c          |  94 +++++++++++++++++++++---------
> >  arch/x86/platform/efi/efi_32.c       |   9 ++-
> >  arch/x86/platform/efi/efi_64.c       | 109 +++++++++++++++++++++++++++++++++++
> >  arch/x86/platform/efi/efi_stub_64.S  |  54 +++++++++++++++++
> >  include/linux/efi.h                  |   1 +
> >  9 files changed, 300 insertions(+), 47 deletions(-)
> > 
> 
> Hi,
> 
> This one still does not apply:
> 
> [dave@darkstar linux-2.6]$ git am ~/Mail/bp/new/*
> Applying: efi: Simplify EFI_DEBUG
> Applying: x86, pageattr: Lookup address in an arbitrary PGD
> Applying: x86, pageattr: Add a PGD pagetable populating function
> Applying: x86, pageattr: Add a PUD pagetable populating function
> Applying: x86, pageattr: Add a PMD pagetable populating function
> Applying: x86, pageattr: Add a PTE pagetable populating function
> Applying: x86, pageattr: Add a PUD error unwinding path
> Applying: x86, pageattr: Add last levels of error path
> Applying: x86, cpa: Map in an arbitrary pgd
> Applying: EFI: Runtime services virtual mapping
> error: patch failed: arch/x86/platform/efi/efi.c:808
> error: arch/x86/platform/efi/efi.c: patch does not apply
> Patch failed at 0010 EFI: Runtime services virtual mapping
> The copy of the patch that failed is found in:
>    /home/dave/git/linux-2.6/.git/rebase-apply/patch
> When you have resolved this problem, run "git am --resolved".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> I found the reason, here is the diff of the efi.c
> between (linus tree + matt next) and the one in matt next:
> 
> --- efi.c.linus-tree	2013-11-01 11:16:44.731554778 +0800
> +++ efi.c.matt-next	2013-11-01 11:17:41.662316832 +0800
> @@ -806,13 +806,10 @@ void __init efi_enter_virtual_mode(void)
>  
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
> -		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
> -#ifdef CONFIG_X86_64
> -			if (md->type != EFI_BOOT_SERVICES_CODE &&
> -			    md->type != EFI_BOOT_SERVICES_DATA)
> -#endif
> -				continue;
> -		}
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> +		    md->type != EFI_BOOT_SERVICES_CODE &&
> +		    md->type != EFI_BOOT_SERVICES_DATA)
> +			continue;
>  
>  		size = md->num_pages << EFI_PAGE_SHIFT;
>  		end = md->phys_addr + size;
> 
> The conflict is caused by missing one commit in matt's efi next tree:
> 
> commit 700870119f49084da004ab588ea2b799689efaf7
> Author: Josh Boyer <jwboyer@redhat.com>
> Date:   Thu Apr 18 07:51:34 2013 -0700
> 
>     x86, efi: Don't map Boot Services on i386
>     
>     Add patch to fix 32bit EFI service mapping (rhbz 726701)
>     
>     Multiple people are reporting hitting the following WARNING on i386,
>     
>       WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
>       Modules linked in:
>       Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95

Hi, Matt

How should I handle this problem, would you take above commit or rebase efi
next branch?

--
Thanks
Dave
