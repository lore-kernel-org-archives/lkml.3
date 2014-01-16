Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaAPEdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:33:14 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45785 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaAPEdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:33:11 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 09/15] w1: reply only to the requester portid
Date: Wed, 15 Jan 2014 22:29:20 -0600
Message-Id: <1389846566-28862-10-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:32:59 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unicast one wire replies back to the sender portid to avoid multiple
programs getting each other's messages, especially as the response
can't be uniquely identified with the sequence coming from the
requesting program when both programs generate the same id.  Continue
to broadcast events such as add/remove master/slave devices.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.h         |    5 +++++
 drivers/w1/w1_netlink.c |   42 +++++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index a096ef4..390a730 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -210,6 +210,11 @@ struct w1_master
 	struct w1_bus_master	*bus_master;
 
 	u32			seq;
+	/* port id to send netlink responses to.  The value is temporarily
+	 * stored here while processing a message, set after locking the
+	 * mutex, zero before unlocking the mutex.
+	 */
+	u32			portid;
 };
 
 /**
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index b63109a..a5dc219 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -45,7 +45,7 @@ void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
 
 	memcpy(w, msg, sizeof(struct w1_netlink_msg));
 
-	cn_netlink_send(m, 0, 0, GFP_KERNEL);
+	cn_netlink_send(m, dev->portid, 0, GFP_KERNEL);
 }
 
 static void w1_send_slave(struct w1_master *dev, u64 rn)
@@ -60,7 +60,7 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 
 	if (avail < 8) {
 		msg->ack++;
-		cn_netlink_send(msg, 0, 0, GFP_KERNEL);
+		cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
 
 		msg->len = sizeof(struct w1_netlink_msg) +
 			sizeof(struct w1_netlink_cmd);
@@ -131,7 +131,7 @@ static int w1_get_slaves(struct w1_master *dev,
 	}
 
 	msg->ack = 0;
-	cn_netlink_send(msg, 0, 0, GFP_KERNEL);
+	cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
 
 	dev->priv = NULL;
 	dev->priv_size = 0;
@@ -142,7 +142,7 @@ static int w1_get_slaves(struct w1_master *dev,
 }
 
 static int w1_send_read_reply(struct cn_msg *msg, struct w1_netlink_msg *hdr,
-		struct w1_netlink_cmd *cmd)
+		struct w1_netlink_cmd *cmd, u32 portid)
 {
 	void *data;
 	struct w1_netlink_msg *h;
@@ -173,7 +173,7 @@ static int w1_send_read_reply(struct cn_msg *msg, struct w1_netlink_msg *hdr,
 
 	memcpy(c->data, cmd->data, c->len);
 
-	err = cn_netlink_send(cm, 0, 0, GFP_KERNEL);
+	err = cn_netlink_send(cm, portid, 0, GFP_KERNEL);
 
 	kfree(data);
 
@@ -188,11 +188,11 @@ static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
 	switch (cmd->cmd) {
 	case W1_CMD_TOUCH:
 		w1_touch_block(dev, cmd->data, cmd->len);
-		w1_send_read_reply(msg, hdr, cmd);
+		w1_send_read_reply(msg, hdr, cmd, dev->portid);
 		break;
 	case W1_CMD_READ:
 		w1_read_block(dev, cmd->data, cmd->len);
-		w1_send_read_reply(msg, hdr, cmd);
+		w1_send_read_reply(msg, hdr, cmd, dev->portid);
 		break;
 	case W1_CMD_WRITE:
 		w1_write_block(dev, cmd->data, cmd->len);
@@ -283,7 +283,8 @@ static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
 	return w1_process_command_io(sl->master, msg, hdr, cmd);
 }
 
-static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mcmd)
+static int w1_process_command_root(struct cn_msg *msg,
+	struct w1_netlink_msg *mcmd, u32 portid)
 {
 	struct w1_master *m;
 	struct cn_msg *cn;
@@ -316,7 +317,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 	mutex_lock(&w1_mlock);
 	list_for_each_entry(m, &w1_masters, w1_master_entry) {
 		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
-			cn_netlink_send(cn, 0, 0, GFP_KERNEL);
+			cn_netlink_send(cn, portid, 0, GFP_KERNEL);
 			cn->ack++;
 			cn->len = sizeof(struct w1_netlink_msg);
 			w->len = 0;
@@ -329,7 +330,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 		id++;
 	}
 	cn->ack = 0;
-	cn_netlink_send(cn, 0, 0, GFP_KERNEL);
+	cn_netlink_send(cn, portid, 0, GFP_KERNEL);
 	mutex_unlock(&w1_mlock);
 
 	kfree(cn);
@@ -337,7 +338,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 }
 
 static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rmsg,
-		struct w1_netlink_cmd *rcmd, int error)
+		struct w1_netlink_cmd *rcmd, int portid, int error)
 {
 	struct cn_msg *cmsg;
 	struct w1_netlink_msg *msg;
@@ -364,7 +365,7 @@ static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rm
 		cmsg->len += sizeof(*cmd);
 	}
 
-	error = cn_netlink_send(cmsg, 0, 0, GFP_KERNEL);
+	error = cn_netlink_send(cmsg, portid, 0, GFP_KERNEL);
 	kfree(cmsg);
 
 	return error;
@@ -375,6 +376,7 @@ static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rm
  */
 struct w1_cb_block {
 	atomic_t refcnt;
+	u32 portid; /* Sending process port ID */
 	struct cn_msg msg;
 	/* cn_msg data */
 	/* one or more variable length struct w1_cb_node */
@@ -399,6 +401,7 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 	struct w1_netlink_cmd *cmd = NULL;
 
 	mutex_lock(&dev->mutex);
+	dev->portid = node->block->portid;
 	if (sl && w1_reset_select_slave(sl))
 		err = -ENODEV;
 
@@ -417,7 +420,8 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 			err = w1_process_command_master(dev, &node->block->msg,
 				node->m, cmd);
 
-		w1_netlink_send_error(&node->block->msg, node->m, cmd, err);
+		w1_netlink_send_error(&node->block->msg, node->m, cmd,
+			node->block->portid, err);
 		err = 0;
 
 		cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
@@ -425,12 +429,14 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 	}
 
 	if (!cmd || err)
-		w1_netlink_send_error(&node->block->msg, node->m, cmd, err);
+		w1_netlink_send_error(&node->block->msg, node->m, cmd,
+			node->block->portid, err);
 
 	if (sl)
 		w1_unref_slave(sl);
 	else
 		atomic_dec(&dev->refcnt);
+	dev->portid = 0;
 	mutex_unlock(&dev->mutex);
 
 	mutex_lock(&dev->list_mutex);
@@ -476,10 +482,12 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 			node_count*sizeof(struct w1_cb_node);
 		block = kmalloc(size, GFP_KERNEL);
 		if (!block) {
-			w1_netlink_send_error(msg, m, NULL, -ENOMEM);
+			w1_netlink_send_error(msg, m, NULL, nsp->portid,
+				-ENOMEM);
 			return;
 		}
 		atomic_set(&block->refcnt, 1);
+		block->portid = nsp->portid;
 		memcpy(&block->msg, msg, sizeof(*msg) + msg->len);
 		node = (struct w1_cb_node *)((u8 *)block->msg.data + msg->len);
 	}
@@ -509,7 +517,7 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 			if (sl)
 				dev = sl->master;
 		} else {
-			err = w1_process_command_root(msg, m);
+			err = w1_process_command_root(msg, m, nsp->portid);
 			goto out_cont;
 		}
 
@@ -538,7 +546,7 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 
 out_cont:
 		if (err)
-			w1_netlink_send_error(msg, m, NULL, err);
+			w1_netlink_send_error(msg, m, NULL, nsp->portid, err);
 		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
 		m = (struct w1_netlink_msg *)(((u8 *)m) + sizeof(struct w1_netlink_msg) + m->len);
 
-- 
1.7.10.4

