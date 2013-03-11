Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3CKV0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:26:34 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33431 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3CKVPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 27/44] tty: Drop lock contention stat from ldsem trylocks
Date: Mon, 11 Mar 2013 16:44:47 -0400
Message-Id: <1363034704-28036-28-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When lockdep is notified of lock contention, lockdep expects its
internal state to indicate the lock is held. Since trylocks cannot
reflect this state unless the lock is actually acquired, contention
stats cannot be collected for trylocks.

Fixes:
[ 1473.912280] =================================
[ 1473.913180] [ BUG: bad contention detected! ]
[ 1473.914071] 3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8 Tainted: G        W
[ 1473.915684] ---------------------------------
[ 1473.916549] kworker/1:1/361 is trying to contend lock (&tty->ldisc_sem) at:
[ 1473.918031] [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
[ 1473.919060] but there are no locks held!
[ 1473.919813]
[ 1473.919813] other info that might help us debug this:
[ 1473.920044] 2 locks held by kworker/1:1/361:
[ 1473.920044]  #0:  (events){.+.+.+}, at: [<ffffffff811328a8>] process_one_work+0x228/0x6a0
[ 1473.920044]  #1:  ((&buf->work)){+.+...}, at: [<ffffffff811328a8>] process_one_work+0x228/0x6a0
[ 1473.920044]
[ 1473.920044] stack backtrace:
[ 1473.920044] Pid: 361, comm: kworker/1:1 Tainted: G        W    3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8
[ 1473.920044] Call Trace:
[ 1473.920044]  [<ffffffff81c493df>] ? tty_ldisc_ref+0x1f/0x60
[ 1473.920044]  [<ffffffff81182026>] print_lock_contention_bug+0xf6/0x110
[ 1473.920044]  [<ffffffff81184973>] lock_contended+0x213/0x4e0
[ 1473.920044]  [<ffffffff81c4bb41>] ldsem_down_read_trylock+0xb1/0xc0
[ 1473.920044]  [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
[ 1473.920044]  [<ffffffff81c4a687>] flush_to_ldisc+0x37/0x1a0
[ 1473.920044]  [<ffffffff811329e6>] process_one_work+0x366/0x6a0
[ 1473.920044]  [<ffffffff811328a8>] ? process_one_work+0x228/0x6a0
[ 1473.920044]  [<ffffffff811332a8>] worker_thread+0x238/0x370
[ 1473.920044]  [<ffffffff81133070>] ? rescuer_thread+0x310/0x310
[ 1473.920044]  [<ffffffff8113d873>] kthread+0xe3/0xf0
[ 1473.920044]  [<ffffffff8113d790>] ? flush_kthread_work+0x1f0/0x1f0
[ 1473.920044]  [<ffffffff83dab4fc>] ret_from_fork+0x7c/0xb0
[ 1473.920044]  [<ffffffff8113d790>] ? flush_kthread_work+0x1f0/0x1f0

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index 0ab5b09..c162295 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -419,7 +419,6 @@ int ldsem_down_read_trylock(struct ld_semaphore *sem)
 			return 1;
 		}
 	}
-	lock_stat(sem, contended);
 	return 0;
 }
 
@@ -453,9 +452,7 @@ int ldsem_down_write_trylock(struct ld_semaphore *sem)
 		lock_stat(sem, acquired);
 		return 1;
 	}
-
 	raw_spin_unlock_irq(&sem->wait_lock);
-	lock_stat(sem, contended);
 	return 0;
 }
 
-- 
1.8.1.2

