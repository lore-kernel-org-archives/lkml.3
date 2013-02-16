Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3BPA6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:58:09 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52962 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3BPA6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:58:07 -0500
From: Mandeep Singh Baines <mandeep.baines@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Chan <benchan@chromium.org>, Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v4] coredump: ignore non-fatal signals when core dumping to a pipe
Date: Fri, 15 Feb 2013 16:57:34 -0800
Message-Id: <1360976254-5847-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1360973398-23823-1-git-send-email-msb@chromium.org>
References: <1360973398-23823-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Chan <benchan@chromium.org>

Make wait_for_dump_helpers() not abort piping the core dump data when the
crashing process has received a non-fatal signal.  The abort still occurs
in the case of SIGKILL.

Testing:

localhost ~ # echo "|/usr/bin/sleep 1d" > /proc/sys/kernel/core_pattern
localhost ~ # sleep 1d &
[1] 2514
localhost ~ # kill -ABRT $! # Cause coredump
localhost ~ # kill -USR1 $! # Send non-fatal signal
localhost ~ # top -p $! -n1 -b # Verify that we aren't dead or busy waiting
top - 16:45:34 up 2 min,  0 users,  load average: 0.71, 0.42, 0.17
Tasks:   1 total,   0 running,   1 sleeping,   0 stopped,   0 zombie
Cpu(s): 26.0%us,  8.5%sy,  0.0%ni, 65.1%id,  0.2%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:    991516k total,   418556k used,   572960k free,     5948k buffers
Swap:        0k total,        0k used,        0k free,   289928k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2514 root      20   0  1868  392  336 S    0  0.0   0:00.00 sleep

localhost ~ # echo mem > /sys/power/state # Suspend
localhost ~ # top -p $! -n1 -b # Verify that we aren't dead or busy waiting
top - 16:46:46 up 3 min,  0 users,  load average: 1.68, 0.69, 0.28
Tasks:   1 total,   0 running,   1 sleeping,   0 stopped,   0 zombie
Cpu(s): 24.1%us,  7.7%sy,  0.0%ni, 67.9%id,  0.2%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:    991516k total,   419956k used,   571560k free,     5996k buffers
Swap:        0k total,        0k used,        0k free,   290208k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2514 root      20   0  1868  392  336 S    0  0.0   0:00.00 sleep

Addresses http://crosbug.com/21559

Changes since v1:
* Mandeep Singh Baines
  * To prevent blocking suspend, add try_to_freeze().
Changes since v2:
* LKML: <20130215150117.GB30829@redhat.com> Oleg Nestorov
  * Block non-fatal signals to avoid poll_wait busy waiting.
* LKML: <20130215152538.9a61a44e.akpm@linux-foundation.org> Andrew Morton
  * Added comment re: try_to_freeze and clarified commit message.
Changes since v3:
* Mandeep Singh Baines
  * Clear signal pending caused by fake signal from freeze_task().
  * Document how the patch was tested.

Signed-off-by: Ben Chan <benchan@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 fs/coredump.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1774932..3c5a08f 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -32,6 +32,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -410,6 +411,11 @@ static void coredump_finish(struct mm_struct *mm)
 static void wait_for_dump_helpers(struct file *file)
 {
 	struct pipe_inode_info *pipe;
+	sigset_t blocked, previous;
+
+	/* Block all but fatal signals. */
+	siginitsetinv(&blocked, sigmask(SIGKILL));
+	sigprocmask(SIG_BLOCK, &blocked, &previous);
 
 	pipe = file->f_path.dentry->d_inode->i_pipe;
 
@@ -417,16 +423,29 @@ static void wait_for_dump_helpers(struct file *file)
 	pipe->readers++;
 	pipe->writers--;
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
+	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		pipe_wait(pipe);
+
+		/*
+		 * Non-fatal signals are blocked. So we need to try
+		 * to freeze in order to not block suspend.
+		 */
+		pipe_unlock(pipe);
+		try_to_freeze();
+		pipe_lock(pipe);
+
+		/* Clear fake signal from freeze_task. */
+		recalc_sigpending();
 	}
 
 	pipe->readers--;
 	pipe->writers++;
 	pipe_unlock(pipe);
 
+	/* Restore signals. */
+	sigprocmask(SIG_SETMASK, &previous, NULL);
 }
 
 /*
-- 
1.7.12.4

