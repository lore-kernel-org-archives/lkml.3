Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3KHCRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3KHCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 19/91] proc connector: fix info leaks
Date: Thu,  7 Nov 2013 18:14:34 -0800
Message-Id: <1383876946-2396-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e727ca82e0e9616ab4844301e6bae60ca7327682 ]

Initialize event_data for all possible message types to prevent leaking
kernel stack contents to userland (up to 20 bytes). Also set the flags
member of the connector message to 0 to prevent leaking two more stack
bytes this way.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/connector/cn_proc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 1110478..1b1d255 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -65,6 +65,7 @@ void proc_fork_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -80,6 +81,7 @@ void proc_fork_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	/*  If cn_netlink_send() failed, the data is not sent */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
@@ -96,6 +98,7 @@ void proc_exec_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -106,6 +109,7 @@ void proc_exec_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -122,6 +126,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what = which_id;
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
@@ -145,6 +150,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -160,6 +166,7 @@ void proc_sid_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -170,6 +177,7 @@ void proc_sid_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -185,6 +193,7 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -203,6 +212,7 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -218,6 +228,7 @@ void proc_comm_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -229,6 +240,7 @@ void proc_comm_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -244,6 +256,7 @@ void proc_exit_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -256,6 +269,8 @@ void proc_exit_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -279,6 +294,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -288,6 +304,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = rcvd_ack + 1;
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
-- 
1.8.1.2

