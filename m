Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaAPEco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:32:44 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45777 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaAPEcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:32:41 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 07/15] w1: process w1 netlink commands in w1_process thread
Date: Wed, 15 Jan 2014 22:29:18 -0600
Message-Id: <1389846566-28862-8-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:32:32 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netlink is a socket interface and is expected to be asynchronous.
Clients can now make w1 requests without blocking by making use of the
w1_master thread to process netlink commands which was previously only
used for doing an automatic bus search.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.c         |  180 +++++++++++++++++++++++++++++++++--------------
 drivers/w1/w1.h         |   32 ++++++++-
 drivers/w1/w1_int.c     |   17 +++--
 drivers/w1/w1_netlink.c |  166 +++++++++++++++++++++++++++++++++----------
 4 files changed, 300 insertions(+), 95 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 97b35cb..53846c7 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -79,19 +79,10 @@ static void w1_slave_release(struct device *dev)
 {
 	struct w1_slave *sl = dev_to_w1_slave(dev);
 
-	dev_dbg(dev, "%s: Releasing %s.\n", __func__, sl->name);
-
-	while (atomic_read(&sl->refcnt)) {
-		dev_dbg(dev, "Waiting for %s to become free: refcnt=%d.\n",
-				sl->name, atomic_read(&sl->refcnt));
-		if (msleep_interruptible(1000))
-			flush_signals(current);
-	}
+	dev_dbg(dev, "%s: Releasing %s [%p]\n", __func__, sl->name, sl);
 
 	w1_family_put(sl->family);
 	sl->master->slave_count--;
-
-	complete(&sl->released);
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -277,7 +268,6 @@ static ssize_t w1_master_attribute_store_pullup(struct device *dev,
 	mutex_lock(&md->mutex);
 	md->enable_pullup = tmp;
 	mutex_unlock(&md->mutex);
-	wake_up_process(md->thread);
 
 	return count;
 }
@@ -370,23 +360,20 @@ static ssize_t w1_master_attribute_show_slaves(struct device *dev,
 {
 	struct w1_master *md = dev_to_w1_master(dev);
 	int c = PAGE_SIZE;
+	struct list_head *ent, *n;
+	struct w1_slave *sl = NULL;
 
-	mutex_lock(&md->mutex);
-
-	if (md->slave_count == 0)
-		c -= snprintf(buf + PAGE_SIZE - c, c, "not found.\n");
-	else {
-		struct list_head *ent, *n;
-		struct w1_slave *sl;
+	mutex_lock(&md->list_mutex);
 
-		list_for_each_safe(ent, n, &md->slist) {
-			sl = list_entry(ent, struct w1_slave, w1_slave_entry);
+	list_for_each_safe(ent, n, &md->slist) {
+		sl = list_entry(ent, struct w1_slave, w1_slave_entry);
 
-			c -= snprintf(buf + PAGE_SIZE - c, c, "%s\n", sl->name);
-		}
+		c -= snprintf(buf + PAGE_SIZE - c, c, "%s\n", sl->name);
 	}
+	if (!sl)
+		c -= snprintf(buf + PAGE_SIZE - c, c, "not found.\n");
 
-	mutex_unlock(&md->mutex);
+	mutex_unlock(&md->list_mutex);
 
 	return PAGE_SIZE - c;
 }
@@ -440,19 +427,22 @@ static int w1_atoreg_num(struct device *dev, const char *buf, size_t count,
 }
 
 /* Searches the slaves in the w1_master and returns a pointer or NULL.
- * Note: must hold the mutex
+ * Note: must not hold list_mutex
  */
 struct w1_slave *w1_slave_search_device(struct w1_master *dev,
 	struct w1_reg_num *rn)
 {
 	struct w1_slave *sl;
+	mutex_lock(&dev->list_mutex);
 	list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
 		if (sl->reg_num.family == rn->family &&
 				sl->reg_num.id == rn->id &&
 				sl->reg_num.crc == rn->crc) {
+			mutex_unlock(&dev->list_mutex);
 			return sl;
 		}
 	}
+	mutex_unlock(&dev->list_mutex);
 	return NULL;
 }
 
@@ -509,7 +499,10 @@ static ssize_t w1_master_attribute_store_remove(struct device *dev,
 	mutex_lock(&md->mutex);
 	sl = w1_slave_search_device(md, &rn);
 	if (sl) {
-		w1_slave_detach(sl);
+		result = w1_slave_detach(sl);
+		/* refcnt 0 means it was detached in the call */
+		if (result == 0)
+			result = count;
 	} else {
 		dev_info(dev, "Device %02x-%012llx doesn't exists\n", rn.family,
 			(unsigned long long)rn.id);
@@ -704,7 +697,9 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	dev_set_uevent_suppress(&sl->dev, false);
 	kobject_uevent(&sl->dev.kobj, KOBJ_ADD);
 
+	mutex_lock(&sl->master->list_mutex);
 	list_add_tail(&sl->w1_slave_entry, &sl->master->slist);
+	mutex_unlock(&sl->master->list_mutex);
 
 	return 0;
 }
@@ -731,8 +726,8 @@ int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
 
 	memset(&msg, 0, sizeof(msg));
 	memcpy(&sl->reg_num, rn, sizeof(sl->reg_num));
-	atomic_set(&sl->refcnt, 0);
-	init_completion(&sl->released);
+	atomic_set(&sl->refcnt, 1);
+	atomic_inc(&sl->master->refcnt);
 
 	/* slave modules need to be loaded in a context with unlocked mutex */
 	mutex_unlock(&dev->mutex);
@@ -772,23 +767,48 @@ int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
 	return 0;
 }
 
-void w1_slave_detach(struct w1_slave *sl)
+int w1_unref_slave(struct w1_slave *sl)
 {
-	struct w1_netlink_msg msg;
-
-	dev_dbg(&sl->dev, "%s: detaching %s [%p].\n", __func__, sl->name, sl);
-
-	list_del(&sl->w1_slave_entry);
-
-	memset(&msg, 0, sizeof(msg));
-	memcpy(msg.id.id, &sl->reg_num, sizeof(msg.id));
-	msg.type = W1_SLAVE_REMOVE;
-	w1_netlink_send(sl->master, &msg);
-
-	device_unregister(&sl->dev);
+	struct w1_master *dev = sl->master;
+	int refcnt;
+	mutex_lock(&dev->list_mutex);
+	refcnt = atomic_sub_return(1, &sl->refcnt);
+	if (refcnt == 0) {
+		struct w1_netlink_msg msg;
+
+		dev_dbg(&sl->dev, "%s: detaching %s [%p].\n", __func__,
+			sl->name, sl);
+
+		list_del(&sl->w1_slave_entry);
+
+		memset(&msg, 0, sizeof(msg));
+		memcpy(msg.id.id, &sl->reg_num, sizeof(msg.id));
+		msg.type = W1_SLAVE_REMOVE;
+		w1_netlink_send(sl->master, &msg);
+
+		device_unregister(&sl->dev);
+		#ifdef DEBUG
+		memset(sl, 0, sizeof(*sl));
+		#endif
+		kfree(sl);
+	}
+	atomic_dec(&dev->refcnt);
+	mutex_unlock(&dev->list_mutex);
+	return refcnt;
+}
 
-	wait_for_completion(&sl->released);
-	kfree(sl);
+int w1_slave_detach(struct w1_slave *sl)
+{
+	/* Only detach a slave once as it decreases the refcnt each time. */
+	int destroy_now;
+	mutex_lock(&sl->master->list_mutex);
+	destroy_now = !test_bit(W1_SLAVE_DETACH, &sl->flags);
+	set_bit(W1_SLAVE_DETACH, &sl->flags);
+	mutex_unlock(&sl->master->list_mutex);
+
+	if (destroy_now)
+		destroy_now = !w1_unref_slave(sl);
+	return destroy_now ? 0 : -EBUSY;
 }
 
 struct w1_master *w1_search_master_id(u32 id)
@@ -817,7 +837,7 @@ struct w1_slave *w1_search_slave(struct w1_reg_num *id)
 
 	mutex_lock(&w1_mlock);
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
-		mutex_lock(&dev->mutex);
+		mutex_lock(&dev->list_mutex);
 		list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
 			if (sl->reg_num.family == id->family &&
 					sl->reg_num.id == id->id &&
@@ -828,7 +848,7 @@ struct w1_slave *w1_search_slave(struct w1_reg_num *id)
 				break;
 			}
 		}
-		mutex_unlock(&dev->mutex);
+		mutex_unlock(&dev->list_mutex);
 
 		if (found)
 			break;
@@ -848,6 +868,7 @@ void w1_reconnect_slaves(struct w1_family *f, int attach)
 		dev_dbg(&dev->dev, "Reconnecting slaves in device %s "
 			"for family %02x.\n", dev->name, f->fid);
 		mutex_lock(&dev->mutex);
+		mutex_lock(&dev->list_mutex);
 		list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
 			/* If it is a new family, slaves with the default
 			 * family driver and are that family will be
@@ -859,14 +880,19 @@ void w1_reconnect_slaves(struct w1_family *f, int attach)
 				(!attach && sl->family->fid == f->fid)) {
 				struct w1_reg_num rn;
 
+				mutex_unlock(&dev->list_mutex);
 				memcpy(&rn, &sl->reg_num, sizeof(rn));
-				w1_slave_detach(sl);
-
-				w1_attach_slave_device(dev, &rn);
+				/* If it was already in use let the automatic
+				 * scan pick it up again later.
+				 */
+				if (!w1_slave_detach(sl))
+					w1_attach_slave_device(dev, &rn);
+				mutex_lock(&dev->list_mutex);
 			}
 		}
 		dev_dbg(&dev->dev, "Reconnecting slaves in device %s "
 			"has been finished.\n", dev->name);
+		mutex_unlock(&dev->list_mutex);
 		mutex_unlock(&dev->mutex);
 	}
 	mutex_unlock(&w1_mlock);
@@ -1020,17 +1046,24 @@ void w1_search_process_cb(struct w1_master *dev, u8 search_type,
 {
 	struct w1_slave *sl, *sln;
 
+	mutex_lock(&dev->list_mutex);
 	list_for_each_entry(sl, &dev->slist, w1_slave_entry)
 		clear_bit(W1_SLAVE_ACTIVE, &sl->flags);
+	mutex_unlock(&dev->list_mutex);
 
 	w1_search_devices(dev, search_type, cb);
 
+	mutex_lock(&dev->list_mutex);
 	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-		if (!test_bit(W1_SLAVE_ACTIVE, &sl->flags) && !--sl->ttl)
+		if (!test_bit(W1_SLAVE_ACTIVE, &sl->flags) && !--sl->ttl) {
+			mutex_unlock(&dev->list_mutex);
 			w1_slave_detach(sl);
+			mutex_lock(&dev->list_mutex);
+		}
 		else if (test_bit(W1_SLAVE_ACTIVE, &sl->flags))
 			sl->ttl = dev->slave_ttl;
 	}
+	mutex_unlock(&dev->list_mutex);
 
 	if (dev->search_count > 0)
 		dev->search_count--;
@@ -1041,6 +1074,26 @@ static void w1_search_process(struct w1_master *dev, u8 search_type)
 	w1_search_process_cb(dev, search_type, w1_slave_found);
 }
 
+int w1_process_callbacks(struct w1_master *dev)
+{
+	int ret = 0;
+	struct w1_async_cmd *async_cmd, *async_n;
+
+	/* The list can be added to in another thread, loop until it is empty */
+	while (!list_empty(&dev->async_list)) {
+		list_for_each_entry_safe(async_cmd, async_n, &dev->async_list,
+			async_entry) {
+			/* drop the lock, if it is a search it can take a long
+			 * time */
+			mutex_unlock(&dev->list_mutex);
+			async_cmd->cb(dev, async_cmd);
+			ret = 1;
+			mutex_lock(&dev->list_mutex);
+		}
+	}
+	return ret;
+}
+
 int w1_process(void *data)
 {
 	struct w1_master *dev = (struct w1_master *) data;
@@ -1048,23 +1101,46 @@ int w1_process(void *data)
 	 * time can be calculated in jiffies once.
 	 */
 	const unsigned long jtime = msecs_to_jiffies(w1_timeout * 1000);
+	/* remainder if it woke up early */
+	unsigned long jremain = 0;
 
-	while (!kthread_should_stop()) {
-		if (dev->search_count) {
+	for (;;) {
+
+		if (!jremain && dev->search_count) {
 			mutex_lock(&dev->mutex);
 			w1_search_process(dev, W1_SEARCH);
 			mutex_unlock(&dev->mutex);
 		}
 
+		mutex_lock(&dev->list_mutex);
+		/* Note, w1_process_callback drops the lock while processing,
+		 * but locks it again before returning.
+		 */
+		if (!w1_process_callbacks(dev) && jremain) {
+			/* a wake up is either to stop the thread, process
+			 * callbacks, or search, it isn't process callbacks, so
+			 * schedule a search.
+			 */
+			jremain = 1;
+		}
+
 		try_to_freeze();
 		__set_current_state(TASK_INTERRUPTIBLE);
 
+		/* hold list_mutex until after interruptible to prevent loosing
+		 * the wakeup signal when async_cmd is added.
+		 */
+		mutex_unlock(&dev->list_mutex);
+
 		if (kthread_should_stop())
 			break;
 
 		/* Only sleep when the search is active. */
-		if (dev->search_count)
-			schedule_timeout(jtime);
+		if (dev->search_count) {
+			if (!jremain)
+				jremain = jtime;
+			jremain = schedule_timeout(jremain);
+		}
 		else
 			schedule();
 	}
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 3376bfb..a096ef4 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -58,6 +58,7 @@ struct w1_reg_num
 #define W1_RESUME_CMD		0xA5
 
 #define W1_SLAVE_ACTIVE		0
+#define W1_SLAVE_DETACH		1
 
 struct w1_slave
 {
@@ -74,7 +75,6 @@ struct w1_slave
 	struct w1_family	*family;
 	void			*family_data;
 	struct device		dev;
-	struct completion	released;
 };
 
 typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
@@ -171,7 +171,14 @@ struct w1_master
 	struct list_head	w1_master_entry;
 	struct module		*owner;
 	unsigned char		name[W1_MAXNAMELEN];
+	/* list_mutex protects just slist and async_list so slaves can be
+	 * searched for and async commands added while the master has
+	 * w1_master.mutex locked and is operating on the bus.
+	 * lock order w1_mlock, w1_master.mutex, w1_master_list_mutex
+	 */
+	struct mutex		list_mutex;
 	struct list_head	slist;
+	struct list_head	async_list;
 	int			max_slave_count, slave_count;
 	unsigned long		attempts;
 	int			slave_ttl;
@@ -205,11 +212,29 @@ struct w1_master
 	u32			seq;
 };
 
+/**
+ * struct w1_async_cmd - execute callback from the w1_process kthread
+ * @async_entry: link entry
+ * @cb: callback function, must list_del and destroy this list before
+ * returning
+ *
+ * When inserted into the w1_master async_list, w1_process will execute
+ * the callback.  Embed this into the structure with the command details.
+ */
+struct w1_async_cmd {
+	struct list_head	async_entry;
+	void (*cb)(struct w1_master *dev, struct w1_async_cmd *async_cmd);
+};
+
 int w1_create_master_attributes(struct w1_master *);
 void w1_destroy_master_attributes(struct w1_master *master);
 void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
 void w1_search_devices(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb);
+/* call w1_unref_slave to release the reference counts w1_search_slave added */
 struct w1_slave *w1_search_slave(struct w1_reg_num *id);
+/* decrements the reference on sl->master and sl, and cleans up if zero
+ * returns the reference count after it has been decremented */
+int w1_unref_slave(struct w1_slave *sl);
 void w1_slave_found(struct w1_master *dev, u64 rn);
 void w1_search_process_cb(struct w1_master *dev, u8 search_type,
 	w1_slave_found_callback cb);
@@ -224,7 +249,8 @@ struct w1_master *w1_search_master_id(u32 id);
  */
 void w1_reconnect_slaves(struct w1_family *f, int attach);
 int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn);
-void w1_slave_detach(struct w1_slave *sl);
+/* 0 success, otherwise EBUSY */
+int w1_slave_detach(struct w1_slave *sl);
 
 u8 w1_triplet(struct w1_master *dev, int bdir);
 void w1_write_8(struct w1_master *, u8);
@@ -260,6 +286,8 @@ extern int w1_max_slave_ttl;
 extern struct list_head w1_masters;
 extern struct mutex w1_mlock;
 
+/* returns 1 if there were commands to executed 0 otherwise */
+extern int w1_process_callbacks(struct w1_master *dev);
 extern int w1_process(void *);
 
 #endif /* __KERNEL__ */
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index f84e48b..ae3b595 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -75,8 +75,10 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	atomic_set(&dev->refcnt, 2);
 
 	INIT_LIST_HEAD(&dev->slist);
+	INIT_LIST_HEAD(&dev->async_list);
 	mutex_init(&dev->mutex);
 	mutex_init(&dev->bus_mutex);
+	mutex_init(&dev->list_mutex);
 
 	memcpy(&dev->dev, device, sizeof(struct device));
 	dev_set_name(&dev->dev, "w1_bus_master%u", dev->id);
@@ -200,17 +202,22 @@ void __w1_remove_master_device(struct w1_master *dev)
 	struct w1_netlink_msg msg;
 	struct w1_slave *sl, *sln;
 
-	set_bit(W1_ABORT_SEARCH, &dev->flags);
-	kthread_stop(dev->thread);
-
 	mutex_lock(&w1_mlock);
 	list_del(&dev->w1_master_entry);
 	mutex_unlock(&w1_mlock);
 
+	set_bit(W1_ABORT_SEARCH, &dev->flags);
+	kthread_stop(dev->thread);
+
 	mutex_lock(&dev->mutex);
-	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry)
+	mutex_lock(&dev->list_mutex);
+	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
+		mutex_unlock(&dev->list_mutex);
 		w1_slave_detach(sl);
+		mutex_lock(&dev->list_mutex);
+	}
 	w1_destroy_master_attributes(dev);
+	mutex_unlock(&dev->list_mutex);
 	mutex_unlock(&dev->mutex);
 	atomic_dec(&dev->refcnt);
 
@@ -220,7 +227,9 @@ void __w1_remove_master_device(struct w1_master *dev)
 
 		if (msleep_interruptible(1000))
 			flush_signals(current);
+		w1_process_callbacks(dev);
 	}
+	w1_process_callbacks(dev);
 
 	memset(&msg, 0, sizeof(msg));
 	msg.id.mst.id = dev->id;
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 747174b..06d614a 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -119,10 +119,12 @@ static int w1_get_slaves(struct w1_master *dev,
 
 	if (req_cmd->cmd == W1_CMD_LIST_SLAVES) {
 		__u64 rn;
+		mutex_lock(&dev->list_mutex);
 		list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
 			memcpy(&rn, &sl->reg_num, sizeof(rn));
 			w1_send_slave(dev, rn);
 		}
+		mutex_unlock(&dev->list_mutex);
 	} else {
 		w1_search_process_cb(dev, cmd->cmd == W1_CMD_ALARM_SEARCH ?
 			W1_ALARM_SEARCH : W1_SEARCH, w1_found_send_slave);
@@ -368,29 +370,134 @@ static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rm
 	return error;
 }
 
+/* Bundle together a reference count, the full message, and broken out
+ * commands to be executed on each w1 master kthread in one memory allocation.
+ */
+struct w1_cb_block {
+	atomic_t refcnt;
+	struct cn_msg msg;
+	/* cn_msg data */
+	/* one or more variable length struct w1_cb_node */
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
+static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
+{
+	struct w1_cb_node *node = container_of(async_cmd, struct w1_cb_node,
+		async);
+	u16 mlen = node->m->len;
+	u8 *cmd_data = node->m->data;
+	int err = 0;
+	struct w1_slave *sl = node->sl;
+	struct w1_netlink_cmd *cmd = NULL;
+
+	mutex_lock(&dev->mutex);
+	if (sl && w1_reset_select_slave(sl))
+		err = -ENODEV;
+
+	while (mlen && !err) {
+		cmd = (struct w1_netlink_cmd *)cmd_data;
+
+		if (cmd->len + sizeof(struct w1_netlink_cmd) > mlen) {
+			err = -E2BIG;
+			break;
+		}
+
+		if (sl)
+			err = w1_process_command_slave(sl, &node->block->msg,
+				node->m, cmd);
+		else
+			err = w1_process_command_master(dev, &node->block->msg,
+				node->m, cmd);
+
+		w1_netlink_send_error(&node->block->msg, node->m, cmd, err);
+		err = 0;
+
+		cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
+		mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
+	}
+
+	if (!cmd || err)
+		w1_netlink_send_error(&node->block->msg, node->m, cmd, err);
+
+	if (sl)
+		w1_unref_slave(sl);
+	else
+		atomic_dec(&dev->refcnt);
+	mutex_unlock(&dev->mutex);
+
+	mutex_lock(&dev->list_mutex);
+	list_del(&async_cmd->async_entry);
+	mutex_unlock(&dev->list_mutex);
+
+	if (atomic_sub_return(1, &node->block->refcnt) == 0)
+		kfree(node->block);
+}
+
 static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct w1_netlink_msg *m = (struct w1_netlink_msg *)(msg + 1);
-	struct w1_netlink_cmd *cmd;
 	struct w1_slave *sl;
 	struct w1_master *dev;
+	u16 msg_len;
 	int err = 0;
+	struct w1_cb_block *block = NULL;
+	struct w1_cb_node *node = NULL;
+	int node_count = 0;
+
+	/* Count the number of master or slave commands there are to allocate
+	 * space for one cb_node each.
+	 */
+	msg_len = msg->len;
+	while (msg_len && !err) {
+		if (m->len + sizeof(struct w1_netlink_msg) > msg_len) {
+			err = -E2BIG;
+			break;
+		}
+
+		if (m->type == W1_MASTER_CMD || m->type == W1_SLAVE_CMD)
+			++node_count;
+
+		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
+		m = (struct w1_netlink_msg *)(((u8 *)m) +
+			sizeof(struct w1_netlink_msg) + m->len);
+	}
+	m = (struct w1_netlink_msg *)(msg + 1);
+	if (node_count) {
+		/* msg->len doesn't include itself */
+		long size = sizeof(struct w1_cb_block) + msg->len +
+			node_count*sizeof(struct w1_cb_node);
+		block = kmalloc(size, GFP_KERNEL);
+		if (!block) {
+			w1_netlink_send_error(msg, m, NULL, -ENOMEM);
+			return;
+		}
+		atomic_set(&block->refcnt, 1);
+		memcpy(&block->msg, msg, sizeof(*msg) + msg->len);
+		node = (struct w1_cb_node *)((u8 *)block->msg.data + msg->len);
+	}
 
-	while (msg->len && !err) {
+	msg_len = msg->len;
+	while (msg_len && !err) {
 		struct w1_reg_num id;
 		u16 mlen = m->len;
-		u8 *cmd_data = m->data;
 
 		dev = NULL;
 		sl = NULL;
-		cmd = NULL;
 
 		memcpy(&id, m->id.id, sizeof(id));
 #if 0
 		printk("%s: %02x.%012llx.%02x: type=%02x, len=%u.\n",
 				__func__, id.family, (unsigned long long)id.id, id.crc, m->type, m->len);
 #endif
-		if (m->len + sizeof(struct w1_netlink_msg) > msg->len) {
+		if (m->len + sizeof(struct w1_netlink_msg) > msg_len) {
 			err = -E2BIG;
 			break;
 		}
@@ -415,41 +522,24 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		if (!mlen)
 			goto out_cont;
 
-		mutex_lock(&dev->mutex);
+		atomic_inc(&block->refcnt);
+		node->async.cb = w1_process_cb;
+		node->block = block;
+		node->m = (struct w1_netlink_msg *)((u8 *)&block->msg +
+			(size_t)((u8 *)m - (u8 *)msg));
+		node->sl = sl;
+		node->dev = dev;
 
-		if (sl && w1_reset_select_slave(sl)) {
-			err = -ENODEV;
-			goto out_up;
-		}
-
-		while (mlen) {
-			cmd = (struct w1_netlink_cmd *)cmd_data;
-
-			if (cmd->len + sizeof(struct w1_netlink_cmd) > mlen) {
-				err = -E2BIG;
-				break;
-			}
-
-			if (sl)
-				err = w1_process_command_slave(sl, msg, m, cmd);
-			else
-				err = w1_process_command_master(dev, msg, m, cmd);
+		mutex_lock(&dev->list_mutex);
+		list_add_tail(&node->async.async_entry, &dev->async_list);
+		wake_up_process(dev->thread);
+		mutex_unlock(&dev->list_mutex);
+		++node;
 
-			w1_netlink_send_error(msg, m, cmd, err);
-			err = 0;
-
-			cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
-			mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
-		}
-out_up:
-		atomic_dec(&dev->refcnt);
-		if (sl)
-			atomic_dec(&sl->refcnt);
-		mutex_unlock(&dev->mutex);
 out_cont:
-		if (!cmd || err)
-			w1_netlink_send_error(msg, m, cmd, err);
-		msg->len -= sizeof(struct w1_netlink_msg) + m->len;
+		if (err)
+			w1_netlink_send_error(msg, m, NULL, err);
+		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
 		m = (struct w1_netlink_msg *)(((u8 *)m) + sizeof(struct w1_netlink_msg) + m->len);
 
 		/*
@@ -458,6 +548,8 @@ out_cont:
 		if (err == -ENODEV)
 			err = 0;
 	}
+	if (block && atomic_sub_return(1, &block->refcnt) == 0)
+		kfree(block);
 }
 
 int w1_init_netlink(void)
-- 
1.7.10.4

