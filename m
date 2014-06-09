Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaFIXCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:02:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933909AbaFIWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gevers <elbrus@debian.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.14 49/78] Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to match vt
Date: Mon,  9 Jun 2014 15:48:29 -0700
Message-Id: <20140609224814.932179159@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/selection.c |   14 +++++++++++---
 drivers/tty/tty_buffer.c            |    2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

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
@@ -135,8 +137,12 @@ static void __speakup_paste_selection(st
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
@@ -145,13 +151,15 @@ static void __speakup_paste_selection(st
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
 
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -60,6 +60,7 @@ void tty_buffer_lock_exclusive(struct tt
 	atomic_inc(&buf->priority);
 	mutex_lock(&buf->lock);
 }
+EXPORT_SYMBOL_GPL(tty_buffer_lock_exclusive);
 
 void tty_buffer_unlock_exclusive(struct tty_port *port)
 {
@@ -73,6 +74,7 @@ void tty_buffer_unlock_exclusive(struct
 	if (restart)
 		queue_work(system_unbound_wq, &buf->work);
 }
+EXPORT_SYMBOL_GPL(tty_buffer_unlock_exclusive);
 
 /**
  *	tty_buffer_space_avail	-	return unused buffer space


