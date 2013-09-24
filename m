Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3IXE5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab3IXE5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:57:38 -0400
Date: Tue, 24 Sep 2013 12:57:05 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130924045705.GB5561@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 at 08:06pm, H. Peter Anvin wrote:
> Okay... I see two problems.
> 
> 1. It looks like we subtract the region size after, rather than before, assigning an address.
> 
> 2. The second region is assigned the same address in the secondary kernel as in the first, implying the size of the first region was somehow set to zero.

I find the reason, efi_reserve_boot_services will reserve the BOOT_SERVICE_DATA region
thus the memmap size is changed to 0, so in 2nd kernel the virtual mapping addr after
the md will be not same as 1st kernel, see below code:
 
void __init efi_map_region(efi_memory_desc_t *md)
{
        unsigned long size = md->num_pages << PAGE_SHIFT;

        efi_va -= size;
        ^^^^^^^^^^^^^^^
	[snip]
}


> 
> Dave Young <dyoung@redhat.com> wrote:
> >On 09/22/13 at 08:27am, H. Peter Anvin wrote:
> >> The address that faults is interesting in that it is indeed just
> >below -4G.  The question at hand is probably what information you are
> >using to build the EFI mappings in the secondary kernel and what could
> >make it not match the primary.
> >> 
> >> Assuming it isn't as simple as the mappings never get built at all.
> >
> >Here is my debug output, diff efi-mapping-1st-kernel
> >efi-mapping-2nd-kernel:
> >Obviously, the high address mapping is not same:
> >
> >--- efi-mapping-1.txt	2013-09-24 10:46:09.977746047 +0800
> >+++ efi-mapping-2.txt	2013-09-24 10:46:33.871421806 +0800
> >@@ -1,30 +1,30 @@
> > efi mapping PA 0x800000 -> VA 0x800000
> > efi mapping PA 0x800000 -> VA 0xffffffff00000000
> > efi mapping PA 0x7c000000 -> VA 0x7c000000
> >-efi mapping PA 0x7c000000 -> VA 0xfffffffefffe0000
> >+efi mapping PA 0x7c000000 -> VA 0xffffffff00000000
> > efi mapping PA 0x7d5e2000 -> VA 0x7d5e2000
> >-efi mapping PA 0x7d5e2000 -> VA 0xfffffffefffdf000
> >+efi mapping PA 0x7d5e2000 -> VA 0xfffffffefffff000
> > efi mapping PA 0x7d77d000 -> VA 0x7d77d000
> >-efi mapping PA 0x7d77d000 -> VA 0xfffffffefffde000
> >+efi mapping PA 0x7d77d000 -> VA 0xfffffffeffffe000
> > efi mapping PA 0x7d864000 -> VA 0x7d864000
> >-efi mapping PA 0x7d864000 -> VA 0xfffffffeff8d4000
> >+efi mapping PA 0x7d864000 -> VA 0xfffffffeff8f4000
> > efi mapping PA 0x7df6e000 -> VA 0x7df6e000
> >-efi mapping PA 0x7df6e000 -> VA 0xfffffffeff6ae000
> >+efi mapping PA 0x7df6e000 -> VA 0xfffffffeff6ce000
> > efi mapping PA 0x7e194000 -> VA 0x7e194000
> >-efi mapping PA 0x7e194000 -> VA 0xfffffffeff6ac000
> >+efi mapping PA 0x7e194000 -> VA 0xfffffffeff6cc000
> > efi mapping PA 0x7e196000 -> VA 0x7e196000
> >-efi mapping PA 0x7e196000 -> VA 0xfffffffeff696000
> >+efi mapping PA 0x7e196000 -> VA 0xfffffffeff6b6000
> > efi mapping PA 0x7e1ac000 -> VA 0x7e1ac000
> >-efi mapping PA 0x7e1ac000 -> VA 0xfffffffeff681000
> >+efi mapping PA 0x7e1ac000 -> VA 0xfffffffeff6a1000
> > efi mapping PA 0x7e1c1000 -> VA 0x7e1c1000
> >-efi mapping PA 0x7e1c1000 -> VA 0xfffffffefe041000
> >+efi mapping PA 0x7e1c1000 -> VA 0xfffffffefe061000
> > efi mapping PA 0x7f802000 -> VA 0x7f802000
> >-efi mapping PA 0x7f802000 -> VA 0xfffffffefdec2000
> >+efi mapping PA 0x7f802000 -> VA 0xfffffffefdee2000
> > efi mapping PA 0x7f981000 -> VA 0x7f981000
> >-efi mapping PA 0x7f981000 -> VA 0xfffffffefde92000
> >+efi mapping PA 0x7f981000 -> VA 0xfffffffefdeb2000
> > efi mapping PA 0x7f9b1000 -> VA 0x7f9b1000
> >-efi mapping PA 0x7f9b1000 -> VA 0xfffffffefde6e000
> >+efi mapping PA 0x7f9b1000 -> VA 0xfffffffefde8e000
> > efi mapping PA 0x7f9e5000 -> VA 0x7f9e5000
> >-efi mapping PA 0x7f9e5000 -> VA 0xfffffffefd873000
> >+efi mapping PA 0x7f9e5000 -> VA 0xfffffffefd893000
> > efi mapping PA 0x7ffe0000 -> VA 0x7ffe0000
> >-efi mapping PA 0x7ffe0000 -> VA 0xfffffffefd853000
> >+efi mapping PA 0x7ffe0000 -> VA 0xfffffffefd873000
> >
> >> 
> >> 
> >> Borislav Petkov <bp@alien8.de> wrote:
> >> >On Sun, Sep 22, 2013 at 08:35:15PM +0800, Dave Young wrote:
> >> >> I tested your new patch, it works both with efi stub and grub boot
> >in
> >> >> 1st kernel.
> >> >
> >> >Good, thanks!
> >> >
> >> >> But it paniced in kexec boot with my kexec related patcheset, the
> >> >patchset
> >> >
> >> >That's the second kernel, right?
> >> >
> >> >> contains 3 patch:
> >> >> 1. introduce cmdline kexecboot=<0|1|2>; 1 == kexec, 2 == kdump
> >> >> 2. export physical addr fw_vendor, runtime, tables to
> >> >/sys/firmware/efi/systab
> >> >> 3. if kexecboot != 0, use fw_vendor, runtime, tables from
> >bootparams;
> >> >Also do not
> >> >>    call SetVirtualAddressMao in case kexecboot.
> >> >> 
> >> >> The panic happens at the last line of efi_init:
> >> >>         /* clean DUMMY object */
> >> >>         efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
> >> >>                          EFI_VARIABLE_NON_VOLATILE |
> >> >>                          EFI_VARIABLE_BOOTSERVICE_ACCESS |
> >> >>                          EFI_VARIABLE_RUNTIME_ACCESS,
> >> >>                          0, NULL);
> >> >> 
> >> >> Below is the dmesg:
> >> >> [    0.003359] pid_max: default: 32768 minimum: 301
> >> >> [    0.004792] BUG: unable to handle kernel paging request at
> >> >fffffffefde97e70
> >> >> [    0.006666] IP: [<ffffffff8103a1db>]
> >> >virt_efi_set_variable+0x40/0x54
> >> >> [    0.006666] PGD 36981067 PUD 35828063 PMD 0
> >> >
> >> >Here it is - fffffffefde97e70 is not mapped in the pagetable, PMD is
> >0.
> >> >
> >> >Ok, can you upload your patches somewhere and tell me exactly how to
> >> >reproduce this so that I can take a look too?
> >> >
> >> >Thanks.
> >> 
> >> -- 
> >> Sent from my mobile phone.  Please pardon brevity and lack of
> >formatting.
> 
> -- 
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.
