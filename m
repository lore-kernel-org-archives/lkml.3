Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaBJTy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:54:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaBJTrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 024/124] USB: pl2303: fix data corruption on termios updates
Date: Mon, 10 Feb 2014 11:39:24 -0800
Message-Id: <1392061264-28124-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/pl2303.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 037fd68..90569d2 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -141,6 +141,8 @@ struct pl2303_private {
 	spinlock_t lock;
 	u8 line_control;
 	u8 line_status;
+
+	u8 line_settings[7];
 };
 
 static int pl2303_vendor_read(__u16 value, __u16 index,
@@ -420,10 +422,29 @@ static void pl2303_set_termios(struct tty_struct *tty,
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
1.8.3.2

