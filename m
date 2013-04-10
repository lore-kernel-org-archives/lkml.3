Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937621Ab3DJXFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:05:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937332Ab3DJWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [ 60/64] vfio-pci: Fix possible integer overflow
Date: Wed, 10 Apr 2013 15:46:57 -0700
Message-Id: <20130410224347.549614022@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 904c680c7bf016a8619a045850937427f8d7368c upstream.

The VFIO_DEVICE_SET_IRQS ioctl takes a start and count parameter, both
of which are unsigned.  We attempt to bounds check these, but fail to
account for the case where start is a very large number, allowing
start + count to wrap back into the valid range.  Bounds check both
start and start + count.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -331,6 +331,7 @@ static long vfio_pci_ioctl(void *device_
 
 		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
 			size_t size;
+			int max = vfio_pci_get_irq_count(vdev, hdr.index);
 
 			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
 				size = sizeof(uint8_t);
@@ -340,7 +341,7 @@ static long vfio_pci_ioctl(void *device_
 				return -EINVAL;
 
 			if (hdr.argsz - minsz < hdr.count * size ||
-			    hdr.count > vfio_pci_get_irq_count(vdev, hdr.index))
+			    hdr.start >= max || hdr.start + hdr.count > max)
 				return -EINVAL;
 
 			data = memdup_user((void __user *)(arg + minsz),


