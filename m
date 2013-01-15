Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3AOD14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab3AOD1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:27:55 -0500
Subject: [PATCH] vfio-pci: Fix buffer overfill
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 14 Jan 2013 20:27:54 -0700
Message-ID: <20130115032702.6680.60037.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A read from a range hidden from the user (ex. MSI-X vector table)
attempts to fill the user buffer up to the end of the excluded range
instead of up to the requested count.  Fix it.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/vfio/pci/vfio_pci_rdwr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 4362d9e..f72323e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -240,17 +240,17 @@ ssize_t vfio_pci_mem_readwrite(struct vfio_pci_device *vdev, char __user *buf,
 			filled = 1;
 		} else {
 			/* Drop writes, fill reads with FF */
+			filled = min((size_t)(x_end - pos), count);
 			if (!iswrite) {
 				char val = 0xFF;
 				size_t i;
 
-				for (i = 0; i < x_end - pos; i++) {
+				for (i = 0; i < filled; i++) {
 					if (put_user(val, buf + i))
 						goto out;
 				}
 			}
 
-			filled = x_end - pos;
 		}
 
 		count -= filled;

