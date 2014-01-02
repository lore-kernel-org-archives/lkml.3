Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaABR3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:29:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaABRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 15/91] connector: improved unaligned access error fix
Date: Thu,  2 Jan 2014 09:03:50 -0800
Message-Id: <1388682306-30859-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

[ Upstream commit 1ca1a4cf59ea343a1a70084fe7cc96f37f3cf5b1 ]

In af3e095a1fb4, Erik Jacobsen fixed one type of unaligned access
bug for ia64 by converting a 64-bit write to use put_unaligned().
Unfortunately, since gcc will convert a short memset() to a series
of appropriately-aligned stores, the problem is now visible again
on tilegx, where the memset that zeros out proc_event is converted
to three 64-bit stores, causing an unaligned access panic.

A better fix for the original problem is to ensure that proc_event
is aligned to 8 bytes here.  We can do that relatively easily by
arranging to start the struct cn_msg aligned to 8 bytes and then
offset by 4 bytes.  Doing so means that the immediately following
proc_event structure is then correctly aligned to 8 bytes.

The result is that the memset() stores are now aligned, and as an
added benefit, we can remove the put_unaligned() calls in the code.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/connector/cn_proc.c | 66 ++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 1b1d255..ccc6e8e 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -32,11 +32,23 @@
 #include <linux/atomic.h>
 #include <linux/pid_namespace.h>
 
-#include <asm/unaligned.h>
-
 #include <linux/cn_proc.h>
 
-#define CN_PROC_MSG_SIZE (sizeof(struct cn_msg) + sizeof(struct proc_event))
+/*
+ * Size of a cn_msg followed by a proc_event structure.  Since the
+ * sizeof struct cn_msg is a multiple of 4 bytes, but not 8 bytes, we
+ * add one 4-byte word to the size here, and then start the actual
+ * cn_msg structure 4 bytes into the stack buffer.  The result is that
+ * the immediately following proc_event structure is aligned to 8 bytes.
+ */
+#define CN_PROC_MSG_SIZE (sizeof(struct cn_msg) + sizeof(struct proc_event) + 4)
+
+/* See comment above; we test our assumption about sizeof struct cn_msg here. */
+static inline struct cn_msg *buffer_to_cn_msg(__u8 *buffer)
+{
+	BUILD_BUG_ON(sizeof(struct cn_msg) != 20);
+	return (struct cn_msg *)(buffer + 4);
+}
 
 static atomic_t proc_event_num_listeners = ATOMIC_INIT(0);
 static struct cb_id cn_proc_event_id = { CN_IDX_PROC, CN_VAL_PROC };
@@ -56,19 +68,19 @@ void proc_fork_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_FORK;
 	rcu_read_lock();
 	parent = rcu_dereference(task->real_parent);
@@ -91,17 +103,17 @@ void proc_exec_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_EXEC;
 	ev->event_data.exec.process_pid = task->pid;
 	ev->event_data.exec.process_tgid = task->tgid;
@@ -117,14 +129,14 @@ void proc_id_connector(struct task_struct *task, int which_id)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 	const struct cred *cred;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what = which_id;
@@ -145,7 +157,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	rcu_read_unlock();
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
@@ -159,17 +171,17 @@ void proc_sid_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_SID;
 	ev->event_data.sid.process_pid = task->pid;
 	ev->event_data.sid.process_tgid = task->tgid;
@@ -186,17 +198,17 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_PTRACE;
 	ev->event_data.ptrace.process_pid  = task->pid;
 	ev->event_data.ptrace.process_tgid = task->tgid;
@@ -221,17 +233,17 @@ void proc_comm_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
@@ -248,18 +260,18 @@ void proc_exit_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_EXIT;
 	ev->event_data.exit.process_pid = task->pid;
 	ev->event_data.exit.process_tgid = task->tgid;
@@ -286,18 +298,18 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->cpu = -1;
 	ev->what = PROC_EVENT_NONE;
 	ev->event_data.ack.err = err;
-- 
1.8.3.2

