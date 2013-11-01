Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3KAWiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:38:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab3KAWEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 12/54] proc connector: fix info leaks
Date: Fri,  1 Nov 2013 15:03:40 -0700
Message-Id: <20131101220212.703199042@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e727ca82e0e9616ab4844301e6bae60ca7327682 ]

Initialize event_data for all possible message types to prevent leaking
kernel stack contents to userland (up to 20 bytes). Also set the flags
member of the connector message to 0 to prevent leaking two more stack
bytes this way.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/connector/cn_proc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -65,6 +65,7 @@ void proc_fork_connector(struct task_str
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -80,6 +81,7 @@ void proc_fork_connector(struct task_str
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	/*  If cn_netlink_send() failed, the data is not sent */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
@@ -96,6 +98,7 @@ void proc_exec_connector(struct task_str
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -106,6 +109,7 @@ void proc_exec_connector(struct task_str
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -122,6 +126,7 @@ void proc_id_connector(struct task_struc
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what = which_id;
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
@@ -145,6 +150,7 @@ void proc_id_connector(struct task_struc
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -160,6 +166,7 @@ void proc_sid_connector(struct task_stru
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -170,6 +177,7 @@ void proc_sid_connector(struct task_stru
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -185,6 +193,7 @@ void proc_ptrace_connector(struct task_s
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -203,6 +212,7 @@ void proc_ptrace_connector(struct task_s
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -218,6 +228,7 @@ void proc_comm_connector(struct task_str
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -229,6 +240,7 @@ void proc_comm_connector(struct task_str
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -244,6 +256,7 @@ void proc_coredump_connector(struct task
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -254,6 +267,7 @@ void proc_coredump_connector(struct task
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -269,6 +283,7 @@ void proc_exit_connector(struct task_str
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -281,6 +296,7 @@ void proc_exit_connector(struct task_str
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -304,6 +320,7 @@ static void cn_proc_ack(int err, int rcv
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -313,6 +330,7 @@ static void cn_proc_ack(int err, int rcv
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = rcvd_ack + 1;
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 


