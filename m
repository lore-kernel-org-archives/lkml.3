Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbbATQZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:25:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbbATQZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:25:22 -0500
Date: Tue, 20 Jan 2015 18:25:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 04/05] fixup! virtio_pci: add module param to force legacy
 mode
Message-ID: <1421771093-1589-5-git-send-email-mst@redhat.com>
References: <1421771093-1589-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421771093-1589-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio modern: fix up fallback logic with force_legacy

This bails out if legacy driver succeeds - not what we wanted.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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

