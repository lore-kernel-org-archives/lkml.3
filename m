Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaKUWIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:08:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaKUWIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:08:40 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/3] PCI/x86: Interface for testing multivector MSI support
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Date: Fri, 21 Nov 2014 15:08:27 -0700
Message-ID: <20141121213752.31095.30735.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to make vfio-pci capable of manipulating the device exposed
to the user such that if the host can only support a single MSI
vector then we hide the fact that the device itself may actually be
able to support more.  When we virtualize PCI config space and
interrupt setup there's no PCI protocol for the device failing to
allocate the number of vectors that it said were available.  If the
userspace driver is a guest operating system, it certainly doesn't
expect this to fail.  I don't think we can ever guarantee that a
multi-vector request will succeed, but we can certainly guarantee
that it will fail if the platform doesn't support it.

An example device is the Atheros AR93xxx running in a Windows 7 VM.
Both the device and the guest OS support multiple MSI vectors.  With
interrupt remapping, such that the host supports multivector, the
device works well in the guest.  With interrupt remapping disabled,
the device is far less reliable because of the mismatch in MSI
programming vs driver configuration and often fails.  If vfio-pci
can test whether multiple vectors are supported, then we can make it
work reliably in both cases by adjusting the exposed MSI capability,
like in this patch that would follow this series:

https://github.com/awilliam/linux-vfio/commit/9ace67515680

With this series, only x86 w/ interrupt remapping will advertise
support for multiple MSI vectors.  In surveying the code, I couldn't
find any other archs that allowed it, but I'll take corrections if
that's untrue.  Thanks,

Alex

---

Alex Williamson (3):
      PCI: Extend and export pci_msi_supported() for multivector MSI
      PCI/x86: Add arch_supports_multivector_msi() hook
      PCI/MSI: Initial hook for archs to declare multivector MSI support


 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/x86_init.c      |    6 ++++++
 drivers/iommu/irq_remapping.c   |    6 ++++++
 drivers/pci/msi.c               |   20 +++++++++++++++++---
 include/linux/msi.h             |    1 +
 include/linux/pci.h             |    3 +++
 6 files changed, 34 insertions(+), 3 deletions(-)
