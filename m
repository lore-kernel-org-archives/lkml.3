Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaEZVpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:45:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35852 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaEZVpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:45:47 -0400
Date: Mon, 26 May 2014 14:44:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Shrinkers and proportional reclaim
In-Reply-To: <1400749779-24879-1-git-send-email-mgorman@suse.de>
Message-ID: <alpine.LSU.2.11.1405261441320.7154@eggly.anvils>
References: <1400749779-24879-1-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Mel Gorman wrote:

> This series is aimed at regressions noticed during reclaim activity. The
> first two patches are shrinker patches that were posted ages ago but never
> merged for reasons that are unclear to me. I'm posting them again to see if
> there was a reason they were dropped or if they just got lost. Dave?  Time?
> The last patch adjusts proportional reclaim. Yuanhan Liu, can you retest
> the vm scalability test cases on a larger machine? Hugh, does this work
> for you on the memcg test cases?

Yes it does, thank you.

Though the situation is muddy, since on our current internal tree, I'm
surprised to find that the memcg test case no longer fails reliably
without our workaround and without your fix.

"Something must have changed"; but it would take a long time to work
out what.  If I travel back in time with git, to where we first applied
the "vindictive" patch, then yes that test case convincingly fails
without either (my or your) patch, and passes with either patch.

And you have something that satisfies Yuanhan too, that's great.

I'm also pleased to see Dave and Tim reduce the contention in
grab_super_passive(): that's a familiar symbol from livelock dumps.

You might want to add this little 4/3, that we've had in for a
while; but with grab_super_passive() out of super_cache_count(),
it will have much less importance.


[PATCH 4/3] fs/superblock: Avoid counting without __GFP_FS

Don't waste time counting objects in super_cache_count() if no __GFP_FS:
super_cache_scan() would only back out with SHRINK_STOP in that case.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 fs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- melgo/fs/super.c	2014-05-26 13:39:33.000131904 -0700
+++ linux/fs/super.c	2014-05-26 13:56:19.012155813 -0700
@@ -110,6 +110,12 @@ static unsigned long super_cache_count(s
 	struct super_block *sb;
 	long	total_objects = 0;
 
+	/*
+	 * None can be freed without __GFP_FS, so don't waste time counting.
+	 */
+	if (!(sc->gfp_mask & __GFP_FS))
+		return 0;
+
 	sb = container_of(shrink, struct super_block, s_shrink);
 
 	/*
