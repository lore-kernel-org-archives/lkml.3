Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab3BPAKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:10:30 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65305 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3BPAK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:10:29 -0500
From: Mandeep Singh Baines <mandeep.baines@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Chan <benchan@chromium.org>, Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v3] coredump: ignore non-fatal signals when core dumping to a pipe
Date: Fri, 15 Feb 2013 16:09:58 -0800
Message-Id: <1360973398-23823-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1360885096-21207-5-git-send-email-msb@chromium.org>
References: <1360885096-21207-5-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Chan <benchan@chromium.org>

Make wait_for_dump_helpers() not abort piping the core dump data when the
crashing process has received a non-fatal signal.  The abort still occurs
in the case of SIGKILL.

Addresses http://crosbug.com/21559

Changes since v1:
* Mandeep Singh Baines
  * To prevent blocking suspend, add try_to_freeze().
Changes since v2:
* LKML: <20130215150117.GB30829@redhat.com> Oleg Nestorov
  * Block non-fatal signals to avoid poll_wait busy waiting.
* LKML: <20130215152538.9a61a44e.akpm@linux-foundation.org> Andrew Morton
  * Added comment re: try_to_freeze and clarified commit message.

Signed-off-by: Ben Chan <benchan@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 fs/coredump.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1774932..976f6cc 100644
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
 
@@ -421,12 +427,22 @@ static void wait_for_dump_helpers(struct file *file)
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

