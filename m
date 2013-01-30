Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab3A3KuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:50:21 -0500
Received: from smtp4.nedap.com ([213.160.213.85]:56828 "EHLO smtp.nedap.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755008Ab3A3KuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:50:17 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2013 05:50:17 EST
X-TM-IMSS-Message-ID: <3a5986d6000390d8@nedap.com>
Date: Wed, 30 Jan 2013 11:44:50 +0100
From: Dirkjan Bussink <d.bussink@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Prevent deadlock in n_gsm driver
Message-ID: <20130130104450.GA16867@nvc1891-openembedded.nedap.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Cc: stable <stable@vger.kernel.org>
---
 drivers/tty/n_gsm.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index e0f80ce..4a43ef5d7 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1689,6 +1689,8 @@ static inline void dlci_put(struct gsm_dlci *dlci)
 	tty_port_put(&dlci->port);
 }
 
+static void gsm_destroy_network(struct gsm_dlci *dlci);
+
 /**
  *	gsm_dlci_release		-	release DLCI
  *	@dlci: DLCI to destroy
@@ -1702,9 +1704,19 @@ static void gsm_dlci_release(struct gsm_dlci *dlci)
 {
 	struct tty_struct *tty = tty_port_tty_get(&dlci->port);
 	if (tty) {
+		mutex_lock(&dlci->mutex);
+		gsm_destroy_network(dlci);
+		mutex_unlock(&dlci->mutex);
+
+		/* tty_vhangup needs the tty_lock, so unlock and
+		   relock after doing the hangup. */
+		tty_unlock(tty);
 		tty_vhangup(tty);
+		tty_lock(tty);
+		tty_port_tty_set(&dlci->port, NULL);
 		tty_kref_put(tty);
 	}
+	dlci->state = DLCI_CLOSED;
 	dlci_put(dlci);
 }
 
@@ -2947,6 +2959,8 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 
 	if (dlci == NULL)
 		return;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	mutex_lock(&dlci->mutex);
 	gsm_destroy_network(dlci);
 	mutex_unlock(&dlci->mutex);
@@ -2965,6 +2979,8 @@ out:
 static void gsmtty_hangup(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	tty_port_hangup(&dlci->port);
 	gsm_dlci_begin_close(dlci);
 }
@@ -2972,9 +2988,12 @@ static void gsmtty_hangup(struct tty_struct *tty)
 static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
 								    int len)
 {
+	int sent;
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	/* Stuff the bytes into the fifo queue */
-	int sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
+	sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
 	/* Need to kick the channel */
 	gsm_dlci_data_kick(dlci);
 	return sent;
@@ -2983,18 +3002,24 @@ static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
 static int gsmtty_write_room(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	return TX_SIZE - kfifo_len(dlci->fifo);
 }
 
 static int gsmtty_chars_in_buffer(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	return kfifo_len(dlci->fifo);
 }
 
 static void gsmtty_flush_buffer(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	/* Caution needed: If we implement reliable transport classes
 	   then the data being transmitted can't simply be junked once
 	   it has first hit the stack. Until then we can just blow it
@@ -3013,6 +3038,8 @@ static void gsmtty_wait_until_sent(struct tty_struct *tty, int timeout)
 static int gsmtty_tiocmget(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	return dlci->modem_rx;
 }
 
@@ -3022,6 +3049,8 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 	struct gsm_dlci *dlci = tty->driver_data;
 	unsigned int modem_tx = dlci->modem_tx;
 
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	modem_tx &= ~clear;
 	modem_tx |= set;
 
@@ -3040,6 +3069,8 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 	struct gsm_netconfig nc;
 	int index;
 
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	switch (cmd) {
 	case GSMIOC_ENABLE_NET:
 		if (copy_from_user(&nc, (void __user *)arg, sizeof(nc)))
@@ -3066,6 +3097,9 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 
 static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
+	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	/* For the moment its fixed. In actual fact the speed information
 	   for the virtual channel can be propogated in both directions by
 	   the RPN control message. This however rapidly gets nasty as we
@@ -3077,6 +3111,8 @@ static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 static void gsmtty_throttle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	if (tty->termios.c_cflag & CRTSCTS)
 		dlci->modem_tx &= ~TIOCM_DTR;
 	dlci->throttled = 1;
@@ -3087,6 +3123,8 @@ static void gsmtty_throttle(struct tty_struct *tty)
 static void gsmtty_unthrottle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	if (tty->termios.c_cflag & CRTSCTS)
 		dlci->modem_tx |= TIOCM_DTR;
 	dlci->throttled = 0;
@@ -3098,6 +3136,8 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	int encode = 0;	/* Off */
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 
 	if (state == -1)	/* "On indefinitely" - we can't encode this
 				    properly */
-- 
1.7.2.5

