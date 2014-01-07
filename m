Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaAGKpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:45:00 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55824 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAGKo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:44:58 -0500
Date: Tue, 7 Jan 2014 11:46:11 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/15] PCI: Allocate 64-bit BARs above 4G when possible
Message-ID: <20140107104611.GI4770@phenom.ffwll.local>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci@vger.kernel.org, David Airlie <airlied@linux.ie>,
	Yinghai Lu <yinghai@kernel.org>, Guo Chao <yan@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 05:55:12PM -0700, Bjorn Helgaas wrote:
> This is basically v7 of Yinghai's patch series:
> http://lkml.kernel.org/r/1387485843-17403-1-git-send-email-yinghai@kernel.org
> 
> The goal is to try to put 64-bit BARs above 4G so we can preserve the
> 32-bit bus address space for 32-bit BARs.
> 
> There are a whole bunch of AGP updates at the beginning because some AGP
> devices have 64-bit BARs, but most of the AGP drivers read the aperture
> bus address directly from the BAR, and they only handle 32-bit BARs.
> Putting BARs above 4G would break those drivers, so we tried to fix them
> up first.  Yinghai fixed intel-gtt.c, and I made similar fixes to all
> the other AGP drivers I could find.
> 
> Some of the AGP updates are related to the fact that most of the drivers
> assume the PCI bus address is the same as the CPU physical address.  For
> example, they read the bus address from the BAR, then call ioremap() on
> it.  This is wrong, because ioremap() expects a CPU physical address,
> not a bus address.  In most cases, I think AGP devices are in simple
> systems where (bus_address == CPU_physical_address), so these updates
> probably don't fix any broken systems.  I'm pretty sure there are more
> things like this that should be fixed.
> 
> The important PCI changes are the last two:
> 
>       PCI: Enforce bus address limits in resource allocation
>       PCI: Allocate 64-bit BARs above 4G when possible
> 
> The first fixes a long-standing bug: we would never assign space to a
> 32-bit BAR if the *CPU* address didn't fit in 32 bits.  But the important
> thing is the *bus* address, and that may fit in 32 bits even if the CPU
> address doesn't.
> 
> The second is the one that tries to allocate space above 4G for 64-bit
> BARs.  If that fails, we fall back to allocating space anywhere.  It's
> possible this will expose other broken drivers that can't deal with
> 64-bit BARs being above 4G.
> 
> I kept Yinghai as the author of the patches that originated with him,
> but I reworked them substantially to try to simplify the series, so any
> bugs here are most likely my fault.  If my rework made things worse, or
> if it makes your life difficult, I will consider doing something
> different; just let me know.

Patches 4-11 are Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

A few notes aside:

- intel-gtt.c isn't actually an agp bridge but just exposes the iommu
  in the integrated intel gfx blocks to userspace through the only
  interface available back in the dark ages over userspace gfx drivers ...

- All agp bridges on ppc don't support cpu access to remapped memory
  ranges (iirc due to coherncy issues), so that explains why the cpu vs
  bus address mess isn't an issue there.

- If you wonder how this worked on alpha grep for __alpha__ in
  drivers/gpu/drm and cry. For added hilarity compare with the fun that's
  going on in the alpha specificy mmap handling (everyone else is using
  ioremap) in alpha_core_agp_vm_fault set up by agp_mmap.

  Probably easier to burn down alpha than fix this mess ... But for
  extremely bored souls I guess the simplest fix would be to switch
  agp_kern_info.aper_base to a cpu physical address, rip out all the alpha
  special casing and hope for the best. Very likely there's no one left to
  test this anyway ;-)

Cheers, Daniel

> 
> ---
> 
> Bjorn Helgaas (11):
>       PCI: Change pci_bus_region addresses to dma_addr_t
>       PCI: Add pci_bus_address() to get bus address of a BAR
>       agp: Support 64-bit APBASE
>       agp: Use pci_resource_start() to get CPU physical address for BAR
>       drm/i915: Rename gtt_bus_addr to gtt_phys_addr
>       agp/intel: Rename gtt_bus_addr to gtt_phys_addr
>       agp/intel: Use pci_bus_address() to get MMADR bus address
>       agp/intel: Use pci_bus_address() to get GTTADR bus address
>       agp/intel: Use CPU physical address, not bus address, for ioremap()
>       agp/ati: Use PCI_COMMAND instead of hard-coded 4
>       PCI: Split out bridge window override of minimum allocation address
> 
> Yinghai Lu (4):
>       PCI: Convert pcibios_resource_to_bus() to take a pci_bus, not a pci_dev
>       agp/intel: Support 64-bit GMADR
>       PCI: Enforce bus address limits in resource allocation
>       PCI: Allocate 64-bit BARs above 4G when possible
> 
> 
>  arch/alpha/kernel/pci-sysfs.c       |    4 +
>  arch/powerpc/kernel/pci-common.c    |    4 +
>  arch/powerpc/kernel/pci_of_scan.c   |    4 +
>  arch/sparc/kernel/pci.c             |    6 +-
>  arch/x86/include/asm/pci.h          |    1 
>  drivers/char/agp/agp.h              |    1 
>  drivers/char/agp/ali-agp.c          |    4 +
>  drivers/char/agp/amd-k7-agp.c       |   14 ++--
>  drivers/char/agp/amd64-agp.c        |    5 -
>  drivers/char/agp/ati-agp.c          |   21 +++---
>  drivers/char/agp/efficeon-agp.c     |    5 +
>  drivers/char/agp/generic.c          |    4 +
>  drivers/char/agp/intel-agp.c        |   48 +++++--------
>  drivers/char/agp/intel-agp.h        |   10 +--
>  drivers/char/agp/intel-gtt.c        |   47 +++++--------
>  drivers/char/agp/nvidia-agp.c       |    9 +-
>  drivers/char/agp/sis-agp.c          |    5 +
>  drivers/char/agp/via-agp.c          |   13 ++--
>  drivers/gpu/drm/i915/i915_gem_gtt.c |    6 +-
>  drivers/pci/bus.c                   |  128 +++++++++++++++++++++++++++--------
>  drivers/pci/host-bridge.c           |   19 ++---
>  drivers/pci/probe.c                 |   18 ++---
>  drivers/pci/quirks.c                |    2 -
>  drivers/pci/rom.c                   |    2 -
>  drivers/pci/setup-bus.c             |   16 ++--
>  drivers/pci/setup-res.c             |    2 -
>  drivers/pcmcia/i82092.c             |    2 -
>  drivers/pcmcia/yenta_socket.c       |    6 +-
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    5 +
>  drivers/video/arkfb.c               |    2 -
>  drivers/video/s3fb.c                |    2 -
>  drivers/video/vt8623fb.c            |    2 -
>  include/linux/pci.h                 |   20 +++--
>  33 files changed, 241 insertions(+), 196 deletions(-)

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
