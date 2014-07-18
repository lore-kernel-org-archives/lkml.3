Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbaGRKjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761443AbaGRKiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:11 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/8] GFS2: Allow caching of glocks for flock
Date: Fri, 18 Jul 2014 11:37:43 +0100
Message-Id: <1405679865-15728-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removes the GLF_NOCACHE flag from the glocks associated with
flocks. There should be no good reason not to cache glocks for flocks:
they only force the glock to be demoted before they can be reacquired,
which can slow down performance and even cause glock hangs, especially
in cases where the flocks are held in Shared (SH) mode.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 491e8e0..26b3f95 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -981,7 +981,7 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 	int error = 0;
 
 	state = (fl->fl_type == F_WRLCK) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
-	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE;
+	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT;
 
 	mutex_lock(&fp->f_fl_mutex);
 
-- 
1.8.3.1

