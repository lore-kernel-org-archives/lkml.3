Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab3HMGlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:41:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab3HMGeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 06/12] virtio: console: return -ENODEV on all read operations after unplug
Date: Mon, 12 Aug 2013 23:35:41 -0700
Message-Id: <20130813063520.771021769@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063520.285638946@linuxfoundation.org>
References: <20130813063520.285638946@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -625,6 +625,10 @@ static ssize_t port_fops_read(struct fil
 
 	port = filp->private_data;
 
+	/* Port is hot-unplugged. */
+	if (!port->guest_connected)
+		return -ENODEV;
+
 	if (!port_has_data(port)) {
 		/*
 		 * If nothing's connected on the host just return 0 in
@@ -641,7 +645,7 @@ static ssize_t port_fops_read(struct fil
 		if (ret < 0)
 			return ret;
 	}
-	/* Port got hot-unplugged. */
+	/* Port got hot-unplugged while we were waiting above. */
 	if (!port->guest_connected)
 		return -ENODEV;
 	/*


