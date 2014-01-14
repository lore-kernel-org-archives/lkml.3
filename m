Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaANLnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:43:55 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:42118 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaANLnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:43:51 -0500
Date: Tue, 14 Jan 2014 11:44:19 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-efi@vger.kernel.org,
        linux@arm.linux.org.uk, patches@linaro.org,
        Will Deacon <will.deacon@arm.com>, roy.franz@linaro.org,
        matt.fleming@intel.com, msalter@redhat.com
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Message-ID: <20140114114419.GH30907@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <201401131943.10352.arnd@arndb.de>
 <20140113200135.GF30907@bivouac.eciton.net>
 <201401140752.33257.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401140752.33257.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 07:52:32AM +0100, Arnd Bergmann wrote:
> > > > It uses the generic configuration table scanning to populate ACPI and
> > > > SMBIOS pointers.
> > > 
> > > As far as I'm concerned there are no plans to have ACPI support on ARM32,
> > > so I wonder what the code to populate the ACPI tables is about. Can
> > > you clarify this?
> > 
> > Are you suggesting that I should #ifndef ARM in common code, or that I
> > should neglect to document what the common code will do with data it is
> > given by UEFI?
> 
> It would probably be good to document the fact that it won't work,
> possibly even having a BUG_ON statement in the code for this case.

Why?

You'll only touch that pointer if you enable CONFIG_ACPI, and if you
do you probably want that address. Sounds a bit hostile to throw a BUG
in the face of someone who's (for example) just succeeded to get Linux
running on a Windows RT device.

> > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > index 78a79a6a..1ab24cc 100644
> > > > --- a/arch/arm/Kconfig
> > > > +++ b/arch/arm/Kconfig
> > > > @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
> > > >  	  the same virtual memory range as kmap so all early mappings must
> > > >  	  be unapped before paging_init() is called.
> > > >  
> > > > +config EFI
> > > > +	bool "UEFI runtime service support"
> > > > +	depends on OF && !CPU_BIG_ENDIAN
> > > 
> > > What is the dependency on !CPU_BIG_ENDIAN?
> > 
> > Mainly on code not being implemented to byte-reverse UCS strings.
> 
> Why would you byte-reverse /strings/? They normally just come in
> order of the characters, and UTF-16 strings are already defined
> as being big-endian or marked by the BOM character.

Well, then that bit might just work[tm].

Although no other architectures supported by UEFI support big-endian,
so to be honest, I don't want to have to be the first one to validate
that in order to get the basic support into the kernel.

Some of the data structures might need swizzling though...
Again - if there is demand, this can be dealt with at a later date.

> > > > +struct efi_memory_map memmap;
> > > 
> > > "memmap" is not a good name for a global identifier, particularly because
> > > it's easily confused with the well-known "mem_map" array. This
> > > wants namespace prefix like you other variable, or a "static" tag,
> > > preferably both.
> > 
> > It is defined by include/linux/efi.h.
> 
> This seems to be a mistake: there is no user of this variable outside
> of arch/x86/platform/efi/efi.c and arch/x86/platform/efi/efi_64.c.
> I think it should just be moved into an x86 specific header file,
> or preferably be renamed in the process. There is also efi->memmap,
> which seems to be the same pointer.

Humm, seems I unknowingly removed the only remaining x86-external
reference to this variable when I made efi_lookup_mapped_address a
common function.
Yeah, changing this makes sense.

/
    Leif
