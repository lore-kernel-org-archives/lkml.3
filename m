Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936075Ab3DKVRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:17:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935513Ab3DKUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:58 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xGhuVBcC6csA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YH3CfvmEkfEA:10 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=Tty9oNO6AAAA:8 a=VwQbUJbxAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202609.110357787@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: FuXiangChun <xfu@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>, Asias He <asias@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, <stable@kernel.org>
Subject: [ 139/171 ] virtio: console: add locking around c_ovq operations
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0139-virtio-console-add-locking-around-c_ovq-operations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

[ Upstream commit 9ba5c80b1aea8648a3efe5f22dc1f7cacdfbeeb8 ]

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
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/virtio_console.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 86cfffe..d2f7eb0 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -132,6 +132,7 @@ struct ports_device {
 
 	/* To protect the vq operations for the control channel */
 	spinlock_t c_ivq_lock;
+	spinlock_t c_ovq_lock;
 
 	/* The current config space is stored here */
 	struct virtio_console_config config;
@@ -457,11 +458,14 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
+
+	spin_lock(&portdev->c_ovq_lock);
 	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) >= 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
 	}
+	spin_unlock(&portdev->c_ovq_lock);
 	return 0;
 }
 
@@ -1743,6 +1747,7 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 		unsigned int nr_added_bufs;
 
 		spin_lock_init(&portdev->c_ivq_lock);
+		spin_lock_init(&portdev->c_ovq_lock);
 		INIT_WORK(&portdev->control_work, &control_work_handler);
 
 		nr_added_bufs = fill_queue(portdev->c_ivq,
-- 
1.7.10.4


