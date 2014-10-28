Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaJ1LLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:11:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaJ1LLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:11:49 -0400
Date: Tue, 28 Oct 2014 04:10:52 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-97d9e28d1a27b84a6a0b155f2390289afa279341@git.kernel.org>
Cc: gregkh@linuxfoundation.org, peterz@infradead.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, mingo@kernel.org, hpa@zytor.com,
        gregkh@linuxfoundation.org, peterz@infradead.org, jslaby@suse.cz
In-Reply-To: <20140924082242.323011233@infradead.org>
References: <20140924082242.323011233@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, tty: Deal with nested sleeps
Git-Commit-ID: 97d9e28d1a27b84a6a0b155f2390289afa279341
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97d9e28d1a27b84a6a0b155f2390289afa279341
Gitweb:     http://git.kernel.org/tip/97d9e28d1a27b84a6a0b155f2390289afa279341
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:56:10 +0100

sched, tty: Deal with nested sleeps

n_tty_{read,write} are wait loops with sleeps in. Wait loops rely on
task_struct::state and sleeps do too, since that's the only means of
actually sleeping. Therefore the nested sleeps destroy the wait loop
state.

Fix this by using the new woken_wake_function and wait_woken() stuff,
which registers wakeups in wait and thereby allows shrinking the
task_state::state changes to the actual sleep part.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: oleg@redhat.com
Link: http://lkml.kernel.org/r/20140924082242.323011233@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/tty/n_tty.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 89c4cee..fb3f519 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2123,7 +2123,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned char __user *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	int minimum, time;
 	ssize_t retval = 0;
@@ -2186,10 +2186,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			nr--;
 			break;
 		}
-		/* This statement must be first before checking for input
-		   so that any interrupt will set the state back to
-		   TASK_RUNNING. */
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (((minimum - (b - buf)) < ldata->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
@@ -2220,13 +2216,13 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
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
@@ -2273,7 +2269,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 	mutex_unlock(&ldata->atomic_read_lock);
 
-	__set_current_state(TASK_RUNNING);
 	if (b - buf)
 		retval = b - buf;
 
@@ -2306,7 +2301,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	ssize_t retval = 0;
 
@@ -2324,7 +2319,6 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 
 	add_wait_queue(&tty->write_wait, &wait);
 	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
@@ -2378,12 +2372,11 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
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
