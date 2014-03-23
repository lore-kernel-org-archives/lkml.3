Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaCWBaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 21:30:00 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:53176 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaCWB36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 21:29:58 -0400
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 3/3] w1: optional bundling of netlink kernel replies
Date: Sat, 22 Mar 2014 20:27:47 -0500
Message-Id: <1395538067-4029-4-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395538067-4029-1-git-send-email-David@Fries.net>
References: <1395538067-4029-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sat, 22 Mar 2014 20:29:44 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applications can submit a set of commands in one packet to the kernel,
and in some cases it is required such as reading the temperature
sensor results.  This adds an option W1_CN_BUNDLE to the flags of
cn_msg to request the kernel to reply in one packet for efficiency.

The cn_msg flags now check for unknown flag values and return an error
if one is seen.  See "Proper handling of unknown flags in system
calls" http://lwn.net/Articles/588444/

This corrects the ack values returned as per the protocol standard,
namely the original ack for status messages and seq + 1 for all others
such as the data returned from a read.

Signed-off-by: David Fries <David@Fries.net>

Some of the common variable names have been standardized as follows.
struct cn_msg *cn
struct w1_netlink_msg *msg
struct w1_netlink_cmd *cmd
struct w1_master *dev

When an argument and a function scope variable would collide, add req_
to the argument.
---
 Documentation/connector/connector.txt |    2 +-
 Documentation/w1/w1.generic           |    2 +-
 Documentation/w1/w1.netlink           |   13 +-
 drivers/w1/w1.h                       |    8 -
 drivers/w1/w1_netlink.c               |  649 ++++++++++++++++++++-------------
 drivers/w1/w1_netlink.h               |   36 ++
 6 files changed, 447 insertions(+), 263 deletions(-)

diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index e56abdb..f6215f9 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -118,7 +118,7 @@ acknowledge number MUST be the same + 1.
 If we receive a message and its sequence number is not equal to one we
 are expecting, then it is a new message.  If we receive a message and
 its sequence number is the same as one we are expecting, but its
-acknowledge is not equal to the acknowledge number in the original
+acknowledge is not equal to the sequence number in the original
 message + 1, then it is a new message.
 
 Obviously, the protocol header contains the above id.
diff --git a/Documentation/w1/w1.generic b/Documentation/w1/w1.generic
index a31c5a2..b2033c6 100644
--- a/Documentation/w1/w1.generic
+++ b/Documentation/w1/w1.generic
@@ -82,7 +82,7 @@ driver             - (standard) symlink to the w1 driver
 w1_master_add      - Manually register a slave device
 w1_master_attempts - the number of times a search was attempted
 w1_master_max_slave_count
-                   - the maximum slaves that may be attached to a master
+                   - maximum number of slaves to search for at a time
 w1_master_name     - the name of the device (w1_bus_masterX)
 w1_master_pullup   - 5V strong pullup 0 enabled, 1 disabled
 w1_master_remove   - Manually remove a slave device
diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index 927a52c..ef27271 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -30,7 +30,7 @@ Protocol.
 			W1_SLAVE_CMD
 				userspace command for slave device
 				(read/write/touch)
-	__u8 res	- reserved
+	__u8 status	- error indication from kernel
 	__u16 len	- size of data attached to this header data
 	union {
 		__u8 id[8];			 - slave unique device id
@@ -44,10 +44,14 @@ Protocol.
 	__u8 cmd	- command opcode.
 			W1_CMD_READ 	- read command
 			W1_CMD_WRITE	- write command
-			W1_CMD_TOUCH	- touch command
-				(write and sample data back to userspace)
 			W1_CMD_SEARCH	- search command
 			W1_CMD_ALARM_SEARCH - alarm search command
+			W1_CMD_TOUCH	- touch command
+				(write and sample data back to userspace)
+			W1_CMD_RESET	- send bus reset
+			W1_CMD_SLAVE_ADD	- add slave to kernel list
+			W1_CMD_SLAVE_REMOVE	- remove slave from kernel list
+			W1_CMD_LIST_SLAVES	- get slaves list from kernel
 	__u8 res	- reserved
 	__u16 len	- length of data for this command
 		For read command data must be allocated like for write command
@@ -87,8 +91,7 @@ format:
 	id0 ... idN
 
 	Each message is at most 4k in size, so if number of master devices
-	exceeds this, it will be split into several messages,
-	cn.seq will be increased for each one.
+	exceeds this, it will be split into several messages.
 
 W1 search and alarm search commands.
 request:
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 734dab7..56a49ba 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -203,7 +203,6 @@ enum w1_master_flags {
  * @search_id:		allows continuing a search
  * @refcnt:		reference count
  * @priv:		private data storage
- * @priv_size:		size allocated
  * @enable_pullup:	allows a strong pullup
  * @pullup_duration:	time for the next strong pullup
  * @flags:		one of w1_master_flags
@@ -214,7 +213,6 @@ enum w1_master_flags {
  * @dev:		sysfs device
  * @bus_master:		io operations available
  * @seq:		sequence number used for netlink broadcasts
- * @portid:		destination for the current netlink command
  */
 struct w1_master
 {
@@ -241,7 +239,6 @@ struct w1_master
 	atomic_t		refcnt;
 
 	void			*priv;
-	int			priv_size;
 
 	/** 5V strong pullup enabled flag, 1 enabled, zero disabled. */
 	int			enable_pullup;
@@ -260,11 +257,6 @@ struct w1_master
 	struct w1_bus_master	*bus_master;
 
 	u32			seq;
-	/* port id to send netlink responses to.  The value is temporarily
-	 * stored here while processing a message, set after locking the
-	 * mutex, zero before unlocking the mutex.
-	 */
-	u32			portid;
 };
 
 /**
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index a02704a..351a297 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -29,51 +29,247 @@
 #include "w1_netlink.h"
 
 #if defined(CONFIG_W1_CON) && (defined(CONFIG_CONNECTOR) || (defined(CONFIG_CONNECTOR_MODULE) && defined(CONFIG_W1_MODULE)))
-void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
+
+#define MIN(a, b)                   (((a) < (b)) ? (a) : (b))
+
+/* Bundle together everything required to process a request in one memory
+ * allocation.
+ */
+struct w1_cb_block {
+	atomic_t refcnt;
+	u32 portid; /* Sending process port ID */
+	/* maximum value for first_cn->len */
+	u16 maxlen;
+	/* pointers to building up the reply message */
+	struct cn_msg *first_cn; /* fixed once the structure is populated */
+	struct cn_msg *cn; /* advances as cn_msg is appeneded */
+	struct w1_netlink_msg *msg; /* advances as w1_netlink_msg is appened */
+	struct w1_netlink_cmd *cmd; /* advances as cmds are appened */
+	struct w1_netlink_msg *cur_msg; /* currently message being processed */
+	/* copy of the original request follows */
+	struct cn_msg request_cn;
+	/* followed by variable length:
+	 * cn_msg, data (w1_netlink_msg and w1_netlink_cmd)
+	 * one or more struct w1_cb_node
+	 * reply first_cn, data (w1_netlink_msg and w1_netlink_cmd)
+	 */
+};
+struct w1_cb_node {
+	struct w1_async_cmd async;
+	/* pointers within w1_cb_block and cn data */
+	struct w1_cb_block *block;
+	struct w1_netlink_msg *msg;
+	struct w1_slave *sl;
+	struct w1_master *dev;
+};
+
+/**
+ * w1_reply_len() - calculate current reply length, compare to maxlen
+ * @block: block to calculate
+ *
+ * Calculates the current message length including possible multiple
+ * cn_msg and data, excludes the first sizeof(struct cn_msg).  Direclty
+ * compariable to maxlen and usable to send the message.
+ */
+static u16 w1_reply_len(struct w1_cb_block *block)
+{
+	if (!block->cn)
+		return 0;
+	return (u8 *)block->cn - (u8 *)block->first_cn + block->cn->len;
+}
+
+static void w1_unref_block(struct w1_cb_block *block)
+{
+	if (atomic_sub_return(1, &block->refcnt) == 0) {
+		u16 len = w1_reply_len(block);
+		if (len) {
+			cn_netlink_send_mult(block->first_cn, len,
+				block->portid, 0, GFP_KERNEL);
+		}
+		kfree(block);
+	}
+}
+
+/**
+ * w1_reply_make_space() - send message if needed to make space
+ * @block: block to make space on
+ * @space: how many bytes requested
+ *
+ * Verify there is enough room left for the caller to add "space" bytes to the
+ * message, if there isn't send the message and reset.
+ */
+static void w1_reply_make_space(struct w1_cb_block *block, u16 space)
+{
+	u16 len = w1_reply_len(block);
+	if (len + space >= block->maxlen) {
+		cn_netlink_send_mult(block->first_cn, len, block->portid, 0, GFP_KERNEL);
+		block->first_cn->len = 0;
+		block->cn = NULL;
+		block->msg = NULL;
+		block->cmd = NULL;
+	}
+}
+
+/* Early send when replies aren't bundled. */
+static void w1_netlink_check_send(struct w1_cb_block *block)
+{
+	if (!(block->request_cn.flags & W1_CN_BUNDLE) && block->cn)
+		w1_reply_make_space(block, block->maxlen);
+}
+
+/**
+ * w1_netlink_setup_msg() - prepare to write block->msg
+ * @block: block to operate on
+ * @ack: determines if cn can be reused
+ *
+ * block->cn will be setup with the correct ack, advancing if needed
+ * block->cn->len does not include space for block->msg
+ * block->msg advances but remains uninitialized
+ */
+static void w1_netlink_setup_msg(struct w1_cb_block *block, u32 ack)
+{
+	if (block->cn && block->cn->ack == ack) {
+		block->msg = (struct w1_netlink_msg *)(block->cn->data + block->cn->len);
+	} else {
+		/* advance or set to data */
+		if (block->cn)
+			block->cn = (struct cn_msg *)(block->cn->data +
+				block->cn->len);
+		else
+			block->cn = block->first_cn;
+
+		memcpy(block->cn, &block->request_cn, sizeof(*block->cn));
+		block->cn->len = 0;
+		block->cn->ack = ack;
+		block->msg = (struct w1_netlink_msg *)block->cn->data;
+	}
+}
+
+/* Append cmd to msg, include cmd->data as well.  This is because
+ * any following data goes with the command and in the case of a read is
+ * the results.
+ */
+static void w1_netlink_queue_cmd(struct w1_cb_block *block,
+	struct w1_netlink_cmd *cmd)
+{
+	u32 space;
+	w1_reply_make_space(block, sizeof(struct cn_msg) +
+		sizeof(struct w1_netlink_msg) + sizeof(*cmd) + cmd->len);
+
+	/* There's a status message sent after each command, so no point
+	 * in trying to bundle this cmd after an existing one, because
+	 * there won't be one.  Allocate and copy over a new cn_msg.
+	 */
+	w1_netlink_setup_msg(block, block->request_cn.seq + 1);
+	memcpy(block->msg, block->cur_msg, sizeof(*block->msg));
+	block->cn->len += sizeof(*block->msg);
+	block->msg->len = 0;
+	block->cmd = (struct w1_netlink_cmd *)(block->msg->data);
+
+	space = sizeof(*cmd) + cmd->len;
+	if (block->cmd != cmd)
+		memcpy(block->cmd, cmd, space);
+	block->cn->len += space;
+	block->msg->len += space;
+}
+
+/* Append req_msg and req_cmd, no other commands and no data from req_cmd are
+ * copied.
+ */
+static void w1_netlink_queue_status(struct w1_cb_block *block,
+	struct w1_netlink_msg *req_msg, struct w1_netlink_cmd *req_cmd,
+	int error)
 {
-	char buf[sizeof(struct cn_msg) + sizeof(struct w1_netlink_msg)];
-	struct cn_msg *m = (struct cn_msg *)buf;
-	struct w1_netlink_msg *w = (struct w1_netlink_msg *)(m+1);
+	u16 space = sizeof(struct cn_msg) + sizeof(*req_msg) + sizeof(*req_cmd);
+	w1_reply_make_space(block, space);
+	w1_netlink_setup_msg(block, block->request_cn.ack);
+
+	memcpy(block->msg, req_msg, sizeof(*req_msg));
+	block->cn->len += sizeof(*req_msg);
+	block->msg->len = 0;
+	block->msg->status = (u8)-error;
+	if (req_cmd) {
+		struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)block->msg->data;
+		memcpy(cmd, req_cmd, sizeof(*cmd));
+		block->cn->len += sizeof(*cmd);
+		block->msg->len += sizeof(*cmd);
+		cmd->len = 0;
+	}
+	w1_netlink_check_send(block);
+}
 
-	memset(buf, 0, sizeof(buf));
+/**
+ * w1_netlink_send_error() - sends the error message now
+ * @cn: original cn_msg
+ * @msg: original w1_netlink_msg
+ * @portid: where to send it
+ * @error: error status
+ *
+ * Use when a block isn't available to queue the message to and cn, msg
+ * might not be contiguous.
+ */
+static void w1_netlink_send_error(struct cn_msg *cn, struct w1_netlink_msg *msg,
+	int portid, int error)
+{
+	struct {
+		struct cn_msg cn;
+		struct w1_netlink_msg msg;
+	} packet;
+	memcpy(&packet.cn, cn, sizeof(packet.cn));
+	memcpy(&packet.msg, msg, sizeof(packet.msg));
+	packet.cn.len = sizeof(packet.msg);
+	packet.msg.len = 0;
+	packet.msg.status = (u8)-error;
+	cn_netlink_send(&packet.cn, portid, 0, GFP_KERNEL);
+}
+
+/**
+ * w1_netlink_send() - sends w1 netlink notifications
+ * @dev: w1_master the even is associated with or for
+ * @msg: w1_netlink_msg message to be sent
+ *
+ * This are notifications generated from the kernel.
+ */
+void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
+{
+	struct {
+		struct cn_msg cn;
+		struct w1_netlink_msg msg;
+	} packet;
+	memset(&packet, 0, sizeof(packet));
 
-	m->id.idx = CN_W1_IDX;
-	m->id.val = CN_W1_VAL;
+	packet.cn.id.idx = CN_W1_IDX;
+	packet.cn.id.val = CN_W1_VAL;
 
-	m->seq = dev->seq++;
-	m->len = sizeof(struct w1_netlink_msg);
+	packet.cn.seq = dev->seq++;
+	packet.cn.len = sizeof(*msg);
 
-	memcpy(w, msg, sizeof(struct w1_netlink_msg));
+	memcpy(&packet.msg, msg, sizeof(*msg));
+	packet.msg.len = 0;
 
-	cn_netlink_send(m, dev->portid, 0, GFP_KERNEL);
+	cn_netlink_send(&packet.cn, 0, 0, GFP_KERNEL);
 }
 
 static void w1_send_slave(struct w1_master *dev, u64 rn)
 {
-	struct cn_msg *msg = dev->priv;
-	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
-	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
-	int avail;
+	struct w1_cb_block *block = dev->priv;
+	struct w1_netlink_cmd *cache_cmd = block->cmd;
 	u64 *data;
 
-	avail = dev->priv_size - cmd->len;
+	w1_reply_make_space(block, sizeof(*data));
 
-	if (avail < 8) {
-		msg->ack++;
-		cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
-
-		msg->len = sizeof(struct w1_netlink_msg) +
-			sizeof(struct w1_netlink_cmd);
-		hdr->len = sizeof(struct w1_netlink_cmd);
-		cmd->len = 0;
+	/* Add cmd back if the packet was sent */
+	if (!block->cmd) {
+		cache_cmd->len = 0;
+		w1_netlink_queue_cmd(block, cache_cmd);
 	}
 
-	data = (void *)(cmd + 1) + cmd->len;
+	data = (u64 *)(block->cmd->data + block->cmd->len);
 
 	*data = rn;
-	cmd->len += 8;
-	hdr->len += 8;
-	msg->len += 8;
+	block->cn->len += sizeof(*data);
+	block->msg->len += sizeof(*data);
+	block->cmd->len += sizeof(*data);
 }
 
 static void w1_found_send_slave(struct w1_master *dev, u64 rn)
@@ -85,40 +281,15 @@ static void w1_found_send_slave(struct w1_master *dev, u64 rn)
 }
 
 /* Get the current slave list, or search (with or without alarm) */
-static int w1_get_slaves(struct w1_master *dev,
-		struct cn_msg *req_msg, struct w1_netlink_msg *req_hdr,
-		struct w1_netlink_cmd *req_cmd)
+static int w1_get_slaves(struct w1_master *dev, struct w1_netlink_cmd *req_cmd)
 {
-	struct cn_msg *msg;
-	struct w1_netlink_msg *hdr;
-	struct w1_netlink_cmd *cmd;
 	struct w1_slave *sl;
 
-	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	msg->id = req_msg->id;
-	msg->seq = req_msg->seq;
-	msg->ack = 0;
-	msg->len = sizeof(struct w1_netlink_msg) +
-		sizeof(struct w1_netlink_cmd);
-
-	hdr = (struct w1_netlink_msg *)(msg + 1);
-	cmd = (struct w1_netlink_cmd *)(hdr + 1);
-
-	hdr->type = W1_MASTER_CMD;
-	hdr->id = req_hdr->id;
-	hdr->len = sizeof(struct w1_netlink_cmd);
-
-	cmd->cmd = req_cmd->cmd;
-	cmd->len = 0;
-
-	dev->priv = msg;
-	dev->priv_size = PAGE_SIZE - msg->len - sizeof(struct cn_msg);
+	req_cmd->len = 0;
+	w1_netlink_queue_cmd(dev->priv, req_cmd);
 
 	if (req_cmd->cmd == W1_CMD_LIST_SLAVES) {
-		__u64 rn;
+		u64 rn;
 		mutex_lock(&dev->list_mutex);
 		list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
 			memcpy(&rn, &sl->reg_num, sizeof(rn));
@@ -126,73 +297,26 @@ static int w1_get_slaves(struct w1_master *dev,
 		}
 		mutex_unlock(&dev->list_mutex);
 	} else {
-		w1_search_process_cb(dev, cmd->cmd == W1_CMD_ALARM_SEARCH ?
+		w1_search_process_cb(dev, req_cmd->cmd == W1_CMD_ALARM_SEARCH ?
 			W1_ALARM_SEARCH : W1_SEARCH, w1_found_send_slave);
 	}
 
-	msg->ack = 0;
-	cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
-
-	dev->priv = NULL;
-	dev->priv_size = 0;
-
-	kfree(msg);
-
 	return 0;
 }
 
-static int w1_send_read_reply(struct cn_msg *msg, struct w1_netlink_msg *hdr,
-		struct w1_netlink_cmd *cmd, u32 portid)
-{
-	void *data;
-	struct w1_netlink_msg *h;
-	struct w1_netlink_cmd *c;
-	struct cn_msg *cm;
-	int err;
-
-	data = kzalloc(sizeof(struct cn_msg) +
-			sizeof(struct w1_netlink_msg) +
-			sizeof(struct w1_netlink_cmd) +
-			cmd->len, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	cm = (struct cn_msg *)(data);
-	h = (struct w1_netlink_msg *)(cm + 1);
-	c = (struct w1_netlink_cmd *)(h + 1);
-
-	memcpy(cm, msg, sizeof(struct cn_msg));
-	memcpy(h, hdr, sizeof(struct w1_netlink_msg));
-	memcpy(c, cmd, sizeof(struct w1_netlink_cmd));
-
-	cm->ack = msg->seq+1;
-	cm->len = sizeof(struct w1_netlink_msg) +
-		sizeof(struct w1_netlink_cmd) + cmd->len;
-
-	h->len = sizeof(struct w1_netlink_cmd) + cmd->len;
-
-	memcpy(c->data, cmd->data, c->len);
-
-	err = cn_netlink_send(cm, portid, 0, GFP_KERNEL);
-
-	kfree(data);
-
-	return err;
-}
-
-static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
-		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+static int w1_process_command_io(struct w1_master *dev,
+	struct w1_netlink_cmd *cmd)
 {
 	int err = 0;
 
 	switch (cmd->cmd) {
 	case W1_CMD_TOUCH:
 		w1_touch_block(dev, cmd->data, cmd->len);
-		w1_send_read_reply(msg, hdr, cmd, dev->portid);
+		w1_netlink_queue_cmd(dev->priv, cmd);
 		break;
 	case W1_CMD_READ:
 		w1_read_block(dev, cmd->data, cmd->len);
-		w1_send_read_reply(msg, hdr, cmd, dev->portid);
+		w1_netlink_queue_cmd(dev->priv, cmd);
 		break;
 	case W1_CMD_WRITE:
 		w1_write_block(dev, cmd->data, cmd->len);
@@ -206,14 +330,13 @@ static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
 }
 
 static int w1_process_command_addremove(struct w1_master *dev,
-	struct cn_msg *msg, struct w1_netlink_msg *hdr,
 	struct w1_netlink_cmd *cmd)
 {
 	struct w1_slave *sl;
 	int err = 0;
 	struct w1_reg_num *id;
 
-	if (cmd->len != 8)
+	if (cmd->len != sizeof(*id))
 		return -EINVAL;
 
 	id = (struct w1_reg_num *)cmd->data;
@@ -241,7 +364,6 @@ static int w1_process_command_addremove(struct w1_master *dev,
 }
 
 static int w1_process_command_master(struct w1_master *dev,
-	struct cn_msg *req_msg, struct w1_netlink_msg *req_hdr,
 	struct w1_netlink_cmd *req_cmd)
 {
 	int err = -EINVAL;
@@ -254,13 +376,13 @@ static int w1_process_command_master(struct w1_master *dev,
 	case W1_CMD_ALARM_SEARCH:
 	case W1_CMD_LIST_SLAVES:
 		mutex_unlock(&dev->bus_mutex);
-		err = w1_get_slaves(dev, req_msg, req_hdr, req_cmd);
+		err = w1_get_slaves(dev, req_cmd);
 		mutex_lock(&dev->bus_mutex);
 		break;
 	case W1_CMD_READ:
 	case W1_CMD_WRITE:
 	case W1_CMD_TOUCH:
-		err = w1_process_command_io(dev, req_msg, req_hdr, req_cmd);
+		err = w1_process_command_io(dev, req_cmd);
 		break;
 	case W1_CMD_RESET:
 		err = w1_reset_bus(dev);
@@ -269,8 +391,7 @@ static int w1_process_command_master(struct w1_master *dev,
 	case W1_CMD_SLAVE_REMOVE:
 		mutex_unlock(&dev->bus_mutex);
 		mutex_lock(&dev->mutex);
-		err = w1_process_command_addremove(dev, req_msg, req_hdr,
-			req_cmd);
+		err = w1_process_command_addremove(dev, req_cmd);
 		mutex_unlock(&dev->mutex);
 		mutex_lock(&dev->bus_mutex);
 		break;
@@ -282,22 +403,21 @@ static int w1_process_command_master(struct w1_master *dev,
 	return err;
 }
 
-static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
-		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+static int w1_process_command_slave(struct w1_slave *sl,
+		struct w1_netlink_cmd *cmd)
 {
 	dev_dbg(&sl->master->dev, "%s: %02x.%012llx.%02x: cmd=%02x, len=%u.\n",
 		__func__, sl->reg_num.family, (unsigned long long)sl->reg_num.id,
 		sl->reg_num.crc, cmd->cmd, cmd->len);
 
-	return w1_process_command_io(sl->master, msg, hdr, cmd);
+	return w1_process_command_io(sl->master, cmd);
 }
 
-static int w1_process_command_root(struct cn_msg *msg,
-	struct w1_netlink_msg *mcmd, u32 portid)
+static int w1_process_command_root(struct cn_msg *req_cn, u32 portid)
 {
-	struct w1_master *m;
+	struct w1_master *dev;
 	struct cn_msg *cn;
-	struct w1_netlink_msg *w;
+	struct w1_netlink_msg *msg;
 	u32 *id;
 
 	cn = kmalloc(PAGE_SIZE, GFP_KERNEL);
@@ -307,32 +427,30 @@ static int w1_process_command_root(struct cn_msg *msg,
 	cn->id.idx = CN_W1_IDX;
 	cn->id.val = CN_W1_VAL;
 
-	cn->seq = msg->seq;
-	cn->ack = 1;
+	cn->seq = req_cn->seq;
+	cn->ack = req_cn->seq + 1;
 	cn->len = sizeof(struct w1_netlink_msg);
-	w = (struct w1_netlink_msg *)(cn + 1);
+	msg = (struct w1_netlink_msg *)cn->data;
 
-	w->type = W1_LIST_MASTERS;
-	w->status = 0;
-	w->len = 0;
-	id = (u32 *)(w + 1);
+	msg->type = W1_LIST_MASTERS;
+	msg->status = 0;
+	msg->len = 0;
+	id = (u32 *)msg->data;
 
 	mutex_lock(&w1_mlock);
-	list_for_each_entry(m, &w1_masters, w1_master_entry) {
+	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
 		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
 			cn_netlink_send(cn, portid, 0, GFP_KERNEL);
-			cn->ack++;
 			cn->len = sizeof(struct w1_netlink_msg);
-			w->len = 0;
-			id = (u32 *)(w + 1);
+			msg->len = 0;
+			id = (u32 *)msg->data;
 		}
 
-		*id = m->id;
-		w->len += sizeof(*id);
+		*id = dev->id;
+		msg->len += sizeof(*id);
 		cn->len += sizeof(*id);
 		id++;
 	}
-	cn->ack = 0;
 	cn_netlink_send(cn, portid, 0, GFP_KERNEL);
 	mutex_unlock(&w1_mlock);
 
@@ -340,100 +458,44 @@ static int w1_process_command_root(struct cn_msg *msg,
 	return 0;
 }
 
-static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rmsg,
-		struct w1_netlink_cmd *rcmd, int portid, int error)
-{
-	struct cn_msg *cmsg;
-	struct w1_netlink_msg *msg;
-	struct w1_netlink_cmd *cmd;
-
-	cmsg = kzalloc(sizeof(*msg) + sizeof(*cmd) + sizeof(*cmsg), GFP_KERNEL);
-	if (!cmsg)
-		return -ENOMEM;
-
-	msg = (struct w1_netlink_msg *)(cmsg + 1);
-	cmd = (struct w1_netlink_cmd *)(msg + 1);
-
-	memcpy(cmsg, rcmsg, sizeof(*cmsg));
-	cmsg->len = sizeof(*msg);
-
-	memcpy(msg, rmsg, sizeof(*msg));
-	msg->len = 0;
-	msg->status = (short)-error;
-
-	if (rcmd) {
-		memcpy(cmd, rcmd, sizeof(*cmd));
-		cmd->len = 0;
-		msg->len += sizeof(*cmd);
-		cmsg->len += sizeof(*cmd);
-	}
-
-	error = cn_netlink_send(cmsg, portid, 0, GFP_KERNEL);
-	kfree(cmsg);
-
-	return error;
-}
-
-/* Bundle together a reference count, the full message, and broken out
- * commands to be executed on each w1 master kthread in one memory allocation.
- */
-struct w1_cb_block {
-	atomic_t refcnt;
-	u32 portid; /* Sending process port ID */
-	struct cn_msg msg;
-	/* cn_msg data */
-	/* one or more variable length struct w1_cb_node */
-};
-struct w1_cb_node {
-	struct w1_async_cmd async;
-	/* pointers within w1_cb_block and msg data */
-	struct w1_cb_block *block;
-	struct w1_netlink_msg *m;
-	struct w1_slave *sl;
-	struct w1_master *dev;
-};
-
 static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 {
 	struct w1_cb_node *node = container_of(async_cmd, struct w1_cb_node,
 		async);
-	u16 mlen = node->m->len;
-	u8 *cmd_data = node->m->data;
+	u16 mlen = node->msg->len;
+	u16 len;
 	int err = 0;
 	struct w1_slave *sl = node->sl;
-	struct w1_netlink_cmd *cmd = NULL;
+	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)node->msg->data;
 
 	mutex_lock(&dev->bus_mutex);
-	dev->portid = node->block->portid;
+	dev->priv = node->block;
 	if (sl && w1_reset_select_slave(sl))
 		err = -ENODEV;
+	node->block->cur_msg = node->msg;
 
 	while (mlen && !err) {
-		cmd = (struct w1_netlink_cmd *)cmd_data;
-
 		if (cmd->len + sizeof(struct w1_netlink_cmd) > mlen) {
 			err = -E2BIG;
 			break;
 		}
 
 		if (sl)
-			err = w1_process_command_slave(sl, &node->block->msg,
-				node->m, cmd);
+			err = w1_process_command_slave(sl, cmd);
 		else
-			err = w1_process_command_master(dev, &node->block->msg,
-				node->m, cmd);
+			err = w1_process_command_master(dev, cmd);
+		w1_netlink_check_send(node->block);
 
-		w1_netlink_send_error(&node->block->msg, node->m, cmd,
-			node->block->portid, err);
+		w1_netlink_queue_status(node->block, node->msg, cmd, err);
 		err = 0;
 
-		cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
-		mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
+		len = sizeof(*cmd) + cmd->len;
+		cmd = (struct w1_netlink_cmd *)((u8 *)cmd + len);
+		mlen -= len;
 	}
 
 	if (!cmd || err)
-		w1_netlink_send_error(&node->block->msg, node->m, cmd,
-			node->block->portid, err);
+		w1_netlink_queue_status(node->block, node->msg, cmd, err);
 
 	/* ref taken in w1_search_slave or w1_search_master_id when building
 	 * the block
@@ -442,99 +504,186 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 		w1_unref_slave(sl);
 	else
 		atomic_dec(&dev->refcnt);
-	dev->portid = 0;
+	dev->priv = NULL;
 	mutex_unlock(&dev->bus_mutex);
 
 	mutex_lock(&dev->list_mutex);
 	list_del(&async_cmd->async_entry);
 	mutex_unlock(&dev->list_mutex);
 
-	if (atomic_sub_return(1, &node->block->refcnt) == 0)
-		kfree(node->block);
+	w1_unref_block(node->block);
+}
+
+static void w1_list_count_cmds(struct w1_netlink_msg *msg, int *cmd_count,
+	u16 *slave_len)
+{
+	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)msg->data;
+	u16 mlen = msg->len;
+	u16 len;
+	int slave_list = 0;
+	while (mlen) {
+		if (cmd->len + sizeof(struct w1_netlink_cmd) > mlen)
+			break;
+
+		switch (cmd->cmd) {
+		case W1_CMD_SEARCH:
+		case W1_CMD_ALARM_SEARCH:
+		case W1_CMD_LIST_SLAVES:
+			++slave_list;
+		}
+		++*cmd_count;
+		len = sizeof(*cmd) + cmd->len;
+		cmd = (struct w1_netlink_cmd *)((u8 *)cmd + len);
+		mlen -= len;
+	}
+
+	if (slave_list) {
+		struct w1_master *dev = w1_search_master_id(msg->id.mst.id);
+		if (dev) {
+			/* Bytes, and likely an overstimate, and if it isn't
+			 * the results can still be split between packets.
+			 */
+			*slave_len += sizeof(struct w1_reg_num) * slave_list *
+				(dev->slave_count + dev->max_slave_count);
+			/* search incremented it */
+			atomic_dec(&dev->refcnt);
+		}
+	}
 }
 
-static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
+static void w1_cn_callback(struct cn_msg *cn, struct netlink_skb_parms *nsp)
 {
-	struct w1_netlink_msg *m = (struct w1_netlink_msg *)(msg + 1);
+	struct w1_netlink_msg *msg = (struct w1_netlink_msg *)(cn + 1);
 	struct w1_slave *sl;
 	struct w1_master *dev;
 	u16 msg_len;
+	u16 slave_len = 0;
 	int err = 0;
 	struct w1_cb_block *block = NULL;
 	struct w1_cb_node *node = NULL;
 	int node_count = 0;
+	int cmd_count = 0;
+
+	/* If any unknown flag is set let the application know, that way
+	 * applications can detect the absence of features in kernels that
+	 * don't know about them.  http://lwn.net/Articles/587527/
+	 */
+	if (cn->flags & ~(W1_CN_BUNDLE)) {
+		w1_netlink_send_error(cn, msg, nsp->portid, -EINVAL);
+		return;
+	}
 
 	/* Count the number of master or slave commands there are to allocate
 	 * space for one cb_node each.
 	 */
-	msg_len = msg->len;
+	msg_len = cn->len;
 	while (msg_len && !err) {
-		if (m->len + sizeof(struct w1_netlink_msg) > msg_len) {
+		if (msg->len + sizeof(struct w1_netlink_msg) > msg_len) {
 			err = -E2BIG;
 			break;
 		}
 
-		if (m->type == W1_MASTER_CMD || m->type == W1_SLAVE_CMD)
+		/* count messages for nodes and allocate any additional space
+		 * required for slave lists
+		 */
+		if (msg->type == W1_MASTER_CMD || msg->type == W1_SLAVE_CMD) {
 			++node_count;
+			w1_list_count_cmds(msg, &cmd_count, &slave_len);
+		}
 
-		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
-		m = (struct w1_netlink_msg *)(((u8 *)m) +
-			sizeof(struct w1_netlink_msg) + m->len);
+		msg_len -= sizeof(struct w1_netlink_msg) + msg->len;
+		msg = (struct w1_netlink_msg *)(((u8 *)msg) +
+			sizeof(struct w1_netlink_msg) + msg->len);
 	}
-	m = (struct w1_netlink_msg *)(msg + 1);
+	msg = (struct w1_netlink_msg *)(cn + 1);
 	if (node_count) {
-		/* msg->len doesn't include itself */
-		long size = sizeof(struct w1_cb_block) + msg->len +
-			node_count*sizeof(struct w1_cb_node);
-		block = kmalloc(size, GFP_KERNEL);
+		int size;
+		u16 reply_size = sizeof(*cn) + cn->len + slave_len;
+		if (cn->flags & W1_CN_BUNDLE) {
+			/* bundling duplicats some of the messages */
+			reply_size += 2 * cmd_count * (sizeof(struct cn_msg) +
+				sizeof(struct w1_netlink_msg) +
+				sizeof(struct w1_netlink_cmd));
+		}
+		reply_size = MIN(CONNECTOR_MAX_MSG_SIZE, reply_size);
+
+		/* allocate space for the block, a copy of the original message,
+		 * one node per cmd to point into the original message,
+		 * space for replies which is the original message size plus
+		 * space for any list slave data and status messages
+		 * cn->len doesn't include itself which is part of the block
+		 * */
+		size =  /* block + original message */
+			sizeof(struct w1_cb_block) + sizeof(*cn) + cn->len +
+			/* space for nodes */
+			node_count * sizeof(struct w1_cb_node) +
+			/* replies */
+			sizeof(struct cn_msg) + reply_size;
+		block = kzalloc(size, GFP_KERNEL);
 		if (!block) {
-			w1_netlink_send_error(msg, m, NULL, nsp->portid,
-				-ENOMEM);
+			/* if the system is already out of memory,
+			 * (A) will this work, and (B) would it be better
+			 * to not try?
+			 */
+			w1_netlink_send_error(cn, msg, nsp->portid, -ENOMEM);
 			return;
 		}
 		atomic_set(&block->refcnt, 1);
 		block->portid = nsp->portid;
-		memcpy(&block->msg, msg, sizeof(*msg) + msg->len);
-		node = (struct w1_cb_node *)((u8 *)block->msg.data + msg->len);
+		memcpy(&block->request_cn, cn, sizeof(*cn) + cn->len);
+		node = (struct w1_cb_node *)(block->request_cn.data + cn->len);
+
+		/* Sneeky, when not bundling, reply_size is the allocated space
+		 * required for the reply, cn_msg isn't part of maxlen so
+		 * it should be reply_size - sizeof(struct cn_msg), however
+		 * when checking if there is enough space, w1_reply_make_space
+		 * is called with the full message size including cn_msg,
+		 * because it isn't known at that time if an additional cn_msg
+		 * will need to be allocated.  So an extra cn_msg is added
+		 * above in "size".
+		 */
+		block->maxlen = reply_size;
+		block->first_cn = (struct cn_msg *)(node + node_count);
+		memset(block->first_cn, 0, sizeof(*block->first_cn));
 	}
 
-	msg_len = msg->len;
+	msg_len = cn->len;
 	while (msg_len && !err) {
 
 		dev = NULL;
 		sl = NULL;
 
-		if (m->len + sizeof(struct w1_netlink_msg) > msg_len) {
+		if (msg->len + sizeof(struct w1_netlink_msg) > msg_len) {
 			err = -E2BIG;
 			break;
 		}
 
 		/* execute on this thread, no need to process later */
-		if (m->type == W1_LIST_MASTERS) {
-			err = w1_process_command_root(msg, m, nsp->portid);
+		if (msg->type == W1_LIST_MASTERS) {
+			err = w1_process_command_root(cn, nsp->portid);
 			goto out_cont;
 		}
 
 		/* All following message types require additional data,
 		 * check here before references are taken.
 		 */
-		if (!m->len) {
+		if (!msg->len) {
 			err = -EPROTO;
 			goto out_cont;
 		}
 
-		/* both search calls take reference counts */
-		if (m->type == W1_MASTER_CMD) {
-			dev = w1_search_master_id(m->id.mst.id);
-		} else if (m->type == W1_SLAVE_CMD) {
-			sl = w1_search_slave((struct w1_reg_num *)m->id.id);
+		/* both search calls take references */
+		if (msg->type == W1_MASTER_CMD) {
+			dev = w1_search_master_id(msg->id.mst.id);
+		} else if (msg->type == W1_SLAVE_CMD) {
+			sl = w1_search_slave((struct w1_reg_num *)msg->id.id);
 			if (sl)
 				dev = sl->master;
 		} else {
 			printk(KERN_NOTICE
-				"%s: msg: %x.%x, wrong type: %u, len: %u.\n",
-				__func__, msg->id.idx, msg->id.val,
-				m->type, m->len);
+				"%s: cn: %x.%x, wrong type: %u, len: %u.\n",
+				__func__, cn->id.idx, cn->id.val,
+				msg->type, msg->len);
 			err = -EPROTO;
 			goto out_cont;
 		}
@@ -549,8 +698,8 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		atomic_inc(&block->refcnt);
 		node->async.cb = w1_process_cb;
 		node->block = block;
-		node->m = (struct w1_netlink_msg *)((u8 *)&block->msg +
-			(size_t)((u8 *)m - (u8 *)msg));
+		node->msg = (struct w1_netlink_msg *)((u8 *)&block->request_cn +
+			(size_t)((u8 *)msg - (u8 *)cn));
 		node->sl = sl;
 		node->dev = dev;
 
@@ -561,11 +710,15 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		++node;
 
 out_cont:
+		/* Can't queue because that modifies block and another
+		 * thread could be processing the messages by now and
+		 * there isn't a lock, send directly.
+		 */
 		if (err)
-			w1_netlink_send_error(msg, m, NULL, nsp->portid, err);
-		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
-		m = (struct w1_netlink_msg *)(((u8 *)m) +
-			sizeof(struct w1_netlink_msg) + m->len);
+			w1_netlink_send_error(cn, msg, nsp->portid, err);
+		msg_len -= sizeof(struct w1_netlink_msg) + msg->len;
+		msg = (struct w1_netlink_msg *)(((u8 *)msg) +
+			sizeof(struct w1_netlink_msg) + msg->len);
 
 		/*
 		 * Let's allow requests for nonexisting devices.
@@ -573,8 +726,8 @@ out_cont:
 		if (err == -ENODEV)
 			err = 0;
 	}
-	if (block && atomic_sub_return(1, &block->refcnt) == 0)
-		kfree(block);
+	if (block)
+		w1_unref_block(block);
 }
 
 int w1_init_netlink(void)
@@ -591,7 +744,7 @@ void w1_fini_netlink(void)
 	cn_del_callback(&w1_id);
 }
 #else
-void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
+void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *cn)
 {
 }
 
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 1e9504e..c99a9ce 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -28,6 +28,17 @@
 #include "w1.h"
 
 /**
+ * enum w1_cn_msg_flags - bitfield flags for struct cn_msg.flags
+ *
+ * @W1_CN_BUNDLE: Request bundling replies into fewer messagse.  Be prepared
+ * to handle multiple struct cn_msg, struct w1_netlink_msg, and
+ * struct w1_netlink_cmd in one packet.
+ */
+enum w1_cn_msg_flags {
+	W1_CN_BUNDLE = 1,
+};
+
+/**
  * enum w1_netlink_message_types - message type
  *
  * @W1_SLAVE_ADD: notification that a slave device was added
@@ -49,6 +60,19 @@ enum w1_netlink_message_types {
 	W1_LIST_MASTERS,
 };
 
+/**
+ * struct w1_netlink_msg - holds w1 message type, id, and result
+ *
+ * @type: one of enum w1_netlink_message_types
+ * @status: kernel feedback for success 0 or errno failure value
+ * @len: length of data following w1_netlink_msg
+ * @id: union holding master bus id (msg.id) and slave device id (id[8]).
+ * @data: start address of any following data
+ *
+ * The base message structure for w1 messages over netlink.
+ * The netlink connector data sequence is, struct nlmsghdr, struct cn_msg,
+ * then one or more struct w1_netlink_msg (each with optional data).
+ */
 struct w1_netlink_msg
 {
 	__u8				type;
@@ -66,6 +90,7 @@ struct w1_netlink_msg
 
 /**
  * enum w1_commands - commands available for master or slave operations
+ *
  * @W1_CMD_READ: read len bytes
  * @W1_CMD_WRITE: write len bytes
  * @W1_CMD_SEARCH: initiate a standard search, returns only the slave
@@ -93,6 +118,17 @@ enum w1_commands {
 	W1_CMD_MAX
 };
 
+/**
+ * struct w1_netlink_cmd - holds the command and data
+ *
+ * @cmd: one of enum w1_commands
+ * @res: reserved
+ * @len: length of data following w1_netlink_cmd
+ * @data: start address of any following data
+ *
+ * One or more struct w1_netlink_cmd is placed starting at w1_netlink_msg.data
+ * each with optional data.
+ */
 struct w1_netlink_cmd
 {
 	__u8				cmd;
-- 
1.7.10.4

