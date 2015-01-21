Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbbAUPBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:01:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbbAUPAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:00:52 -0500
Date: Wed, 21 Jan 2015 17:00:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH pre-squash 13/14] fixup! virtio_pci: add module param to
 force legacy mode
Message-ID: <1421852375-22604-14-git-send-email-mst@redhat.com>
References: <1421852375-22604-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852375-22604-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio modern: fix up fallback logic with force_legacy

This bails out if legacy driver succeeds - not what we wanted.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/virtio/virtio_pci_common.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 0f87b99..e894eb2 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -516,18 +516,14 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 	if (force_legacy) {
 		rc = virtio_pci_legacy_probe(vp_dev);
 		/* Also try modern mode if we can't map BAR0 (no IO space). */
-		if (rc != -ENODEV && rc != -ENOMEM)
-			return rc;
-
-		rc = virtio_pci_modern_probe(vp_dev);
+		if (rc == -ENODEV || rc == -ENOMEM)
+			rc = virtio_pci_modern_probe(vp_dev);
 		if (rc)
 			goto err_probe;
 	} else {
 		rc = virtio_pci_modern_probe(vp_dev);
-		if (rc != -ENODEV)
-			return rc;
-
-		rc = virtio_pci_legacy_probe(vp_dev);
+		if (rc == -ENODEV)
+			rc = virtio_pci_legacy_probe(vp_dev);
 		if (rc)
 			goto err_probe;
 	}
-- 
MST

