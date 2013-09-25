Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3IYAUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab3IYAT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [ 022/117] ARM: PCI: versatile: Fix PCI I/O
Date: Tue, 24 Sep 2013 17:18:08 -0700
Message-Id: <20130925001743.264297508@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-versatile/include/mach/platform.h |    2 ++
 arch/arm/mach-versatile/pci.c                   |   16 ++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

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
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -170,8 +170,8 @@ static struct pci_ops pci_versatile_ops
 	.write	= versatile_write_config,
 };
 
-static struct resource io_mem = {
-	.name	= "PCI I/O space",
+static struct resource unused_mem = {
+	.name	= "PCI unused",
 	.start	= VERSATILE_PCI_MEM_BASE0,
 	.end	= VERSATILE_PCI_MEM_BASE0+VERSATILE_PCI_MEM_BASE0_SIZE-1,
 	.flags	= IORESOURCE_MEM,
@@ -195,9 +195,9 @@ static int __init pci_versatile_setup_re
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
@@ -205,7 +205,7 @@ static int __init pci_versatile_setup_re
 	if (ret) {
 		printk(KERN_ERR "PCI: unable to allocate non-prefetchable "
 		       "memory region (%d)\n", ret);
-		goto release_io_mem;
+		goto release_unused_mem;
 	}
 	ret = request_resource(&iomem_resource, &pre_mem);
 	if (ret) {
@@ -225,8 +225,8 @@ static int __init pci_versatile_setup_re
 
  release_non_mem:
 	release_resource(&non_mem);
- release_io_mem:
-	release_resource(&io_mem);
+ release_unused_mem:
+	release_resource(&unused_mem);
  out:
 	return ret;
 }
@@ -246,7 +246,7 @@ int __init pci_versatile_setup(int nr, s
 		goto out;
 	}
 
-	ret = pci_ioremap_io(0, VERSATILE_PCI_MEM_BASE0);
+	ret = pci_ioremap_io(0, VERSATILE_PCI_IO_BASE);
 	if (ret)
 		goto out;
 


