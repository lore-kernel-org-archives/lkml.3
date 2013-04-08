Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233Ab3DHJzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:55:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935964Ab3DHJwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 094/102] virtio: console: add locking around c_ovq operations
Date: Mon,  8 Apr 2013 10:50:49 +0100
Message-Id: <1365414657-29191-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 9ba5c80b1aea8648a3efe5f22dc1f7cacdfbeeb8 upstream.

When multiple ovq operations are being performed (lots of open/close
operations on virtio_console fds), the __send_control_msg() function can
get confused without locking.

A simple recipe to cause badness is:
* create a QEMU VM with two virtio-serial ports
* in the guest, do
  while true;do echo abc >/dev/vport0p1;done
  while true;do echo edf >/dev/vport0p2;done

In one run, this caused a panic in __send_control_msg().  In another, I
got

   virtio_console virtio0: control-o:id 0 is not a head!

This also results repeated messages similar to these on the host:

  qemu-kvm: virtio-serial-bus: Unexpected port id 478762112 for device virtio-serial-bus.0
  qemu-kvm: virtio-serial-bus: Unexpected port id 478762368 for device virtio-serial-bus.0

Reported-by: FuXiangChun <xfu@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Asias He <asias@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/virtio_console.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 4c76834..957f293 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -132,6 +132,7 @@ struct ports_device {
 
 	/* To protect the vq operations for the control channel */
 	spinlock_t c_ivq_lock;
+	spinlock_t c_ovq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -457,11 +458,13 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
+	spin_lock(&portdev->c_ovq_lock);
 	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) >= 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
 	}
+	spin_unlock(&portdev->c_ovq_lock);
 	return 0;
 }
 
@@ -1743,6 +1746,7 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 		unsigned int nr_added_bufs;
 
 		spin_lock_init(&portdev->c_ivq_lock);
+		spin_lock_init(&portdev->c_ovq_lock);
 		INIT_WORK(&portdev->control_work, &control_work_handler);
 
 		nr_added_bufs = fill_queue(portdev->c_ivq,
-- 
1.8.1.2

