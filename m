Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbaKNBjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:39:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934900AbaKNBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:38:16 -0500
Date: Fri, 14 Nov 2014 02:38:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rik van Riel <riel@redhat.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] exit: release_task: fix the comment about group leader
	accounting
Message-ID: <20141114013823.GA5129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114013750.GA4697@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contrary to what the comment in __exit_signal() says we do account the
group leader. Fix this and explain why.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index e0914eb..f773863 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -118,13 +118,10 @@ static void __exit_signal(struct task_struct *tsk)
 	}
 
 	/*
-	 * Accumulate here the counters for all threads but the group leader
-	 * as they die, so they can be added into the process-wide totals
-	 * when those are taken.  The group leader stays around as a zombie as
-	 * long as there are other threads.  When it gets reaped, the exit.c
-	 * code will add its counts into these totals.  We won't ever get here
-	 * for the group leader, since it will have been the last reference on
-	 * the signal_struct.
+	 * Accumulate here the counters for all threads as they die. We could
+	 * skip the group leader because it is the last user of signal_struct,
+	 * but we want to avoid the race with thread_group_cputime() which can
+	 * see the empty ->thread_head list.
 	 */
 	task_cputime(tsk, &utime, &stime);
 	write_seqlock(&sig->stats_lock);
-- 
1.5.5.1

