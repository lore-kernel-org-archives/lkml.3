Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaLFPJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:09:37 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47689 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752367AbaLFPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 35/66] USB: keyspan: fix overrun-error reporting
Date: Sat,  6 Dec 2014 16:07:27 +0100
Message-Id: <7f293483b05b6f3472942b9c733daaf05ec2115e.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 855515a6d3731242d85850a206f2ec084c917338 upstream.

Fix reporting of overrun errors, which are not associated with a
character. Instead insert a null character and report only once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/keyspan.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index d6960aebe246..7053e0a9bb05 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -312,12 +312,13 @@ static void	usa26_indat_callback(struct urb *urb)
 		if ((data[0] & 0x80) == 0) {
 			/* no errors on individual bytes, only
 			   possible overrun err */
-			if (data[0] & RXERROR_OVERRUN)
-				err = TTY_OVERRUN;
-			else
-				err = 0;
+			if (data[0] & RXERROR_OVERRUN) {
+				tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+			}
 			for (i = 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(&port->port, data[i], err);
+				tty_insert_flip_char(&port->port, data[i],
+								TTY_NORMAL);
 		} else {
 			/* some bytes had errors, every byte has status */
 			dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
@@ -791,13 +792,13 @@ static void usa90_indat_callback(struct urb *urb)
 			if ((data[0] & 0x80) == 0) {
 				/* no errors on individual bytes, only
 				   possible overrun err*/
-				if (data[0] & RXERROR_OVERRUN)
-					err = TTY_OVERRUN;
-				else
-					err = 0;
+				if (data[0] & RXERROR_OVERRUN) {
+					tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+				}
 				for (i = 1; i < urb->actual_length ; ++i)
 					tty_insert_flip_char(&port->port,
-							data[i], err);
+							data[i], TTY_NORMAL);
 			}  else {
 			/* some bytes had errors, every byte has status */
 				dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
-- 
2.1.3

