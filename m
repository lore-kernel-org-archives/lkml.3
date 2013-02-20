Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990Ab3BTUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:16:27 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54980 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836Ab3BTUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:16:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 14/32] tty: Complete ownership transfer of flip buffers
Date: Wed, 20 Feb 2013 15:03:01 -0500
Message-Id: <1361390599-15195-15-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiting for buffer work to complete is not required for safely
performing changes to the line discipline, once the line discipline
is halted. The buffer work routine, flush_to_ldisc(), will be
unable to acquire an ldisc ref and all existing references were
waited until released (so it can't already have one).

Ensure running buffer work which may reference the soon-to-be-gone
tty completes and any buffer work running after this point retrieves
a NULL tty.

Also, ensure all buffer work is cancelled on port destruction.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    |  1 +
 drivers/tty/tty_ldisc.c | 47 ++++++++++++-----------------------------------
 drivers/tty/tty_port.c  |  1 +
 3 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4f8a06e..198b345 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1549,6 +1549,7 @@ static void release_tty(struct tty_struct *tty, int idx)
 	tty_free_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
 	tty->port->itty = NULL;
+	cancel_work_sync(&tty->port->buf.work);
 
 	if (tty->link)
 		tty_kref_put(tty->link);
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9c727da..cbb945b 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -508,7 +508,6 @@ static void tty_ldisc_flush_works(struct tty_struct *tty)
 {
 	flush_work(&tty->SAK_work);
 	flush_work(&tty->hangup_work);
-	flush_work(&tty->port->buf.work);
 }
 
 /**
@@ -531,20 +530,12 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
  *	tty_ldisc_halt		-	shut down the line discipline
  *	@tty: tty device
  *	@o_tty: paired pty device (can be NULL)
- *	@pending: returns true if work was scheduled when cancelled
- *		  (can be set to NULL)
- *	@o_pending: returns true if work was scheduled when cancelled
- *		    (can be set to NULL)
  *	@timeout: # of jiffies to wait for ldisc refs to be released
  *
  *	Shut down the line discipline and work queue for this tty device and
  *	its paired pty (if exists). Clearing the TTY_LDISC flag ensures
- *	no further references can be obtained while the work queue halt
- *	ensures that no more data is fed to the ldisc.
- *
- *	Furthermore, guarantee that existing ldisc references have been
- *	released, which in turn, guarantees that no future buffer work
- *	can be rescheduled.
+ *	no further references can be obtained, while waiting for existing
+ *	references to be released ensures no more data is fed to the ldisc.
  *
  *	You need to do a 'flush_scheduled_work()' (outside the ldisc_mutex)
  *	in order to make sure any currently executing ldisc work is also
@@ -552,9 +543,9 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
  */
 
 static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
-			  int *pending, int *o_pending, long timeout)
+			  long timeout)
 {
-	int scheduled, o_scheduled, retval;
+	int retval;
 
 	clear_bit(TTY_LDISC, &tty->flags);
 	if (o_tty)
@@ -566,17 +557,10 @@ static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
 	if (retval)
 		return retval;
 
-	scheduled = cancel_work_sync(&tty->port->buf.work);
 	set_bit(TTY_LDISC_HALTED, &tty->flags);
-	if (o_tty) {
-		o_scheduled = cancel_work_sync(&o_tty->port->buf.work);
+	if (o_tty)
 		set_bit(TTY_LDISC_HALTED, &o_tty->flags);
-	}
 
-	if (pending)
-		*pending = scheduled;
-	if (o_tty && o_pending)
-		*o_pending = o_scheduled;
 	return 0;
 }
 
@@ -586,17 +570,12 @@ static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
  *
  *	Shut down the line discipline and work queue for the tty device
  *	being hungup. Clear the TTY_LDISC flag to ensure no further
- *	references can be obtained, wait for remaining references to be
- *	released, and cancel pending buffer work to ensure no more
- *	data is fed to this ldisc.
+ *	references can be obtained and wait for remaining references to be
+ *	released to ensure no more data is fed to this ldisc.
  *	Caller must hold legacy and ->ldisc_mutex.
  *
  *	NB: tty_set_ldisc() is prevented from changing the ldisc concurrently
  *	with this function by checking the TTY_HUPPING flag.
- *
- *	NB: if tty->ldisc is NULL then buffer work does not need to be
- *	cancelled because it must already have done as a precondition
- *	of closing the ldisc and setting tty->ldisc to NULL
  */
 static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
 {
@@ -616,7 +595,6 @@ static bool tty_ldisc_hangup_halt(struct tty_struct *tty)
 				tty_name(tty, tty_n));
 		}
 
-		cancel_work_sync(&tty->port->buf.work);
 		set_bit(TTY_LDISC_HALTED, &tty->flags);
 
 		/* must reacquire both locks and preserve lock order */
@@ -644,7 +622,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 {
 	int retval;
 	struct tty_ldisc *o_ldisc, *new_ldisc;
-	int work, o_work = 0;
 	struct tty_struct *o_tty;
 
 	new_ldisc = tty_ldisc_get(ldisc);
@@ -718,7 +695,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 *	parallel to the change and re-referencing the tty.
 	 */
 
-	retval = tty_ldisc_halt(tty, o_tty, &work, &o_work, 5 * HZ);
+	retval = tty_ldisc_halt(tty, o_tty, 5 * HZ);
 
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate.
@@ -782,10 +759,10 @@ enable:
 
 	/* Restart the work queue in case no characters kick it off. Safe if
 	   already running */
-	if (work)
-		schedule_work(&tty->port->buf.work);
-	if (o_work)
+	schedule_work(&tty->port->buf.work);
+	if (o_tty)
 		schedule_work(&o_tty->port->buf.work);
+
 	mutex_unlock(&tty->ldisc_mutex);
 	tty_unlock(tty);
 	return retval;
@@ -979,7 +956,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * race with the set_ldisc code path.
 	 */
 
-	tty_ldisc_halt(tty, o_tty, NULL, NULL, MAX_SCHEDULE_TIMEOUT);
+	tty_ldisc_halt(tty, o_tty, MAX_SCHEDULE_TIMEOUT);
 	tty_ldisc_flush_works(tty);
 	if (o_tty)
 		tty_ldisc_flush_works(o_tty);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index b7ff59d..6d9e0b2 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -132,6 +132,7 @@ EXPORT_SYMBOL(tty_port_free_xmit_buf);
  */
 void tty_port_destroy(struct tty_port *port)
 {
+	cancel_work_sync(&port->buf.work);
 	tty_buffer_free_all(port);
 }
 EXPORT_SYMBOL(tty_port_destroy);
-- 
1.8.1.2

