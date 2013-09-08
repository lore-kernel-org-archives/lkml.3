Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab3IHDTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55984 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209Ab3IHDSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Amit Shah" <amit.shah@redhat.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.797028608@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [046/121] virtio: console: fix raising SIGIO after port unplug
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

commit 92d3453815fbe74d539c86b60dab39ecdf01bb99 upstream.

SIGIO should be sent when a port gets unplugged.  It should only be sent
to prcesses that have the port opened, and have asked for SIGIO to be
delivered.  We were clearing out guest_connected before calling
send_sigio_to_port(), resulting in a sigio not getting sent to
processes.

Fix by setting guest_connected to false after invoking the sigio
function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/virtio_console.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1284,12 +1284,14 @@ static void unplug_port(struct port *por
 	spin_unlock_irq(&port->portdev->ports_lock);
 
 	if (port->guest_connected) {
+		/* Let the app know the port is going down. */
+		send_sigio_to_port(port);
+
+		/* Do this after sigio is actually sent */
 		port->guest_connected = false;
 		port->host_connected = false;
-		wake_up_interruptible(&port->waitqueue);
 
-		/* Let the app know the port is going down. */
-		send_sigio_to_port(port);
+		wake_up_interruptible(&port->waitqueue);
 	}
 
 	if (is_console_port(port)) {

