Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3AXVf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:35:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:39964 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030206Ab3AXVNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [ 11/46] vfio-pci: Fix buffer overfill
Date: Thu, 24 Jan 2013 13:12:49 -0800
Message-Id: <20130124211139.803453844@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit ec1287e511320a2c9a02640b7ac02d5d79f56f08 upstream.

A read from a range hidden from the user (ex. MSI-X vector table)
attempts to fill the user buffer up to the end of the excluded range
instead of up to the requested count.  Fix it.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci_rdwr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -240,17 +240,17 @@ ssize_t vfio_pci_mem_readwrite(struct vf
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


