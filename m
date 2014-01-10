Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbaAJStu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:49:50 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46769 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaAJSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:47 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] ipc,msg: document barriers
Date: Fri, 10 Jan 2014 10:48:27 -0800
Message-Id: <1389379707-20298-8-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both expunge_all() and pipeline_send() rely on both a nil msg value and a
full barrier to guarantee the correct ordering when waking up a task. While
its counter part at the receiving end is well documented for the lockless
recv algorithm, we still need to document these specific smp_mb() calls.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 4377f4a..8c1cc76 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -253,8 +253,14 @@ static void expunge_all(struct msg_queue *msq, int res)
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		msr->r_msg = NULL;
+		msr->r_msg = NULL; /* initialize expunge ordering */
 		wake_up_process(msr->r_tsk);
+		/*
+		 * Ensure that the wakeup is visible before setting r_msg as
+		 * the receiving end depends on it: either spinning on a nil,
+		 * or dealing with -EAGAIN cases. See lockless reveice part 1
+		 * and 2 in do_msgrcv().
+		 */
 		smp_mb();
 		msr->r_msg = ERR_PTR(res);
 	}
@@ -638,15 +644,22 @@ static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 
 			list_del(&msr->r_list);
 			if (msr->r_maxsize < msg->m_ts) {
+				/* initialize pipelined send ordering */
 				msr->r_msg = NULL;
 				wake_up_process(msr->r_tsk);
-				smp_mb();
+				smp_mb(); /* see barrier comment below */
 				msr->r_msg = ERR_PTR(-E2BIG);
 			} else {
 				msr->r_msg = NULL;
 				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
 				msq->q_rtime = get_seconds();
 				wake_up_process(msr->r_tsk);
+				/*
+				 * Ensure that the wakeup is visible before
+				 * setting r_msg, as the receiving end depends
+				 * on it. See lockless reveice part 1 and 2 in
+				 * do_msgrcv().
+				 */
 				smp_mb();
 				msr->r_msg = msg;
 
@@ -654,6 +667,7 @@ static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 			}
 		}
 	}
+
 	return 0;
 }
 
@@ -716,6 +730,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 			goto out_unlock0;
 		}
 
+		/* enqueue the sender and prepare to block */
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
-- 
1.8.1.4

