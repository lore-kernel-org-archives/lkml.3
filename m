Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3IXMq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:46:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab3IXMq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:46:26 -0400
Date: Tue, 24 Sep 2013 20:45:56 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130924124555.GA4690@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20130924045705.GB5561@dhcp-16-126.nay.redhat.com>
 <bd9528a453bce9b52ad4be75dcc0f034.squirrel@www.skyhub.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd9528a453bce9b52ad4be75dcc0f034.squirrel@www.skyhub.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/13 at 11:43am, Borislav Petkov wrote:
> Crap,
> 
> I need to send from the web interface since the network here doesn't
> somehow let through port 587.
> 
> On Tue, September 24, 2013 6:57 am, Dave Young wrote:
> > On 09/23/13 at 08:06pm, H. Peter Anvin wrote:
> >> Okay... I see two problems.
> >>
> >> 1. It looks like we subtract the region size after, rather than before,
> >> assigning an address.
> >>
> >> 2. The second region is assigned the same address in the secondary
> >> kernel as in the first, implying the size of the first region was
> >> somehow set to zero.
> >
> > I find the reason, efi_reserve_boot_services will reserve the
> > BOOT_SERVICE_DATA region
> > thus the memmap size is changed to 0, so in 2nd kernel the virtual mapping
> > addr after
> > the md will be not same as 1st kernel, see below code:
> >
> > void __init efi_map_region(efi_memory_desc_t *md)
> > {
> >         unsigned long size = md->num_pages << PAGE_SHIFT;
> >
> >         efi_va -= size;
> >         ^^^^^^^^^^^^^^^
> 
> Anyway, yes, this is wrong. We probably want to something like the
> following, instead (patch might be whitespace-damaged):
> 
> --
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a235dc95d629..ea0ea4fd3dab 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -85,8 +85,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  {
>  	unsigned long size = md->num_pages << PAGE_SHIFT;
> 
> -	efi_va -= size;
> -	if (efi_va < EFI_VA_END) {
> +	if (efi_va - size < EFI_VA_END) {
>  		pr_warning(FW_WARN "VA address range overflow!\n");
>  		return;
>  	}
> @@ -101,6 +100,8 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  	/* Do the VA map */
>  	__map_region(md, efi_va);
>  	md->virt_addr = efi_va;
> +
> +	efi_va -= size;
>  }
> 
>  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long
> size,
> 

Think again about this, how about 1:1 map them from a base address like -64G
phy_addr  ->  (-64G + phy_addr), in this way we can avoid depending on the
previous region size.

For the zero region problem, we can resolve it as a standalone problem.

--
Thanks
Dave
