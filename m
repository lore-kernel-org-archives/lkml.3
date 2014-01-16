Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaAPEc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:32:57 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45781 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaAPEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:32:53 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 08/15] connector: add portid to unicast in addition to broadcasting
Date: Wed, 15 Jan 2014 22:29:19 -0600
Message-Id: <1389846566-28862-9-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:32:46 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows replying only to the requestor portid while still
supporting broadcasting.  Pass 0 to portid for the previous behavior.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/connector/cn_test.c      |    2 +-
 drivers/connector/cn_proc.c            |   18 +++++++++---------
 drivers/connector/connector.c          |   20 +++++++++++++-------
 drivers/hv/hv_kvp.c                    |    4 ++--
 drivers/hv/hv_snapshot.c               |    2 +-
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 drivers/video/uvesafb.c                |    4 ++--
 drivers/w1/w1_netlink.c                |   14 +++++++-------
 include/linux/connector.h              |    2 +-
 9 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
index adcca03..d12cc94 100644
--- a/Documentation/connector/cn_test.c
+++ b/Documentation/connector/cn_test.c
@@ -145,7 +145,7 @@ static void cn_test_timer_func(unsigned long __data)
 
 		memcpy(m + 1, data, m->len);
 
-		cn_netlink_send(m, 0, GFP_ATOMIC);
+		cn_netlink_send(m, 0, 0, GFP_ATOMIC);
 		kfree(m);
 	}
 
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 18c5b9b..148d707 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -95,7 +95,7 @@ void proc_fork_connector(struct task_struct *task)
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
 	/*  If cn_netlink_send() failed, the data is not sent */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_exec_connector(struct task_struct *task)
@@ -122,7 +122,7 @@ void proc_exec_connector(struct task_struct *task)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_id_connector(struct task_struct *task, int which_id)
@@ -163,7 +163,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_sid_connector(struct task_struct *task)
@@ -190,7 +190,7 @@ void proc_sid_connector(struct task_struct *task)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
@@ -225,7 +225,7 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_comm_connector(struct task_struct *task)
@@ -253,7 +253,7 @@ void proc_comm_connector(struct task_struct *task)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_coredump_connector(struct task_struct *task)
@@ -280,7 +280,7 @@ void proc_coredump_connector(struct task_struct *task)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_exit_connector(struct task_struct *task)
@@ -309,7 +309,7 @@ void proc_exit_connector(struct task_struct *task)
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 /*
@@ -343,7 +343,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	msg->ack = rcvd_ack + 1;
 	msg->len = sizeof(*ev);
 	msg->flags = 0; /* not used */
-	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_KERNEL);
 }
 
 /**
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index a36749f..77afe74 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -50,7 +50,7 @@ static int cn_already_initialized;
  *
  * Sequence number is incremented with each message to be sent.
  *
- * If we expect reply to our message then the sequence number in
+ * If we expect a reply to our message then the sequence number in
  * received message MUST be the same as in original message, and
  * acknowledge number MUST be the same + 1.
  *
@@ -62,8 +62,11 @@ static int cn_already_initialized;
  * the acknowledgement number in the original message + 1, then it is
  * a new message.
  *
+ * The message is sent to, the portid if given, the group if given, both if
+ * both, or if both are zero then the group is looked up and sent there.
  */
-int cn_netlink_send(struct cn_msg *msg, u32 __group, gfp_t gfp_mask)
+int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
+	gfp_t gfp_mask)
 {
 	struct cn_callback_entry *__cbq;
 	unsigned int size;
@@ -74,7 +77,9 @@ int cn_netlink_send(struct cn_msg *msg, u32 __group, gfp_t gfp_mask)
 	u32 group = 0;
 	int found = 0;
 
-	if (!__group) {
+	if (portid || __group) {
+		group = __group;
+	} else {
 		spin_lock_bh(&dev->cbdev->queue_lock);
 		list_for_each_entry(__cbq, &dev->cbdev->queue_list,
 				    callback_entry) {
@@ -88,11 +93,9 @@ int cn_netlink_send(struct cn_msg *msg, u32 __group, gfp_t gfp_mask)
 
 		if (!found)
 			return -ENODEV;
-	} else {
-		group = __group;
 	}
 
-	if (!netlink_has_listeners(dev->nls, group))
+	if (!portid && !netlink_has_listeners(dev->nls, group))
 		return -ESRCH;
 
 	size = sizeof(*msg) + msg->len;
@@ -113,7 +116,10 @@ int cn_netlink_send(struct cn_msg *msg, u32 __group, gfp_t gfp_mask)
 
 	NETLINK_CB(skb).dst_group = group;
 
-	return netlink_broadcast(dev->nls, skb, 0, group, gfp_mask);
+	if (group)
+		return netlink_broadcast(dev->nls, skb, portid, group,
+					 gfp_mask);
+	return netlink_unicast(dev->nls, skb, portid, !(gfp_mask&__GFP_WAIT));
 }
 EXPORT_SYMBOL_GPL(cn_netlink_send);
 
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 09988b2..ea85253 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -113,7 +113,7 @@ kvp_register(int reg_value)
 		kvp_msg->kvp_hdr.operation = reg_value;
 		strcpy(version, HV_DRV_VERSION);
 		msg->len = sizeof(struct hv_kvp_msg);
-		cn_netlink_send(msg, 0, GFP_ATOMIC);
+		cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
 		kfree(msg);
 	}
 }
@@ -435,7 +435,7 @@ kvp_send_key(struct work_struct *dummy)
 	}
 
 	msg->len = sizeof(struct hv_kvp_msg);
-	cn_netlink_send(msg, 0, GFP_ATOMIC);
+	cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
 	kfree(msg);
 
 	return;
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 0c35462..34f14fd 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -98,7 +98,7 @@ static void vss_send_op(struct work_struct *dummy)
 	vss_msg->vss_hdr.operation = op;
 	msg->len = sizeof(struct hv_vss_msg);
 
-	cn_netlink_send(msg, 0, GFP_ATOMIC);
+	cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
 	kfree(msg);
 
 	return;
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 08d9a20..b428c0a 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -66,7 +66,7 @@ static int dm_ulog_sendto_server(struct dm_ulog_request *tfr)
 	msg->seq = tfr->seq;
 	msg->len = sizeof(struct dm_ulog_request) + tfr->data_size;
 
-	r = cn_netlink_send(msg, 0, gfp_any());
+	r = cn_netlink_send(msg, 0, 0, gfp_any());
 
 	return r;
 }
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 256fba7..1f38445 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -190,7 +190,7 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 	uvfb_tasks[seq] = task;
 	mutex_unlock(&uvfb_lock);
 
-	err = cn_netlink_send(m, 0, GFP_KERNEL);
+	err = cn_netlink_send(m, 0, 0, GFP_KERNEL);
 	if (err == -ESRCH) {
 		/*
 		 * Try to start the userspace helper if sending
@@ -204,7 +204,7 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 					"helper is installed and executable\n");
 		} else {
 			v86d_started = 1;
-			err = cn_netlink_send(m, 0, gfp_any());
+			err = cn_netlink_send(m, 0, 0, gfp_any());
 			if (err == -ENOBUFS)
 				err = 0;
 		}
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 06d614a..b63109a 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -45,7 +45,7 @@ void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
 
 	memcpy(w, msg, sizeof(struct w1_netlink_msg));
 
-	cn_netlink_send(m, 0, GFP_KERNEL);
+	cn_netlink_send(m, 0, 0, GFP_KERNEL);
 }
 
 static void w1_send_slave(struct w1_master *dev, u64 rn)
@@ -60,7 +60,7 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 
 	if (avail < 8) {
 		msg->ack++;
-		cn_netlink_send(msg, 0, GFP_KERNEL);
+		cn_netlink_send(msg, 0, 0, GFP_KERNEL);
 
 		msg->len = sizeof(struct w1_netlink_msg) +
 			sizeof(struct w1_netlink_cmd);
@@ -131,7 +131,7 @@ static int w1_get_slaves(struct w1_master *dev,
 	}
 
 	msg->ack = 0;
-	cn_netlink_send(msg, 0, GFP_KERNEL);
+	cn_netlink_send(msg, 0, 0, GFP_KERNEL);
 
 	dev->priv = NULL;
 	dev->priv_size = 0;
@@ -173,7 +173,7 @@ static int w1_send_read_reply(struct cn_msg *msg, struct w1_netlink_msg *hdr,
 
 	memcpy(c->data, cmd->data, c->len);
 
-	err = cn_netlink_send(cm, 0, GFP_KERNEL);
+	err = cn_netlink_send(cm, 0, 0, GFP_KERNEL);
 
 	kfree(data);
 
@@ -316,7 +316,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 	mutex_lock(&w1_mlock);
 	list_for_each_entry(m, &w1_masters, w1_master_entry) {
 		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
-			cn_netlink_send(cn, 0, GFP_KERNEL);
+			cn_netlink_send(cn, 0, 0, GFP_KERNEL);
 			cn->ack++;
 			cn->len = sizeof(struct w1_netlink_msg);
 			w->len = 0;
@@ -329,7 +329,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 		id++;
 	}
 	cn->ack = 0;
-	cn_netlink_send(cn, 0, GFP_KERNEL);
+	cn_netlink_send(cn, 0, 0, GFP_KERNEL);
 	mutex_unlock(&w1_mlock);
 
 	kfree(cn);
@@ -364,7 +364,7 @@ static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rm
 		cmsg->len += sizeof(*cmd);
 	}
 
-	error = cn_netlink_send(cmsg, 0, GFP_KERNEL);
+	error = cn_netlink_send(cmsg, 0, 0, GFP_KERNEL);
 	kfree(cmsg);
 
 	return error;
diff --git a/include/linux/connector.h b/include/linux/connector.h
index b2b5a41..be9c4747 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -71,7 +71,7 @@ struct cn_dev {
 int cn_add_callback(struct cb_id *id, const char *name,
 		    void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
 void cn_del_callback(struct cb_id *);
-int cn_netlink_send(struct cn_msg *, u32, gfp_t);
+int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 group, gfp_t gfp_mask);
 
 int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
 			  struct cb_id *id,
-- 
1.7.10.4

