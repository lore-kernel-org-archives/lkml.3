Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3JUJNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:13:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39627 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888Ab3JUIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.258048662@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 080/149] serial: pch_uart: fix tty-kref leak in dma-rx
 path
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 19b85cfb190eb9980eaf416bff96aef4159a430e upstream.

Fix tty_kref leak when tty_buffer_request room fails in dma-rx path.

Note that the tty ref isn't really needed anymore, but as the leak has
always been there, fixing it before removing should makes it easier to
backport the fix.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/pch_uart.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -552,11 +552,12 @@ static int dma_push_rx(struct eg20t_port
 		dev_warn(port->dev, "Rx overrun: dropping %u bytes\n",
 			 size - room);
 	if (!room)
-		return room;
+		goto out;
 
 	tty_insert_flip_string(tty, sg_virt(&priv->sg_rx), size);
 
 	port->icount.rx += room;
+out:
 	tty_kref_put(tty);
 
 	return room;

