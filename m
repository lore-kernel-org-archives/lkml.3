Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3HENDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:03:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51253 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3HENDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:03:01 -0400
Date: Mon, 5 Aug 2013 15:02:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805130258.GB31845@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51FF8C14.2070405@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 01:27:16PM +0200, Laszlo Ersek wrote:
> > --- before      2013-07-31 22:20:52.316039492 +0200
> > +++ after       2013-07-31 22:21:30.960731706 +0200
> > @@ -9,7 +9,7 @@ efi: mem07: type=2, attr=0xf, range=[0x0
> >  efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
> >  efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
> >  efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
> > -efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
> > +efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
> 
> (type 4 is EfiBootServicesData)

Yes.

> >  efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
> >  efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
> >  efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
> > 
> > That second boundary of region mem11 suddenly changes *before* we merge
> > the regions. edk2 bug?
> 
> I take it you mean this change (ie. appearance of the zero-sized range)
> occurs when you enable KVM acceleration in qemu?

Right. And I'm booting with qemu -enable-kvm so KVM acceleration is
enabled?? Or do you mean something else.

> If so, please locate "gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel"
> in OvmfPkg/OvmfPkgX64.dsc, and set the following bit in its value:
> 
>   # DEBUG_GCD      0x00100000 Global Coherency Database changes
> 
> Then please rebuild OVMF, and capture the debug port output of qemu
> ("-debugcon file:debug.log -global isa-debugcon.iobase=0x402") both with
> and without KVM.
> 
> DEBUG_GCD should produce messages related to CoreAllocateSpace(), and
> might help us find the spot the difference is introduced.

Ok, I'll try to get this thing done before my vacation. If not, we'll
deal with it afterwards but I won't forget, I promise! :-)

> BTW does this have anything to do with the NX bit report of yours, or
> have you noticed this independently?

Independently, while testing my runtime services mapping patchset. I was
getting an empty region and was wondering whether to discard it from the
mapping or not and then I looked at why I get it in the first place.

Basically, I get this empty region which appears at some point. It is
there when we enter efi_enter_virtual_mode in the kernel to setup the
runtime mappings:

[    0.005012] efi: efi_enter_virtual_mode: enter
[    0.006004] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
[    0.007004] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.008003] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
[    0.009004] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
[    0.010004] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
[    0.011004] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e3000) (22MB)
[    0.012004] efi: mem06: type=7, attr=0xf, range=[0x00000000036e3000-0x000000003fffb000) (969MB)
[    0.013003] efi: mem07: type=2, attr=0xf, range=[0x000000003fffb000-0x0000000040000000) (0MB)
[    0.014004] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
[    0.015004] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
[    0.016004] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
[    0.017004] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
							^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[    0.018003] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)

When we dump the EFI regions initially, it is ok.

[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)

So what basically happens is the end boundary of the region becomes the
start, practically turning it into a 0-size one.

Thanks for looking into it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
