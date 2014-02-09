Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaBIVGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:06:10 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18798 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaBIVGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:06:06 -0500
Message-ID: <1391979963.1099.34.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] ipc,mqueue: remove limits for the amount of system-wide
 queues
From: Davidlohr Bueso <davidlohr@hp.com>
To: m@silodev.com, stable@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        dledford@redhat.com
Date: Sun, 09 Feb 2014 13:06:03 -0800
In-Reply-To: <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
	 <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Commit 93e6f119 (ipc/mqueue: cleanup definition names and locations) added
global hardcoded limits to the amount of message queues that can be created.
While these limits are per-namespace, reality is that it ends up breaking
userspace applications. Historically users have, at least in theory, been able
to create up to INT_MAX queues, and limiting it to just 1024 is way too low
and dramatic for some workloads and use cases. For instance, Madars reports:

"This update imposes bad limits on our multi-process application. As our
app uses approaches that each process opens its own set of queues (usually
something about 3-5 queues per process). In some scenarios we might run up
to 3000 processes or more (which of-course for linux is not a problem).
Thus we might need up to 9000 queues or more. All processes run under one
user."

Other affected users can be found in launchpad bug #1155695:
https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695

Instead of increasing this limit, revert it entirely and fallback to the
original way of dealing queue limits -- where once a user's resource limit
is reached, and all memory is used, new queues cannot be created.

Reported-by: m@silodev.com
Cc: Doug Ledford <dledford@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: stable@vger.kernel.org # v3.5+
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/ipc_namespace.h |  2 --
 ipc/mq_sysctl.c               | 18 ++++++++++++------
 ipc/mqueue.c                  |  6 +++---
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index e7831d2..35e7eca 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -118,9 +118,7 @@ extern int mq_init_ns(struct ipc_namespace *ns);
  *     the new maximum will handle anyone else.  I may have to revisit this
  *     in the future.
  */
-#define MIN_QUEUESMAX			1
 #define DFLT_QUEUESMAX		      256
-#define HARD_QUEUESMAX		     1024
 #define MIN_MSGMAX			1
 #define DFLT_MSG		       10U
 #define DFLT_MSGMAX		       10
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 383d638..5bb8bfe 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -22,6 +22,16 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
+static int proc_mq_dointvec(ctl_table *table, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table mq_table;
+	memcpy(&mq_table, table, sizeof(mq_table));
+	mq_table.data = get_mq(table);
+
+	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
+}
+
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -33,12 +43,10 @@ static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 					lenp, ppos);
 }
 #else
+#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
-static int msg_queues_limit_min = MIN_QUEUESMAX;
-static int msg_queues_limit_max = HARD_QUEUESMAX;
-
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = HARD_MSGMAX;
 
@@ -51,9 +59,7 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec_minmax,
-		.extra1		= &msg_queues_limit_min,
-		.extra2		= &msg_queues_limit_max,
+		.proc_handler	= proc_mq_dointvec,
 	},
 	{
 		.procname	= "msg_max",
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ccf1f9f..c3b3117 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -433,9 +433,9 @@ static int mqueue_create(struct inode *dir, struct dentry *dentry,
 		error = -EACCES;
 		goto out_unlock;
 	}
-	if (ipc_ns->mq_queues_count >= HARD_QUEUESMAX ||
-	    (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-	     !capable(CAP_SYS_RESOURCE))) {
+
+	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
+	    !capable(CAP_SYS_RESOURCE)) {
 		error = -ENOSPC;
 		goto out_unlock;
 	}
-- 
1.8.1.4



