Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3F1S4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3F1S4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 042/105] USB: f81232: fix device initialisation at open
Date: Fri, 28 Jun 2013 11:51:04 -0700
Message-Id: <1372445527-24414-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 21886725d58e92188159731c7c1aac803dd6b9dc upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

This also prevents stack data from leaking to userspace.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/f81232.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 1e64343..96fa734 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -170,11 +170,12 @@ static void f81232_set_termios(struct tty_struct *tty,
 	/* FIXME - Stubbed out for now */
 
 	/* Don't change anything if nothing has changed */
-	if (!tty_termios_hw_change(&tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
 	/* Do the real work here... */
-	tty_termios_copy_hw(&tty->termios, old_termios);
+	if (old_termios)
+		tty_termios_copy_hw(&tty->termios, old_termios);
 }
 
 static int f81232_tiocmget(struct tty_struct *tty)
@@ -192,12 +193,11 @@ static int f81232_tiocmset(struct tty_struct *tty,
 
 static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	int result;
 
 	/* Setup termios */
 	if (tty)
-		f81232_set_termios(tty, port, &tmp_termios);
+		f81232_set_termios(tty, port, NULL);
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {
-- 
1.8.1.2

