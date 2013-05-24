Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3EXQIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:08:04 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:48353 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3EXQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:08:02 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 1/1] sched/autogroup: Fix race with task_groups list
Date: Fri, 24 May 2013 18:07:49 +0200
Message-Id: <1369411669-46971-2-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1369411669-46971-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1369411669-46971-1-git-send-email-gerald.schaefer@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052416-4966-0000-0000-000005D6BBB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In autogroup_create(), a tg is allocated and added to the task_groups
list. If CONFIG_RT_GROUP_SCHED is set, this tg is then modified while on
the list, without locking. This can race with someone walking the list,
like __enable_runtime() during CPU unplug, and result in a use-after-free
bug.

To fix this, move sched_online_group(), which adds the tg to the list,
to the end of the autogroup_create() function after the modification.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
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
-- 
1.8.1.6

