Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaJ2Nnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:43:55 -0400
Received: from jim.sh ([75.150.123.25]:50192 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746AbaJ2Nnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:43:53 -0400
Date: Wed, 29 Oct 2014 09:43:41 -0400
From: Jim Paris <jim@jtan.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] cdc-acm: ensure that termios get set when the port is
 activated
Message-ID: <20141029134305.GA8149@psychosis.jim.sh>
References: <20141028232649.GA1064@psychosis.jim.sh>
 <54503D44.4080908@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54503D44.4080908@hurleysoftware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver wasn't properly configuring the hardware for the current
termios settings under all conditions.  Ensure that termios are
written to the device when the port is activated.

Signed-off-by: Jim Paris <jim@jtan.com>
---

Peter Hurley wrote:
> Yeah, you're right that the cdc-acm driver isn't properly configuring
> the hardware for the current termios settings under all conditions.
> 
> But you don't want to do it for every tty open, only for opens
> requiring port initialization, which is what the tty_port->activate()
> method is for (ie., acm_port_activate()).

I moved it to acm_port_activate(), which works fine.  Thanks!
acm_tty_set_termios is just moved in this patch, not changed.

Jim

---
 drivers/usb/class/cdc-acm.c | 104 ++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e934e19f49f5..24077deb737a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -504,6 +504,57 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
 	return tty_port_open(&acm->port, tty, filp);
 }
 
+static void acm_tty_set_termios(struct tty_struct *tty,
+						struct ktermios *termios_old)
+{
+	struct acm *acm = tty->driver_data;
+	struct ktermios *termios = &tty->termios;
+	struct usb_cdc_line_coding newline;
+	int newctrl = acm->ctrlout;
+
+	newline.dwDTERate = cpu_to_le32(tty_get_baud_rate(tty));
+	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
+	newline.bParityType = termios->c_cflag & PARENB ?
+				(termios->c_cflag & PARODD ? 1 : 2) +
+				(termios->c_cflag & CMSPAR ? 2 : 0) : 0;
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		newline.bDataBits = 5;
+		break;
+	case CS6:
+		newline.bDataBits = 6;
+		break;
+	case CS7:
+		newline.bDataBits = 7;
+		break;
+	case CS8:
+	default:
+		newline.bDataBits = 8;
+		break;
+	}
+	/* FIXME: Needs to clear unsupported bits in the termios */
+	acm->clocal = ((termios->c_cflag & CLOCAL) != 0);
+
+	if (!newline.dwDTERate) {
+		newline.dwDTERate = acm->line.dwDTERate;
+		newctrl &= ~ACM_CTRL_DTR;
+	} else
+		newctrl |=  ACM_CTRL_DTR;
+
+	if (newctrl != acm->ctrlout)
+		acm_set_control(acm, acm->ctrlout = newctrl);
+
+	if (memcmp(&acm->line, &newline, sizeof newline)) {
+		memcpy(&acm->line, &newline, sizeof newline);
+		dev_dbg(&acm->control->dev, "%s - set line: %d %d %d %d\n",
+			__func__,
+			le32_to_cpu(newline.dwDTERate),
+			newline.bCharFormat, newline.bParityType,
+			newline.bDataBits);
+		acm_set_line(acm, &acm->line);
+	}
+}
+
 static void acm_port_dtr_rts(struct tty_port *port, int raise)
 {
 	struct acm *acm = container_of(port, struct acm, port);
@@ -554,6 +605,8 @@ static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
 		goto error_submit_urb;
 	}
 
+	acm_tty_set_termios(tty, NULL);
+
 	/*
 	 * Unthrottle device in case the TTY was closed while throttled.
 	 */
@@ -949,57 +1002,6 @@ static int acm_tty_ioctl(struct tty_struct *tty,
 	return rv;
 }
 
-static void acm_tty_set_termios(struct tty_struct *tty,
-						struct ktermios *termios_old)
-{
-	struct acm *acm = tty->driver_data;
-	struct ktermios *termios = &tty->termios;
-	struct usb_cdc_line_coding newline;
-	int newctrl = acm->ctrlout;
-
-	newline.dwDTERate = cpu_to_le32(tty_get_baud_rate(tty));
-	newline.bCharFormat = termios->c_cflag & CSTOPB ? 2 : 0;
-	newline.bParityType = termios->c_cflag & PARENB ?
-				(termios->c_cflag & PARODD ? 1 : 2) +
-				(termios->c_cflag & CMSPAR ? 2 : 0) : 0;
-	switch (termios->c_cflag & CSIZE) {
-	case CS5:
-		newline.bDataBits = 5;
-		break;
-	case CS6:
-		newline.bDataBits = 6;
-		break;
-	case CS7:
-		newline.bDataBits = 7;
-		break;
-	case CS8:
-	default:
-		newline.bDataBits = 8;
-		break;
-	}
-	/* FIXME: Needs to clear unsupported bits in the termios */
-	acm->clocal = ((termios->c_cflag & CLOCAL) != 0);
-
-	if (!newline.dwDTERate) {
-		newline.dwDTERate = acm->line.dwDTERate;
-		newctrl &= ~ACM_CTRL_DTR;
-	} else
-		newctrl |=  ACM_CTRL_DTR;
-
-	if (newctrl != acm->ctrlout)
-		acm_set_control(acm, acm->ctrlout = newctrl);
-
-	if (memcmp(&acm->line, &newline, sizeof newline)) {
-		memcpy(&acm->line, &newline, sizeof newline);
-		dev_dbg(&acm->control->dev, "%s - set line: %d %d %d %d\n",
-			__func__,
-			le32_to_cpu(newline.dwDTERate),
-			newline.bCharFormat, newline.bParityType,
-			newline.bDataBits);
-		acm_set_line(acm, &acm->line);
-	}
-}
-
 static const struct tty_port_operations acm_port_ops = {
 	.dtr_rts = acm_port_dtr_rts,
 	.shutdown = acm_port_shutdown,
-- 
2.1.0
