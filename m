Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3B1Oqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3B1Oqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirkjan Bussink <dirkjan.bussink@nedap.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 018/139] tty: Prevent deadlock in n_gsm driver
Date: Thu, 28 Feb 2013 14:42:48 +0000
Message-Id: <1362062689-2567-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirkjan Bussink <d.bussink@gmail.com>

commit 4d9b109060f690f5c835130ff54165ae157b3087 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/n_gsm.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 90dff82..4056483 100644
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
+		tty_unlock(tty);
 		tty_vhangup(tty);
+		tty_lock(tty);
+		tty_port_tty_set(&dlci->port, NULL);
 		tty_kref_put(tty);
 	}
+	dlci->state = DLCI_CLOSED;
 	dlci_put(dlci);
 }
 
@@ -2933,6 +2945,8 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 
 	if (dlci == NULL)
 		return;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	mutex_lock(&dlci->mutex);
 	gsm_destroy_network(dlci);
 	mutex_unlock(&dlci->mutex);
@@ -2951,6 +2965,8 @@ out:
 static void gsmtty_hangup(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
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
+	if (dlci->state == DLCI_CLOSED)
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
@@ -2999,6 +3024,8 @@ static void gsmtty_wait_until_sent(struct tty_struct *tty, int timeout)
 static int gsmtty_tiocmget(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	return dlci->modem_rx;
 }
 
@@ -3008,6 +3035,8 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 	struct gsm_dlci *dlci = tty->driver_data;
 	unsigned int modem_tx = dlci->modem_tx;
 
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	modem_tx &= ~clear;
 	modem_tx |= set;
 
@@ -3026,6 +3055,8 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 	struct gsm_netconfig nc;
 	int index;
 
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 	switch (cmd) {
 	case GSMIOC_ENABLE_NET:
 		if (copy_from_user(&nc, (void __user *)arg, sizeof(nc)))
@@ -3052,6 +3083,9 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 
 static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
+	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	/* For the moment its fixed. In actual fact the speed information
 	   for the virtual channel can be propogated in both directions by
 	   the RPN control message. This however rapidly gets nasty as we
@@ -3063,6 +3097,8 @@ static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 static void gsmtty_throttle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	if (tty->termios->c_cflag & CRTSCTS)
 		dlci->modem_tx &= ~TIOCM_DTR;
 	dlci->throttled = 1;
@@ -3073,6 +3109,8 @@ static void gsmtty_throttle(struct tty_struct *tty)
 static void gsmtty_unthrottle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	if (dlci->state == DLCI_CLOSED)
+		return;
 	if (tty->termios->c_cflag & CRTSCTS)
 		dlci->modem_tx |= TIOCM_DTR;
 	dlci->throttled = 0;
@@ -3084,6 +3122,8 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	int encode = 0;	/* Off */
+	if (dlci->state == DLCI_CLOSED)
+		return -EINVAL;
 
 	if (state == -1)	/* "On indefinitely" - we can't encode this
 				    properly */
-- 
1.8.1.2

