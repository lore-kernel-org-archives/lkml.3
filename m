Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaIJTpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:45:15 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47264 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753342AbaIJTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:45:11 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 13/14] tty: Hold termios_rwsem for tcflow(TCIxxx)
Date: Wed, 10 Sep 2014 15:06:35 -0400
Message-Id: <1410375996-4693-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While transmitting a START/STOP char for tcflow(TCION/TCIOFF), prevent
a termios change. Otherwise, a garbage in-band flow control char
may be sent, if the termios change overlaps the transmission setup.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ioctl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 14d9002..32cee97 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1164,17 +1164,21 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 			spin_unlock_irq(&tty->flow_lock);
 			break;
 		case TCIOFF:
+			down_read(&tty->termios_rwsem);
 			if (STOP_CHAR(tty) != __DISABLED_CHAR)
-				return tty_send_xchar(tty, STOP_CHAR(tty));
+				retval = tty_send_xchar(tty, STOP_CHAR(tty));
+			up_read(&tty->termios_rwsem);
 			break;
 		case TCION:
+			down_read(&tty->termios_rwsem);
 			if (START_CHAR(tty) != __DISABLED_CHAR)
-				return tty_send_xchar(tty, START_CHAR(tty));
+				retval = tty_send_xchar(tty, START_CHAR(tty));
+			up_read(&tty->termios_rwsem);
 			break;
 		default:
 			return -EINVAL;
 		}
-		return 0;
+		return retval;
 	case TCFLSH:
 		retval = tty_check_change(tty);
 		if (retval)
-- 
2.1.0

