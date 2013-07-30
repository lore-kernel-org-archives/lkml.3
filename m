Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3G3PfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:35:21 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62771 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3G3PfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:35:19 -0400
From: Artem Savkov <artem.savkov@gmail.com>
To: peter@hurleysoftware.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] n_tty: release atomic_read_lock before calling schedule_timeout()
Date: Tue, 30 Jul 2013 19:35:00 +0400
Message-Id: <1375198500-17414-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ldata->atomic_read_lock should be released before scheduling as well as
tty->termios_rwsem, otherwise there is a potential deadlock detected by lockdep

Introduced in "n_tty: Access termios values safely"
(9356b535fcb71db494fc434acceb79f56d15bda2 in linux-next.git)

[   16.822058] ======================================================
[   16.822058] [ INFO: possible circular locking dependency detected ]
[   16.822058] 3.11.0-rc3-next-20130730+ #140 Tainted: G        W
[   16.822058] -------------------------------------------------------
[   16.822058] bash/1198 is trying to acquire lock:
[   16.822058]  (&tty->termios_rwsem){++++..}, at: [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
[   16.822058]
[   16.822058] but task is already holding lock:
[   16.822058]  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
[   16.822058]
[   16.822058] which lock already depends on the new lock.
[   16.822058]
[   16.822058]
[   16.822058] the existing dependency chain (in reverse order) is:
[   16.822058]
-> #1 (&ldata->atomic_read_lock){+.+...}:
[   16.822058]        [<ffffffff811111cc>] validate_chain+0x73c/0x850
[   16.822058]        [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
[   16.822058]        [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
[   16.822058]        [<ffffffff81d34b9c>] mutex_lock_interruptible_nested+0x7c/0x540
[   16.822058]        [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
[   16.822058]        [<ffffffff816a3bb6>] tty_read+0x86/0xf0
[   16.822058]        [<ffffffff811f21d3>] vfs_read+0xc3/0x130
[   16.822058]        [<ffffffff811f2702>] SyS_read+0x62/0xa0
[   16.822058]        [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
[   16.822058]
-> #0 (&tty->termios_rwsem){++++..}:
[   16.822058]        [<ffffffff8111064f>] check_prev_add+0x14f/0x590
[   16.822058]        [<ffffffff811111cc>] validate_chain+0x73c/0x850
[   16.822058]        [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
[   16.822058]        [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
[   16.822058]        [<ffffffff81d372c1>] down_read+0x51/0xa0
[   16.822058]        [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
[   16.822058]        [<ffffffff816a3bb6>] tty_read+0x86/0xf0
[   16.822058]        [<ffffffff811f21d3>] vfs_read+0xc3/0x130
[   16.822058]        [<ffffffff811f2702>] SyS_read+0x62/0xa0
[   16.822058]        [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b
[   16.822058]
[   16.822058] other info that might help us debug this:
[   16.822058]
[   16.822058]  Possible unsafe locking scenario:
[   16.822058]
[   16.822058]        CPU0                    CPU1
[   16.822058]        ----                    ----
[   16.822058]   lock(&ldata->atomic_read_lock);
[   16.822058]                                lock(&tty->termios_rwsem);
[   16.822058]                                lock(&ldata->atomic_read_lock);
[   16.822058]   lock(&tty->termios_rwsem);
[   16.822058]
[   16.822058]  *** DEADLOCK ***
[   16.822058]
[   16.822058] 2 locks held by bash/1198:
[   16.822058]  #0:  (&tty->ldisc_sem){.+.+.+}, at: [<ffffffff816ade04>] tty_ldisc_ref_wait+0x24/0x60
[   16.822058]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff816aa0f0>] n_tty_read+0x1d0/0x660
[   16.822058]
[   16.822058] stack backtrace:
[   16.822058] CPU: 1 PID: 1198 Comm: bash Tainted: G        W    3.11.0-rc3-next-20130730+ #140
[   16.822058] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   16.822058]  0000000000000000 ffff880019acdb28 ffffffff81d34074 0000000000000002
[   16.822058]  0000000000000000 ffff880019acdb78 ffffffff8110ed75 ffff880019acdb98
[   16.822058]  ffff880019fd0000 ffff880019acdb78 ffff880019fd0638 ffff880019fd0670
[   16.822058] Call Trace:
[   16.822058]  [<ffffffff81d34074>] dump_stack+0x59/0x7d
[   16.822058]  [<ffffffff8110ed75>] print_circular_bug+0x105/0x120
[   16.822058]  [<ffffffff8111064f>] check_prev_add+0x14f/0x590
[   16.822058]  [<ffffffff81d3ab5f>] ? _raw_spin_unlock_irq+0x4f/0x70
[   16.822058]  [<ffffffff811111cc>] validate_chain+0x73c/0x850
[   16.822058]  [<ffffffff8110ae0f>] ? trace_hardirqs_off_caller+0x1f/0x190
[   16.822058]  [<ffffffff811117e0>] __lock_acquire+0x500/0x5d0
[   16.822058]  [<ffffffff81111a29>] lock_acquire+0x179/0x1d0
[   16.822058]  [<ffffffff816aa3bb>] ? n_tty_read+0x49b/0x660
[   16.822058]  [<ffffffff81d372c1>] down_read+0x51/0xa0
[   16.822058]  [<ffffffff816aa3bb>] ? n_tty_read+0x49b/0x660
[   16.822058]  [<ffffffff816aa3bb>] n_tty_read+0x49b/0x660
[   16.822058]  [<ffffffff810e4130>] ? try_to_wake_up+0x210/0x210
[   16.822058]  [<ffffffff816a3bb6>] tty_read+0x86/0xf0
[   16.822058]  [<ffffffff811f21d3>] vfs_read+0xc3/0x130
[   16.822058]  [<ffffffff811f2702>] SyS_read+0x62/0xa0
[   16.822058]  [<ffffffff815e24ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   16.822058]  [<ffffffff81d45259>] system_call_fastpath+0x16/0x1b

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/tty/n_tty.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index dd8ae0c..38c09db 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2203,11 +2203,23 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 				break;
 			}
 			n_tty_set_room(tty);
+			mutex_unlock(&ldata->atomic_read_lock);
 			up_read(&tty->termios_rwsem);
 
 			timeout = schedule_timeout(timeout);
 
 			down_read(&tty->termios_rwsem);
+			if (file->f_flags & O_NONBLOCK) {
+				if (!mutex_trylock(&ldata->atomic_read_lock)) {
+					retval = -EAGAIN;
+					break;
+				}
+			} else {
+				if (mutex_lock_interruptible(&ldata->atomic_read_lock)) {
+					retval = -ERESTARTSYS;
+					break;
+				}
+			}
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
-- 
1.7.0.4

