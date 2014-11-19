Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaKSKlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:41:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:12708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbaKSKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:41:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418550819"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/2] sched/deadline: reduce overhead if there are no scheduling parameters changed
Date: Wed, 19 Nov 2014 16:35:02 +0800
Message-Id: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to dequeue/enqueue and push/pull if there are
no scheduling parameters changed for dl class, actually both 
fair and rt class have already check if parameters changed for 
them to avoid unnecessary overhead. This patch add the parameters 
changed verify for dl class in order to reduce overhead.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 603c462..f361867 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3402,6 +3402,21 @@ static bool check_same_owner(struct task_struct *p)
 	return match;
 }
 
+static bool dl_param_changed(struct task_struct *p,
+			const struct sched_attr *attr)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	if (dl_se->dl_runtime != attr->sched_runtime ||
+		dl_se->dl_deadline != attr->sched_deadline ||
+		dl_se->dl_period != attr->sched_period ||
+		dl_se->flags != attr->sched_flags ||
+		p->rt_priority != attr->sched_priority)
+		return true;
+
+	return false;
+}
+
 static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
@@ -3530,7 +3545,7 @@ recheck:
 			goto change;
 		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
 			goto change;
-		if (dl_policy(policy))
+		if (dl_policy(policy) && dl_param_changed(p, attr))
 			goto change;
 
 		p->sched_reset_on_fork = reset_on_fork;
-- 
1.9.1

