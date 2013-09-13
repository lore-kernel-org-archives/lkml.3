Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3IMPlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:41:44 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:37393 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3IMPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:41:40 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 1/3] USB : serial : call handle_dcd_change in ftdi driver.
Date: Fri, 13 Sep 2013 17:35:11 +0200
Message-Id: <1379086513-2434-2-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 13 Sep 2013 17:41:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/usb/serial/ftdi_sio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c45f9c0..df66495 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1966,8 +1966,14 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 			port->icount.dsr++;
 		if (diff_status & FTDI_RS0_RI)
 			port->icount.rng++;
-		if (diff_status & FTDI_RS0_RLSD)
+		if (diff_status & FTDI_RS0_RLSD) {
 			port->icount.dcd++;
+			struct tty_struct *tty = tty_port_tty_get(&port->port);
+			if (tty)
+				usb_serial_handle_dcd_change(port, tty,
+						status & FTDI_RS0_RLSD);
+			tty_kref_put(tty);
+		}
 
 		wake_up_interruptible(&port->port.delta_msr_wait);
 		priv->prev_status = status;
-- 
1.7.12.1

