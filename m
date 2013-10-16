Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3JPG2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3JPG2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:28:06 -0400
Date: Wed, 16 Oct 2013 14:27:09 +0800
From: Dave Young <dyoung@redhat.com>
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131016062709.GA18241@dhcp-16-126.nay.redhat.com>
References: <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011102706.GE12321@console-pimps.org>
 <643121905.4545046.1381498954428.JavaMail.root@redhat.com>
 <20131012021439.GA4464@dhcp-16-126.nay.redhat.com>
 <20131014155725.GD19665@fenchurch.internal.datastacks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014155725.GD19665@fenchurch.internal.datastacks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/13 at 11:57am, Peter Jones wrote:
> On Sat, Oct 12, 2013 at 10:14:39AM +0800, Dave Young wrote:
> > CCing Peter Jones .., Peter, any idea about the grub related problem?
> 
> What grub problem?  As Matt was saying, grub2 isn't loading it as
> EfiBootServicesCode/Data.  grub2 is loading it as EfiLoaderData .

Today I did printk debug, it is in fact an off by one bug:
text start: 1000000 md start: 800000 md size: 800000

Below is the code:
                if ((start+size >= __pa_symbol(_text)
                                && start <= __pa_symbol(_end)) ||
                        !e820_all_mapped(start, start+size, E820_RAM) ||
                        memblock_is_region_reserved(start, size)) {
                        /* Could not reserve, skip it */

Will post a patch to fix it.

> 
> > 
> > On 10/11/13 at 09:42am, Dave Young wrote:
> > > Matt,
> > > 
> > > The kernel I referring is the boot kernel aka the 1st kernel,
> > > the boot loader is grub2 from Fedora 19.
> > > 
> > > [sorry for top reply because of using webmail]
> > > 
> > > 
> > > ----- Original Message -----
> > > From: "Matt Fleming" <matt@console-pimps.org>
> > > To: "Dave Young" <dyoung@redhat.com>
> > > Cc: "Borislav Petkov" <bp@alien8.de>, "X86 ML" <x86@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, "Borislav Petkov" <bp@suse.de>, "Matthew Garrett" <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Vivek Goyal" <vgoyal@redhat.com>, linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
> > > Sent: Friday, October 11, 2013 6:27:06 PM
> > > Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
> > > 
> > > On Fri, 11 Oct, at 02:24:37PM, Dave Young wrote:
> > > > For the boot efi_reserve_boot_services code, it's mainly for the
> > > > SetVirtualAddressMap callback use, so boot regions should not be reused
> > > > before SetVirtualAddressMap, but the overlapping happens before the
> > > > efi_reserve_boot_services, isn't it a problem?
> > > 
> > > Hang on, which kernel are you referring to here? The boot kernel or the
> > > kexec'd kernel? I thought you were saying you noticed the overlap when
> > > running in the second (kexec'd) kernel?
> > > 
> > > The only reason that you would see this overlap in the first (boot)
> > > kernel is if the bootloader messed up and allocated the kernel text as
> > > EfiBootServicesCode/Data. I'd like to believe no bootloaders are still
> > > doing that.
> > > 
> > > -- 
> > > Matt Fleming, Intel Open Source Technology Center
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
>         Peter
