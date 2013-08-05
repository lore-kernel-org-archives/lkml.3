Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3HEODL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:03:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44944 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3HEODJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:03:09 -0400
Date: Mon, 5 Aug 2013 16:03:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805140306.GD31845@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51FFAB13.4090603@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:39:31PM +0200, Laszlo Ersek wrote:
> My question was: is my understanding correct that you only see this
> problem with "-enable-kvm"? Because,
> 
> On 08/01/13 18:49, Borislav Petkov wrote:
> > so I'm seeing this funny thing where an EFI region changes when we
> > enter efi_enter_virtual_mode when booting with edk2 on kvm. Here's
> > the diff:
> 
> You said "on kvm", and provided a diff. I think (hope) I understand the
> environment you've denoted with "after", but what's your "before"? The
> absence of "-enable-kvm", or something else?

Ah, I see.

So 'before' is the initial dump of the EFI regions, very early during
boot:

[    0.000000] efi: EFI v2.31 by EDK II
[    0.000000] efi:  ACPI=0x7fb71000  ACPI 2.0=0x7fb71014 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
[    0.000000] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e3000) (22MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x00000000036e3000-0x000000003fffb000) (969MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x000000003fffb000-0x0000000040000000) (0MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
[    0.000000] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
[    0.000000] efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000007e59c000-0x000000007e5a0000) (0MB)
[    0.000000] efi: mem16: type=3, attr=0xf, range=[0x000000007e5a0000-0x000000007e668000) (0MB)
[    0.000000] efi: mem17: type=5, attr=0x800000000000000f, range=[0x000000007e668000-0x000000007e67d000) (0MB)
[    0.000000] efi: mem18: type=6, attr=0x800000000000000f, range=[0x000000007e67d000-0x000000007e692000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000007e692000-0x000000007f992000) (19MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000007f992000-0x000000007f994000) (0MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x000000007f994000-0x000000007fb12000) (1MB)
[    0.000000] efi: mem22: type=5, attr=0x800000000000000f, range=[0x000000007fb12000-0x000000007fb42000) (0MB)
[    0.000000] efi: mem23: type=6, attr=0x800000000000000f, range=[0x000000007fb42000-0x000000007fb66000) (0MB)
[    0.000000] efi: mem24: type=0, attr=0xf, range=[0x000000007fb66000-0x000000007fb6a000) (0MB)
[    0.000000] efi: mem25: type=9, attr=0xf, range=[0x000000007fb6a000-0x000000007fb72000) (0MB)
[    0.000000] efi: mem26: type=10, attr=0xf, range=[0x000000007fb72000-0x000000007fb76000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x000000007fb76000-0x000000007ffe0000) (4MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007ffe0000-0x0000000080000000) (0MB)

and with 'after' I've denoted the dump of the EFI regions a second time,
a bit later, when we enter efi_enter_virtual_mode():

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
[    0.018003] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
[    0.019003] efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
[    0.021010] efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
[    0.022004] efi: mem15: type=4, attr=0xf, range=[0x000000007e59c000-0x000000007e5a0000) (0MB)
[    0.023003] efi: mem16: type=3, attr=0xf, range=[0x000000007e5a0000-0x000000007e668000) (0MB)
[    0.024004] efi: mem17: type=5, attr=0x800000000000000f, range=[0x000000007e668000-0x000000007e67d000) (0MB)
[    0.025003] efi: mem18: type=6, attr=0x800000000000000f, range=[0x000000007e67d000-0x000000007e692000) (0MB)
[    0.026004] efi: mem19: type=4, attr=0xf, range=[0x000000007e692000-0x000000007f992000) (19MB)
[    0.027003] efi: mem20: type=7, attr=0xf, range=[0x000000007f992000-0x000000007f994000) (0MB)
[    0.028003] efi: mem21: type=3, attr=0xf, range=[0x000000007f994000-0x000000007fb12000) (1MB)
[    0.029004] efi: mem22: type=5, attr=0x800000000000000f, range=[0x000000007fb12000-0x000000007fb42000) (0MB)
[    0.030004] efi: mem23: type=6, attr=0x800000000000000f, range=[0x000000007fb42000-0x000000007fb66000) (0MB)
[    0.031004] efi: mem24: type=0, attr=0xf, range=[0x000000007fb66000-0x000000007fb6a000) (0MB)
[    0.032004] efi: mem25: type=9, attr=0xf, range=[0x000000007fb6a000-0x000000007fb72000) (0MB)
[    0.033004] efi: mem26: type=10, attr=0xf, range=[0x000000007fb72000-0x000000007fb76000) (0MB)
[    0.034003] efi: mem27: type=4, attr=0xf, range=[0x000000007fb76000-0x000000007ffe0000) (4MB)
[    0.035003] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007ffe0000-0x0000000080000000) (0MB)

during the *same* boot.

So, it is one boot but two dumps of the EFI regions. And yes, I'm
booting with the 'kvm' executable which has '-enable-kvm'

> What's the purpose of that series? Can you please provide a link (if
> you posted versions of it already)?

Not yet posted but working on it.

The idea is to map the runtime regions at stable addresses so that when
we kexec a kernel, it can use runtime services too. And we have to do
that because of the braindead design of SetVirtualAddressMap() being
callable only once per boot.

> > So what basically happens is the end boundary of the region becomes the
> > start, practically turning it into a 0-size one.
> 
> ... and you guys suspect that some firmware code is responsible, code
> that runs between the initial memory map dump, and efi_enter_virtual_mode():
> 
> https://lkml.org/lkml/2013/7/31/550

I wouldn't wonder if we f*cked it up again like the last time. I'll give
it a long hard look.

> > Thanks for looking into it.
> 
> Hopefully DEBUG_GCD will tell us something.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
