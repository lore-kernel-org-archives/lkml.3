Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3IHDUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55983 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab3IHDSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Amit Shah" <amit.shah@redhat.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.402660700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [047/121] virtio: console: return -ENODEV on all read operations
 after unplug
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

commit 96f97a83910cdb9d89d127c5ee523f8fc040a804 upstream.

If a port gets unplugged while a user is blocked on read(), -ENODEV is
returned.  However, subsequent read()s returned 0, indicating there's no
host-side connection (but not indicating the device went away).

This also happened when a port was unplugged and the user didn't have
any blocking operation pending.  If the user didn't monitor the SIGIO
signal, they won't have a chance to find out if the port went away.

Fix by returning -ENODEV on all read()s after the port gets unplugged.
write() already behaves this way.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/virtio_console.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -637,6 +637,10 @@ static ssize_t port_fops_read(struct fil
 
 	port = filp->private_data;
 
+	/* Port is hot-unplugged. */
+	if (!port->guest_connected)
+		return -ENODEV;
+
 	if (!port_has_data(port)) {
 		/*
 		 * If nothing's connected on the host just return 0 in
@@ -653,7 +657,7 @@ static ssize_t port_fops_read(struct fil
 		if (ret < 0)
 			return ret;
 	}
-	/* Port got hot-unplugged. */
+	/* Port got hot-unplugged while we were waiting above. */
 	if (!port->guest_connected)
 		return -ENODEV;
 	/*

