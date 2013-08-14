Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab3HNKqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:46:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab3HNKiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 55/75] virtio: console: fix raising SIGIO after port unplug
Date: Wed, 14 Aug 2013 11:36:44 +0100
Message-Id: <1376476624-10011-56-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/virtio_console.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index e1ab8ad..3bd6d4c 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1289,12 +1289,14 @@ static void unplug_port(struct port *port)
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
-- 
1.8.3.2

