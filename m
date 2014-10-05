Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaJEQEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaJEQEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:04:07 -0400
Date: Sun, 5 Oct 2014 19:07:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 14/16] virtio_console: enable VQs early
Message-ID: <1412525038-15871-15-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, virtio console violated this
rule by adding inbufs, which causes the VQ to be used directly within
probe.

To fix, call virtio_early_enable_vqs before using VQs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/virtio_console.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index b585b47..8605009 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1449,6 +1449,8 @@ static int add_port(struct ports_device *portdev, u32 id)
 	spin_lock_init(&port->outvq_lock);
 	init_waitqueue_head(&port->waitqueue);
 
+	virtio_early_enable_vqs(portdev->vdev);
+
 	/* Fill the in_vq with buffers so the host can send us data. */
 	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
 	if (!nr_added_bufs) {
-- 
MST

