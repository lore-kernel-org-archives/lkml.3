Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaCaAel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:34:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36211 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbaC3XY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Frank =?UTF-8?Q?Sch=C3=A4fer?=" <fschaefer.oss@googlemail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.760482614@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 016/200] USB: pl2303: fix data corruption on termios
 updates
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 623c8263376c0b8a4b0c220232e7313d762cd0cc upstream.

Some PL2303 devices are known to lose bytes if you change serial
settings even to the same values as before. Avoid this by comparing the
encoded settings with the previsouly used ones before configuring the
device.

The common case was fixed by commit bf5e5834bffc6 ("pl2303: Fix mode
switching regression"), but this problem was still possible to trigger,
for instance, by using the TCSETS2-interface to repeatedly request
115201 baud, which gets mapped to 115200 and thus always triggers a
settings update.

Cc: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context; use dbg() instead of dev_dbg()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/pl2303.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -153,6 +153,8 @@ struct pl2303_private {
 	u8 line_control;
 	u8 line_status;
 	enum pl2303_type type;
+
+	u8 line_settings[7];
 };
 
 static int pl2303_vendor_read(__u16 value, __u16 index,
@@ -266,10 +268,6 @@ static void pl2303_set_termios(struct tt
 
 	dbg("%s -  port %d", __func__, port->number);
 
-	/* The PL2303 is reported to lose bytes if you change
-	   serial settings even to the same values as before. Thus
-	   we actually need to filter in this specific case */
-
 	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
@@ -407,10 +405,29 @@ static void pl2303_set_termios(struct tt
 		dbg("%s - parity = none", __func__);
 	}
 
-	i = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    SET_LINE_REQUEST, SET_LINE_REQUEST_TYPE,
-			    0, 0, buf, 7, 100);
-	dbg("0x21:0x20:0:0  %d", i);
+	/*
+	 * Some PL2303 are known to lose bytes if you change serial settings
+	 * even to the same values as before. Thus we actually need to filter
+	 * in this specific case.
+	 *
+	 * Note that the tty_termios_hw_change check above is not sufficient
+	 * as a previously requested baud rate may differ from the one
+	 * actually used (and stored in old_termios).
+	 *
+	 * NOTE: No additional locking needed for line_settings as it is
+	 *       only used in set_termios, which is serialised against itself.
+	 */
+	if (!old_termios || memcmp(buf, priv->line_settings, 7)) {
+		i = usb_control_msg(serial->dev,
+				    usb_sndctrlpipe(serial->dev, 0),
+				    SET_LINE_REQUEST, SET_LINE_REQUEST_TYPE,
+				    0, 0, buf, 7, 100);
+
+		dbg("0x21:0x20:0:0  %d", i);
+
+		if (i == 7)
+			memcpy(priv->line_settings, buf, 7);
+	}
 
 	/* change control lines if we are switching to or from B0 */
 	spin_lock_irqsave(&priv->lock, flags);

