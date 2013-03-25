Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab3CYRWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:22:37 -0400
Received: from mail-gg0-f201.google.com ([209.85.161.201]:42709 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3CYRWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:22:35 -0400
From: Greg Thelen <gthelen@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] vfs: dcache: cond_resched in shrink_dentry_list
Date: Mon, 25 Mar 2013 10:22:31 -0700
Message-Id: <1364232151-23242-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call cond_resched() from shrink_dentry_list() to preserve
shrink_dcache_parent() interactivity.

void shrink_dcache_parent(struct dentry * parent)
{
	while ((found = select_parent(parent, &dispose)) != 0)
		shrink_dentry_list(&dispose);
}

select_parent() populates the dispose list with dentries which
shrink_dentry_list() then deletes.  select_parent() carefully uses
need_resched() to avoid doing too much work at once.  But neither
shrink_dcache_parent() nor its called functions call cond_resched().
So once need_resched() is set select_parent() will return single
dentry dispose list which is then deleted by shrink_dentry_list().
This is inefficient when there are a lot of dentry to process.  This
can cause softlockup and hurts interactivity on non preemptable
kernels.

This change adds a call to cond_resched() in shrink_dentry_list().
The primary benefit of this is that need_resched() is quickly cleared
so that future calls to select_parent() are able to efficiently return
a big batch of dentry.  A theoretically secondary benefit of this
change is that shrink_dentry_list() is willing to give up the
processor when working on a huge number of dentry.

These additional cond_resched() do not seem to impact performance, at
least for the workload below.

Here is a program which can cause soft lockup on a if other system
activity sets need_resched().

	int main()
	{
	        struct rlimit rlim;
	        int i;
	        int f[100000];
	        char buf[20];
	        struct timeval t1, t2;
	        double diff;

	        /* cleanup past run */
	        system("rm -rf x");

	        /* boost nfile rlimit */
	        rlim.rlim_cur = 200000;
	        rlim.rlim_max = 200000;
	        if (setrlimit(RLIMIT_NOFILE, &rlim))
	                err(1, "setrlimit");

	        /* make directory for files */
	        if (mkdir("x", 0700))
	                err(1, "mkdir");

	        if (gettimeofday(&t1, NULL))
	                err(1, "gettimeofday");

	        /* populate directory with open files */
	        for (i = 0; i < 100000; i++) {
	                snprintf(buf, sizeof(buf), "x/%d", i);
	                f[i] = open(buf, O_CREAT);
	                if (f[i] == -1)
	                        err(1, "open");
	        }

	        /* close some of the files */
	        for (i = 0; i < 85000; i++)
	                close(f[i]);

	        /* unlink all files, even open ones */
	        system("rm -rf x");

	        if (gettimeofday(&t2, NULL))
	                err(1, "gettimeofday");

	        diff = (((double)t2.tv_sec * 1000000 + t2.tv_usec) -
	                ((double)t1.tv_sec * 1000000 + t1.tv_usec));

	        printf("done: %g elapsed\n", diff/1e6);
	        return 0;
	}

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 fs/dcache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index fbfae008..105e973 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -818,6 +818,8 @@ static void shrink_dentry_list(struct list_head *list)
 
 		try_prune_one_dentry(dentry);
 
+		cond_resched();
+
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
1.8.1.3

