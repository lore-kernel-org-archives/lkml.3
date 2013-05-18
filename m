Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab3ERDAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831Ab3ERDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:33 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xk-AZOMFybkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=BSAgiG1IjQkA:10 a=1XWaLZrsAAAA:8 a=7-415B0cAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=TMfZduu8ABQO1fGtqU0A:9 a=UTB_XpHje0EA:10 a=FtYAf7_czLgA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021651.581887769@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>,
        <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [ 061/136 ] fs/dcache.c: add cond_resched() to shrink_dcache_parent()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0061-fs-dcache.c-add-cond_resched-to-shrink_dcache_parent.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Greg Thelen <gthelen@google.com>

[ Upstream commit 421348f1ca0bf17769dee0aed4d991845ae0536d ]

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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 2488c47..0578ce2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1256,8 +1256,10 @@ void shrink_dcache_parent(struct dentry * parent)
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
1.7.10.4


