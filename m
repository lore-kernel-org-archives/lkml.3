Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaAPEed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:34:33 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45811 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaAPEe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:34:29 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 15/15] w1: hold bus_mutex in netlink and search
Date: Wed, 15 Jan 2014 22:29:26 -0600
Message-Id: <1389846566-28862-16-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:34:23 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus_mutex needs to be taken to serialize access to a specific bus.
netlink wasn't updated when bus_mutex was added and was calling
without that lock held, and not all of the masters were holding the
bus_mutex in a search.  This was causing the ds2490 hardware to stop
responding when both netlink and /sys slaves were executing bus
commands at the same time.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/ds1wm.c  |    4 +++-
 drivers/w1/masters/ds2490.c |    8 ++++++--
 drivers/w1/w1_netlink.c     |   13 +++++++++++--
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 02df3b1..b077b8b 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -326,13 +326,14 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 	unsigned slaves_found = 0;
 	unsigned int pass = 0;
 
+	mutex_lock(&master_dev->bus_mutex);
 	dev_dbg(&ds1wm_data->pdev->dev, "search begin\n");
 	while (true) {
 		++pass;
 		if (pass > 100) {
 			dev_dbg(&ds1wm_data->pdev->dev,
 				"too many attempts (100), search aborted\n");
-			return;
+			break;
 		}
 
 		mutex_lock(&master_dev->bus_mutex);
@@ -439,6 +440,7 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 	dev_dbg(&ds1wm_data->pdev->dev,
 		"pass: %d total: %d search done ms d bit pos: %d\n", pass,
 		slaves_found, ms_discrep_bit);
+	mutex_unlock(&master_dev->bus_mutex);
 }
 
 /* --------------------------------------------------------------------- */
diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index db0bf32..7404ad30 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -727,9 +727,11 @@ static void ds9490r_search(void *data, struct w1_master *master,
 	 */
 	u64 buf[2*64/8];
 
+	mutex_lock(&master->bus_mutex);
+
 	/* address to start searching at */
 	if (ds_send_data(dev, (u8 *)&master->search_id, 8) < 0)
-		return;
+		goto search_out;
 	master->search_id = 0;
 
 	value = COMM_SEARCH_ACCESS | COMM_IM | COMM_RST | COMM_SM | COMM_F |
@@ -739,7 +741,7 @@ static void ds9490r_search(void *data, struct w1_master *master,
 		search_limit = 0;
 	index = search_type | (search_limit << 8);
 	if (ds_send_control(dev, value, index) < 0)
-		return;
+		goto search_out;
 
 	do {
 		schedule_timeout(jtime);
@@ -791,6 +793,8 @@ static void ds9490r_search(void *data, struct w1_master *master,
 			master->max_slave_count);
 		set_bit(W1_WARN_MAX_COUNT, &master->flags);
 	}
+search_out:
+	mutex_unlock(&master->bus_mutex);
 }
 
 #if 0
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index a5dc219..5234964 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -246,11 +246,16 @@ static int w1_process_command_master(struct w1_master *dev,
 {
 	int err = -EINVAL;
 
+	/* drop bus_mutex for search (does it's own locking), and add/remove
+	 * which doesn't use the bus
+	 */
 	switch (req_cmd->cmd) {
 	case W1_CMD_SEARCH:
 	case W1_CMD_ALARM_SEARCH:
 	case W1_CMD_LIST_SLAVES:
+		mutex_unlock(&dev->bus_mutex);
 		err = w1_get_slaves(dev, req_msg, req_hdr, req_cmd);
+		mutex_lock(&dev->bus_mutex);
 		break;
 	case W1_CMD_READ:
 	case W1_CMD_WRITE:
@@ -262,8 +267,12 @@ static int w1_process_command_master(struct w1_master *dev,
 		break;
 	case W1_CMD_SLAVE_ADD:
 	case W1_CMD_SLAVE_REMOVE:
+		mutex_unlock(&dev->bus_mutex);
+		mutex_lock(&dev->mutex);
 		err = w1_process_command_addremove(dev, req_msg, req_hdr,
 			req_cmd);
+		mutex_unlock(&dev->mutex);
+		mutex_lock(&dev->bus_mutex);
 		break;
 	default:
 		err = -EINVAL;
@@ -400,7 +409,7 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 	struct w1_slave *sl = node->sl;
 	struct w1_netlink_cmd *cmd = NULL;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->bus_mutex);
 	dev->portid = node->block->portid;
 	if (sl && w1_reset_select_slave(sl))
 		err = -ENODEV;
@@ -437,7 +446,7 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 	else
 		atomic_dec(&dev->refcnt);
 	dev->portid = 0;
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->bus_mutex);
 
 	mutex_lock(&dev->list_mutex);
 	list_del(&async_cmd->async_entry);
-- 
1.7.10.4

