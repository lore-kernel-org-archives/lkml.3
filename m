Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaFWJBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55490 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/111] Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to match vt
Date: Mon, 23 Jun 2014 10:31:19 +0200
Message-Id: <d743aefeb796657d61155b0074c43a0eda2e6bdc.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 28a821c306889b9f2c3fff49abedc9b2c743eb73 upstream.

This function is largely a duplicate of paste_selection() in
drivers/tty/vt/selection.c, but with its own selection state.  The
speakup selection mechanism should really be merged with vt.

For now, apply the changes from 'TTY: vt, fix paste_selection ldisc
handling', 'tty: Make ldisc input flow control concurrency-friendly',
and 'tty: Fix unsafe vt paste_selection()'.

References: https://bugs.debian.org/735202
References: https://bugs.debian.org/744015
Reported-by: Paul Gevers <elbrus@debian.org>
Reported-and-tested-by: Jarek Czekalski <jarekczek@poczta.onet.pl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/speakup/selection.c | 14 +++++++++++---
 drivers/tty/tty_buffer.c            |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index f67941e78e4a..ca04d3669acc 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -5,6 +5,8 @@
 #include <linux/device.h> /* for dev_warn */
 #include <linux/selection.h>
 #include <linux/workqueue.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <asm/cmpxchg.h>
 
 #include "speakup.h"
@@ -135,8 +137,12 @@ static void __speakup_paste_selection(struct work_struct *work)
 	struct tty_struct *tty = xchg(&spw->tty, NULL);
 	struct vc_data *vc = (struct vc_data *) tty->driver_data;
 	int pasted = 0, count;
+	struct tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
 
+	ld = tty_ldisc_ref_wait(tty);
+	tty_buffer_lock_exclusive(&vc->port);
+
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -145,13 +151,15 @@ static void __speakup_paste_selection(struct work_struct *work)
 			continue;
 		}
 		count = sel_buffer_lth - pasted;
-		count = min_t(int, count, tty->receive_room);
-		tty->ldisc->ops->receive_buf(tty, sel_buffer + pasted,
-			NULL, count);
+		count = tty_ldisc_receive_buf(ld, sel_buffer + pasted, NULL,
+					      count);
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
 	current->state = TASK_RUNNING;
+
+	tty_buffer_unlock_exclusive(&vc->port);
+	tty_ldisc_deref(ld);
 	tty_kref_put(tty);
 }
 
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 4847fc57f3e2..d9d216eb7db9 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -61,6 +61,7 @@ void tty_buffer_lock_exclusive(struct tty_port *port)
 	atomic_inc(&buf->priority);
 	mutex_lock(&buf->lock);
 }
+EXPORT_SYMBOL_GPL(tty_buffer_lock_exclusive);
 
 void tty_buffer_unlock_exclusive(struct tty_port *port)
 {
@@ -74,6 +75,7 @@ void tty_buffer_unlock_exclusive(struct tty_port *port)
 	if (restart)
 		queue_work(system_unbound_wq, &buf->work);
 }
+EXPORT_SYMBOL_GPL(tty_buffer_unlock_exclusive);
 
 /**
  *	tty_buffer_space_avail	-	return unused buffer space
-- 
2.0.0

