Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3JCToX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:44:23 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49531 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3JCToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:44:21 -0400
Date: Thu, 3 Oct 2013 21:44:25 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: Re: [PATCH v2 1/3] Documentation: arm: add UEFI support documentation
Message-ID: <20131003194425.GD1557@rocoto.smurfnet.nu>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
 <1380799481-5470-2-git-send-email-leif.lindholm@linaro.org>
 <20131003171053.GB6999@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003171053.GB6999@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:10:54PM +0100, Mark Rutland wrote:
> > +The implementation depends on receiving the UEFI runtime memory map and a
> > +pointer to the System Table in a Flattened Device Tree - so is only available
> > +with CONFIG_OF.
> > +
> > +It parses the FDT /chosen node for the following parameters:
> > +- 'linux,efi-system-table':
> > +  Physical address of the system table. (required)
> > +  64-bit value since an ARMv7 plattform may support LPAE, and to facilitate
> 
> s/plattform/platform/
 
Indeed, thanks.

> > +  code sharing with arm64. Top 32 bits will be ignored, since UEFI specification
> > +  mandates a 1:1 mapping of all RAM.
> 
> You could use something like #size-cells to describe how big this is
> going to be. Is this Linux-specific -- it looks like something provided
> by EFI rather than the kernel itself.
 
Provided by the bootloader, which may be the kernel's UEFI stub, or
something else (like GRUB). Extracted from UEFI by stub (or other
loader) which executes as a UEFI application.

> > +- 'linux,efi-mmap':
> > +  The EFI memory map as an embedded property. (required)
> > +  An array of type EFI_MEMORY_DESCRIPTOR as described by the UEFI
> > +  specification, current version described in Linux by efi_memory_desc_t.
> > +  The memory map is represented in little-endian, not DT, byte order.
> > +  This map needs to contain at least the regions to be preserved for runtime
> > +  services, but would normally just be the map retreieved by calling UEFI
> > +  GetMemoryMap() immediately before ExitBootServices().
> 
> This is a little scary. If the format is so complicated, should it
> really be embedded? How big is this likely to be?

With current format, and it has yet to be extended beyond v1, it is
40 bytes per entry. Number of entries will vary depending on how many
regions are allocated in UEFI (1 entry per region). I have heard of
some x86 systems with 128 or more regions, but my devboards have more
like 16, and my desktop ~60.

Having it embedded in the DT means the data passed by the bootloader
to the kernel is automatically kept together (for kexec or such).
Not vital, but nice.
 
> Given that this is in a format defined externally, this isn't really
> Linux-specific. Maybe we need an "efi" pseudo-vendor prefix.

A discussion for the other thread.

> > +- 'linux,efi-mmap-desc-size':
> > +  Size of each descriptor in the memory map. (override default)
> 
> What units is this in? How many u32 cells does this take up (one
> presumably)?
 
Value as returned by UEFI GetMemoryMap() boot service call.
Yes, one for ARM.

> > +- 'linux,efi-mmap-desc-ver':
> > +  Memory descriptor format version. (override default)
> 
> Type, format, valid values and their meaning?

Meaning defined by UEFI specification, currently providing the only
valid value as 1. 32-bit uint.

/
    Leif
