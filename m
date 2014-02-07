Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaBGMaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:30:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaBGLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Asias He <asias.hejun@gmail.com>, Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 139/233] virtio-scsi: Fix hotcpu_notifier use-after-free with virtscsi_freeze
Date: Fri,  7 Feb 2014 11:45:58 +0000
Message-Id: <1391773652-25214-140-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias.hejun@gmail.com>

commit f466f75385369a181409e46da272db3de6f5c5cb upstream.

vqs are freed in virtscsi_freeze but the hotcpu_notifier is not
unregistered. We will have a use-after-free usage when the notifier
callback is called after virtscsi_freeze.

Fixes: 285e71ea6f3583a85e27cb2b9a7d8c35d4c0d558
("virtio-scsi: reset virtqueue affinity when doing cpu hotplug")

Signed-off-by: Asias He <asias.hejun@gmail.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/virtio_scsi.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 74b88ef..b26f1a5 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -957,6 +957,10 @@ static void virtscsi_remove(struct virtio_device *vdev)
 #ifdef CONFIG_PM
 static int virtscsi_freeze(struct virtio_device *vdev)
 {
+	struct Scsi_Host *sh = virtio_scsi_host(vdev);
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
+	unregister_hotcpu_notifier(&vscsi->nb);
 	virtscsi_remove_vqs(vdev);
 	return 0;
 }
@@ -965,8 +969,17 @@ static int virtscsi_restore(struct virtio_device *vdev)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
+	int err;
+
+	err = virtscsi_init(vdev, vscsi);
+	if (err)
+		return err;
+
+	err = register_hotcpu_notifier(&vscsi->nb);
+	if (err)
+		vdev->config->del_vqs(vdev);
 
-	return virtscsi_init(vdev, vscsi);
+	return err;
 }
 #endif
 
-- 
1.8.3.2

