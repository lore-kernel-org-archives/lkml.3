Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3IKE7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3IKE5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:10 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kxAOY3v-hBEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=eWU4qceznocA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042921.257344440@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mateusz Guzik <mguzik@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [174/251] virtio: console: fix race with port unplug and open/close
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0174-virtio-console-fix-race-with-port-unplug-and-open-cl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

[ Upstream commit 057b82be3ca3d066478e43b162fc082930a746c9 ]

There's a window between find_port_by_devt() returning a port and us
taking a kref on the port, where the port could get unplugged.  Fix it
by taking the reference in find_port_by_devt() itself.

Problem reported and analyzed by Mateusz Guzik.

CC: <stable@vger.kernel.org>
Reported-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/virtio_console.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index d2f7eb0..abca6eb 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -257,9 +257,12 @@ static struct port *find_port_by_devt_in_portdev(struct ports_device *portdev,
 	unsigned long flags;
 
 	spin_lock_irqsave(&portdev->ports_lock, flags);
-	list_for_each_entry(port, &portdev->ports, list)
-		if (port->cdev->dev == dev)
+	list_for_each_entry(port, &portdev->ports, list) {
+		if (port->cdev->dev == dev) {
+			kref_get(&port->kref);
 			goto out;
+		}
+	}
 	port = NULL;
 out:
 	spin_unlock_irqrestore(&portdev->ports_lock, flags);
@@ -793,14 +796,10 @@ static int port_fops_open(struct inode *inode, struct file *filp)
 	struct port *port;
 	int ret;
 
+	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
 	filp->private_data = port;
 
-	/* Prevent against a port getting hot-unplugged at the same time */
-	spin_lock_irq(&port->portdev->ports_lock);
-	kref_get(&port->kref);
-	spin_unlock_irq(&port->portdev->ports_lock);
-
 	/*
 	 * Don't allow opening of console port devices -- that's done
 	 * via /dev/hvc
-- 
1.7.10.4


