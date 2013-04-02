Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3DBWqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:46:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab3DBWMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>, Asias He <asias@redhat.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 085/124] virtio: console: rename cvq_lock to c_ivq_lock
Date: Tue,  2 Apr 2013 15:11:07 -0700
Message-Id: <20130402221113.952290831@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 165b1b8bbc17c9469b053bab78b11b7cbce6d161 upstream.

The cvq_lock was taken for the c_ivq.  Rename the lock to make that
obvious.

We'll also add a lock around the c_ovq in the next commit, so there's no
ambiguity.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Reviewed-by: Asias He <asias@redhat.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -152,7 +152,7 @@ struct ports_device {
 	spinlock_t ports_lock;
 
 	/* To protect the vq operations for the control channel */
-	spinlock_t cvq_lock;
+	spinlock_t c_ivq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -1715,23 +1715,23 @@ static void control_work_handler(struct
 	portdev = container_of(work, struct ports_device, control_work);
 	vq = portdev->c_ivq;
 
-	spin_lock(&portdev->cvq_lock);
+	spin_lock(&portdev->c_ivq_lock);
 	while ((buf = virtqueue_get_buf(vq, &len))) {
-		spin_unlock(&portdev->cvq_lock);
+		spin_unlock(&portdev->c_ivq_lock);
 
 		buf->len = len;
 		buf->offset = 0;
 
 		handle_control_message(portdev, buf);
 
-		spin_lock(&portdev->cvq_lock);
+		spin_lock(&portdev->c_ivq_lock);
 		if (add_inbuf(portdev->c_ivq, buf) < 0) {
 			dev_warn(&portdev->vdev->dev,
 				 "Error adding buffer to queue\n");
 			free_buf(buf, false);
 		}
 	}
-	spin_unlock(&portdev->cvq_lock);
+	spin_unlock(&portdev->c_ivq_lock);
 }
 
 static void out_intr(struct virtqueue *vq)
@@ -1996,10 +1996,11 @@ static int virtcons_probe(struct virtio_
 	if (multiport) {
 		unsigned int nr_added_bufs;
 
-		spin_lock_init(&portdev->cvq_lock);
+		spin_lock_init(&portdev->c_ivq_lock);
 		INIT_WORK(&portdev->control_work, &control_work_handler);
 
-		nr_added_bufs = fill_queue(portdev->c_ivq, &portdev->cvq_lock);
+		nr_added_bufs = fill_queue(portdev->c_ivq,
+					   &portdev->c_ivq_lock);
 		if (!nr_added_bufs) {
 			dev_err(&vdev->dev,
 				"Error allocating buffers for control queue\n");
@@ -2150,7 +2151,7 @@ static int virtcons_restore(struct virti
 		return ret;
 
 	if (use_multiport(portdev))
-		fill_queue(portdev->c_ivq, &portdev->cvq_lock);
+		fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
 
 	list_for_each_entry(port, &portdev->ports, list) {
 		port->in_vq = portdev->in_vqs[port->id];


