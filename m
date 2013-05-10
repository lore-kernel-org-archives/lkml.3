Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3EJOgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:36:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57140 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152Ab3EJOVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Thelen" <gthelen@google.com>,
        "Dave Chinner" <david@fromorbit.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.297696118@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [069/118] fs/dcache.c: add cond_resched() to shrink_dcache_parent()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1176,8 +1176,10 @@ void shrink_dcache_parent(struct dentry
 	LIST_HEAD(dispose);
 	int found;
 
-	while ((found = select_parent(parent, &dispose)) != 0)
+	while ((found = select_parent(parent, &dispose)) != 0) {
 		shrink_dentry_list(&dispose);
+		cond_resched();
+	}
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 

