Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3BEUWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:22:41 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:58357 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756586Ab3BEUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:22:37 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 05/23] tty: Remove unnecessary re-test of ldisc ref count
Date: Tue,  5 Feb 2013 15:20:20 -0500
Message-Id: <1360095638-6624-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
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
index 70d2b86..405e972 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -558,29 +558,29 @@ static int tty_ldisc_halt(struct tty_struct *tty)
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
 	return !!(tty->ldisc);
 }
-- 
1.8.1.2

