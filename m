Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaEMAl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:41:58 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:59115 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaEMAl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:41:57 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Petr Mladek <pmladek@suse.cz>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] Fix lockup on panic with lockdep
Date: Mon, 12 May 2014 17:41:54 -0700
Message-Id: <1399941714-20145-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't call mutex_acquire at the beginning of console_unblank, we can run
into a lockup on the logbuf_lock between console_unlock and printk during panic.
What happens in console_unlock is:

-locks logbuf_lock
-calls mutex_release
 -which calls printk
  -which locks logbuf_lock

This fixes the problem by calling console_trylock (which calls mutex_acquire)
instead of directly accessing the semaphore in console_unblank and moves the
mutex_release to after we unlock logbuf_lock in console_unlock (interrupts are
still disabled).

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7228258..c599ab5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2084,7 +2084,6 @@ skip:
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
@@ -2092,6 +2091,7 @@ skip:
 
 	raw_spin_unlock(&logbuf_lock);
 
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 	up(&console_sem);
 
 	/*
@@ -2137,7 +2137,7 @@ void console_unblank(void)
 	 * oops_in_progress is set to 1..
 	 */
 	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
+		if (!console_trylock())
 			return;
 	} else
 		console_lock();
-- 
1.9.1.423.g4596e3a

