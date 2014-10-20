Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaJTN7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:59:04 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45687 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaJTN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:59:00 -0400
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Graf <tgraf@suug.ch>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH] virtio_console: move early VQ enablement
Date: Mon, 20 Oct 2014 15:58:49 +0200
Message-Id: <1413813529-11044-1-git-send-email-cornelia.huck@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20141020133555.GA27111@redhat.com>
References: <20141020133555.GA27111@redhat.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102013-0025-0000-0000-000001F7AC56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f5866db6 (virtio_console: enable VQs early) tried to make
sure that DRIVER_OK was set when virtio_console started using its
virtqueues. Doing this in add_port(), however, means that we try
to set DRIVER_OK again when when a port is dynamically added after
the probe function is done.

Let's move virtio_device_ready() to the probe function just before
trying to use the virtqueues instead. This is fine as nothing can
fail inbetween.

Reported-by: Thomas Graf <tgraf@suug.ch>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/char/virtio_console.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index bfa6400..cf7a561 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1449,8 +1449,6 @@ static int add_port(struct ports_device *portdev, u32 id)
 	spin_lock_init(&port->outvq_lock);
 	init_waitqueue_head(&port->waitqueue);
 
-	virtio_device_ready(portdev->vdev);
-
 	/* Fill the in_vq with buffers so the host can send us data. */
 	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
 	if (!nr_added_bufs) {
@@ -2026,6 +2024,8 @@ static int virtcons_probe(struct virtio_device *vdev)
 	spin_lock_init(&portdev->ports_lock);
 	INIT_LIST_HEAD(&portdev->ports);
 
+	virtio_device_ready(portdev->vdev);
+
 	if (multiport) {
 		unsigned int nr_added_bufs;
 
-- 
1.8.5.5

