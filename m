Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaC1RvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:51:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaC1Rau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH 3.10 22/22] sched/autogroup: Fix race with task_groups list
Date: Fri, 28 Mar 2014 10:32:14 -0700
Message-Id: <20140328173112.401929561@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 41261b6a832ea0e788627f6a8707854423f9ff49 upstream.

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
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/auto_group.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -77,8 +77,6 @@ static inline struct autogroup *autogrou
 	if (IS_ERR(tg))
 		goto out_free;
 
-	sched_online_group(tg, &root_task_group);
-
 	kref_init(&ag->kref);
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
@@ -98,6 +96,7 @@ static inline struct autogroup *autogrou
 #endif
 	tg->autogroup = ag;
 
+	sched_online_group(tg, &root_task_group);
 	return ag;
 
 out_free:


