Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3CTGvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:51:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:48154 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3CTGvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:51:07 -0400
From: Jesper Derehag <jderehag@hotmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Derehag <jderehag@hotmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v2=201/1=5D=20connector=3A=20Added=20coredumping=20event=20to=20the=20process=20connector?=
Date: Wed, 20 Mar 2013 07:50:05 +0100
Message-Id: <1363762205-26206-1-git-send-email-jderehag@hotmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Process connector can now also detect coredumping events.
Main aim of patch is get notified at start of coredumping, instead of having to wait for it to finish and then being notified through EXIT event.
Could be used for instance by process-managers that want to get notified as soon as possible about process failures, and not necessarily beeing notified after coredump, which could be in the order of minutes depending on size of coredump, piping and so on.

Signed-off-by: Jesper Derehag <jderehag@hotmail.com>
---
 drivers/connector/cn_proc.c  |   25 +++++++++++++++++++++++++
 include/linux/cn_proc.h      |    4 ++++
 include/uapi/linux/cn_proc.h |   10 +++++++++-
 kernel/signal.c              |    2 ++
 4 filer ändrade, 40 tillägg(+), 1 borttagning(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index fce2000..c613ab3 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -232,6 +232,31 @@ void proc_comm_connector(struct task_struct *task)
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
+void proc_coredump_connector(struct task_struct *task)
+{
+	struct cn_msg *msg;
+	struct proc_event *ev;
+	__u8 buffer[CN_PROC_MSG_SIZE];
+	struct timespec ts;
+
+	if (atomic_read(&proc_event_num_listeners) < 1)
+		return;
+
+	msg = (struct cn_msg *)buffer;
+	ev = (struct proc_event *)msg->data;
+	get_seq(&msg->seq, &ev->cpu);
+	ktime_get_ts(&ts); /* get high res monotonic timestamp */
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->what = PROC_EVENT_COREDUMP;
+	ev->event_data.coredump.process_pid = task->pid;
+	ev->event_data.coredump.process_tgid = task->tgid;
+
+	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
+	msg->ack = 0; /* not used */
+	msg->len = sizeof(*ev);
+	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+}
+
 void proc_exit_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
diff --git a/include/linux/cn_proc.h b/include/linux/cn_proc.h
index 2c1bc1e..1d5b02a 100644
--- a/include/linux/cn_proc.h
+++ b/include/linux/cn_proc.h
@@ -26,6 +26,7 @@ void proc_id_connector(struct task_struct *task, int which_id);
 void proc_sid_connector(struct task_struct *task);
 void proc_ptrace_connector(struct task_struct *task, int which_id);
 void proc_comm_connector(struct task_struct *task);
+void proc_coredump_connector(struct task_struct *task);
 void proc_exit_connector(struct task_struct *task);
 #else
 static inline void proc_fork_connector(struct task_struct *task)
@@ -48,6 +49,9 @@ static inline void proc_ptrace_connector(struct task_struct *task,
 					 int ptrace_id)
 {}
 
+static inline void proc_coredump_connector(struct task_struct *task)
+{}
+
 static inline void proc_exit_connector(struct task_struct *task)
 {}
 #endif	/* CONFIG_PROC_EVENTS */
diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
index 0d7b499..f6c2710 100644
--- a/include/uapi/linux/cn_proc.h
+++ b/include/uapi/linux/cn_proc.h
@@ -56,7 +56,9 @@ struct proc_event {
 		PROC_EVENT_PTRACE = 0x00000100,
 		PROC_EVENT_COMM = 0x00000200,
 		/* "next" should be 0x00000400 */
-		/* "last" is the last process event: exit */
+		/* "last" is the last process event: exit,
+		 * while "next to last" is coredumping event */
+		PROC_EVENT_COREDUMP = 0x40000000,
 		PROC_EVENT_EXIT = 0x80000000
 	} what;
 	__u32 cpu;
@@ -110,11 +112,17 @@ struct proc_event {
 			char           comm[16];
 		} comm;
 
+		struct coredump_proc_event {
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
+		} coredump;
+
 		struct exit_proc_event {
 			__kernel_pid_t process_pid;
 			__kernel_pid_t process_tgid;
 			__u32 exit_code, exit_signal;
 		} exit;
+
 	} event_data;
 };
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 2ec870a..55f035b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -32,6 +32,7 @@
 #include <linux/user_namespace.h>
 #include <linux/uprobes.h>
 #include <linux/compat.h>
+#include <linux/cn_proc.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
 
@@ -2347,6 +2348,7 @@ relock:
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
 				print_fatal_signal(info->si_signo);
+			proc_coredump_connector(current);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with
-- 
1.7.10.4

