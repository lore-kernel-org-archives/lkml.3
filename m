Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaABM3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:29:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaABM2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:28:48 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/6] GFS2: Fix unsafe dereference in dump_holder()
Date: Thu,  2 Jan 2014 12:28:14 +0000
Message-Id: <1388665694-1639-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
References: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

GLOCK_BUG_ON() might call this function without RCU read lock. Make sure that
RCU read lock is held when using task_struct returned from pid_task().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c8420f7..6f7a47c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1655,6 +1655,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 	struct task_struct *gh_owner = NULL;
 	char flags_buf[32];
 
+	rcu_read_lock();
 	if (gh->gh_owner_pid)
 		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
 	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
@@ -1664,6 +1665,7 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
 		       gh_owner ? gh_owner->comm : "(ended)",
 		       (void *)gh->gh_ip);
+	rcu_read_unlock();
 	return 0;
 }
 
-- 
1.8.3.1

