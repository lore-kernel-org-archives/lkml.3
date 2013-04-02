Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3DBWqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:46:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368Ab3DBWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        FuXiangChun <xfu@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>, Asias He <asias@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 086/124] virtio: console: add locking around c_ovq operations
Date: Tue,  2 Apr 2013 15:11:08 -0700
Message-Id: <20130402221114.074200612@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -153,6 +153,7 @@ struct ports_device {
 
 	/* To protect the vq operations for the control channel */
 	spinlock_t c_ivq_lock;
+	spinlock_t c_ovq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -575,11 +576,14 @@ static ssize_t __send_control_msg(struct
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
+
+	spin_lock(&portdev->c_ovq_lock);
 	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) == 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
 	}
+	spin_unlock(&portdev->c_ovq_lock);
 	return 0;
 }
 
@@ -1997,6 +2001,7 @@ static int virtcons_probe(struct virtio_
 		unsigned int nr_added_bufs;
 
 		spin_lock_init(&portdev->c_ivq_lock);
+		spin_lock_init(&portdev->c_ovq_lock);
 		INIT_WORK(&portdev->control_work, &control_work_handler);
 
 		nr_added_bufs = fill_queue(portdev->c_ivq,


