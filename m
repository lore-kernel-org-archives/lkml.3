Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbaJXQ22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:28:28 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48378 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaJXQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:28:26 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits() implementation for procfs mmap
Date: Fri, 24 Oct 2014 17:28:05 +0100
Message-Id: <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addresses stored in PCI device resources for memory spaces
correspond to CPU physical addresses, which do not necessarily
map 1:1 to PCI bus addresses as programmed in PCI devices configuration
spaces.

Therefore, the changes applied by commits:

8c05cd08a7504b855c26526
3b519e4ea618b6943a82931

imply that the sanity checks carried out in pci_mmap_fits() to
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
index 92b6d9a..777d8bc 100644
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

