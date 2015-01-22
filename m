Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbbAVVJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:09:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23167 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbbAVVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:09:06 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>
CC: <Kernel-team@fb.com>, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
Subject: [RFC 2/2] perf: update userspace page info for software event
Date: Thu, 22 Jan 2015 13:09:02 -0800
Message-ID: <e0f8f6f0a114c464e8e38cd73be31564bd5ea7da.1421906750.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <119aa7d433860f568136ab623fb4a510c28e9e6f.1421906750.git.shli@fb.com>
References: <119aa7d433860f568136ab623fb4a510c28e9e6f.1421906750.git.shli@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_08:2015-01-22,2015-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.92412122293584e-09 kscore.compositescore=0
 circleOfTrustscore=514.84 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501220194
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hardware event, the userspace page of the event gets updated in
context switch, so if we read time in the page, we get updated info. For
software event, this is missed currently. This patch makes the behavior
consistency.

With this patch, we can implement clock_gettime(THREAD_CPUTIME) with
PERF_COUNT_SW_DUMMY in userspace as suggested by Andy and Peter. Code
likes this:

  if (pc->cap_user_time) {
	do {
		seq = pc->lock;
		barrier();

		running = pc->time_running;
		cyc = rdtsc();
		time_mult = pc->time_mult;
		time_shift = pc->time_shift;
		time_offset = pc->time_offset;

		barrier();
	} while (pc->lock != seq);

	quot = (cyc >> time_shift);
	rem = cyc & ((1 << time_shift) - 1);
	delta = time_offset + quot * time_mult +
		((rem * time_mult) >> time_shift);

	running += delta;
	return running;
  }

I tried in a busy system, the userspace page updating hasn't noticeable
overhead.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4edde3e..4221240 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5950,6 +5950,7 @@ static int perf_swevent_add(struct perf_event *event, int flags)
 	}
 
 	hlist_add_head_rcu(&event->hlist_entry, head);
+	perf_event_update_userpage(event);
 
 	return 0;
 }
@@ -6419,6 +6420,7 @@ static int cpu_clock_event_add(struct perf_event *event, int flags)
 {
 	if (flags & PERF_EF_START)
 		cpu_clock_event_start(event, flags);
+	perf_event_update_userpage(event);
 
 	return 0;
 }
@@ -6493,6 +6495,7 @@ static int task_clock_event_add(struct perf_event *event, int flags)
 {
 	if (flags & PERF_EF_START)
 		task_clock_event_start(event, flags);
+	perf_event_update_userpage(event);
 
 	return 0;
 }
-- 
1.8.1

