Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3I2GPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:15:19 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46065 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3I2GOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:14:50 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] splice: Add sync parameter to wakeup_pipe_writers()
Date: Sun, 29 Sep 2013 15:14:36 +0900
Message-Id: <1380435278-10927-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
References: <1380435278-10927-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can handle both of sync and normal wakeups in one place.
Although it doesn't have any sync user, it'll be introduced soon.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/splice.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 77251152e1b8..0325e8b0d816 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -765,11 +765,15 @@ out:
 }
 EXPORT_SYMBOL(pipe_to_file);
 
-static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
+static void wakeup_pipe_writers(struct pipe_inode_info *pipe, bool sync)
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
 	kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 }
 
@@ -868,7 +872,7 @@ int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
 			return -ERESTARTSYS;
 
 		if (sd->need_wakeup) {
-			wakeup_pipe_writers(pipe);
+			wakeup_pipe_writers(pipe, false);
 			sd->need_wakeup = false;
 		}
 
@@ -908,7 +912,7 @@ EXPORT_SYMBOL(splice_from_pipe_begin);
 void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_desc *sd)
 {
 	if (sd->need_wakeup)
-		wakeup_pipe_writers(pipe);
+		wakeup_pipe_writers(pipe, false);
 }
 EXPORT_SYMBOL(splice_from_pipe_end);
 
@@ -1935,7 +1939,7 @@ retry:
 		wakeup_pipe_readers(opipe, false);
 
 	if (input_wakeup)
-		wakeup_pipe_writers(ipipe);
+		wakeup_pipe_writers(ipipe, false);
 
 	return ret;
 }
-- 
1.7.9.2

