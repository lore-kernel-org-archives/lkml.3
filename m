Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaGPVEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:59762 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaGPVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:41 -0400
Message-Id: <20140716205055.145238026@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [patch V2 35/64] connector: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=connector-remove-silly-timestamp-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ever recurring:
        ts = ktime_get_ts();
        ns = timespec_to_ns(&ts);
with
        ns = ktime_get_ns();

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/connector/cn_proc.c |   36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

Index: tip/drivers/connector/cn_proc.c
===================================================================
--- tip.orig/drivers/connector/cn_proc.c
+++ tip/drivers/connector/cn_proc.c
@@ -69,7 +69,6 @@ void proc_fork_connector(struct task_str
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -79,8 +78,7 @@ void proc_fork_connector(struct task_str
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_FORK;
 	rcu_read_lock();
 	parent = rcu_dereference(task->real_parent);
@@ -102,7 +100,6 @@ void proc_exec_connector(struct task_str
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -112,8 +109,7 @@ void proc_exec_connector(struct task_str
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_EXEC;
 	ev->event_data.exec.process_pid = task->pid;
 	ev->event_data.exec.process_tgid = task->tgid;
@@ -130,7 +126,6 @@ void proc_id_connector(struct task_struc
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 	const struct cred *cred;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -156,8 +151,7 @@ void proc_id_connector(struct task_struc
 	}
 	rcu_read_unlock();
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
@@ -170,7 +164,6 @@ void proc_sid_connector(struct task_stru
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -180,8 +173,7 @@ void proc_sid_connector(struct task_stru
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_SID;
 	ev->event_data.sid.process_pid = task->pid;
 	ev->event_data.sid.process_tgid = task->tgid;
@@ -197,7 +189,6 @@ void proc_ptrace_connector(struct task_s
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -207,8 +198,7 @@ void proc_ptrace_connector(struct task_s
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_PTRACE;
 	ev->event_data.ptrace.process_pid  = task->pid;
 	ev->event_data.ptrace.process_tgid = task->tgid;
@@ -232,7 +222,6 @@ void proc_comm_connector(struct task_str
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -242,8 +231,7 @@ void proc_comm_connector(struct task_str
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
@@ -261,7 +249,6 @@ void proc_coredump_connector(struct task
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -270,8 +257,7 @@ void proc_coredump_connector(struct task
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_COREDUMP;
 	ev->event_data.coredump.process_pid = task->pid;
 	ev->event_data.coredump.process_tgid = task->tgid;
@@ -288,7 +274,6 @@ void proc_exit_connector(struct task_str
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -297,8 +282,7 @@ void proc_exit_connector(struct task_str
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_EXIT;
 	ev->event_data.exit.process_pid = task->pid;
 	ev->event_data.exit.process_tgid = task->tgid;
@@ -325,7 +309,6 @@ static void cn_proc_ack(int err, int rcv
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -334,8 +317,7 @@ static void cn_proc_ack(int err, int rcv
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->cpu = -1;
 	ev->what = PROC_EVENT_NONE;
 	ev->event_data.ack.err = err;


