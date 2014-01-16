Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaAPEc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:32:27 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45773 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaAPEcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:32:25 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 06/15] w1: new netlink commands, add/remove/list slaves
Date: Wed, 15 Jan 2014 22:29:17 -0600
Message-Id: <1389846566-28862-7-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:32:14 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new commands to add, remove, and list slave devices through
the netlink interface.  This can be useful to skip the search on a
static network.  They could previously only be added or removed
through automatic search or sysfs, and this allows a program to only
use netlink.

Only allocate memory when needed, so move kzalloc into w1_get_slaves
where it was used.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.c         |    6 +--
 drivers/w1/w1.h         |    3 ++
 drivers/w1/w1_netlink.c |  125 ++++++++++++++++++++++++++++++++++-------------
 drivers/w1/w1_netlink.h |   31 +++++++++++-
 4 files changed, 126 insertions(+), 39 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 4c89f85..97b35cb 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -56,8 +56,6 @@ module_param_named(slave_ttl, w1_max_slave_ttl, int, 0);
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
 
-static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn);
-
 static int w1_master_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -444,7 +442,7 @@ static int w1_atoreg_num(struct device *dev, const char *buf, size_t count,
 /* Searches the slaves in the w1_master and returns a pointer or NULL.
  * Note: must hold the mutex
  */
-static struct w1_slave *w1_slave_search_device(struct w1_master *dev,
+struct w1_slave *w1_slave_search_device(struct w1_master *dev,
 	struct w1_reg_num *rn)
 {
 	struct w1_slave *sl;
@@ -711,7 +709,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	return 0;
 }
 
-static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
+int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
 {
 	struct w1_slave *sl;
 	struct w1_family *f;
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 80fbdf9..3376bfb 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -213,6 +213,8 @@ struct w1_slave *w1_search_slave(struct w1_reg_num *id);
 void w1_slave_found(struct w1_master *dev, u64 rn);
 void w1_search_process_cb(struct w1_master *dev, u8 search_type,
 	w1_slave_found_callback cb);
+struct w1_slave *w1_slave_search_device(struct w1_master *dev,
+	struct w1_reg_num *rn);
 struct w1_master *w1_search_master_id(u32 id);
 
 /* Disconnect and reconnect devices in the given family.  Used for finding
@@ -221,6 +223,7 @@ struct w1_master *w1_search_master_id(u32 id);
  * has just been registered, to 0 when it has been unregistered.
  */
 void w1_reconnect_slaves(struct w1_family *f, int attach);
+int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn);
 void w1_slave_detach(struct w1_slave *sl);
 
 u8 w1_triplet(struct w1_master *dev, int bdir);
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 73705af..747174b 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -56,9 +56,6 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 	int avail;
 	u64 *data;
 
-	/* update kernel slave list */
-	w1_slave_found(dev, rn);
-
 	avail = dev->priv_size - cmd->len;
 
 	if (avail < 8) {
@@ -79,17 +76,57 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 	msg->len += 8;
 }
 
-static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
-		unsigned int avail)
+static void w1_found_send_slave(struct w1_master *dev, u64 rn)
 {
-	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
-	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
-	int search_type = (cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH;
+	/* update kernel slave list */
+	w1_slave_found(dev, rn);
+
+	w1_send_slave(dev, rn);
+}
+
+/* Get the current slave list, or search (with or without alarm) */
+static int w1_get_slaves(struct w1_master *dev,
+		struct cn_msg *req_msg, struct w1_netlink_msg *req_hdr,
+		struct w1_netlink_cmd *req_cmd)
+{
+	struct cn_msg *msg;
+	struct w1_netlink_msg *hdr;
+	struct w1_netlink_cmd *cmd;
+	struct w1_slave *sl;
+
+	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	msg->id = req_msg->id;
+	msg->seq = req_msg->seq;
+	msg->ack = 0;
+	msg->len = sizeof(struct w1_netlink_msg) +
+		sizeof(struct w1_netlink_cmd);
+
+	hdr = (struct w1_netlink_msg *)(msg + 1);
+	cmd = (struct w1_netlink_cmd *)(hdr + 1);
+
+	hdr->type = W1_MASTER_CMD;
+	hdr->id = req_hdr->id;
+	hdr->len = sizeof(struct w1_netlink_cmd);
+
+	cmd->cmd = req_cmd->cmd;
+	cmd->len = 0;
 
 	dev->priv = msg;
-	dev->priv_size = avail;
+	dev->priv_size = PAGE_SIZE - msg->len - sizeof(struct cn_msg);
 
-	w1_search_process_cb(dev, search_type, w1_send_slave);
+	if (req_cmd->cmd == W1_CMD_LIST_SLAVES) {
+		__u64 rn;
+		list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
+			memcpy(&rn, &sl->reg_num, sizeof(rn));
+			w1_send_slave(dev, rn);
+		}
+	} else {
+		w1_search_process_cb(dev, cmd->cmd == W1_CMD_ALARM_SEARCH ?
+			W1_ALARM_SEARCH : W1_SEARCH, w1_found_send_slave);
+	}
 
 	msg->ack = 0;
 	cn_netlink_send(msg, 0, GFP_KERNEL);
@@ -97,6 +134,8 @@ static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
 	dev->priv = NULL;
 	dev->priv_size = 0;
 
+	kfree(msg);
+
 	return 0;
 }
 
@@ -164,38 +203,52 @@ static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
 	return err;
 }
 
-static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
-		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
+static int w1_process_command_addremove(struct w1_master *dev,
+	struct cn_msg *msg, struct w1_netlink_msg *hdr,
+	struct w1_netlink_cmd *cmd)
 {
-	int err = -EINVAL;
-	struct cn_msg *msg;
-	struct w1_netlink_msg *hdr;
-	struct w1_netlink_cmd *cmd;
+	struct w1_slave *sl;
+	int err = 0;
+	struct w1_reg_num *id;
 
-	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (cmd->len != 8)
+		return -EINVAL;
 
-	msg->id = req_msg->id;
-	msg->seq = req_msg->seq;
-	msg->ack = 0;
-	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
+	id = (struct w1_reg_num *)cmd->data;
 
-	hdr = (struct w1_netlink_msg *)(msg + 1);
-	cmd = (struct w1_netlink_cmd *)(hdr + 1);
+	sl = w1_slave_search_device(dev, id);
+	switch (cmd->cmd) {
+	case W1_CMD_SLAVE_ADD:
+		if (sl)
+			err = -EINVAL;
+		else
+			err = w1_attach_slave_device(dev, id);
+		break;
+	case W1_CMD_SLAVE_REMOVE:
+		if (sl)
+			w1_slave_detach(sl);
+		else
+			err = -EINVAL;
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
 
-	hdr->type = W1_MASTER_CMD;
-	hdr->id = req_hdr->id;
-	hdr->len = sizeof(struct w1_netlink_cmd);
+	return err;
+}
 
-	cmd->cmd = req_cmd->cmd;
-	cmd->len = 0;
+static int w1_process_command_master(struct w1_master *dev,
+	struct cn_msg *req_msg, struct w1_netlink_msg *req_hdr,
+	struct w1_netlink_cmd *req_cmd)
+{
+	int err = -EINVAL;
 
-	switch (cmd->cmd) {
+	switch (req_cmd->cmd) {
 	case W1_CMD_SEARCH:
 	case W1_CMD_ALARM_SEARCH:
-		err = w1_process_search_command(dev, msg,
-				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
+	case W1_CMD_LIST_SLAVES:
+		err = w1_get_slaves(dev, req_msg, req_hdr, req_cmd);
 		break;
 	case W1_CMD_READ:
 	case W1_CMD_WRITE:
@@ -205,12 +258,16 @@ static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_m
 	case W1_CMD_RESET:
 		err = w1_reset_bus(dev);
 		break;
+	case W1_CMD_SLAVE_ADD:
+	case W1_CMD_SLAVE_REMOVE:
+		err = w1_process_command_addremove(dev, req_msg, req_hdr,
+			req_cmd);
+		break;
 	default:
 		err = -EINVAL;
 		break;
 	}
 
-	kfree(msg);
 	return err;
 }
 
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index b0922dc..ea9f3e4 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -27,6 +27,17 @@
 
 #include "w1.h"
 
+/** enum w1_netlink_message_types - message type
+ *
+ * @W1_SLAVE_ADD: notification that a slave device was added
+ * @W1_SLAVE_REMOVE: notification that a slave device was removed
+ * @W1_MASTER_ADD: notification that a new bus master was added
+ * @W1_MASTER_REMOVE: notification that a bus masterwas removed
+ * @W1_MASTER_CMD: initiate operations on a specific master
+ * @W1_SLAVE_CMD: sends reset, selects the slave, then does a read/write/touch
+ * operation
+ * @W1_LIST_MASTERS: used to determine the bus master identifiers
+ */
 enum w1_netlink_message_types {
 	W1_SLAVE_ADD = 0,
 	W1_SLAVE_REMOVE,
@@ -52,6 +63,21 @@ struct w1_netlink_msg
 	__u8				data[0];
 };
 
+/** enum w1_commands - commands available for master or slave operations
+ * @W1_CMD_READ: read len bytes
+ * @W1_CMD_WRITE: write len bytes
+ * @W1_CMD_SEARCH: initiate a standard search, returns only the slave
+ * devices found during that search
+ * @W1_CMD_ALARM_SEARCH: search for devices that are currently alarming
+ * @W1_CMD_TOUCH: Touches a series of bytes.
+ * @W1_CMD_RESET: sends a bus reset on the given master
+ * @W1_CMD_SLAVE_ADD: adds a slave to the given master,
+ * 8 byte slave id at data[0]
+ * @W1_CMD_SLAVE_REMOVE: removes a slave to the given master,
+ * 8 byte slave id at data[0]
+ * @W1_CMD_LIST_SLAVES: list of slaves registered on this master
+ * @W1_CMD_MAX: number of available commands
+ */
 enum w1_commands {
 	W1_CMD_READ = 0,
 	W1_CMD_WRITE,
@@ -59,7 +85,10 @@ enum w1_commands {
 	W1_CMD_ALARM_SEARCH,
 	W1_CMD_TOUCH,
 	W1_CMD_RESET,
-	W1_CMD_MAX,
+	W1_CMD_SLAVE_ADD,
+	W1_CMD_SLAVE_REMOVE,
+	W1_CMD_LIST_SLAVES,
+	W1_CMD_MAX
 };
 
 struct w1_netlink_cmd
-- 
1.7.10.4

