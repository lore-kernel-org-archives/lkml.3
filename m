Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3CKUqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:46:03 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:59170 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3CKUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:46:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 05/44] tty: Remove unnecessary re-test of ldisc ref count
Date: Mon, 11 Mar 2013 16:44:25 -0400
Message-Id: <1363034704-28036-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the tty->ldisc is prevented from being changed by tty_set_ldisc()
when a tty is being hung up, re-testing the ldisc user count is
unnecessary -- ie, it cannot be a different ldisc and the user count
cannot have increased (assuming the caller meets the precondition that
TTY_LDISC flag is cleared)

Removal of the 'early-out' locking optimization is necessary for
the subsequent patch 'tty: Fix ldisc halt sequence on hangup'.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index c5b848a..fa0170e 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -558,29 +558,29 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
  *	have been halted for this to guarantee it remains idle.
  *
  *	Caller must hold legacy and ->ldisc_mutex.
+ *
+ *	NB: tty_set_ldisc() is prevented from changing the ldisc concurrently
+ *	with this function by checking the TTY_HUPPING flag.
  */
 static bool tty_ldisc_hangup_wait_idle(struct tty_struct *tty)
 {
-	while (tty->ldisc) {	/* Not yet closed */
-		if (atomic_read(&tty->ldisc->users) != 1) {
-			char cur_n[TASK_COMM_LEN], tty_n[64];
-			long timeout = 3 * HZ;
-			tty_unlock(tty);
-
-			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
-				timeout = MAX_SCHEDULE_TIMEOUT;
-				printk_ratelimited(KERN_WARNING
-					"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
-					__func__, get_task_comm(cur_n, current),
-					tty_name(tty, tty_n));
-			}
-			/* must reacquire both locks and preserve lock order */
-			mutex_unlock(&tty->ldisc_mutex);
-			tty_lock(tty);
-			mutex_lock(&tty->ldisc_mutex);
-			continue;
+	char cur_n[TASK_COMM_LEN], tty_n[64];
+	long timeout = 3 * HZ;
+
+	if (tty->ldisc) {	/* Not yet closed */
+		tty_unlock(tty);
+
+		while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
+			timeout = MAX_SCHEDULE_TIMEOUT;
+			printk_ratelimited(KERN_WARNING
+				"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
+				__func__, get_task_comm(cur_n, current),
+				tty_name(tty, tty_n));
 		}
-		break;
+		/* must reacquire both locks and preserve lock order */
+		mutex_unlock(&tty->ldisc_mutex);
+		tty_lock(tty);
+		mutex_lock(&tty->ldisc_mutex);
 	}
 	return !!tty->ldisc;
 }
-- 
1.8.1.2

