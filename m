Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3ITUPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3ITUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 77/93] ARM: PCI: versatile: Fix PCI I/O
Date: Fri, 20 Sep 2013 13:09:12 -0700
Message-Id: <1379707768-1804-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Maydell <peter.maydell@linaro.org>

commit 829f9fedee30cde2ec15e88d57ec11074db791e2 upstream.

The versatile PCI controller code was confused between the
PCI I/O window (at 0x43000000) and the first PCI memory
window (at 0x44000000). Pass the correct base address to
pci_remap_io() so that PCI I/O accesses work.

Since the first PCI memory window isn't used at all (it's
an odd size), rename the associated variables and labels
so that it's clear that it isn't related to the I/O window.

This has been tested and confirmed to fix PCI I/O accesses
both on physical PB926+PCI backplane hardware and on QEMU.

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-versatile/include/mach/platform.h |  2 ++
 arch/arm/mach-versatile/pci.c                   | 16 ++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-versatile/include/mach/platform.h b/arch/arm/mach-versatile/include/mach/platform.h
index ec08740..6f938cc 100644
--- a/arch/arm/mach-versatile/include/mach/platform.h
+++ b/arch/arm/mach-versatile/include/mach/platform.h
@@ -231,12 +231,14 @@
 /* PCI space */
 #define VERSATILE_PCI_BASE             0x41000000	/* PCI Interface */
 #define VERSATILE_PCI_CFG_BASE	       0x42000000
+#define VERSATILE_PCI_IO_BASE          0x43000000
 #define VERSATILE_PCI_MEM_BASE0        0x44000000
 #define VERSATILE_PCI_MEM_BASE1        0x50000000
 #define VERSATILE_PCI_MEM_BASE2        0x60000000
 /* Sizes of above maps */
 #define VERSATILE_PCI_BASE_SIZE	       0x01000000
 #define VERSATILE_PCI_CFG_BASE_SIZE    0x02000000
+#define VERSATILE_PCI_IO_BASE_SIZE     0x01000000
 #define VERSATILE_PCI_MEM_BASE0_SIZE   0x0c000000	/* 32Mb */
 #define VERSATILE_PCI_MEM_BASE1_SIZE   0x10000000	/* 256Mb */
 #define VERSATILE_PCI_MEM_BASE2_SIZE   0x10000000	/* 256Mb */
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 234740d..1e48878 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -170,8 +170,8 @@ static struct pci_ops pci_versatile_ops = {
 	.write	= versatile_write_config,
 };
 
-static struct resource io_mem = {
-	.name	= "PCI I/O space",
+static struct resource unused_mem = {
+	.name	= "PCI unused",
 	.start	= VERSATILE_PCI_MEM_BASE0,
 	.end	= VERSATILE_PCI_MEM_BASE0+VERSATILE_PCI_MEM_BASE0_SIZE-1,
 	.flags	= IORESOURCE_MEM,
@@ -195,9 +195,9 @@ static int __init pci_versatile_setup_resources(struct pci_sys_data *sys)
 {
 	int ret = 0;
 
-	ret = request_resource(&iomem_resource, &io_mem);
+	ret = request_resource(&iomem_resource, &unused_mem);
 	if (ret) {
-		printk(KERN_ERR "PCI: unable to allocate I/O "
+		printk(KERN_ERR "PCI: unable to allocate unused "
 		       "memory region (%d)\n", ret);
 		goto out;
 	}
@@ -205,7 +205,7 @@ static int __init pci_versatile_setup_resources(struct pci_sys_data *sys)
 	if (ret) {
 		printk(KERN_ERR "PCI: unable to allocate non-prefetchable "
 		       "memory region (%d)\n", ret);
-		goto release_io_mem;
+		goto release_unused_mem;
 	}
 	ret = request_resource(&iomem_resource, &pre_mem);
 	if (ret) {
@@ -225,8 +225,8 @@ static int __init pci_versatile_setup_resources(struct pci_sys_data *sys)
 
  release_non_mem:
 	release_resource(&non_mem);
- release_io_mem:
-	release_resource(&io_mem);
+ release_unused_mem:
+	release_resource(&unused_mem);
  out:
 	return ret;
 }
@@ -246,7 +246,7 @@ int __init pci_versatile_setup(int nr, struct pci_sys_data *sys)
 		goto out;
 	}
 
-	ret = pci_ioremap_io(0, VERSATILE_PCI_MEM_BASE0);
+	ret = pci_ioremap_io(0, VERSATILE_PCI_IO_BASE);
 	if (ret)
 		goto out;
 
-- 
1.8.1.2

