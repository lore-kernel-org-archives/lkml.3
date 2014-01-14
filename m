Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaANOoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:44:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaANOof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:44:35 -0500
Message-ID: <1389710640.26822.10.camel@deneb.redhat.com>
Subject: Re: [PATCH 4/6] arm64: add EFI stub
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, matt.fleming@intel.com,
        patches@linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        linux-efi@vger.kernel.org
Date: Tue, 14 Jan 2014 09:44:00 -0500
In-Reply-To: <201401131949.39358.arnd@arndb.de>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
	 <1389392950-22457-5-git-send-email-msalter@redhat.com>
	 <201401131949.39358.arnd@arndb.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 19:49 +0100, Arnd Bergmann wrote:
> On Friday 10 January 2014, Mark Salter wrote:
> > This patch adds PE/COFF header fields to the start of the Image
> > so that it appears as an EFI application to EFI firmware. An EFI
> > stub is included to allow direct booting of the kernel Image. Due
> > to EFI firmware limitations, only little endian kernels with 4K
> > page sizes are supported at this time. Support in the COFF header
> > for signed images was provided by Ard Biesheuvel.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> You got the ordering of the S-o-b lines wrong. Since you send the
> patch, your name should come last.

Yes.

> 
> > +config EFI_STUB
> > +     bool "EFI stub support"
> > +     depends on !ARM64_64K_PAGES && OF
> > +     select LIBFDT
> > +     default y
> > +     help
> > +       This kernel feature allows an Image to be loaded directly
> > +       by EFI firmware without the use of a bootloader.
> > +       See Documentation/efi-stub.txt for more information.
> > +
> >  endmenu
> 
> Why not ARM64_64K_PAGES? I thought that it was going to be the
> default for a lot of distros that would need to run on UEFI systems.

The UEFI spec currently mandates 4k page size. We may be able to work
around that or get the spec changed, but for now it is just 4k pages.

> 
> >  menu "Userspace binary formats"
> > diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> > index 5ba2fd4..1c52b84 100644
> > --- a/arch/arm64/kernel/Makefile
> > +++ b/arch/arm64/kernel/Makefile
> > @@ -4,6 +4,8 @@
> >  
> >  CPPFLAGS_vmlinux.lds := -DTEXT_OFFSET=$(TEXT_OFFSET)
> >  AFLAGS_head.o                := -DTEXT_OFFSET=$(TEXT_OFFSET)
> > +CFLAGS_efi-stub.o    := -DTEXT_OFFSET=$(TEXT_OFFSET) \
> > +                        -I$(src)/../../../scripts/dtc/libfdt
> 
> Hmm, this is pretty ugly. I notice the same has been done on MIPS
> as well, but I'd hope we can find a proper way to do it.

Yes, I just copied that from mips. I can look into some more.

> 
> > diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> > new file mode 100644
> > index 0000000..10d02bf
> > --- /dev/null
> > +++ b/arch/arm64/kernel/efi-stub.c
> > +
> > +/* Include shared EFI stub code */
> > +#include "../../../drivers/firmware/efi/efi-stub-helper.c"
> > +#include "../../../drivers/firmware/efi/fdt.c"
> 
> It gets worse here.

Well, I'm open to suggestions here. The shared code has to work with
stubs which are built into kernel (arm64) and which are part of the
compressed image wrapper.



