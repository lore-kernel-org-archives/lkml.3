Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKIJiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:38:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaKIJix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:38:53 -0500
From: Fam Zheng <famz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] virtio-pci: Reset device on shutdown
Date: Sun,  9 Nov 2014 17:39:05 +0800
Message-Id: <1415525945-7324-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a hanging issue during guest shutdown.

The device is left enabled even though we removed it and disabled msix
during shutdown. If the virtio device happens to get a new event right
at this point, seeing msix is disabled, it may try to notify us with an
IRQ, which is totally unexpected thus will not be handled. In this
case the guest hangs.

Let's reset the device so that it will not generate any interrupts.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1128424
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/virtio/virtio_pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index d34ebfa..cd7be6f 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -743,6 +743,14 @@ out:
 	return err;
 }
 
+static void virtio_pci_shutdown(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+
+	vp_reset(&vp_dev->vdev);
+}
+
+
 static void virtio_pci_remove(struct pci_dev *pci_dev)
 {
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
@@ -794,6 +802,7 @@ static struct pci_driver virtio_pci_driver = {
 	.id_table	= virtio_pci_id_table,
 	.probe		= virtio_pci_probe,
 	.remove		= virtio_pci_remove,
+	.shutdown	= virtio_pci_shutdown,
 #ifdef CONFIG_PM_SLEEP
 	.driver.pm	= &virtio_pci_pm_ops,
 #endif
-- 
1.9.3

