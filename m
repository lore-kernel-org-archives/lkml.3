Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaCCLMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:12:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbaCCLMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:12:35 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] fanotify: Reorganize loop in fanotify_read()
Date: Mon,  3 Mar 2014 12:12:22 +0100
Message-Id: <1393845143-28007-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393845143-28007-1-git-send-email-jack@suse.cz>
References: <1393845143-28007-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap the error / "read ok" branches in the main loop of fanotify_read().
We will grow the "read ok" part in the next patch and this makes the
indentation easier. Also it is more common to have error conditions
inside an 'if' instead of the fast path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 46 ++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index e0379d725cd9..68a06a7b5659 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -272,35 +272,37 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
 
-		if (kevent) {
+		if (IS_ERR(kevent)) {
 			ret = PTR_ERR(kevent);
-			if (IS_ERR(kevent))
+			break;
+		}
+
+		if (!kevent) {
+			ret = -EAGAIN;
+			if (file->f_flags & O_NONBLOCK)
 				break;
-			ret = copy_event_to_user(group, kevent, buf);
-			/*
-			 * Permission events get queued to wait for response.
-			 * Other events can be destroyed now.
-			 */
-			if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
-				fsnotify_destroy_event(group, kevent);
-			if (ret < 0)
+
+			ret = -ERESTARTSYS;
+			if (signal_pending(current))
+				break;
+
+			if (start != buf)
 				break;
-			buf += ret;
-			count -= ret;
+			schedule();
 			continue;
 		}
 
-		ret = -EAGAIN;
-		if (file->f_flags & O_NONBLOCK)
-			break;
-		ret = -ERESTARTSYS;
-		if (signal_pending(current))
-			break;
-
-		if (start != buf)
+		ret = copy_event_to_user(group, kevent, buf);
+		/*
+		 * Permission events get queued to wait for response.  Other
+		 * events can be destroyed now.
+		 */
+		if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+			fsnotify_destroy_event(group, kevent);
+		if (ret < 0)
 			break;
-
-		schedule();
+		buf += ret;
+		count -= ret;
 	}
 
 	finish_wait(&group->notification_waitq, &wait);
-- 
1.8.1.4

