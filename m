Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaIOJeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbaIOJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/6] GFS2: Request demote when a "try" flock fails
Date: Mon, 15 Sep 2014 10:32:45 +0100
Message-Id: <1410773568-1573-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
References: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes the flock code so that it uses the TRY_1CB flag
instead of the TRY flag on the first attempt. That forces any holding
nodes to issue a dlm callback, which requests a demote of the glock.
Then, if the "try" failed, it sleeps a small amount of time for the
demote to occur. Then it tries again, for an increasing amount of time.
Subsequent attempts to gain the "try" lock don't use "_1CB" so that
only one callback is issued.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 26b3f95..7f4ed3d 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -26,6 +26,7 @@
 #include <linux/dlm.h>
 #include <linux/dlm_plock.h>
 #include <linux/aio.h>
+#include <linux/delay.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -979,9 +980,10 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 	unsigned int state;
 	int flags;
 	int error = 0;
+	int sleeptime;
 
 	state = (fl->fl_type == F_WRLCK) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
-	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT;
+	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY_1CB) | GL_EXACT;
 
 	mutex_lock(&fp->f_fl_mutex);
 
@@ -1001,7 +1003,14 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 		gfs2_holder_init(gl, state, flags, fl_gh);
 		gfs2_glock_put(gl);
 	}
-	error = gfs2_glock_nq(fl_gh);
+	for (sleeptime = 1; sleeptime <= 4; sleeptime <<= 1) {
+		error = gfs2_glock_nq(fl_gh);
+		if (error != GLR_TRYFAILED)
+			break;
+		fl_gh->gh_flags = LM_FLAG_TRY | GL_EXACT;
+		fl_gh->gh_error = 0;
+		msleep(sleeptime);
+	}
 	if (error) {
 		gfs2_holder_uninit(fl_gh);
 		if (error == GLR_TRYFAILED)
@@ -1024,7 +1033,7 @@ static void do_unflock(struct file *file, struct file_lock *fl)
 	mutex_lock(&fp->f_fl_mutex);
 	flock_lock_file_wait(file, fl);
 	if (fl_gh->gh_gl) {
-		gfs2_glock_dq_wait(fl_gh);
+		gfs2_glock_dq(fl_gh);
 		gfs2_holder_uninit(fl_gh);
 	}
 	mutex_unlock(&fp->f_fl_mutex);
-- 
1.8.3.1

