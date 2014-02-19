Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaBSHTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:19:24 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:59934 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaBSHTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:19:22 -0500
Date: Wed, 19 Feb 2014 01:19:11 -0600
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] w1: bundle reply if the request was bundled
Message-ID: <20140219071911.GA26209@spacedout.fries.net>
References: <20140211164513.GF5530@spacedout.fries.net>
 <20140211210755.GA25579@elgon.mountain>
 <85681392392562@web18h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85681392392562@web18h.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 19 Feb 2014 01:19:13 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A program can bundle multiple messages and commands together when
making one wire requests, which is going to be much more efficient
than sending lots of little packets one write at a time.  With this
change the kernel will then bundle responses to requests that were
bundled, where it's probably even more important because programs will
typically execute select or a poll operation between reading packets,
which takes additional context switches.

Without doing any bundling, reading 14 temperature sensors using slave
commands requires the application to send 14 packets for the
conversion with one command each, and then later for reading it takes
14 packets with two commands each, one to request reading the
scratchpad, and another to read the data back in.  The kernel will
then generate 14 replies with data, and then one status for each of
the three commands per sensor totaling 56 packets or 84 total packets.

That's a lot of context switches and not very efficient on the one
wire bus.  Using master commands allows for merging writes, such as
match rom, rom id, and convert temperature into sending one write to
the hardware.  But that means sending individual commands for reset
and write (for convert), or reset, write, read (for reading the
result) which would be 28 packets without bundling or 2 packets when
bundling.  It requires two packets because it must wait for the
conversion before reading results.  Without this change the kernel
would send one read result, and five command status results, so 6*14 =
84 packets.  With this set of changes it would send three, a set of
status results for the first convert commands, and another status
result along with the data read for the second set.

This also allows an application to get all the results from a bundle
(reading the temperature sensors) at the same time, instead of them
being spread out in time as the one wire bus takes time to execute and
read each response.

Due to the data structure limitation this patch will return packets in
a different order.  For a given bundle all the replies will be sent
first, followed by the status messages.  This is because currently the
connector takes a cn_msg, and the difference between a reply and
status is the ack field of cn_msg.  I could add a second
cn_netlink_send_nlh, to take a nlmsghdr or maybe a length so multiple
cn_msg can be bundled into one packet, then all the messages could be
returned in the current order.
---
 drivers/w1/w1.h         |    8 -
 drivers/w1/w1_netlink.c |  531 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 340 insertions(+), 199 deletions(-)

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
index fa24561..98b9314 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -29,6 +29,198 @@
 #include "w1_netlink.h"
 
 #if defined(CONFIG_W1_CON) && (defined(CONFIG_CONNECTOR) || (defined(CONFIG_CONNECTOR_MODULE) && defined(CONFIG_W1_MODULE)))
+
+#define MIN(a, b)                   (((a) < (b)) ? (a) : (b))
+
+/* Bundle together everything required to process a request in one memory
+ * allocation.
+ */
+struct w1_cb_block {
+	atomic_t refcnt;
+	/* replies, this would be include the data for a read message */
+	/* maximum value for reply_msg->len */
+	u16 reply_maxlen;
+	/* pointers to building up the reply message */
+	struct cn_msg *reply_msg;
+	struct w1_netlink_msg *reply_m;
+	struct w1_netlink_cmd *reply_cmd;
+	/* status, for w1_netlink_msg.status of 0 success or error, can't
+	 * be mixed with reply_msg because the status needs a different ack */
+	/* maximum value for status_msg->len */
+	u16 status_maxlen;
+	/* pointers to building up the status message */
+	struct cn_msg *status_msg;
+	struct w1_netlink_msg *status_m;
+	u32 portid; /* Sending process port ID */
+	struct cn_msg msg;
+	/* cn_msg data (w1_netlink_msg and w1_netlink_cmd )*/
+	/* one or more struct w1_cb_node */
+};
+struct w1_cb_node {
+	struct w1_async_cmd async;
+	/* pointers within w1_cb_block and msg data */
+	struct w1_cb_block *block;
+	struct w1_netlink_msg *m;
+	struct w1_slave *sl;
+	struct w1_master *dev;
+};
+
+static void w1_unref_block(struct w1_cb_block *block)
+{
+	if (atomic_sub_return(1, &block->refcnt) == 0) {
+		if (block->reply_msg && block->reply_msg->len)
+			cn_netlink_send(block->reply_msg, block->portid, 0,
+				GFP_KERNEL);
+		if (block->status_msg && block->status_msg->len)
+			cn_netlink_send(block->status_msg, block->portid, 0,
+				GFP_KERNEL);
+		kfree(block);
+	}
+}
+
+/**
+ * w1_reply_make_space() - send reply_msg if needed to make space
+ * @block: block to make space on
+ * @space: how many bytes requested
+ * @return 0 enough space, -1 still not enough space
+ *
+ * Verify there is enough space to add "space" bytes to the reply_msg,
+ * if there isn't send the message and reset.  The message is reset by
+ * copying the current reply_m to reply_msg->data, clearing reply_cmd,
+ * and updating each len.
+ */
+static int w1_reply_make_space(struct w1_cb_block *block, u16 space)
+{
+	if (block->reply_msg->len + space > block->reply_maxlen) {
+		struct w1_netlink_msg *first_m = (struct w1_netlink_msg *)
+			block->reply_msg->data;
+		cn_netlink_send(block->reply_msg, block->portid, 0, GFP_KERNEL);
+
+		if (block->reply_m != first_m)
+			memcpy(first_m, block->reply_m, sizeof(*first_m));
+		block->reply_msg->len = sizeof(*first_m);
+		block->reply_m->len = 0;
+		block->reply_cmd = NULL;
+
+		if (block->reply_msg->len + space > block->reply_maxlen)
+			return -1;
+	}
+	return 0;
+}
+
+/* Append rmsg to reply_msg, following rmsg->data (any commands) isn't copied.
+ * This is because commands will be processed one at a time and not all
+ * commands have a reply.
+ */
+static void w1_netlink_queue_msg(struct w1_cb_block *block,
+	struct w1_netlink_msg *rmsg)
+{
+	if (block->reply_msg->len + sizeof(*rmsg) > block->reply_maxlen) {
+		cn_netlink_send(block->reply_msg, block->portid, 0, GFP_KERNEL);
+		block->reply_msg->len = 0;
+	}
+
+	if (block->reply_msg->len) {
+		block->reply_m = (struct w1_netlink_msg *)(
+			block->reply_m->data + block->reply_m->len);
+	} else {
+		block->reply_m = (struct w1_netlink_msg *)(
+			block->reply_msg->data);
+	}
+
+	memcpy(block->reply_m, rmsg, sizeof(*rmsg));
+	block->reply_msg->len += sizeof(*rmsg);
+	block->reply_m->len = 0;
+	block->reply_cmd = NULL;
+}
+
+/* Append rcmd to reply_msg, include rcmd->data as well.  This is because
+ * any following data goes with the command and in the case of read is
+ * the results.
+ */
+static void w1_netlink_queue_cmd(struct w1_cb_block *block,
+	struct w1_netlink_cmd *rcmd)
+{
+	uint16_t space = sizeof(*rcmd) + rcmd->len;
+	w1_reply_make_space(block, space);
+
+	if (block->reply_cmd) {
+		block->reply_cmd = (struct w1_netlink_cmd *)(
+			block->reply_cmd->data + block->reply_cmd->len);
+	} else {
+		block->reply_cmd = (struct w1_netlink_cmd *)(
+			block->reply_m->data);
+	}
+
+	if (block->reply_cmd != rcmd)
+		memcpy(block->reply_cmd, rcmd, space);
+	block->reply_msg->len += space;
+	block->reply_m->len += space;
+}
+
+/* Append rmsg and rcmd, no other commands and no data from rcmd are
+ * copied.
+ */
+static void w1_netlink_queue_status(struct w1_cb_block *block,
+	struct w1_netlink_msg *rmsg, struct w1_netlink_cmd *rcmd, int error)
+{
+	if (block->status_msg->len + sizeof(*rmsg) + sizeof(*rcmd) >
+		block->status_maxlen) {
+		/* make sure any replies go out before the status by
+		 * requesting more data than will fit.
+		 */
+		if (block->reply_cmd)
+			w1_reply_make_space(block, block->reply_maxlen);
+		cn_netlink_send(block->status_msg, block->portid, 0,
+			GFP_KERNEL);
+		block->status_msg->len = 0;
+	}
+
+	if (block->status_msg->len) {
+		block->status_m = (struct w1_netlink_msg *)(
+			block->status_m->data + block->status_m->len);
+	} else {
+		block->status_m = (struct w1_netlink_msg *)(
+			block->status_msg->data);
+	}
+	memcpy(block->status_m, rmsg, sizeof(*rmsg));
+	block->status_msg->len += sizeof(*rmsg);
+	block->status_m->len = 0;
+	block->status_m->status = (u8)-error;
+	if (rcmd) {
+		struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)
+			block->status_m->data;
+		memcpy(cmd, rcmd, sizeof(*rcmd));
+		block->status_msg->len += sizeof(*cmd);
+		block->status_m->len += sizeof(*cmd);
+		cmd->len = 0;
+	}
+}
+
+/**
+ * w1_netlink_send_error() - sends the error message now
+ * @msg: original cn_msg
+ * @m: original w1_netlink_msg
+ * @portid: where to send it
+ * @error: error status
+ *
+ * Use when a block isn't available to queue the message to.
+ */
+static void w1_netlink_send_error(struct cn_msg *msg, struct w1_netlink_msg *m,
+	int portid, int error)
+{
+	struct {
+		struct cn_msg msg;
+		struct w1_netlink_msg m;
+	} packet;
+	memcpy(&packet.msg, msg, sizeof(packet.msg));
+	memcpy(&packet.m, m, sizeof(packet.m));
+	packet.msg.len = sizeof(packet.m);
+	packet.m.len = 0;
+	packet.m.status = (u8)-error;
+	cn_netlink_send(&packet.msg, portid, 0, GFP_KERNEL);
+}
+
 /**
  * w1_netlink_send() - sends w1 netlink notifications
  * @dev: w1_master the even is associated with or for
@@ -38,48 +230,48 @@
  */
 void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
 {
-	char buf[sizeof(struct cn_msg) + sizeof(struct w1_netlink_msg)];
-	struct cn_msg *m = (struct cn_msg *)buf;
-	struct w1_netlink_msg *w = (struct w1_netlink_msg *)(m+1);
+	struct {
+		struct cn_msg msg;
+		struct w1_netlink_msg m;
+	} packet;
+	memset(&packet, 0, sizeof(packet));
 
-	memset(buf, 0, sizeof(buf));
+	packet.msg.id.idx = CN_W1_IDX;
+	packet.msg.id.val = CN_W1_VAL;
 
-	m->id.idx = CN_W1_IDX;
-	m->id.val = CN_W1_VAL;
+	packet.msg.seq = dev->seq++;
+	packet.msg.len = sizeof(*msg);
 
-	m->seq = dev->seq++;
-	m->len = sizeof(struct w1_netlink_msg);
+	memcpy(&packet.m, msg, sizeof(*msg));
 
-	memcpy(w, msg, sizeof(struct w1_netlink_msg));
-
-	cn_netlink_send(m, 0, 0, GFP_KERNEL);
+	cn_netlink_send(&packet.msg, 0, 0, GFP_KERNEL);
 }
 
 static void w1_send_slave(struct w1_master *dev, u64 rn)
 {
-	struct cn_msg *msg = dev->priv;
-	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
-	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
-	int avail;
+	struct w1_cb_block *block = dev->priv;
+	struct w1_netlink_cmd *cache_cmd = block->reply_cmd;
 	u64 *data;
 
-	avail = dev->priv_size - cmd->len;
-
-	if (avail < 8) {
-		cn_netlink_send(msg, dev->portid, 0, GFP_KERNEL);
+	if (w1_reply_make_space(block, sizeof(*data)) == -1) {
+		block->reply_m->status = ENOMEM;
+		return;
+	}
 
-		msg->len = sizeof(struct w1_netlink_msg) +
-			sizeof(struct w1_netlink_cmd);
-		hdr->len = sizeof(struct w1_netlink_cmd);
-		cmd->len = 0;
+	/* Add cmd back if the packet was sent, w1_netlink_cmd isn't
+	 * overwritten, but it needs be cleared and moved to make space.
+	 */
+	if (!block->reply_cmd) {
+		cache_cmd->len = 0;
+		w1_netlink_queue_cmd(block, cache_cmd);
 	}
 
-	data = (void *)(cmd + 1) + cmd->len;
+	data = (u64 *)(block->reply_cmd->data + block->reply_cmd->len);
 
 	*data = rn;
-	cmd->len += 8;
-	hdr->len += 8;
-	msg->len += 8;
+	block->reply_msg->len += sizeof(*data);
+	block->reply_m->len += sizeof(*data);
+	block->reply_cmd->len += sizeof(*data);
 }
 
 static void w1_found_send_slave(struct w1_master *dev, u64 rn)
@@ -91,37 +283,12 @@ static void w1_found_send_slave(struct w1_master *dev, u64 rn)
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
-	msg->ack = req_msg->seq + 1;
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
 		__u64 rn;
@@ -132,72 +299,26 @@ static int w1_get_slaves(struct w1_master *dev,
 		}
 		mutex_unlock(&dev->list_mutex);
 	} else {
-		w1_search_process_cb(dev, cmd->cmd == W1_CMD_ALARM_SEARCH ?
+		w1_search_process_cb(dev, req_cmd->cmd == W1_CMD_ALARM_SEARCH ?
 			W1_ALARM_SEARCH : W1_SEARCH, w1_found_send_slave);
 	}
 
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
@@ -211,14 +332,13 @@ static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
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
@@ -246,7 +366,6 @@ static int w1_process_command_addremove(struct w1_master *dev,
 }
 
 static int w1_process_command_master(struct w1_master *dev,
-	struct cn_msg *req_msg, struct w1_netlink_msg *req_hdr,
 	struct w1_netlink_cmd *req_cmd)
 {
 	int err = -EINVAL;
@@ -259,13 +378,13 @@ static int w1_process_command_master(struct w1_master *dev,
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
@@ -274,8 +393,7 @@ static int w1_process_command_master(struct w1_master *dev,
 	case W1_CMD_SLAVE_REMOVE:
 		mutex_unlock(&dev->bus_mutex);
 		mutex_lock(&dev->mutex);
-		err = w1_process_command_addremove(dev, req_msg, req_hdr,
-			req_cmd);
+		err = w1_process_command_addremove(dev, req_cmd);
 		mutex_unlock(&dev->mutex);
 		mutex_lock(&dev->bus_mutex);
 		break;
@@ -287,14 +405,14 @@ static int w1_process_command_master(struct w1_master *dev,
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
 
 static int w1_process_command_root(struct cn_msg *msg,
@@ -343,59 +461,6 @@ static int w1_process_command_root(struct cn_msg *msg,
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
@@ -407,9 +472,11 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 	struct w1_netlink_cmd *cmd = NULL;
 
 	mutex_lock(&dev->bus_mutex);
-	dev->portid = node->block->portid;
+	dev->priv = node->block;
 	if (sl && w1_reset_select_slave(sl))
 		err = -ENODEV;
+	if (!err)
+		w1_netlink_queue_msg(node->block, node->m);
 
 	while (mlen && !err) {
 		cmd = (struct w1_netlink_cmd *)cmd_data;
@@ -420,14 +487,11 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 		}
 
 		if (sl)
-			err = w1_process_command_slave(sl, &node->block->msg,
-				node->m, cmd);
+			err = w1_process_command_slave(sl, cmd);
 		else
-			err = w1_process_command_master(dev, &node->block->msg,
-				node->m, cmd);
+			err = w1_process_command_master(dev, cmd);
 
-		w1_netlink_send_error(&node->block->msg, node->m, cmd,
-			node->block->portid, err);
+		w1_netlink_queue_status(node->block, node->m, cmd, err);
 		err = 0;
 
 		cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
@@ -435,8 +499,7 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 	}
 
 	if (!cmd || err)
-		w1_netlink_send_error(&node->block->msg, node->m, cmd,
-			node->block->portid, err);
+		w1_netlink_queue_status(node->block, node->m, cmd, err);
 
 	/* ref taken in w1_search_slave or w1_search_master_id when building
 	 * the block
@@ -445,15 +508,36 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
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
+static void w1_list_count_cmds(void *data, u16 mlen, int *slave_list,
+	int *cmd_count)
+{
+	struct w1_netlink_cmd *cmd = data;
+	u16 len;
+	while (mlen) {
+		if (cmd->len + sizeof(struct w1_netlink_cmd) > mlen)
+			break;
+
+		switch (cmd->cmd) {
+		case W1_CMD_SEARCH:
+		case W1_CMD_ALARM_SEARCH:
+		case W1_CMD_LIST_SLAVES:
+			++*slave_list;
+		}
+		++*cmd_count;
+		len = cmd->len + sizeof(struct w1_netlink_cmd);
+		mlen -= len;
+		cmd = (struct w1_netlink_cmd *)((u8 *)cmd + len);
+	}
 }
 
 static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
@@ -462,10 +546,12 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	struct w1_slave *sl;
 	struct w1_master *dev;
 	u16 msg_len;
+	u16 slave_len = 0;
 	int err = 0;
 	struct w1_cb_block *block = NULL;
 	struct w1_cb_node *node = NULL;
 	int node_count = 0;
+	int cmd_count = 0;
 
 	/* Count the number of master or slave commands there are to allocate
 	 * space for one cb_node each.
@@ -477,8 +563,30 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 			break;
 		}
 
-		if (m->type == W1_MASTER_CMD || m->type == W1_SLAVE_CMD)
+
+		/* count messages for nodes and allocate any additional space
+		 * required for slave lists
+		 */
+		if (m->type == W1_MASTER_CMD || m->type == W1_SLAVE_CMD) {
+			int slave_list = 0;
 			++node_count;
+			w1_list_count_cmds(m->data, m->len, &slave_list,
+				&cmd_count);
+			if (slave_list) {
+				dev = w1_search_master_id(m->id.mst.id);
+				if (dev) {
+					/* expected worse case, more slaves
+					 * could be found or added by the time
+					 * the block is finished
+					 */
+					slave_len = sizeof(struct w1_reg_num) *
+						slave_list *
+						(dev->max_slave_count +
+						dev->slave_count);
+					atomic_dec(&dev->refcnt);
+				}
+			}
+		}
 
 		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
 		m = (struct w1_netlink_msg *)(((u8 *)m) +
@@ -486,19 +594,56 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	}
 	m = (struct w1_netlink_msg *)(msg + 1);
 	if (node_count) {
-		/* msg->len doesn't include itself */
-		long size = sizeof(struct w1_cb_block) + msg->len +
-			node_count*sizeof(struct w1_cb_node);
-		block = kmalloc(size, GFP_KERNEL);
+		u16 reply_size = MIN(CONNECTOR_MAX_MSG_SIZE,
+			sizeof(struct cn_msg) + msg->len + slave_len);
+		u16 status_size = MIN(CONNECTOR_MAX_MSG_SIZE,
+			sizeof(struct cn_msg) + cmd_count *
+			(sizeof(struct w1_netlink_msg) +
+			sizeof(struct w1_netlink_cmd)));
+		u16 reply_maxlen = reply_size - sizeof(struct cn_msg);
+		u16 status_maxlen = status_size - sizeof(struct cn_msg);
+
+		/* allocate space for the block, a copy of the original message,
+		 * one node per cmd to point into the original message,
+		 * space for replies which is the original message size plus
+		 * space for any list slave data,
+		 * space for status message
+		 * msg->len doesn't include itself which is part of the block
+		 * */
+		long size =
+			/* original message */
+			sizeof(struct w1_cb_block) + msg->len +
+			/* space for nodes */
+			node_count * sizeof(struct w1_cb_node) +
+			/* replies */
+			reply_size +
+			/* status */
+			status_size;
+		block = kzalloc(size, GFP_KERNEL);
 		if (!block) {
-			w1_netlink_send_error(msg, m, NULL, nsp->portid,
-				-ENOMEM);
+			/* if the system is already out of memory,
+			 * (A) will this work, and (B) would it be better
+			 * to not try?
+			 */
+			w1_netlink_send_error(msg, m, nsp->portid, -ENOMEM);
 			return;
 		}
 		atomic_set(&block->refcnt, 1);
 		block->portid = nsp->portid;
 		memcpy(&block->msg, msg, sizeof(*msg) + msg->len);
 		node = (struct w1_cb_node *)((u8 *)block->msg.data + msg->len);
+
+		block->reply_maxlen = reply_maxlen;
+		block->reply_msg = (struct cn_msg *)(node + node_count);
+		memcpy(block->reply_msg, msg, sizeof(*msg));
+		block->reply_msg->len = 0;
+		block->reply_msg->ack = block->reply_msg->seq + 1;
+
+		block->status_maxlen = status_maxlen;
+		block->status_msg = (struct cn_msg *)((u8 *)block + size -
+			status_size);
+		memcpy(block->status_msg, msg, sizeof(*msg));
+		block->status_msg->len = 0;
 	}
 
 	msg_len = msg->len;
@@ -564,8 +709,12 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		++node;
 
 out_cont:
+		/* Can't queue because that modifies block and another
+		 * thread could be processing the messages by now and
+		 * there isn't a lock, send directly.
+		 */
 		if (err)
-			w1_netlink_send_error(msg, m, NULL, nsp->portid, err);
+			w1_netlink_send_error(msg, m, nsp->portid, err);
 		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
 		m = (struct w1_netlink_msg *)(((u8 *)m) +
 			sizeof(struct w1_netlink_msg) + m->len);
@@ -576,8 +725,8 @@ out_cont:
 		if (err == -ENODEV)
 			err = 0;
 	}
-	if (block && atomic_sub_return(1, &block->refcnt) == 0)
-		kfree(block);
+	if (block)
+		w1_unref_block(block);
 }
 
 int w1_init_netlink(void)
-- 
1.7.10.4
