Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaEWSSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:18:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36326 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaEWSQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:56 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 12/16] sched: Task wakeup tracking
Date: Fri, 23 May 2014 19:16:39 +0100
Message-Id: <1400869003-27769-13-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:54.0213 (UTC) FILETIME=[2CEF2F50:01CF76B3]
X-MC-Unique: 114052319165415001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIIfPl005175

Track task wakeup rate in wakeup_avg_sum by counting wakeups. Note that
this is _not_ cpu wakeups (idle exits). Task wakeups only cause cpu
wakeups if the cpu is idle when the task wakeup occurs.

The wakeup rate decays over time at the same rate as used for the
existing entity load tracking. Unlike runnable_avg_sum, wakeup_avg_sum
is counting events, not time, and is therefore theoretically unbounded
and should be used with care.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/linux/sched.h |    3 +++
 kernel/sched/fair.c   |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 727b936..d7b032f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1109,6 +1109,9 @@ struct sched_avg {
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
+
+	unsigned long last_wakeup_update;
+	u32 wakeup_avg_sum;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 09e5232..39e9cd8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -679,6 +679,8 @@ void init_task_runnable_average(struct task_struct *p)
 	p->se.avg.runnable_avg_sum = slice;
 	p->se.avg.runnable_avg_period = slice;
 	__update_task_entity_contrib(&p->se);
+
+	p->se.avg.last_wakeup_update = jiffies;
 }
 #else
 void init_task_runnable_average(struct task_struct *p)
@@ -4025,6 +4027,21 @@ static void record_wakee(struct task_struct *p)
 	}
 }
 
+static void update_wakeup_avg(struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct sched_avg *sa = &se->avg;
+	unsigned long now = ACCESS_ONCE(jiffies);
+
+	if (time_after(now, sa->last_wakeup_update)) {
+		sa->wakeup_avg_sum = decay_load(sa->wakeup_avg_sum,
+				jiffies_to_msecs(now - sa->last_wakeup_update));
+		sa->last_wakeup_update = now;
+	}
+
+	sa->wakeup_avg_sum += 1024;
+}
+
 static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
@@ -4045,6 +4062,7 @@ static void task_waking_fair(struct task_struct *p)
 
 	se->vruntime -= min_vruntime;
 	record_wakee(p);
+	update_wakeup_avg(p);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-- 
1.7.9.5


