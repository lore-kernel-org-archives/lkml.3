Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3IHDUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55987 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087Ab3IHDSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Rusty Russell" <rusty@rustcorp.com.au>,
        "Mateusz Guzik" <mguzik@redhat.com>,
        "Amit Shah" <amit.shah@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.221090758@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [043/121] virtio: console: fix race with port unplug and open/close
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/virtio_console.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -257,9 +257,12 @@ static struct port *find_port_by_devt_in
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
@@ -793,14 +796,10 @@ static int port_fops_open(struct inode *
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

