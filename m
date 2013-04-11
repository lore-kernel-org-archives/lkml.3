Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777Ab3DKVRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:17:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935519Ab3DKUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:58 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=m3jw-dGWv8QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6KMyPShBnOMA:10 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=Tty9oNO6AAAA:8 a=VwQbUJbxAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202608.948571074@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Asias He <asias@redhat.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>, <stable@kernel.org>
Subject: [ 138/171 ] virtio: console: rename cvq_lock to c_ivq_lock
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0138-virtio-console-rename-cvq_lock-to-c_ivq_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

[ Upstream commit 165b1b8bbc17c9469b053bab78b11b7cbce6d161 ]

The cvq_lock was taken for the c_ivq.  Rename the lock to make that
obvious.

We'll also add a lock around the c_ovq in the next commit, so there's no
ambiguity.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Reviewed-by: Asias He <asias@redhat.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/virtio_console.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..86cfffe 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -131,7 +131,7 @@ struct ports_device {
 	spinlock_t ports_lock;
 
 	/* To protect the vq operations for the control channel */
-	spinlock_t cvq_lock;
+	spinlock_t c_ivq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -1465,23 +1465,23 @@ static void control_work_handler(struct work_struct *work)
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
@@ -1742,10 +1742,11 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
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
@@ -1885,7 +1886,7 @@ static int virtcons_restore(struct virtio_device *vdev)
 		return ret;
 
 	if (use_multiport(portdev))
-		fill_queue(portdev->c_ivq, &portdev->cvq_lock);
+		fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
 
 	list_for_each_entry(port, &portdev->ports, list) {
 		port->in_vq = portdev->in_vqs[port->id];
-- 
1.7.10.4


