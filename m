Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbbAUPGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:06:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbbAUPFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:05:39 -0500
Date: Wed, 21 Jan 2015 17:05:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH post-squash 8/9] virtio_pci: add module param to force legacy
 mode
Message-ID: <1421852670-23742-9-git-send-email-mst@redhat.com>
References: <1421852670-23742-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852670-23742-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If set, try legacy interface first, modern one if that fails.  Useful to
work around device/driver bugs, and for compatibility testing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/virtio/virtio_pci_common.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 8ae34a3..e894eb2 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -19,6 +19,14 @@
 
 #include "virtio_pci_common.h"
 
+static bool force_legacy = false;
+
+#if IS_ENABLED(CONFIG_VIRTIO_PCI_LEGACY)
+module_param(force_legacy, bool, 0444);
+MODULE_PARM_DESC(force_legacy,
+		 "Force legacy mode for transitional virtio 1 devices");
+#endif
+
 /* wait for pending irq handlers */
 void vp_synchronize_vectors(struct virtio_device *vdev)
 {
@@ -505,11 +513,20 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto err_request_regions;
 
-	rc = virtio_pci_modern_probe(vp_dev);
-	if (rc == -ENODEV)
+	if (force_legacy) {
 		rc = virtio_pci_legacy_probe(vp_dev);
-	if (rc)
-		goto err_probe;
+		/* Also try modern mode if we can't map BAR0 (no IO space). */
+		if (rc == -ENODEV || rc == -ENOMEM)
+			rc = virtio_pci_modern_probe(vp_dev);
+		if (rc)
+			goto err_probe;
+	} else {
+		rc = virtio_pci_modern_probe(vp_dev);
+		if (rc == -ENODEV)
+			rc = virtio_pci_legacy_probe(vp_dev);
+		if (rc)
+			goto err_probe;
+	}
 
 	pci_set_master(pci_dev);
 
-- 
MST

