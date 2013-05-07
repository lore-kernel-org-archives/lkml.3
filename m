Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab3EGNob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:44:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3EGNmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 113/118] fs/dcache.c: add cond_resched() to shrink_dcache_parent()
Date: Tue,  7 May 2013 14:39:19 +0100
Message-Id: <1367933964-1564-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Thelen <gthelen@google.com>

commit 421348f1ca0bf17769dee0aed4d991845ae0536d upstream.

Call cond_resched() in shrink_dcache_parent() to maintain interactivity.

Before this patch:

	void shrink_dcache_parent(struct dentry * parent)
	{
		while ((found = select_parent(parent, &dispose)) != 0)
			shrink_dentry_list(&dispose);
	}

select_parent() populates the dispose list with dentries which
shrink_dentry_list() then deletes.  select_parent() carefully uses
need_resched() to avoid doing too much work at once.  But neither
shrink_dcache_parent() nor its called functions call cond_resched().  So
once need_resched() is set select_parent() will return single dentry
dispose list which is then deleted by shrink_dentry_list().  This is
inefficient when there are a lot of dentry to process.  This can cause
softlockup and hurts interactivity on non preemptable kernels.

This change adds cond_resched() in shrink_dcache_parent().  The benefit
of this is that need_resched() is quickly cleared so that future calls
to select_parent() are able to efficiently return a big batch of dentry.

These additional cond_resched() do not seem to impact performance, at
least for the workload below.

Here is a program which can cause soft lockup if other system activity
sets need_resched().

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
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 458ec45..9b36632 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1254,8 +1254,10 @@ void shrink_dcache_parent(struct dentry * parent)
 	LIST_HEAD(dispose);
 	int found;
 
-	while ((found = select_parent(parent, &dispose)) != 0)
+	while ((found = select_parent(parent, &dispose)) != 0) {
 		shrink_dentry_list(&dispose);
+		cond_resched();
+	}
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
-- 
1.8.1.2

