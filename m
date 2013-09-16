Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3IPP6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:58:22 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52310 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3IPP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:58:19 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 16 Sep 2013 08:57:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, jerry.hoemann@hp.com,
        Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Randy Wright <rwright@hp.com>, Linn Crosetto <linn.crosetto@hp.com>,
        terry.lee@hp.com, samer.el-haj-mahmoud@hp.com, randy.pawell@hp.com,
        chrisp@hp.com, linda.knippers@hp.com, dong.wei@hp.com,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Chao Zhang <chao.b.zhang@intel.com>, Yao Jiewen <jiewen.yao@intel.com>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130916155751.GA3636@leaf>
References: <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
 <20130913203812.GA312@anatevka.fc.hp.com>
 <20130916105920.GB2697@console-pimps.org>
 <5236F096.8040702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236F096.8040702@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 01:50:46PM +0200, Laszlo Ersek wrote:
> On 09/16/13 12:59, Matt Fleming wrote:
> > On Fri, 13 Sep, at 02:38:12PM, jerry.hoemann@hp.com wrote:
> >> Matt,
> >>
> >> We have hit an issue on our new platform in development related to the
> >> call of efi_reserve_boot_services() from setup_arch().
> >>
> >> The reservation can interfere with allocation of the crash kernel.
> >  
> > Jerry, thanks for bringing this up.
> > 
> >> In pre 3.9(?) kernels,  the crash kernel is required to be allocated from
> >> physically contiguous memory below 896 MB.
> >>
> >> Our new platforms are large in both the amount of memory and the amount
> >> of IO. This requires large crash kernels for kdump to work.  This is even
> >> after the work done for makedumpfile v 1.5 to allow it to work with a
> >> smaller foot print.
> >>
> >>
> >> One of the problems is that drivers will allocate memory as boot code and/or
> >> data in the region < 896 that effectively fragments this memory.
> >> With the reservation, we can't reuse the memory when needed for the
> >> crash kernels.   If we remove the reservation and allow the kernel
> >> to reuse the memory,  we the reservation of the crash kernel succeeds.
> >>
> >> This is definitely a problem for distros that are pre 3.9.  Probably less
> >> so for top of tree, but i haven't been focused there.
> >>
> >> So we are definitely interested in finding a mechanism to not
> >> do this reservation on platforms that don't have the issues described
> >> earlier in this thread.
> > 
> > OK, in an ideal world we'd move the crash kernel reservation after
> > efi_free_boot_services(), because at that point the boot regions are
> > available again. But it seems that we reserve the boot regions really
> > early during startup and release them relatively late. The reason is
> > that the Boot Graphics Resource Table (BGRT) data, if present, is
> > located in the Boot Services Data regions but we can't extract the
> > address of the region from the ACPI tables until we've setup the ACPI
> > subsystem, which happens quite late.
> 
> Why is BGRT allocated as Boot Services Data?
> 
> In file
> "MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.c":
> 
> InstallBootGraphicsResourceTable()
>   BgrtAllocateBsDataMemoryBelow4G()
>     gBS->AllocatePages(... EfiBootServicesData ...)
> 
> From Table 25. Memory Type Usage before ExitBootServices():
> 
>   EfiBootServicesData  -- The data portions of a loaded Boot Services
>                           Driver, and the default data allocation type
>                           used by a Boot Services Driver to allocate
>                           pool memory.
> 
>   EfiACPIReclaimMemory -- Memory that holds the ACPI tables.
> 
> From Table 26. Memory Type Usage after ExitBootServices():
> 
>   EfiBootServicesData -- Memory available for general use.
> 
>   EfiACPIReclaimMemory -- This memory is to be preserved by the loader
>                           and OS until ACPI is enabled. Once ACPI is
>                           enabled, the memory in this range is available
>                           for general use.
> 
> I thought that anything referenced by a pointer in any ACPI table was
> EfiACPIReclaimMemory or stricter. Specifically, the RSDT or XSDT points
> to BGRT, so BGRT is EfiACPIReclaimMemory.  BGRT points to the image data
> (with its Image Address field), hence the image data should be
> EfiACPIReclaimMemory too.
> 
> Otherwise, the pointer (BGRT.ImageAddress) can outlive the pointed-to
> storage (the image data).
> 
> The image data sounds to me like textbook example for
> EfiACPIReclaimMemory. This way the kernel could free Boot Services Data
> early, perform the crash kernel reservation right after, and safely
> access BGRT whenever the ACPI subsystem is brought up later.
> 
> 
> The edk2 commit that flipped the memory type underneath the image data
> from EfiReservedMemoryType to EfiBootServicesData is:
> 
>     https://github.com/tianocore/edk2/commit/4c58575e
> 
> I think this commit is wrong. It's fine for OSPM to release the image
> data at some point, but not right after ExitBootServices(), because
> referencing pointers in ACPI tables survive strictly longer.
> 
> ... Actually, the commit does follow the ACPI spec 5.0:
> 
> 5.2.22.4 Image Address
> 
>     The Image Address contains the location in memory where an
>     in-memory copy of the boot image can be found. The image should be
>     stored in EfiBootServicesData, allowing the system to reclaim
>     the memory when the image is no longer needed.
> 
> The ACPI spec 5.0 should recommend EfiACPIReclaimMemory here IMO. (I
> take the current wording ("should be stored") as a recommendation only.)

I agree that UEFI *should* store the BGRT in EfiACPIReclaimMemory, but
in practice the UEFI firmware I've seen with a BGRT does follow that
recommendation and store it in EfiBootServicesData.  So, even if the
recommendation in the spec changed, the kernel would still have to
accomodate both possibilities.

- Josh Triplett
