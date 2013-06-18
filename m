Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3FRQSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3FRQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:27 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 45/48] USB: f81232: fix device initialisation at open
Date: Tue, 18 Jun 2013 09:18:11 -0700
Message-Id: <20130618161732.483104596@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 21886725d58e92188159731c7c1aac803dd6b9dc upstream.

Do not use uninitialised termios data to determine when to configure the
device at open.

This also prevents stack data from leaking to userspace.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/f81232.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -165,11 +165,12 @@ static void f81232_set_termios(struct tt
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
@@ -187,12 +188,11 @@ static int f81232_tiocmset(struct tty_st
 
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


