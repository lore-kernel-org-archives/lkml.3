Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab3BOAIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 19:08:09 -0500
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40619 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759753Ab3BOAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 19:08:07 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ben Chan <benchan@chromium.org>, Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 5/5] coredump: abort core dump piping only due to a fatal signal
Date: Thu, 14 Feb 2013 15:38:16 -0800
Message-Id: <1360885096-21207-5-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360885096-21207-1-git-send-email-msb@chromium.org>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Chan <benchan@chromium.org>

This patch makes wait_for_dump_helpers() not to abort piping the core
dump data when the crashing process has received any but a fatal signal
(SIGKILL). The rationale is that a crashing process may still receive
uninteresting signals such as SIGCHLD when its core dump data is being
redirected to a helper application. While it's necessary to allow
terminating the core dump piping via SIGKILL, it's practically more
useful for the purpose of debugging and crash reporting if the core dump
piping is not aborted due to other non-fatal signals.

Signed-off-by: Ben Chan <benchan@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 fs/coredump.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1774932..54e31a3 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -32,6 +32,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -417,10 +418,13 @@ static void wait_for_dump_helpers(struct file *file)
 	pipe->readers++;
 	pipe->writers--;
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
+	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		pipe_wait(pipe);
+		pipe_unlock(pipe);
+		try_to_freeze();
+		pipe_lock(pipe);
 	}
 
 	pipe->readers--;
-- 
1.8.1

