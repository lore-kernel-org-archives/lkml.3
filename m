Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaICXiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:38:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392AbaICWGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gevers <elbrus@debian.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.10 43/55] Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to match vt
Date: Wed,  3 Sep 2014 15:05:33 -0700
Message-Id: <20140903220500.817299348@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.10:
 - Only apply the changes from 'TTY: vt, fix paste_selection ldisc handling'
 - Add the same FIXME comment as vt's paste_selection() has in this version]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/selection.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -5,6 +5,7 @@
 #include <linux/device.h> /* for dev_warn */
 #include <linux/selection.h>
 #include <linux/workqueue.h>
+#include <linux/tty.h>
 #include <asm/cmpxchg.h>
 
 #include "speakup.h"
@@ -135,8 +136,12 @@ static void __speakup_paste_selection(st
 	struct tty_struct *tty = xchg(&spw->tty, NULL);
 	struct vc_data *vc = (struct vc_data *) tty->driver_data;
 	int pasted = 0, count;
+	struct tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
 
+	ld = tty_ldisc_ref_wait(tty);
+
+	/* FIXME: this is completely unsafe */
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -146,12 +151,13 @@ static void __speakup_paste_selection(st
 		}
 		count = sel_buffer_lth - pasted;
 		count = min_t(int, count, tty->receive_room);
-		tty->ldisc->ops->receive_buf(tty, sel_buffer + pasted,
-			NULL, count);
+		ld->ops->receive_buf(tty, sel_buffer + pasted, NULL, count);
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
 	current->state = TASK_RUNNING;
+
+	tty_ldisc_deref(ld);
 	tty_kref_put(tty);
 }
 


