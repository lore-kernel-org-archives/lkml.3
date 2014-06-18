Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966202AbaFRLgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:36:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36936 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954AbaFRLgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:36:46 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Subject: [PATCH] vfio: Fix endianness handling for emulated BARs
Date: Wed, 18 Jun 2014 21:36:31 +1000
Message-Id: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061811-0260-0000-0000-0000052CFACC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO exposes BARs to user space as a byte stream so userspace can
read it using pread()/pwrite(). Since this is a byte stream, VFIO should
not do byte swapping and simply return values as it gets them from
PCI device.

Instead, the existing code assumes that byte stream in read/write is
little-endian and it fixes endianness for values which it passes to
ioreadXX/iowriteXX helpers. This works for little-endian as PCI is
little endian and le32_to_cpu/... are stubs.

This also works for big endian but rather by an accident: it reads 4 bytes
from the stream (@val is big endian), converts to CPU format (which should
be big endian) as it was little endian (@val becomes actually little
endian) and calls iowrite32() which does not do swapping on big endian
system.

This removes byte swapping and makes use ioread32be/iowrite32be
(and 16bit versions) on big-endian systems. The "be" helpers take
native endian values and do swapping at the moment of writing to a PCI
register using one of "store byte-reversed" instructions.

Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 210db24..f363b5a 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -21,6 +21,18 @@
 
 #include "vfio_pci_private.h"
 
+#ifdef __BIG_ENDIAN__
+#define ioread16_native		ioread16be
+#define ioread32_native		ioread32be
+#define iowrite16_native	iowrite16be
+#define iowrite32_native	iowrite32be
+#else
+#define ioread16_native		ioread16
+#define ioread32_native		ioread32
+#define iowrite16_native	iowrite16
+#define iowrite32_native	iowrite32
+#endif
+
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
  * range which is inaccessible.  The excluded range drops writes and fills
@@ -50,9 +62,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 				if (copy_from_user(&val, buf, 4))
 					return -EFAULT;
 
-				iowrite32(le32_to_cpu(val), io + off);
+				iowrite32_native(val, io + off);
 			} else {
-				val = cpu_to_le32(ioread32(io + off));
+				val = ioread32_native(io + off);
 
 				if (copy_to_user(buf, &val, 4))
 					return -EFAULT;
@@ -66,9 +78,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 				if (copy_from_user(&val, buf, 2))
 					return -EFAULT;
 
-				iowrite16(le16_to_cpu(val), io + off);
+				iowrite16_native(val, io + off);
 			} else {
-				val = cpu_to_le16(ioread16(io + off));
+				val = ioread16_native(io + off);
 
 				if (copy_to_user(buf, &val, 2))
 					return -EFAULT;
-- 
2.0.0

