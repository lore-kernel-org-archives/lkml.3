Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaCaN1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:27:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaCaNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:25:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 70/71] USB: pl2303: fix data corruption on termios updates
Date: Mon, 31 Mar 2014 14:23:16 +0100
Message-Id: <1396272197-13394-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/pl2303.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index dd2c8c3..640905e 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -140,6 +140,8 @@ struct pl2303_private {
 	u8 line_control;
 	u8 line_status;
 	enum pl2303_type type;
+
+	u8 line_settings[7];
 };
 
 static int pl2303_vendor_read(__u16 value, __u16 index,
@@ -254,10 +256,6 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	int baud_floor, baud_ceil;
 	int k;
 
-	/* The PL2303 is reported to lose bytes if you change
-	   serial settings even to the same values as before. Thus
-	   we actually need to filter in this specific case */
-
 	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
@@ -395,10 +393,29 @@ static void pl2303_set_termios(struct tty_struct *tty,
 		dev_dbg(&port->dev, "parity = none\n");
 	}
 
-	i = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			    SET_LINE_REQUEST, SET_LINE_REQUEST_TYPE,
-			    0, 0, buf, 7, 100);
-	dev_dbg(&port->dev, "0x21:0x20:0:0  %d\n", i);
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
+		dev_dbg(&port->dev, "0x21:0x20:0:0  %d\n", i);
+
+		if (i == 7)
+			memcpy(priv->line_settings, buf, 7);
+	}
 
 	/* change control lines if we are switching to or from B0 */
 	spin_lock_irqsave(&priv->lock, flags);
-- 
1.9.1

