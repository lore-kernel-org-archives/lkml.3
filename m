Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967331Ab3HIBya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:54:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967140Ab3HIBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:42:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 11/25] sched: Fix the broken sched_rr_get_interval()
Date: Thu,  8 Aug 2013 18:41:47 -0700
Message-Id: <20130809013651.623921789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809013649.057678051@linuxfoundation.org>
References: <20130809013649.057678051@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5511,7 +5511,7 @@ static unsigned int get_rr_interval_fair
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }


