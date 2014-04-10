Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbaDJCqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 22:46:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:12923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbaDJCqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 22:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,831,1389772800"; 
   d="scan'208";a="510601329"
From: Chen Tingjie <tingjie.chen@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Cc: Chen Tingjie <tingjie.chen@intel.com>, Zhang Jun <jun.zhang@intel.com>
Subject: [PATCH] tty: fix memleak in alloc_pid
Date: Thu, 10 Apr 2014 10:41:56 +0800
Message-Id: <1397097716-3535-1-git-send-email-tingjie.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is memleak in alloc_pid:
-----------------------------
unreferenced object 0xd3453a80 (size 64):
  comm "adbd", pid 1730, jiffies 66363 (age 6586.950s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 40 c2 f6 d5 00 d3 25 c1 59 28 00 00  ....@.....%.Y(..
  backtrace:
    [<c1a6f15c>] kmemleak_alloc+0x3c/0xa0
    [<c1320546>] kmem_cache_alloc+0xc6/0x190
    [<c125d51e>] alloc_pid+0x1e/0x400
    [<c123d344>] copy_process.part.39+0xad4/0x1120
    [<c123da59>] do_fork+0x99/0x330
    [<c123dd58>] sys_fork+0x28/0x30
    [<c1a89a08>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff

the leak is due to unreleased pid->count, which execute in function:
get_pid()(pid->count++) and put_pid()(pid->count--).

Tracking it, in disassociate_ctty(), when both
current->signal->tty_old_pgrp and current->signal->tty are NULL,
it will lack one put_pid() and cause pid leak.

In theory, set p->signal->tty to NULL and p->signal->tty_old_pgrp
should be atomic operation, can be seen in function:
tty_signal_session_leader(), but in disassociate_ctty(), it is not.
This lack of protection will sometimes cause the leak case.

Make sure the atomic for the two operations can fix this leak.

Signed-off-by: Zhang Jun <jun.zhang@intel.com>
Signed-off-by: Chen Tingjie <tingjie.chen@intel.com>
---
 drivers/tty/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d3448a9..3411071 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -878,9 +878,8 @@ void disassociate_ctty(int on_exit)
 	spin_lock_irq(&current->sighand->siglock);
 	put_pid(current->signal->tty_old_pgrp);
 	current->signal->tty_old_pgrp = NULL;
-	spin_unlock_irq(&current->sighand->siglock);
 
-	tty = get_current_tty();
+	tty = tty_kref_get(current->signal->tty);
 	if (tty) {
 		unsigned long flags;
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
@@ -897,6 +896,7 @@ void disassociate_ctty(int on_exit)
 #endif
 	}
 
+	spin_unlock_irq(&current->sighand->siglock);
 	/* Now clear signal->tty under the lock */
 	read_lock(&tasklist_lock);
 	session_clear_tty(task_session(current));
-- 
1.7.9.5

