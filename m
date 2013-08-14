Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab3HNKqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:46:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3HNKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 52/75] virtio: console: fix race with port unplug and open/close
Date: Wed, 14 Aug 2013 11:36:41 +0100
Message-Id: <1376476624-10011-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 057b82be3ca3d066478e43b162fc082930a746c9 upstream.

There's a window between find_port_by_devt() returning a port and us
taking a kref on the port, where the port could get unplugged.  Fix it
by taking the reference in find_port_by_devt() itself.

Problem reported and analyzed by Mateusz Guzik.

Reported-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/virtio_console.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 957f293..002357f 100644
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
@@ -792,14 +795,10 @@ static int port_fops_open(struct inode *inode, struct file *filp)
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
1.8.3.2

