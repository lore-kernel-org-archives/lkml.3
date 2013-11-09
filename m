Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab3KIHae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:30:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3KIGu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eunki Kim <eunki_kim@samsung.com>,
        Anjana V Kumar <anjanavk12@gmail.com>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 09/74] cgroup: fix to break the while loop in cgroup_attach_task() correctly
Date: Fri,  8 Nov 2013 22:51:14 -0800
Message-Id: <20131109065114.151262963@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjana V Kumar <anjanavk12@gmail.com>

commit ea84753c98a7ac6b74e530b64c444a912b3835ca upstream.

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

[ lizf: - fixed the first continue, pointed out by Oleg,
        - rewrote changelog. ]

Reported-by: Eunki Kim <eunki_kim@samsung.com>
Reported-by: Anjana V Kumar <anjanavk12@gmail.com>
Signed-off-by: Anjana V Kumar <anjanavk12@gmail.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1995,7 +1995,7 @@ static int cgroup_attach_task(struct cgr
 
 		/* @tsk either already exited or can't exit until the end */
 		if (tsk->flags & PF_EXITING)
-			continue;
+			goto next;
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
@@ -2003,7 +2003,7 @@ static int cgroup_attach_task(struct cgr
 		ent.cgrp = task_cgroup_from_root(tsk, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
-			continue;
+			goto next;
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2011,7 +2011,7 @@ static int cgroup_attach_task(struct cgr
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-
+	next:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, tsk);


