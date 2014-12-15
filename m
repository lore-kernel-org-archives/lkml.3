Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaLOT2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:28:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaLOT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 41/96] USB: keyspan: fix overrun-error reporting
Date: Mon, 15 Dec 2014 11:26:01 -0800
Message-Id: <1418671616-25482-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 855515a6d3731242d85850a206f2ec084c917338 upstream.

Fix reporting of overrun errors, which are not associated with a
character. Instead insert a null character and report only once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/keyspan.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 5df5f81..dc3a77c 100644
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
@@ -805,13 +806,13 @@ static void usa90_indat_callback(struct urb *urb)
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
1.9.1

