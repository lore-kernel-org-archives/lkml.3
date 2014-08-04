Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaHDKj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:39:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:33291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaHDKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:39:54 -0400
Message-Id: <20140804103537.628164803@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 5/7] tty: Deal with nested sleeps
References: <20140804103025.478913141@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep-tty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n_tty_{read,write} are wait loops with sleeps in. Wait loops rely on
task_struct::state and sleeps do too, since that's the only means of
actually sleeping. Therefore the nested sleeps destroy the wait loop
state and the wait loop breaks the sleep functions that assume
TASK_RUNNING (mutex_lock).

Fix this by using the new woken_wake_function and wait_woken() stuff,
which registers wakeups in wait and thereby allows shrinking the
task_state::state changes to the actual sleep part.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 drivers/tty/n_tty.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2123,7 +2123,7 @@ static ssize_t n_tty_read(struct tty_str
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned char __user *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	int minimum, time;
 	ssize_t retval = 0;
@@ -2186,10 +2186,6 @@ static ssize_t n_tty_read(struct tty_str
 			nr--;
 			break;
 		}
-		/* This statement must be first before checking for input
-		   so that any interrupt will set the state back to
-		   TASK_RUNNING. */
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (((minimum - (b - buf)) < ldata->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
@@ -2220,13 +2216,13 @@ static ssize_t n_tty_read(struct tty_str
 				n_tty_set_room(tty);
 				up_read(&tty->termios_rwsem);
 
-				timeout = schedule_timeout(timeout);
+				timeout = wait_woken(&wait, TASK_INTERRUPTIBLE,
+						     timeout);
 
 				down_read(&tty->termios_rwsem);
 				continue;
 			}
 		}
-		__set_current_state(TASK_RUNNING);
 
 		/* Deal with packet mode. */
 		if (packet && b == buf) {
@@ -2273,7 +2269,6 @@ static ssize_t n_tty_read(struct tty_str
 
 	mutex_unlock(&ldata->atomic_read_lock);
 
-	__set_current_state(TASK_RUNNING);
 	if (b - buf)
 		retval = b - buf;
 
@@ -2306,7 +2301,7 @@ static ssize_t n_tty_write(struct tty_st
 			   const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	ssize_t retval = 0;
 
@@ -2324,7 +2319,6 @@ static ssize_t n_tty_write(struct tty_st
 
 	add_wait_queue(&tty->write_wait, &wait);
 	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
@@ -2378,12 +2372,11 @@ static ssize_t n_tty_write(struct tty_st
 		}
 		up_read(&tty->termios_rwsem);
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 
 		down_read(&tty->termios_rwsem);
 	}
 break_out:
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&tty->write_wait, &wait);
 	if (b - buf != nr && tty->fasync)
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);


