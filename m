Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbaFIXIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:08:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637AbaFIWpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gevers <elbrus@debian.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.14 47/78] Staging: speakup: Move pasting into a work item
Date: Mon,  9 Jun 2014 15:48:27 -0700
Message-Id: <20140609224814.868544840@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit d7500135802ca55b3f4e01a16544e8b34082f8c3 upstream.

Input is handled in softirq context, but when pasting we may
need to sleep.  speakup_paste_selection() currently tries to
bodge this by busy-waiting if in_atomic(), but that doesn't
help because the ldisc may also sleep.

For bonus breakage, speakup_paste_selection() changes the
state of current, even though it's not running in process
context.

Move it into a work item and make sure to cancel it on exit.

References: https://bugs.debian.org/735202
References: https://bugs.debian.org/744015
Reported-by: Paul Gevers <elbrus@debian.org>
Reported-and-tested-by: Jarek Czekalski <jarekczek@poczta.onet.pl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/main.c      |    1 
 drivers/staging/speakup/selection.c |   40 +++++++++++++++++++++++++++++-------
 drivers/staging/speakup/speakup.h   |    1 
 3 files changed, 35 insertions(+), 7 deletions(-)

--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -2218,6 +2218,7 @@ static void __exit speakup_exit(void)
 	unregister_keyboard_notifier(&keyboard_notifier_block);
 	unregister_vt_notifier(&vt_notifier_block);
 	speakup_unregister_devsynth();
+	speakup_cancel_paste();
 	del_timer(&cursor_timer);
 	kthread_stop(speakup_task);
 	speakup_task = NULL;
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -4,6 +4,8 @@
 #include <linux/sched.h>
 #include <linux/device.h> /* for dev_warn */
 #include <linux/selection.h>
+#include <linux/workqueue.h>
+#include <asm/cmpxchg.h>
 
 #include "speakup.h"
 
@@ -121,20 +123,24 @@ int speakup_set_selection(struct tty_str
 	return 0;
 }
 
-/* TODO: move to some helper thread, probably.  That'd fix having to check for
- * in_atomic().  */
-int speakup_paste_selection(struct tty_struct *tty)
-{
+struct speakup_paste_work {
+	struct work_struct work;
+	struct tty_struct *tty;
+};
+
+static void __speakup_paste_selection(struct work_struct *work)
+{
+	struct speakup_paste_work *spw =
+		container_of(work, struct speakup_paste_work, work);
+	struct tty_struct *tty = xchg(&spw->tty, NULL);
 	struct vc_data *vc = (struct vc_data *) tty->driver_data;
 	int pasted = 0, count;
 	DECLARE_WAITQUEUE(wait, current);
+
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (test_bit(TTY_THROTTLED, &tty->flags)) {
-			if (in_atomic())
-				/* if we are in an interrupt handler, abort */
-				break;
 			schedule();
 			continue;
 		}
@@ -146,6 +152,26 @@ int speakup_paste_selection(struct tty_s
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
 	current->state = TASK_RUNNING;
+	tty_kref_put(tty);
+}
+
+static struct speakup_paste_work speakup_paste_work = {
+	.work = __WORK_INITIALIZER(speakup_paste_work.work,
+				   __speakup_paste_selection)
+};
+
+int speakup_paste_selection(struct tty_struct *tty)
+{
+	if (cmpxchg(&speakup_paste_work.tty, NULL, tty) != NULL)
+		return -EBUSY;
+
+	tty_kref_get(tty);
+	schedule_work_on(WORK_CPU_UNBOUND, &speakup_paste_work.work);
 	return 0;
 }
 
+void speakup_cancel_paste(void)
+{
+	cancel_work_sync(&speakup_paste_work.work);
+	tty_kref_put(speakup_paste_work.tty);
+}
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -77,6 +77,7 @@ extern void synth_buffer_clear(void);
 extern void speakup_clear_selection(void);
 extern int speakup_set_selection(struct tty_struct *tty);
 extern int speakup_paste_selection(struct tty_struct *tty);
+extern void speakup_cancel_paste(void);
 extern void speakup_register_devsynth(void);
 extern void speakup_unregister_devsynth(void);
 extern void synth_write(const char *buf, size_t count);


