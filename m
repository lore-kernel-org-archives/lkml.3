Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab3EGECY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:02:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab3EGD65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:57 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gWsbt_ToJvsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=r5cpsj1WQUsA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jEp0ucaQiEUA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035847.446699462@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [039/126] vfio-pci: Fix possible integer overflow
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0039-vfio-pci-Fix-possible-integer-overflow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 904c680c7bf016a8619a045850937427f8d7368c ]

The VFIO_DEVICE_SET_IRQS ioctl takes a start and count parameter, both
of which are unsigned.  We attempt to bounds check these, but fail to
account for the case where start is a very large number, allowing
start + count to wrap back into the valid range.  Bounds check both
start and start + count.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/vfio/pci/vfio_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6968b72..cdaaa25 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -315,6 +315,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
 			size_t size;
+			int max = vfio_pci_get_irq_count(vdev, hdr.index);
 
 			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
 				size = sizeof(uint8_t);
@@ -324,7 +325,7 @@ static long vfio_pci_ioctl(void *device_data,
 				return -EINVAL;
 
 			if (hdr.argsz - minsz < hdr.count * size ||
-			    hdr.count > vfio_pci_get_irq_count(vdev, hdr.index))
+			    hdr.start >= max || hdr.start + hdr.count > max)
 				return -EINVAL;
 
 			data = kmalloc(hdr.count * size, GFP_KERNEL);
-- 
1.7.10.4


