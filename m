Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaBSKOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:14:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaBSKN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:59 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org
Subject: [PATCH] virtio: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:29 +0100
Message-Id: <1392804931-30671-9-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org
Cc: virtualization@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org
---
 drivers/virtio/virtio_pci.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index a416f9b..dea042c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -333,11 +333,9 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	for (i = 0; i < nvectors; ++i)
 		vp_dev->msix_entries[i].entry = i;
 
-	/* pci_enable_msix returns positive if we can't get this many. */
-	err = pci_enable_msix(vp_dev->pci_dev, vp_dev->msix_entries, nvectors);
-	if (err > 0)
-		err = -ENOSPC;
-	if (err)
+	err = pci_enable_msix_range(vp_dev->pci_dev,
+				    vp_dev->msix_entries, nvectors, nvectors);
+	if (err < 0)
 		goto error;
 	vp_dev->msix_enabled = 1;
 
-- 
1.7.7.6

