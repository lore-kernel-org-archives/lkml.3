Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaAMUBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:01:11 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33009 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaAMUBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:01:09 -0500
Date: Mon, 13 Jan 2014 20:01:35 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-efi@vger.kernel.org,
        linux@arm.linux.org.uk, patches@linaro.org,
        Will Deacon <will.deacon@arm.com>, roy.franz@linaro.org,
        matt.fleming@intel.com, msalter@redhat.com
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Message-ID: <20140113200135.GF30907@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
 <201401131943.10352.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401131943.10352.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 07:43:09PM +0100, Arnd Bergmann wrote:
> > This patch implements basic support for UEFI runtime services in the
> > ARM architecture - a requirement for using efibootmgr to read and update
> > the system boot configuration.
> > 
> > It uses the generic configuration table scanning to populate ACPI and
> > SMBIOS pointers.
> 
> As far as I'm concerned there are no plans to have ACPI support on ARM32,
> so I wonder what the code to populate the ACPI tables is about. Can
> you clarify this?

Are you suggesting that I should #ifndef ARM in common code, or that I
should neglect to document what the common code will do with data it is
given by UEFI?

> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 78a79a6a..1ab24cc 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
> >  	  the same virtual memory range as kmap so all early mappings must
> >  	  be unapped before paging_init() is called.
> >  
> > +config EFI
> > +	bool "UEFI runtime service support"
> > +	depends on OF && !CPU_BIG_ENDIAN
> 
> What is the dependency on !CPU_BIG_ENDIAN?

Mainly on code not being implemented to byte-reverse UCS strings.

> We try hard to have
> all kernel code support both big-endian and little-endian, and
> I'm guessing there is a significant overlap between the people
> that want UEFI support and those that want big-endian kernels.

Not really. There might be some. Also, it is not necessarily the case
that those people want to run the big-endian kernel at EL2.

If a need is seen, this support can be added at a later date.

> > +struct efi_memory_map memmap;
> 
> "memmap" is not a good name for a global identifier, particularly because
> it's easily confused with the well-known "mem_map" array. This
> wants namespace prefix like you other variable, or a "static" tag,
> preferably both.

It is defined by include/linux/efi.h.

> > +/*
> > + * This function switches the UEFI runtime services to virtual mode.
> > + * This operation must be performed only once in the system's lifetime,
> > + * including any kecec calls.
> 
>                    kexec

Ok.

> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index fa7d950..afaeb85 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -664,7 +664,7 @@ extern int __init efi_setup_pcdp_console(char *);
> >  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
> >  
> >  #ifdef CONFIG_EFI
> > -# ifdef CONFIG_X86
> > +# if defined(CONFIG_X86) || defined(CONFIG_ARM)
> >  extern int efi_enabled(int facility);
> >  # else
> >  static inline int efi_enabled(int facility)
> 
> Maybe better #ifndef CONFIG_IA64? It seems that is the odd one out and
> all possible future architectures would be like x86 and ARM.

This was pointed out by Matt Fleming earlier, so it will change.
Mark Salter suggested introducing something like ARCH_USES_EFI_FACILITY
would be a bit cleaner.

/
    Leif
