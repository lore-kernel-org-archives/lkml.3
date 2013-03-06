Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3CFMVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:21:51 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43058 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab3CFMVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:21:40 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/5] tty: Use spin_lock() inside existing critical region
Date: Wed,  6 Mar 2013 07:20:55 -0500
Message-Id: <1362572457-29993-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
References: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt state does not need to be saved, disabled and
restored here; interrupts are already off because this lock
is bracketed by spin_lock_irq/spin_unlock_irq.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index f9d4acf..40d3a7a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -545,7 +545,6 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
 static int tty_signal_session_leader(struct tty_struct *tty)
 {
 	struct task_struct *p;
-	unsigned long flags;
 	int refs = 0;
 
 	read_lock(&tasklist_lock);
@@ -565,10 +564,10 @@ static int tty_signal_session_leader(struct tty_struct *tty)
 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
-			spin_lock_irqsave(&tty->ctrl_lock, flags);
+			spin_lock(&tty->ctrl_lock);
 			if (tty->pgrp)
 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
-			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+			spin_unlock(&tty->ctrl_lock);
 			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
 	}
-- 
1.8.1.2

