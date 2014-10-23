Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaJWCfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:35:21 -0400
Received: from relay1.sgi.com ([192.48.180.66]:56594 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbaJWCfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:35:19 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: athorlton@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Bob Liu <lliubbo@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Convert khugepaged to a task_work function
Date: Wed, 22 Oct 2014 21:35:02 -0500
Message-Id: <1414031706-101613-1-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey everyone,

Last week, while discussing possible fixes for some unexpected/unwanted behavior
from khugepaged (see: https://lkml.org/lkml/2014/10/8/515) several people
mentioned possibly changing changing khugepaged to work as a task_work function
instead of a kernel thread.  This will give us finer grained control over the
page collapse scans, eliminate some unnecessary scans since tasks that are
relatively inactive will not be scanned often, and eliminate the unwanted
behavior described in the email thread I mentioned.

This initial patch is fully functional, but there are quite a few areas that
will need to be polished up before it's ready to be considered for a merge.  I
wanted to get this initial version out with some basic test results quickly, so
that people can give their opinions and let me know if there's anything they'd
like to see done differently (and there probably is :).  I'll give details on
the code in the individual patches.

I gathered some pretty rudimentary test data using a 48-thread NAMD simulation
pinned to a cpuset with 8 cpus and about 60g of memory.  I'm checking to see if
I'm allowed to publish the input data so that others can replicate the test.  In
the meantime, if somebody knows of a publicly available benchmark that stresses
khugepaged, that would be helpful.

The only data point I gathered was the number of pages collapsed, sampled every
ten seconds, for the lifetime of the job.  This one statistic gives a pretty
decent illustration of the difference in behavior between the two kernels, but I
intend to add some other counters to measure fully completed scans, failed
allocations, and possibly scans skipped due to timer constraints.

The data for the standard kernel (with a very small patch to add the stat
counter that I used to the task_struct) is available here:

http://oss.sgi.com/projects/memtests/pgcollapse/output-khpd

This was a fairly recent kernel (last Tuesday).  Commit ID:
2d65a9f48fcdf7866aab6457bc707ca233e0c791.  I'll send the patches I used for that
kernel as a reply to this message shortly.

The output from the modified kernel is stored here:

http://oss.sgi.com/projects/memtests/pgcollapse/output-pgcollapse

The output is stored in a pretty dumb format (*really* wide).  Best viewed in a
simple text editor with word wrap off, just fyi.

Quick summary of what I found:  Both kernels performed about the same when it
comes to overall runtime, my kernel was 22 seconds faster with a total runtime
of 4:13:07.  Not a significant difference, but important to note that there was
no apparent performance degradation.  The most interesting result is that my
kernel completed the majority of the necessary page collapses for this job in
2:04, whereas the mainline kernel took 29:05 to get to the same point.

Let me know what you think.  Any suggestions are appreciated!

- Alex

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org

Alex Thorlton (4):
  Disable khugepaged thread
  Add pgcollapse controls to task_struct
  Convert khugepaged scan functions to work with task_work
  Add /proc files to expose per-mm pgcollapse stats

 fs/proc/base.c             |  23 +++++++
 include/linux/khugepaged.h |  10 ++-
 include/linux/sched.h      |  16 +++++
 kernel/fork.c              |   7 ++
 kernel/sched/fair.c        |  18 +++++
 mm/huge_memory.c           | 162 +++++++++++++++------------------------------
 6 files changed, 123 insertions(+), 113 deletions(-)

-- 
1.7.12.4

