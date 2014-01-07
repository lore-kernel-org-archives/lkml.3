Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaAGAzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:55:18 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:41853 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbaAGAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:55:15 -0500
Subject: [PATCH v7 00/15] PCI: Allocate 64-bit BARs above 4G when possible
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:55:12 -0700
Message-ID: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically v7 of Yinghai's patch series:
http://lkml.kernel.org/r/1387485843-17403-1-git-send-email-yinghai@kernel.org

The goal is to try to put 64-bit BARs above 4G so we can preserve the
32-bit bus address space for 32-bit BARs.

There are a whole bunch of AGP updates at the beginning because some AGP
devices have 64-bit BARs, but most of the AGP drivers read the aperture
bus address directly from the BAR, and they only handle 32-bit BARs.
Putting BARs above 4G would break those drivers, so we tried to fix them
up first.  Yinghai fixed intel-gtt.c, and I made similar fixes to all
the other AGP drivers I could find.

Some of the AGP updates are related to the fact that most of the drivers
assume the PCI bus address is the same as the CPU physical address.  For
example, they read the bus address from the BAR, then call ioremap() on
it.  This is wrong, because ioremap() expects a CPU physical address,
not a bus address.  In most cases, I think AGP devices are in simple
systems where (bus_address == CPU_physical_address), so these updates
probably don't fix any broken systems.  I'm pretty sure there are more
things like this that should be fixed.

The important PCI changes are the last two:

      PCI: Enforce bus address limits in resource allocation
      PCI: Allocate 64-bit BARs above 4G when possible

The first fixes a long-standing bug: we would never assign space to a
32-bit BAR if the *CPU* address didn't fit in 32 bits.  But the important
thing is the *bus* address, and that may fit in 32 bits even if the CPU
address doesn't.

The second is the one that tries to allocate space above 4G for 64-bit
BARs.  If that fails, we fall back to allocating space anywhere.  It's
possible this will expose other broken drivers that can't deal with
64-bit BARs being above 4G.

I kept Yinghai as the author of the patches that originated with him,
but I reworked them substantially to try to simplify the series, so any
bugs here are most likely my fault.  If my rework made things worse, or
if it makes your life difficult, I will consider doing something
different; just let me know.

---

Bjorn Helgaas (11):
      PCI: Change pci_bus_region addresses to dma_addr_t
      PCI: Add pci_bus_address() to get bus address of a BAR
      agp: Support 64-bit APBASE
      agp: Use pci_resource_start() to get CPU physical address for BAR
      drm/i915: Rename gtt_bus_addr to gtt_phys_addr
      agp/intel: Rename gtt_bus_addr to gtt_phys_addr
      agp/intel: Use pci_bus_address() to get MMADR bus address
      agp/intel: Use pci_bus_address() to get GTTADR bus address
      agp/intel: Use CPU physical address, not bus address, for ioremap()
      agp/ati: Use PCI_COMMAND instead of hard-coded 4
      PCI: Split out bridge window override of minimum allocation address

Yinghai Lu (4):
      PCI: Convert pcibios_resource_to_bus() to take a pci_bus, not a pci_dev
      agp/intel: Support 64-bit GMADR
      PCI: Enforce bus address limits in resource allocation
      PCI: Allocate 64-bit BARs above 4G when possible


 arch/alpha/kernel/pci-sysfs.c       |    4 +
 arch/powerpc/kernel/pci-common.c    |    4 +
 arch/powerpc/kernel/pci_of_scan.c   |    4 +
 arch/sparc/kernel/pci.c             |    6 +-
 arch/x86/include/asm/pci.h          |    1 
 drivers/char/agp/agp.h              |    1 
 drivers/char/agp/ali-agp.c          |    4 +
 drivers/char/agp/amd-k7-agp.c       |   14 ++--
 drivers/char/agp/amd64-agp.c        |    5 -
 drivers/char/agp/ati-agp.c          |   21 +++---
 drivers/char/agp/efficeon-agp.c     |    5 +
 drivers/char/agp/generic.c          |    4 +
 drivers/char/agp/intel-agp.c        |   48 +++++--------
 drivers/char/agp/intel-agp.h        |   10 +--
 drivers/char/agp/intel-gtt.c        |   47 +++++--------
 drivers/char/agp/nvidia-agp.c       |    9 +-
 drivers/char/agp/sis-agp.c          |    5 +
 drivers/char/agp/via-agp.c          |   13 ++--
 drivers/gpu/drm/i915/i915_gem_gtt.c |    6 +-
 drivers/pci/bus.c                   |  128 +++++++++++++++++++++++++++--------
 drivers/pci/host-bridge.c           |   19 ++---
 drivers/pci/probe.c                 |   18 ++---
 drivers/pci/quirks.c                |    2 -
 drivers/pci/rom.c                   |    2 -
 drivers/pci/setup-bus.c             |   16 ++--
 drivers/pci/setup-res.c             |    2 -
 drivers/pcmcia/i82092.c             |    2 -
 drivers/pcmcia/yenta_socket.c       |    6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 +
 drivers/video/arkfb.c               |    2 -
 drivers/video/s3fb.c                |    2 -
 drivers/video/vt8623fb.c            |    2 -
 include/linux/pci.h                 |   20 +++--
 33 files changed, 241 insertions(+), 196 deletions(-)
