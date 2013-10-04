Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3JDMy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:54:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47972 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab3JDMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:54:26 -0400
Date: Fri, 4 Oct 2013 13:54:21 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 1/3] Documentation: arm: add UEFI support
 documentation
Message-ID: <20131004125420.GD6999@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003171800.GC1557@rocoto.smurfnet.nu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leif,

On Thu, Oct 03, 2013 at 06:18:02PM +0100, Leif Lindholm wrote:
> On Thu, Oct 03, 2013 at 11:11:18AM -0500, Rob Herring wrote:
> > Adding devicetree list since you are defining bindings...
> > 
> > > +with CONFIG_OF.
> > > +
> > > +It parses the FDT /chosen node for the following parameters:
> > 
> > DT bindings should be documented in Documentation/devicetree/bindings.
> > 
> > I also wonder if this would be more appropriately placed in a /firmware
> > node.
> 
> This is information passed to the kernel by the bootloader - not
> system descriptiont - so I don't quite see why it needs different
> treatment from initrd and bootargs.

That's somewhat debatable -- the description isn't a configuration
option (as bootargs and initrd are) so much as a description of the
firmware.

> 
> Feedback on v1 was:
> https://lkml.org/lkml/2013/6/26/378
> and
> https://lkml.org/lkml/2013/6/27/420
> 
> I don't really mind either way, but the current layout is now used
> across 3 sets of kernel patches, so we need to reach some sort of
> consensus. Interested parties so far: me, you, Grant, Arnd, Mark.
> 
> > > +- 'linux,efi-mmap':
> > > +  The EFI memory map as an embedded property. (required)
> > > +  An array of type EFI_MEMORY_DESCRIPTOR as described by the UEFI
> > > +  specification, current version described in Linux by efi_memory_desc_t.
> > 
> > Is that too complex to describe here?
>  
> No, just felt a bit redundant, and also not architecture-specific.

I'd point to the EFI spec and leave it at that. The particular encoding
is defined by EFI and is beyond the scope of this document (endianness
issues aside).

If this were a device with a single window of registers we'd just
describe the whole window and not the format of each individual register
or bit within them. I see no reason to do differently here.

As the efi-mmap is built by EFI, and is in a format defined by EFI, I'd
also drop the "linux" vendor prefix -- Linux has had no hand in defining
this property. It may make sense to have "efi" as a vendor prefix, but
perhaps others won't like that?

> 
> > > +  The memory map is represented in little-endian, not DT, byte order.
> > > +  This map needs to contain at least the regions to be preserved for runtime
> > > +  services, but would normally just be the map retreieved by calling UEFI
> > > +  GetMemoryMap() immediately before ExitBootServices().
> > > +- 'linux,efi-mmap-desc-size':
> > > +  Size of each descriptor in the memory map. (override default)
> > 
> > 32-bit value?
> 
> Value as returned by the above mentioned GetMemoryMap().
> Defined in UEFI specification (and <linux/efi.h>) as 32-bit (native
> int). But yes, I can be explicit.

Please do. Something like:

- efi-mmap-desc-size:
  A single (u32) cell describing the size of each descriptor in the
  memory map, if not the EFI default size of $EFI_MMAP_DESC_SIZE. See
  $EFI_DOCUMENTATION for more information.
  
> 
> > > +- 'linux,efi-mmap-desc-ver':
> > > +  Memory descriptor format version. (override default)
> > 
> > String? Number?
>  
> Value as returned by the above mentioned GetMemoryMap().
> Defined in the UEFI specification as 32-bit (uint32), not
> architecture specific. And I can add that too.

How about something like:

- efi-mmap-desc-version:
  A single (u32) cell describing the memory descriptor format version, 
  if not 1 (the current EFI version). See $EFI_DOCUMENTATION for more
  information.

> 
> > Are these all generated by UEFI at runtime or could they be statically
> > set in a platform's DTB?
> 
> Generated at runtime.
> This is not the platform memory map, this is the UEFI memory map,
> which tells us which regions we need to preserve for runtime
> services, ACPI and such.
> 
> > How would other OS's get this information? Is this really linux specific?
> 
> The way it is passed through DT is. Other operating systems might keep
> boot services running for longer, and make calls into UEFI later, so
> not needing to cache the data. Since boot services means the timer
> interrupt is active, the ARM Linux boot protocol effectively prohibits
> this.

I suspect other OSs that may use DT are likely to have similar
requirements, or could at least cope with this mechanism.

I think before we can take any code in this area we need to define the
boot protocol (i.e. do we use DT to describe EFI & ACPI, what gets
described where) for EFI and/or ACPI. We have enough of a mess as it is,
and we need to carefully control anything we add to the fray. We should
discuss this at the upcoming LinuxCon, ELC, and Linaro Connect.

Thanks,
Mark.

>
> Many of these questions are about generic UEFI mechanisms.
> If they need to be documented outside the UEFI specification,
> Documentation/arm is not the right place for it.
> 
> If you want, I could give a basic Documentation/uefi.txt a shot.
> 
> /
>     Leif
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
