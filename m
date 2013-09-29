Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3I2GPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:15:17 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44532 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3I2GOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:14:48 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] splice: Add sync parameter to wakeup_pipe_readers()
Date: Sun, 29 Sep 2013 15:14:35 +0900
Message-Id: <1380435278-10927-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
References: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can handle both of sync and normal wakeups in one place.
And convert a sync user to reuse it.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/splice.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 320cc65585b2..77251152e1b8 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -164,11 +164,15 @@ static const struct pipe_buf_operations user_page_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
-static void wakeup_pipe_readers(struct pipe_inode_info *pipe)
+static void wakeup_pipe_readers(struct pipe_inode_info *pipe, bool sync)
 {
 	smp_mb();
-	if (waitqueue_active(&pipe->wait))
-		wake_up_interruptible(&pipe->wait);
+	if (waitqueue_active(&pipe->wait)) {
+		if (sync)
+			wake_up_interruptible_sync(&pipe->wait);
+		else
+			wake_up_interruptible(&pipe->wait);
+	}
 	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 }
 
@@ -243,10 +247,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		}
 
 		if (do_wakeup) {
-			smp_mb();
-			if (waitqueue_active(&pipe->wait))
-				wake_up_interruptible_sync(&pipe->wait);
-			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+			wakeup_pipe_readers(pipe, true);
 			do_wakeup = 0;
 		}
 
@@ -258,7 +259,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 	pipe_unlock(pipe);
 
 	if (do_wakeup)
-		wakeup_pipe_readers(pipe);
+		wakeup_pipe_readers(pipe, false);
 
 	while (page_nr < spd_pages)
 		spd->spd_release(spd, page_nr++);
@@ -1931,7 +1932,7 @@ retry:
 	 * If we put data in the output pipe, wakeup any potential readers.
 	 */
 	if (ret > 0)
-		wakeup_pipe_readers(opipe);
+		wakeup_pipe_readers(opipe, false);
 
 	if (input_wakeup)
 		wakeup_pipe_writers(ipipe);
@@ -2012,7 +2013,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 	 * If we put data in the output pipe, wakeup any potential readers.
 	 */
 	if (ret > 0)
-		wakeup_pipe_readers(opipe);
+		wakeup_pipe_readers(opipe, false);
 
 	return ret;
 }
-- 
1.7.9.2

