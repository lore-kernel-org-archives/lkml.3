Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbaKMLTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:19:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57415 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbaKMLTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:19:22 -0500
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [RFC PATCH v3 1/2] drivers: pci: fix pci_mmap_fits() implementation for procfs mmap
Date: Thu, 13 Nov 2014 11:19:15 +0000
Message-Id: <1415877558-8906-2-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
References: <1415877558-8906-1-git-send-email-lorenzo.pieralisi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of pci_mmap_fits() in commit:

b5ff7df3df9efab511244d5a299fce706c71af48
"Check mapped ranges on sysfs resource files"

allowed to check for valid range mappings of PCI resources to user space
when mapping PCI resources through the sysfs filesystem.

The mapping of resources through the sysfs expects the offset passed
by the user through the mmap syscall to be 0, and the pgoff is adjusted
by the kernel to memory map the resource to the CPU physical address
corresponding to the PCI resource in question.

The usage of procfs mapping of PCI resources (/proc/bus/pci files)
is more controversial in that userspace programs mapping PCI resources
are expected to pass in the mmap offset field either a CPU physical address
or a PCI bar value, depending on the architecture.

By the time pci_mmap_fits() was used to check PCI resource ranges for
procfs PCI resources mapping in commit:

9eff02e2042f96fb2aedd02e032eca1c5333d7
"PCI: check mmap range of /proc/bus/pci files too"

the procfs interface for mmapping resources to user space broke, since
pci_mmap_fits() expected the offset passed from user space in the mmap
call to be 0, not the CPU physical address or PCI BAR value of the
resource in question.

Subsequent attempts at fixing the pci_mmap_fits() implementation failed
to fix the issue (or fixed the issue in some architectures but not for
all of them, ARM and SPARC procfs interface PCI resources mapping stayed
broken throughout) in particular commits:

8c05cd08a7504b855c265263e84af61aabafa329
"PCI: fix offset check for sysfs mmapped files"

and

3b519e4ea618b6943a82931630872907f9ac2c2b
"PCI: fix size checks for mmap() on /proc/bus/pci files"

fixed procfs PCI resources mapping checks in pci_mmap_fits for some
architectures, but not for architectures like SPARC that expects
the offset value passed from user space through the mmap syscall
(when mapping through procfs) to represent the PCI BAR value of the
resource to be mapped.

The reason behind the breakage is the following. The addresses stored
in PCI device resources for memory spaces correspond to CPU physical
addresses, which do not necessarily map 1:1 to PCI bus addresses as
programmed in PCI devices configuration spaces.

This implies that the sanity checks carried out in pci_mmap_fits() to
ensure that the user executes an mmap of a "real" pci resource are
erroneous when executed through procfs. Some platforms (ie SPARC)
expect the offset value to be passed in (procfs mapping) to be the
PCI BAR configuration value as read from the PCI device configuration
space, not the fixed-up CPU physical address that is present in PCI
device resources.

The required pgoff (offset in mmap syscall) value passed from userspace
is supposed to represent the resource value exported through
/proc/bus/pci/devices when the resource is mmapped though procfs (and 0
when the mapping is carried out through sysfs resource files), which
corresponds to the PCI resource filtered through the pci_resource_to_user()
API.

This patch converts the PCI resource to the expected "user visible"
value through pci_resource_to_user() before carrying out sanity checks
in pci_mmap_fits() so that the check is carried out on the resource
values as expected from the userspace mmap API.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 drivers/pci/pci-sysfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 2c6643f..e4634e3 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -963,17 +963,20 @@ void pci_remove_legacy_files(struct pci_bus *b)
 int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
 		  enum pci_mmap_api mmap_api)
 {
-	unsigned long nr, start, size, pci_start;
+	unsigned long nr, start, size, pci_offset;
+	resource_size_t pci_start, pci_end;
 
 	if (pci_resource_len(pdev, resno) == 0)
 		return 0;
 	nr = vma_pages(vma);
 	start = vma->vm_pgoff;
+	pci_resource_to_user(pdev, resno, &pdev->resource[resno],
+			     &pci_start, &pci_end);
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
-			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
-	if (start >= pci_start && start < pci_start + size &&
-			start + nr <= pci_start + size)
+	pci_offset = (mmap_api == PCI_MMAP_PROCFS) ?
+			pci_start >> PAGE_SHIFT : 0;
+	if (start >= pci_offset && start < pci_offset + size &&
+			start + nr <= pci_offset + size)
 		return 1;
 	return 0;
 }
-- 
2.1.2

