Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746Ab3IHDVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56259 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757007Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Turner" <pjt@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Zhu Yanhai" <gaoyang.zyh@taobao.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.203000298@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [004/121] sched: Fix the broken sched_rr_get_interval()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanhai <gaoyang.zyh@taobao.com>

commit a59f4e079d19464eebb9b06513a1d4f55fdae5ba upstream.

The caller of sched_sliced() should pass se.cfs_rq and se as the
arguments, however in sched_rr_get_interval() we gave it
rq.cfs_rq and se, which made the following computation obviously
wrong.

The change was introduced by commit:

  77034937dc45 sched: fix crash in sys_sched_rr_get_interval()

... 5 years ago, while it had been the correct 'cfs_rq_of' before
the commit. The change seems to be irrelevant to the commit
msg, which was to return a 0 timeslice for tasks that are on an
idle runqueue. So I believe that was just a plain typo.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1357621012-15039-1-git-send-email-gaoyang.zyh@taobao.com
[ Since this is an ABI and an old bug, we'll test this via a
  slow upstream route, to hopefully discover any app breakage. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -5033,7 +5033,7 @@ static unsigned int get_rr_interval_fair
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }

