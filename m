Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3I2GP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:15:27 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42063 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3I2GOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:14:55 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/5] pipe: Do not use sync wakeups
Date: Sun, 29 Sep 2013 15:14:38 +0900
Message-Id: <1380435278-10927-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
References: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sync wakeup is a hint to the scheduler that means a waker would go to
sleep right soon.  So don't use the sync wakeup unless it guarantees
to sleep.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/pipe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index d2c45e14e6d8..58f4b9b009da 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -479,7 +479,7 @@ redo:
 
 	/* Signal writers asynchronously that there is more room. */
 	if (do_wakeup) {
-		wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT | POLLWRNORM);
+		wake_up_interruptible_poll(&pipe->wait, POLLOUT | POLLWRNORM);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
 	if (ret > 0)
@@ -660,7 +660,7 @@ redo2:
 out:
 	__pipe_unlock(pipe);
 	if (do_wakeup) {
-		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
+		wake_up_interruptible_poll(&pipe->wait, POLLIN | POLLRDNORM);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
 	if (ret > 0) {
@@ -739,7 +739,7 @@ pipe_release(struct inode *inode, struct file *file)
 		pipe->writers--;
 
 	if (pipe->readers || pipe->writers) {
-		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM | POLLERR | POLLHUP);
+		wake_up_interruptible_poll(&pipe->wait, POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM | POLLERR | POLLHUP);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
-- 
1.7.9.2

