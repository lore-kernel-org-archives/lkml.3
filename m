Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935540AbaBDWgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:36:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521AbaBDVC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Asias He <asias.hejun@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.10 099/104] virtio-scsi: Fix hotcpu_notifier use-after-free with virtscsi_freeze
Date: Tue,  4 Feb 2014 13:02:42 -0800
Message-Id: <20140204210225.525962387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/virtio_scsi.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -957,6 +957,10 @@ static void virtscsi_remove(struct virti
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
@@ -965,8 +969,17 @@ static int virtscsi_restore(struct virti
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
 


