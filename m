Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3CFMWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:22:16 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43073 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab3CFMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:21:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 5/5] tty: Signal SIGHUP before hanging up ldisc
Date: Wed,  6 Mar 2013 07:20:57 -0500
Message-Id: <1362572457-29993-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
References: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An exiting session leader can hang if a foreground process is
blocking for line discipline i/o, eg. in n_tty_read(). This happens
because the blocking reader is holding an ldisc reference (indicating
the line discipline is in-use) which prevents __tty_hangup() from
recycling the line discipline. Although waiters are woken before
attempting to gain exclusive access for changing the ldisc, the
blocking reader in this case will not exit the i/o loop since it
has not yet received SIGHUP (because it has not been sent).

Instead, perform signalling first, then recycle the line discipline.

Fixes:

INFO: task init:1 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init            D 00000000001d7180  2688     1      0 0x00000002
 ffff8800b9acfba8 0000000000000002 00000000001d7180 ffff8800b9b10048
 ffff8800b94cb000 ffff8800b9b10000 00000000001d7180 00000000001d7180
 ffff8800b9b10000 ffff8800b9acffd8 00000000001d7180 00000000001d7180
Call Trace:
 [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
 [<ffffffff83db9b35>] schedule+0x55/0x60
 [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
 [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
 [<ffffffff83dbab38>] ? down_failed+0x108/0x200
 [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
 [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
 [<ffffffff83dbab61>] down_failed+0x131/0x200
 [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
 [<ffffffff83dbae03>] ldsem_down_write+0xd3/0x113
 [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
 [<ffffffff8118264d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120
 [<ffffffff81c3df60>] tty_ldisc_hangup+0xd0/0x220
 [<ffffffff81c35bd7>] __tty_hangup+0x137/0x4f0
 [<ffffffff81c37c7c>] disassociate_ctty+0x6c/0x230
 [<ffffffff8111290c>] do_exit+0x41c/0x590
 [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
 [<ffffffff81112b4a>] do_group_exit+0x8a/0xc0
 [<ffffffff81112b92>] sys_exit_group+0x12/0x20
 [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
1 lock held by init/1:
 #0: (&tty->ldisc_sem){++++++}, at: [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index cc6727e..d93573c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -651,17 +651,17 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 	}
 	spin_unlock(&tty_files_lock);
 
+	refs = tty_signal_session_leader(tty, exit_session);
+	/* Account for the p->signal references we killed */
+	while (refs--)
+		tty_kref_put(tty);
+
 	/*
 	 * it drops BTM and thus races with reopen
 	 * we protect the race by TTY_HUPPING
 	 */
 	tty_ldisc_hangup(tty);
 
-	refs = tty_signal_session_leader(tty, exit_session);
-	/* Account for the p->signal references we killed */
-	while (refs--)
-		tty_kref_put(tty);
-
 	spin_lock_irq(&tty->ctrl_lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_PUSH, &tty->flags);
-- 
1.8.1.2

