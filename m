Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaA1TXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:23:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaA1TXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:23:20 -0500
Date: Tue, 28 Jan 2014 11:22:32 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a57beec5d427086cdc8d75fd51164577193fa7f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, davej@redhat.com, tt.rantala@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, tt.rantala@gmail.com,
        davej@redhat.com
In-Reply-To: <20140127105413.GC11314@laptop.programming.kicks-ass.net>
References: <20140127105413.GC11314@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched: Make sched_class::get_rr_interval()
  optional
Git-Commit-ID: a57beec5d427086cdc8d75fd51164577193fa7f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:22:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a57beec5d427086cdc8d75fd51164577193fa7f4
Gitweb:     http://git.kernel.org/tip/a57beec5d427086cdc8d75fd51164577193fa7f4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 27 Jan 2014 11:54:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 13:08:41 +0100

sched: Make sched_class::get_rr_interval() optional

Not all classes implement (or can implement) a useful get_rr_interval()
function, default to a 0 time-slice for them.

This fixes a crash reported by Tommi Rantala.

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140127105413.GC11314@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 36c951b..81343d6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4324,7 +4324,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 		goto out_unlock;
 
 	rq = task_rq_lock(p, &flags);
-	time_slice = p->sched_class->get_rr_interval(rq, p);
+	time_slice = 0;
+	if (p->sched_class->get_rr_interval)
+		time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, p, &flags);
 
 	rcu_read_unlock();
