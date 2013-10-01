Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3JAUPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:15:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab3JAUPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:15:03 -0400
Subject: [PATCH 0/4] KVM noncoherent DMA registration and VFIO pseudo device
To: gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 01 Oct 2013 14:15:01 -0600
Message-ID: <20131001200757.31715.22994.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow-up to my previous RFC series on this topic.  The goal
is to unify how KVM manages guests in the presence of non-coherent DMA
trafic and provide a way for QEMU to register VFIO groups to enable
that support.  Since this changes the way KVM handles things like
WBINVD, we use the VFIO external user interface so that KVM can verify
if a user has physical hardware access.  For now we assume VFIO domains
are always non-coherent, which is true if the IOMMU driver honors the
IOMMU_CACHE mapping attribute.  Once this is in and we figure out what
exactly VFIO should do regarding support for coherent IOMMU domains,
we can create a new interface for KVM to call.  This is noted with a
TODO in this patch.  I've reworked the device interface to use
attributes and pass an address for the file descriptor since the RFC.
Alexey, I expect that a new attribute to associate an LIOBN to a group
and arch callbacks to make use of that information is all that you'll
need to add for POWER.  Thanks,

Alex

---

Alex Williamson (4):
      kvm: Destroy & free KVM devices on release
      kvm/x86: Convert iommu_flags to iommu_noncoherent
      kvm: Create non-coherent DMA registeration
      kvm: Add VFIO device for handling IOMMU cache coherency


 Documentation/virtual/kvm/devices/vfio.txt |   22 ++
 arch/ia64/include/asm/kvm_host.h           |    2 
 arch/powerpc/kvm/book3s_xics.c             |    1 
 arch/x86/include/asm/kvm_host.h            |    4 
 arch/x86/kvm/Makefile                      |    2 
 arch/x86/kvm/vmx.c                         |    3 
 arch/x86/kvm/x86.c                         |   21 ++
 include/linux/kvm_host.h                   |   23 ++
 include/uapi/linux/kvm.h                   |    4 
 virt/kvm/iommu.c                           |   22 +-
 virt/kvm/kvm_main.c                        |    8 +
 virt/kvm/vfio.c                            |  262 ++++++++++++++++++++++++++++
 12 files changed, 355 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
 create mode 100644 virt/kvm/vfio.c
