Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3HQAO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:14:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3HPWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 088/133] virtio: console: fix race with port unplug and open/close
Date: Fri, 16 Aug 2013 15:33:50 -0700
Message-Id: <1376692475-28413-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/virtio_console.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 3e338a7..ff015e7 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -278,9 +278,12 @@ static struct port *find_port_by_devt_in_portdev(struct ports_device *portdev,
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
@@ -1042,14 +1045,10 @@ static int port_fops_open(struct inode *inode, struct file *filp)
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
1.8.1.2

