Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3JLDAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:00:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:33456 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3JLDAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:00:23 -0400
Message-ID: <5258BB05.8030106@huawei.com>
Date: Sat, 12 Oct 2013 10:59:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, anjana vk <anjanvk12@gmail.com>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eunki_kim@samsung.com>
Subject: [PATCH] cgroup: fix to break the while loop in cgroup_attach_task()
 correctly
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com> <20131009133047.GA12414@redhat.com> <20131009140551.GA15849@redhat.com> <20131009165448.GA22437@redhat.com> <5257F9E3.5030708@huawei.com> <20131011160004.GA26416@redhat.com>
In-Reply-To: <20131011160004.GA26416@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anjana V Kumar <anjanavk12@gmail.com>

Both Anjana and Eunki reported a stall in the while_each_thread loop
in cgroup_attach_task().

It's because, when we attach a single thread to a cgroup, if the cgroup
is exiting or is already in that cgroup, we won't break the loop.

If the task is already in the cgroup, the bug can lead to another thread
being attached to the cgroup unexpectedly:

  # echo 5207 > tasks
  # cat tasks
  5207
  # echo 5207 > tasks
  # cat tasks
  5207
  5215

What's worse, if the task to be attached isn't the leader of the thread
group, we might never exit the loop, hence cpu stall. Thanks for Oleg's
analysis.

This bug was introduced by commit 081aa458c38ba576bdd4265fc807fa95b48b9e79
("cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()")

Cc: <stable@vger.kernel.org> # 3.9+
Reported-by: Eunki Kim <eunki_kim@samsung.com>
Reported-by: Anjana V Kumar <anjanavk12@gmail.com>
Signed-off-by: Anjana V Kumar <anjanavk12@gmail.com>
[ lizf: - fixed the first continue, pointed out by Oleg,
        - rewrote changelog. ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5629f1..3db1d2e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2002,7 +2002,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 
 		/* @tsk either already exited or can't exit until the end */
 		if (tsk->flags & PF_EXITING)
-			continue;
+			goto next;
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
@@ -2010,7 +2010,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		ent.cgrp = task_cgroup_from_root(tsk, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
-			continue;
+			goto next;
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2018,7 +2018,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-
+next:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, tsk);
-- 
1.8.0.2

