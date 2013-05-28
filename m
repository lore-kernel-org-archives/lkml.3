Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037Ab3E1NGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:06:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3E1NGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:06:16 -0400
Date: Tue, 28 May 2013 06:05:34 -0700
From: tip-bot for Gerald Schaefer <tipbot@zytor.com>
Message-ID: <tip-41261b6a832ea0e788627f6a8707854423f9ff49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, gerald.schaefer@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, gerald.schaefer@de.ibm.com, tglx@linutronix.de
In-Reply-To: <1369411669-46971-2-git-send-email-gerald.schaefer@de.ibm.com>
References: <1369411669-46971-2-git-send-email-gerald.schaefer@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/autogroup: Fix race with task_groups list
Git-Commit-ID: 41261b6a832ea0e788627f6a8707854423f9ff49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41261b6a832ea0e788627f6a8707854423f9ff49
Gitweb:     http://git.kernel.org/tip/41261b6a832ea0e788627f6a8707854423f9ff49
Author:     Gerald Schaefer <gerald.schaefer@de.ibm.com>
AuthorDate: Fri, 24 May 2013 18:07:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:40:22 +0200

sched/autogroup: Fix race with task_groups list

In autogroup_create(), a tg is allocated and added to the task_groups
list. If CONFIG_RT_GROUP_SCHED is set, this tg is then modified while on
the list, without locking. This can race with someone walking the list,
like __enable_runtime() during CPU unplug, and result in a use-after-free
bug.

To fix this, move sched_online_group(), which adds the tg to the list,
to the end of the autogroup_create() function after the modification.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1369411669-46971-2-git-send-email-gerald.schaefer@de.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/auto_group.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 64de5f8..4a07353 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -77,8 +77,6 @@ static inline struct autogroup *autogroup_create(void)
 	if (IS_ERR(tg))
 		goto out_free;
 
-	sched_online_group(tg, &root_task_group);
-
 	kref_init(&ag->kref);
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
@@ -98,6 +96,7 @@ static inline struct autogroup *autogroup_create(void)
 #endif
 	tg->autogroup = ag;
 
+	sched_online_group(tg, &root_task_group);
 	return ag;
 
 out_free:
