Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3J2QNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab3J2QNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:13:20 -0400
Subject: [PATCH 0/4] KVM-VFIO pseudo device for VFIO coherency
To: kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 29 Oct 2013 10:13:16 -0600
Message-ID: <20131029160019.22578.16409.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series allows QEMU to create a VFIO device in KVM for registering
VFIO groups.  The initial user of this interface is to toggle whether
KVM emulates coherency instructions like WBINVD.  For this particular
use case I've toyed with the idea of disabling NoSnoop at the device,
but we already have an example where this fails as video cards often
have backdoors to PCI config space and may re-enable NoSnoop support.
Regardless of whether the driver should be doing this or not, we don't
really want to rely on well behaved drivers for things as important as
coherency.

In this first step we assume that noncoherent DMA is possible any time
a VFIO group is present.  I have follow-on patches which fix a bug in
intel-iommu which that prevents us from always enabling SNP support in
the IOMMU page tables and prevents us from tracking the hardware
capabilities of the IOMMU domain for coherency.  Once that is fixed I
can fill in the TODO which would allow us to only mark VFIO as
noncoherent when necessary.

POWER support for VFIO would also like to make use of the VFIO pseudo
device interface, but has some remaining work to architect an
interface into it.

I'd very much like to see this for v3.13.  Thanks,

Alex

---

Alex Williamson (4):
      kvm: Destroy & free KVM devices on release
      kvm: Add VFIO device
      kvm/x86: Convert iommu_flags to iommu_noncoherent
      kvm: Create non-coherent DMA registeration


 Documentation/virtual/kvm/devices/vfio.txt |   22 ++
 arch/ia64/include/asm/kvm_host.h           |    2 
 arch/powerpc/kvm/book3s_xics.c             |    1 
 arch/x86/include/asm/kvm_host.h            |    4 
 arch/x86/kvm/Kconfig                       |    1 
 arch/x86/kvm/Makefile                      |    2 
 arch/x86/kvm/vmx.c                         |    3 
 arch/x86/kvm/x86.c                         |   21 ++
 include/linux/kvm_host.h                   |   23 ++
 include/uapi/linux/kvm.h                   |    4 
 virt/kvm/Kconfig                           |    3 
 virt/kvm/iommu.c                           |   22 +-
 virt/kvm/kvm_main.c                        |   10 +
 virt/kvm/vfio.c                            |  263 ++++++++++++++++++++++++++++
 14 files changed, 362 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
 create mode 100644 virt/kvm/vfio.c
