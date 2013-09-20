Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3ITIUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:20:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab3ITIUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:20:17 -0400
Date: Fri, 20 Sep 2013 16:19:40 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20130920081940.GC21922@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/13 at 03:29pm, Dave Young wrote:
> On 09/19/13 at 04:54pm, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Hi all,
> > 
> > here's finally a new version of the runtime services VA mapping patchset
> > which hopefully implements hpa's idea of statically mapping EFI runtime
> > regions in a top-down manner starting at -4Gb virtual.
> > 
> > We're also using a different pagetable so as not to pollute kernel
> > address space. For that, we switch to that table before doing an EFI
> > call, and afterwards we switch back to the previous one.
> > 
> > To the patches:
> > 
> > 1-2 are simple cleanups which Matt probably can take now
> > 
> > 3-10 add the machinery to map regions into an arbitrary PGD. Those I've
> > split deliberately into very small bites so that they can be reviewed
> > more thoroughly and easily for my pagetable skills are pretty basic.
> > 
> > 11 is the actual patch which implements that mapping so that we can use
> > runtime services in kexec (which is the whole reason for this fuss :))
> > 
> > So please take a long hard look at those, hammer on them on your
> > boxes and let me know. They boot fine on my Dell UEFI box and in OVMF
> > (obviously :)).
> 
> Thanks for your update!
> 
> Just tested this series, for 1st kernel It boots ok in qemu+ovmf. But it immediately
> reboot on my Thinkpad T420. Unfortunately there's no way to debug this
> very early problem because there's no serial port also earlyprintk does
> not work for efi boot. No usb debug as well on this machine. I will test
> it when I go back to work after the china holiday.

Actually the ovmf testing is "qemu-system-x86_64 -kernel ", boot from grub
fails as well. Nothing printed on serial. I guess '-kernel' is using efi stub
to boot?

> 
> OTOH, for 2nd kernel testing because kexec tools does not fill efi_info[]
> in bootparam so kernel will disable efi, also it pass acpi_rsdp pointer
> automaticlly to make 2nd kernel boot ok.
> 
> I tested with a user space patch which copy efi_info from 1st kernel to
> bootparams, as I said previously this is not enough because several fields
> in systab, fw_vendor, runtime and tables are converted to virtual address
> but in kernel efi init function they are assumed physical addresses. Thus
> we need save these physical address. I have a patch to save them and pass
> them to 2nd kernel in bootparams.
> Since the mapping are same, I wonder if we can calculate the physical
> address from virtual address.  Idea?
> 
> Another concern is that is it safe for i386 efi boot?
> 
