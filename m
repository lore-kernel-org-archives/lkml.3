Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbbAQUmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 15:42:24 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36118 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbAQUmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 15:42:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/3] pty: Fix buffer flush deadlock
Date: Sat, 17 Jan 2015 15:42:05 -0500
Message-Id: <1421527326-4368-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421527326-4368-1-git-send-email-peter@hurleysoftware.com>
References: <1421527326-4368-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pty driver does not clear its write buffer when commanded.
This is to avoid an apparent deadlock between parallel flushes from
both pty ends; specifically when handling either BRK or INTR input.
However, parallel flushes from this source is not possible since
the pty master can never be set to BRKINT or ISIG. Parallel flushes
from other sources are possible but these do not threaten deadlocks.

Annotate the tty buffer mutex for lockdep to represent the nested
tty_buffer locking which occurs when the pty slave is processing input
(its buffer mutex held) and receives INTR or BRK and acquires the
linked tty buffer mutex via tty_buffer_flush().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c        | 10 +++++++++-
 drivers/tty/tty_buffer.c |  6 ++++++
 include/linux/tty.h      |  4 ++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2cf2567..e0007d1 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -209,10 +209,16 @@ static int pty_signal(struct tty_struct *tty, int sig)
 static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
+	struct tty_ldisc *ld;
 
 	if (!to)
 		return;
-	/* tty_buffer_flush(to); FIXME */
+
+	ld = tty_ldisc_ref(to);
+	tty_buffer_flush(to, ld);
+	if (ld)
+		tty_ldisc_deref(ld);
+
 	if (to->packet) {
 		spin_lock_irq(&tty->ctrl_lock);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
@@ -422,6 +428,8 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	tty->port = ports[1];
 	o_tty->port->itty = o_tty;
 
+	tty_buffer_set_lock_subclass(o_tty->port);
+
 	tty_driver_kref_get(driver);
 	tty->count++;
 	o_tty->count++;
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 3605103..7566164 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -557,3 +557,9 @@ int tty_buffer_set_limit(struct tty_port *port, int limit)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tty_buffer_set_limit);
+
+/* slave ptys can claim nested buffer lock when handling BRK and INTR */
+void tty_buffer_set_lock_subclass(struct tty_port *port)
+{
+	lockdep_set_subclass(&port->buf.lock, TTY_LOCK_SLAVE);
+}
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4c1c453..c60efad 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -25,6 +25,9 @@
  *
  * legacy_mutex - Nested tty locks are necessary for releasing pty pairs.
  *		  The stable lock order is master pty first, then slave pty.
+ * tty_buffer lock - slave ptys can claim nested buffer lock when handling
+ *		     signal chars. The stable lock order is slave pty, then
+ *		     master.
  */
 
 enum {
@@ -460,6 +463,7 @@ extern void tty_flush_to_ldisc(struct tty_struct *tty);
 extern void tty_buffer_free_all(struct tty_port *port);
 extern void tty_buffer_flush(struct tty_struct *tty, struct tty_ldisc *ld);
 extern void tty_buffer_init(struct tty_port *port);
+extern void tty_buffer_set_lock_subclass(struct tty_port *port);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
 extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
 extern void tty_termios_encode_baud_rate(struct ktermios *termios,
-- 
2.2.2

