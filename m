Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3ITLv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3ITLv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:51:58 -0400
Date: Fri, 20 Sep 2013 19:51:25 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20130920115125.GE21922@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920090544.GA9574@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920090544.GA9574@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/13 at 11:05am, Borislav Petkov wrote:
> On Fri, Sep 20, 2013 at 03:29:04PM +0800, Dave Young wrote:
> > Just tested this series, for 1st kernel It boots ok in qemu+ovmf. But
> > it immediately reboot on my Thinkpad T420. Unfortunately there's no
> > way to debug this very early problem because there's no serial port
> > also earlyprintk does not work for efi boot. No usb debug as well on
> > this machine. I will test it when I go back to work after the china
> > holiday.
> 
> Hmm, I'm booting with the efi boot stub, how do you do it?

Just a Fedora 19 grub boot.

> 
> > OTOH, for 2nd kernel testing because kexec tools does not fill
> > efi_info[] in bootparam so kernel will disable efi, also it pass
> > acpi_rsdp pointer automaticlly to make 2nd kernel boot ok.
> 
> Right, the way this could be done is to pass in efi_info.efi_memmap,
> i.e. the physical map and then iterate over it and compute the virtual
> addresses *without* calling phys_efi_set_virtual_address_map() - they
> are stable now.
> 
> > I tested with a user space patch which copy efi_info from 1st kernel
> > to bootparams, as I said previously this is not enough because several
> > fields in systab, fw_vendor, runtime and tables are converted to
> > virtual address but in kernel efi init function they are assumed
> > physical addresses. Thus we need save these physical address. I have a
> > patch to save them and pass them to 2nd kernel in bootparams.
> 
> Yep.
> 
> > Since the mapping are same, I wonder if we can calculate the physical
> > address from virtual address. Idea?
> 
> Just look at the loop where we're iterating over regions in
> efi_enter_virtual_mode(): we basically can do the same __map_region
> calls without calling phys_efi_set_virtual_address_map.

Sorry, I do not understand the "do the same __map_region"

See below code:
        /*
         * Show what we know for posterity
         */
        c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);

efi.systab->fw_vendor is a virtual addr after entering virtual mode,
so can not ioremap it in 2nd kernel. 

efi_init is before enter_virtual_mode, do you means move mem mapping code 
earlier so we can directly use the fw_vendor as a virtual address?

> 
> > Another concern is that is it safe for i386 efi boot?
> 
> That's why I didn't put a git tree on k.org - I wanted to run tests
> myself before Fengguang's robot :)
> 
> But no, 32-bit is not addressed here. Which just dawned on me: Matt, I
> probably should keep the ioremapping code for 32-bit, doh. I completely
> went 64-bit only here :-)
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
