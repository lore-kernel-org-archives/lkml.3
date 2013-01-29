Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3A2IzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:55:25 -0500
Received: from smtp4.nedap.com ([213.160.213.85]:51993 "EHLO smtp.nedap.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754487Ab3A2IzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:55:23 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 03:55:22 EST
From: Dirkjan Bussink <dirkjan.bussink@nedap.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 29 Jan 2013 09:49:52 +0100
Subject: [PATCH] Prevent deadlock in n_gsm driver
Thread-Topic: [PATCH] Prevent deadlock in n_gsm driver
Thread-Index: Ac39/ZnD9ivWE5P2SNiS0Vnvbv6bgA==
Message-ID: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
Accept-Language: en-US, nl-NL
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, nl-NL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes a deadlock when the multiplexer is closed while there
are still client side ports open.

When the multiplexer is closed and there are active tty's it tries to
close them with tty_vhangup. This has a problem though, because
tty_vhangup needs the tty_lock. This patch changes it to unlock the
tty_lock before attempting the hangup and relocks afterwards. The
additional call to tty_port_tty_set is needed because otherwise the
port stays active because of the reference counter.

This change also exposed another problem that other code paths don't
expect that the multiplexer could have been closed. This patch also adds
checks for these cases in the gsmtty_ class of function that could be
called.

The documentation explicitly states that "first close all virtual ports
before closing the physical port" but we've found this to not always
reality in our field situations. The GPRS / UTMS modem sometimes crashes
and needs a power cycle in that case which means cleanly shutting down
everything is not always possible. This change makes it much more robust
for our situation where at least the system is recoverable with this patch
and doesn't hang in a deadlock situation inside the kernel.

The patch is against the long term support kernel (3.4.27) and should
apply cleanly to more recent branches. Tested with a Telit GE864-QUADV2
and Telit HE910 modem.

Signed-off-by: Dirkjan Bussink <dirkjan.bussink@nedap.com>
---
 drivers/tty/n_gsm.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 90dff82..d9bde03 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1692,6 +1692,8 @@ static inline void dlci_put(struct gsm_dlci *dlci)
 	kref_put(&dlci->ref, gsm_dlci_free);
 }
 
+static void gsm_destroy_network(struct gsm_dlci *dlci);
+
 /**
  *	gsm_dlci_release		-	release DLCI
  *	@dlci: DLCI to destroy
@@ -1705,9 +1707,19 @@ static void gsm_dlci_release(struct gsm_dlci *dlci)
 {
 	struct tty_struct *tty = tty_port_tty_get(&dlci->port);
 	if (tty) {
+		mutex_lock(&dlci->mutex);
+		gsm_destroy_network(dlci);
+		mutex_unlock(&dlci->mutex);
+
+		/* tty_vhangup needs the tty_lock, so unlock and
+		   relock after doing the hangup. */
+		tty_unlock();
 		tty_vhangup(tty);
+		tty_lock();
+		tty_port_tty_set(&dlci->port, NULL);
 		tty_kref_put(tty);
 	}
+	dlci->state = DLCI_CLOSED;
 	dlci_put(dlci);
 }
 
@@ -2933,6 +2945,8 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 
 	if (dlci == NULL)
 		return;
+	if (dlci->state != DLCI_OPEN)
+		return;
 	mutex_lock(&dlci->mutex);
 	gsm_destroy_network(dlci);
 	mutex_unlock(&dlci->mutex);
@@ -2951,6 +2965,8 @@ out:
 static void gsmtty_hangup(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return;
 	tty_port_hangup(&dlci->port);
 	gsm_dlci_begin_close(dlci);
 }
@@ -2958,9 +2974,12 @@ static void gsmtty_hangup(struct tty_struct *tty)
 static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
 								    int len)
 {
+	int sent;
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 	/* Stuff the bytes into the fifo queue */
-	int sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
+	sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
 	/* Need to kick the channel */
 	gsm_dlci_data_kick(dlci);
 	return sent;
@@ -2969,18 +2988,24 @@ static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
 static int gsmtty_write_room(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 	return TX_SIZE - kfifo_len(dlci->fifo);
 }
 
 static int gsmtty_chars_in_buffer(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 	return kfifo_len(dlci->fifo);
 }
 
 static void gsmtty_flush_buffer(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return;
 	/* Caution needed: If we implement reliable transport classes
 	   then the data being transmitted can't simply be junked once
 	   it has first hit the stack. Until then we can just blow it
@@ -2999,6 +3024,8 @@ static void gsmtty_wait_until_sent(struct tty_struct *tty, int timeout)
 static int gsmtty_tiocmget(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 	return dlci->modem_rx;
 }
 
@@ -3008,6 +3035,8 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 	struct gsm_dlci *dlci = tty->driver_data;
 	unsigned int modem_tx = dlci->modem_tx;
 
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 	modem_tx &= ~clear;
 	modem_tx |= set;
 
@@ -3026,6 +3055,8 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 	struct gsm_netconfig nc;
 	int index;
 
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 	switch (cmd) {
 	case GSMIOC_ENABLE_NET:
 		if (copy_from_user(&nc, (void __user *)arg, sizeof(nc)))
@@ -3052,6 +3083,9 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 
 static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
+	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return;
 	/* For the moment its fixed. In actual fact the speed information
 	   for the virtual channel can be propogated in both directions by
 	   the RPN control message. This however rapidly gets nasty as we
@@ -3063,6 +3097,8 @@ static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 static void gsmtty_throttle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return;
 	if (tty->termios->c_cflag & CRTSCTS)
 		dlci->modem_tx &= ~TIOCM_DTR;
 	dlci->throttled = 1;
@@ -3073,6 +3109,8 @@ static void gsmtty_throttle(struct tty_struct *tty)
 static void gsmtty_unthrottle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state != DLCI_OPEN)
+		return;
 	if (tty->termios->c_cflag & CRTSCTS)
 		dlci->modem_tx |= TIOCM_DTR;
 	dlci->throttled = 0;
@@ -3084,6 +3122,8 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	int encode = 0;	/* Off */
+	if (dlci->state != DLCI_OPEN)
+		return -EINVAL;
 
 	if (state == -1)	/* "On indefinitely" - we can't encode this
 				    properly */
-- 
1.7.2.5




