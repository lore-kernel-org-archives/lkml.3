Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3IVOcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab3IVOcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:32:00 -0400
Date: Sun, 22 Sep 2013 22:31:27 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130922143127.GC7476@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <20130922140038.GB7476@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130922140038.GB7476@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/13 at 10:00pm, Dave Young wrote:
> On 09/22/13 at 03:37pm, Borislav Petkov wrote:
> > On Sun, Sep 22, 2013 at 08:35:15PM +0800, Dave Young wrote:
> > > I tested your new patch, it works both with efi stub and grub boot in
> > > 1st kernel.
> > 
> > Good, thanks!
> > 
> > > But it paniced in kexec boot with my kexec related patcheset, the patchset
> > 
> > That's the second kernel, right?
> 
> Yes, it's 2nd kernel.
> 
> > 
> > > contains 3 patch:
> > > 1. introduce cmdline kexecboot=<0|1|2>; 1 == kexec, 2 == kdump
> > > 2. export physical addr fw_vendor, runtime, tables to /sys/firmware/efi/systab
> > > 3. if kexecboot != 0, use fw_vendor, runtime, tables from bootparams; Also do not
> > >    call SetVirtualAddressMao in case kexecboot.
> > > 
> > > The panic happens at the last line of efi_init:
> > >         /* clean DUMMY object */
> > >         efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
> > >                          EFI_VARIABLE_NON_VOLATILE |
> > >                          EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > >                          EFI_VARIABLE_RUNTIME_ACCESS,
> > >                          0, NULL);
> > > 
> > > Below is the dmesg:
> > > [    0.003359] pid_max: default: 32768 minimum: 301
> > > [    0.004792] BUG: unable to handle kernel paging request at fffffffefde97e70
> > > [    0.006666] IP: [<ffffffff8103a1db>] virt_efi_set_variable+0x40/0x54
> > > [    0.006666] PGD 36981067 PUD 35828063 PMD 0
> > 
> > Here it is - fffffffefde97e70 is not mapped in the pagetable, PMD is 0.
> > 
> > Ok, can you upload your patches somewhere and tell me exactly how to
> > reproduce this so that I can take a look too?
> 
> Ok, will put somewhere after a little cleanup today.

Here it is:
https://people.redhat.com/ruyang/kexec-efi/for-bp/

userspace patches are also necessary, they are under kexec-tools-patches/

Just test with below steps:
kexec -l /boot/vmlinuz-3.12.0-rc1+ --reuse-cmdline --append "kexecboot=1"
kexec -e

> 
> > 
> > Thanks.
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > Sent from a fat crate under my desk. Formatting is fine.
> > --
