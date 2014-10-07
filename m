Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaJGI7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:59:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48171 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaJGI7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:59:20 -0400
Message-ID: <5433AB8A.7050908@arm.com>
Date: Tue, 07 Oct 2014 09:59:54 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "michael@amarulasolutions.com" <michael@amarulasolutions.com>,
        "fchecconi@gmail.com" <fchecconi@gmail.com>,
        "daniel.wagner@bmw-carit.de" <daniel.wagner@bmw-carit.de>,
        "vincent@legout.info" <vincent@legout.info>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-3-git-send-email-juri.lelli@arm.com> <20140919212547.GG2832@worktop.localdomain>
In-Reply-To: <20140919212547.GG2832@worktop.localdomain>
X-OriginalArrivalTime: 07 Oct 2014 08:59:14.0178 (UTC) FILETIME=[F7CAC620:01CFE20C]
X-MC-Unique: 114100709591608901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 19/09/14 22:25, Peter Zijlstra wrote:
> On Fri, Sep 19, 2014 at 10:22:40AM +0100, Juri Lelli wrote:
>> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
>> affinity (performing what is commonly called clustered scheduling).
>> Unfortunately, such thing is currently broken for two reasons:
>>
>>  - No check is performed when the user tries to attach a task to
>>    an exlusive cpuset (recall that exclusive cpusets have an
>>    associated maximum allowed bandwidth).
>>
>>  - Bandwidths of source and destination cpusets are not correctly
>>    updated after a task is migrated between them.
>>
>> This patch fixes both things at once, as they are opposite faces
>> of the same coin.
>>
>> The check is performed in cpuset_can_attach(), as there aren't any
>> points of failure after that function. The updated is split in two
>> halves. We first reserve bandwidth in the destination cpuset, after
>> we pass the check in cpuset_can_attach(). And we then release
>> bandwidth from the source cpuset when the task's affinity is
>> actually changed. Even if there can be time windows when sched_setattr()
>> may erroneously fail in the source cpuset, we are fine with it, as
>> we can't perfom an atomic update of both cpusets at once.
> 
> The thing I cannot find is if we correctly deal with updates to the
> cpuset. Say we first setup 2 (exclusive) sets A:cpu0 B:cpu1-3. Then
> assign tasks and then update the cpu masks like: B:cpu2,3, A:cpu1,2.
> 

So, what follows should address the problem you describe.

Assuming you intended that we try to update masks as A:cpu0,3 and
B:cpu1,2, with what below we are able to check that removing cpu3
from B doesn't break guarantees. After that cpu3 can be put in A.

Does it make any sense?

Thanks,

- Juri

>From 0e52c2211879eec92cd435e7717ab628f3b3084b Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@arm.com>
Date: Tue, 7 Oct 2014 09:52:11 +0100
Subject: [PATCH] sched/deadline: ensure that updates to exclusive cpusets
 don't break AC

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
---
 include/linux/sched.h |  2 ++
 kernel/cpuset.c       | 10 ++++++++++
 kernel/sched/core.c   | 19 +++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 163295f..24696d3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2041,6 +2041,8 @@ static inline void tsk_restore_flags(struct task_struct *task,
 	task->flags |= orig_flags & flags;
 }
 
+extern int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+				     const struct cpumask *trial);
 extern int task_can_attach(struct task_struct *p,
 			   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4a7ebde..f96b47f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -506,6 +506,16 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 			goto out;
 	}
 
+	/*
+	 * We can't shrink if we won't have enough room for SCHED_DEADLINE
+	 * tasks.
+	 */
+	ret = -EBUSY;
+	if (is_cpu_exclusive(cur) &&
+	    !cpuset_cpumask_can_shrink(cur->cpus_allowed,
+				       trial->cpus_allowed))
+		goto out;
+
 	ret = 0;
 out:
 	rcu_read_unlock();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 092143d..b4bd8fa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4587,6 +4587,25 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
 
+int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+			      const struct cpumask *trial)
+{
+	int ret = 1, trial_cpus;
+	struct dl_bw *cur_dl_b;
+	unsigned long flags;
+
+	cur_dl_b = dl_bw_of(cpumask_any(cur));
+	trial_cpus = cpumask_weight(trial);
+
+	raw_spin_lock_irqsave(&cur_dl_b->lock, flags);
+	if (cur_dl_b->bw != -1 &&
+	    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
+		ret = 0;
+	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+
+	return ret;
+}
+
 int task_can_attach(struct task_struct *p,
 		    const struct cpumask *cs_cpus_allowed)
 {
-- 
2.1.0

