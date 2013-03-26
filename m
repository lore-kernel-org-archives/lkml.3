Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab3CZEgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:36:19 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:51607 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3CZEgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:36:16 -0400
From: Greg Thelen <gthelen@google.com>
To: Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: dcache: cond_resched in shrink_dentry_list
References: <1364232151-23242-1-git-send-email-gthelen@google.com>
	<20130325235614.GI6369@dastard>
	<xr93fvzjgfke.fsf@gthelen.mtv.corp.google.com>
	<20130326024032.GJ6369@dastard>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 21:36:14 -0700
Message-ID: <xr934nfyg4ld.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25 2013, Dave Chinner wrote:

> On Mon, Mar 25, 2013 at 05:39:13PM -0700, Greg Thelen wrote:
>> On Mon, Mar 25 2013, Dave Chinner wrote:
>> > On Mon, Mar 25, 2013 at 10:22:31AM -0700, Greg Thelen wrote:
>> >> Call cond_resched() from shrink_dentry_list() to preserve
>> >> shrink_dcache_parent() interactivity.
>> >> 
>> >> void shrink_dcache_parent(struct dentry * parent)
>> >> {
>> >> 	while ((found = select_parent(parent, &dispose)) != 0)
>> >> 		shrink_dentry_list(&dispose);
>> >> }
>> >> 
>> >> select_parent() populates the dispose list with dentries which
>> >> shrink_dentry_list() then deletes.  select_parent() carefully uses
>> >> need_resched() to avoid doing too much work at once.  But neither
>> >> shrink_dcache_parent() nor its called functions call cond_resched().
>> >> So once need_resched() is set select_parent() will return single
>> >> dentry dispose list which is then deleted by shrink_dentry_list().
>> >> This is inefficient when there are a lot of dentry to process.  This
>> >> can cause softlockup and hurts interactivity on non preemptable
>> >> kernels.
>> >
>> > Hi Greg,
>> >
>> > I can see how this coul dcause problems, but isn't the problem then
>> > that shrink_dcache_parent()/select_parent() itself is mishandling
>> > the need for rescheduling rather than being a problem with
>> > the shrink_dentry_list() implementation?  i.e. select_parent() is
>> > aborting batching based on a need for rescheduling, but then not
>> > doing that itself and assuming that someone else will do the
>> > reschedule for it?
>> >
>> > Perhaps this is a better approach:
>> >
>> > -	while ((found = select_parent(parent, &dispose)) != 0)
>> > +	while ((found = select_parent(parent, &dispose)) != 0) {
>> >                 shrink_dentry_list(&dispose);
>> > +		cond_resched();
>> > +	}
>> >
>> > With this, select_parent() stops batching when a resched is needed,
>> > we dispose of the list as a single batch and only then resched if it
>> > was needed before we go and grab the next batch. That should fix the
>> > "small batch" problem without the potential for changing the
>> > shrink_dentry_list() behaviour adversely for other users....
>> 
>> I considered only modifying shrink_dcache_parent() as you show above.
>> Either approach fixes the problem I've seen.  My initial approach adds
>> cond_resched() deeper into shrink_dentry_list() because I thought that
>> there might a secondary benefit: shrink_dentry_list() would be willing
>> to give up the processor when working on a huge number of dentry.  This
>> could improve interactivity during shrinker and umount.  I don't feel
>> strongly on this and would be willing to test and post the
>> add-cond_resched-to-shrink_dcache_parent approach.
>
> The shrinker has interactivity problems because of the global
> dcache_lru_lock, not because of ithe size of the list passed to
> shrink_dentry_list(). The amount of work that shrink_dentry_list()
> does here is already bound by the shrinker batch size. Hence in the
> absence of the RT folk complaining about significant holdoffs I
> don't think there is an interactivity problem through the shrinker
> path.

No arguments from me.

> As for the unmount path - shrink_dcache_for_umount_subtree() - that
> doesn't use shrink_dentry_list() and so would need it's own internal
> calls to cond_resched().  Perhaps it's shrink_dcache_sb() that you
> are concerned about?  Either way, And there are lots more similar
> issues in the unmount path such as evict_inodes(), so unless you are
> going to give every possible path through unmount/remount/bdev
> invalidation the same treatment then changing shrink_dentry_list()
> won't significantly improve the interactivity of the system
> situation in these paths...

Ok.  As stated, I wasn't sure if the cond_resched() in
shrink_dentry_list() had any appeal.  Apparently it doesn't.  I'll drop
this approach in favor of the following:

--->8---

From: Greg Thelen <gthelen@google.com>
Date: Sat, 23 Mar 2013 18:25:02 -0700
Subject: [PATCH] vfs: dcache: cond_resched in shrink_dcache_parent

Call cond_resched() in shrink_dcache_parent() to maintain
interactivity.

Before this patch:

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

This change adds cond_resched() in shrink_dcache_parent().  The
benefit of this is that need_resched() is quickly cleared so that
future calls to select_parent() are able to efficiently return a big
batch of dentry.

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
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/dcache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index fbfae008..e52c07e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1230,8 +1230,10 @@ void shrink_dcache_parent(struct dentry * parent)
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
1.8.1.3


