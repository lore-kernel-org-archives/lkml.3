Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaLHNGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaLHNGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:05 -0500
Date: Mon, 8 Dec 2014 15:05:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dahi@linux.vnet.ibm.com, cornelia.huck@de.ibm.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 1/6] virtio: add API to detect legacy devices
Message-ID: <1418042769-25539-2-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418042769-25539-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

transports need to be able to detect legacy-only
devices (ATM balloon only) to use legacy path
to drive them.

Add a core API to do just that.
The implementation just blacklists balloon:
not too pretty, but let's not over-engineer.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/linux/virtio.h  | 2 ++
 drivers/virtio/virtio.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 2bbf626..d666bcb 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -108,6 +108,8 @@ struct virtio_device {
 	void *priv;
 };
 
+bool virtio_device_is_legacy_only(struct virtio_device_id id);
+
 static inline struct virtio_device *dev_to_virtio(struct device *_dev)
 {
 	return container_of(_dev, struct virtio_device, dev);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index fa6b75d..224f854 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -3,6 +3,7 @@
 #include <linux/virtio_config.h>
 #include <linux/module.h>
 #include <linux/idr.h>
+#include <uapi/linux/virtio_ids.h>
 
 /* Unique numbering for virtio devices. */
 static DEFINE_IDA(virtio_index_ida);
@@ -267,6 +268,12 @@ static struct bus_type virtio_bus = {
 	.remove = virtio_dev_remove,
 };
 
+bool virtio_device_is_legacy_only(struct virtio_device_id id)
+{
+	return id.device == VIRTIO_ID_BALLOON;
+}
+EXPORT_SYMBOL_GPL(virtio_device_is_legacy_only);
+
 int register_virtio_driver(struct virtio_driver *driver)
 {
 	/* Catch this early. */
-- 
MST

