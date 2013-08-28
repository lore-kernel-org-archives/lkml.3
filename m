Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3H1N5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab3H1N5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:57:20 -0400
Date: Wed, 28 Aug 2013 15:56:34 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
Message-ID: <20130828135634.GC4785@redhat.com>
References: <20130802194659.GP26476@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802194659.GP26476@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Fri, Aug 02, 2013 at 02:46:59PM -0500, Alex Thorlton wrote:
> This patch implements functionality to allow processes to disable the use of
> transparent hugepages through the prctl syscall.
> 
> We've determined that some jobs perform significantly better with thp disabled,
> and we need a way to control thp on a per-process basis, without relying on
> madvise.

Are you using automatic NUMA balancing or CPU pinning or was this a
short lived computation?

If you're not using automatic NUMA balancing or if you're using
automatic NUMA balancing and this is a fairly short lived computation,
zone_reclaim_mode was broken with THP enabled as it never called into
compaction, so with THP enabled you would have a random NUMA placement
during page fault to satisfy hugepage allocation (first priority was
to get any hugepage from any wrong node, only then it would call
compaction).

Did you verify the numa placement that you were getting?

I fixed the zone_reclaim_mode for THP and posted the fixes on
linux-mm, so you may want to try that fix just in case it helps your
workload.

Chances are you work with a big system where zone_reclaim_mode is
enabled by default, and for a test I would suggest you to enable it
once even if it's not enabled by default (after applying the fixes) to
see if it makes any difference.

I just did a push of my latest tree to the master branch of aa.git on
kernel.org, so you can just pull that for a quick test with
zone_reclaim_mode enabled.

NOTE: it's not guaranteed to help but it's worth a try. As you pointed
out if the threads are working on separate 4k fragments, it won't
help. But as things stands now THP enabled would breaks
zone_reclaim_mode and so without hard memory pinning it wouldn't
perform as good as with THP disabled.
