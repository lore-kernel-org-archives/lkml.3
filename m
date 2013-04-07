Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962Ab3DGXhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:37:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934833Ab3DGXbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:31:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wanlong Gao" <gaowanlong@cn.fujitsu.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "Amit Shah" <amit.shah@redhat.com>, "Asias He" <asias@redhat.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.868844806@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [41/74] virtio: console: rename cvq_lock to c_ivq_lock
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Drop change to virtcons_restore()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/virtio_console.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -131,7 +131,7 @@ struct ports_device {
 	spinlock_t ports_lock;
 
 	/* To protect the vq operations for the control channel */
-	spinlock_t cvq_lock;
+	spinlock_t c_ivq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -1466,23 +1466,23 @@ static void control_work_handler(struct
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
 			free_buf(buf);
 		}
 	}
-	spin_unlock(&portdev->cvq_lock);
+	spin_unlock(&portdev->c_ivq_lock);
 }
 
 static void out_intr(struct virtqueue *vq)
@@ -1721,10 +1721,11 @@ static int __devinit virtcons_probe(stru
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

