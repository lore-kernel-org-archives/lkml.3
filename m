Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKINSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 08:18:55 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44859 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaKINSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 08:18:53 -0500
From: Jassi Brar <jaswinder.singh@linaro.org>
To: ashwin.chaugule@linaro.org, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, patches@linaro.org, linux-acpi@vger.kernel.org,
        rjw@rjwysocki.net, arnd@arndb.de, lv.zheng@intel.com,
        linaro-acpi@lists.linaro.org, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH] mailbox: enable non-DT/ACPI clients to use the api
Date: Sun,  9 Nov 2014 18:48:25 +0530
Message-Id: <1415539105-4213-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Mailbox API so far discounted controllers and clients that
may not have a DT based channel mapping capability, as in ACPI.

Allow such mailbox clients to ask for a mailbox channel by simply
specifying a token. The token would be globally unique
among channels provided by such controllers... which shouldn't
be a problem because practically non-DT means ACPI and ACPI
specifies just one controller instance called the Platform
Communications Channel (PCC) that could have max 256 subspaces
(channels or mailboxes). So this is simply going to be the value
from 'Signature' field (first 4bytes) of the SharedMemory Region
corresponding to the subspace/channel the client is interested in.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mailbox/mailbox.c          | 50 +++++++++++++++++++++-----------------
 include/linux/mailbox_controller.h |  7 ++++++
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index afcb430..8260451 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -296,36 +296,42 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 {
 	struct device *dev = cl->dev;
 	struct mbox_controller *mbox;
-	struct of_phandle_args spec;
-	struct mbox_chan *chan;
+	struct mbox_chan *chan = NULL;
 	unsigned long flags;
 	int ret;
 
-	if (!dev || !dev->of_node) {
-		pr_debug("%s: No owner device node\n", __func__);
-		return ERR_PTR(-ENODEV);
-	}
-
 	mutex_lock(&con_mutex);
 
-	if (of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", index, &spec)) {
-		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
-		mutex_unlock(&con_mutex);
-		return ERR_PTR(-ENODEV);
-	}
-
-	chan = NULL;
-	list_for_each_entry(mbox, &mbox_cons, node)
-		if (mbox->dev->of_node == spec.np) {
-			chan = mbox->of_xlate(mbox, &spec);
-			break;
+	if (!dev || !dev->of_node) { /* If it's an ACPI client */
+		list_for_each_entry(mbox, &mbox_cons, node) {
+			if (!mbox->global_xlate)
+				continue;
+			chan = mbox->global_xlate(mbox, index);
+			if (chan && !chan->cl)
+				break;
+		}
+	} else {
+		struct of_phandle_args spec;
+
+		if (of_parse_phandle_with_args(dev->of_node, "mboxes",
+					       "#mbox-cells", index, &spec)) {
+			dev_dbg(dev, "%s: can't parse \"mboxes\" property\n",
+				__func__);
+			mutex_unlock(&con_mutex);
+			return ERR_PTR(-ENODEV);
 		}
 
-	of_node_put(spec.np);
+		list_for_each_entry(mbox, &mbox_cons, node)
+			if (mbox->dev->of_node == spec.np) {
+				chan = mbox->of_xlate(mbox, &spec);
+				break;
+			}
+
+		of_node_put(spec.np);
+	}
 
 	if (!chan || chan->cl || !try_module_get(mbox->dev->driver->owner)) {
-		dev_dbg(dev, "%s: mailbox not free\n", __func__);
+		pr_err("%s: mailbox not available\n", __func__);
 		mutex_unlock(&con_mutex);
 		return ERR_PTR(-EBUSY);
 	}
@@ -344,7 +350,7 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 
 	ret = chan->mbox->ops->startup(chan);
 	if (ret) {
-		dev_err(dev, "Unable to startup the chan (%d)\n", ret);
+		pr_err("Unable to startup the chan (%d)\n", ret);
 		mbox_free_channel(chan);
 		chan = ERR_PTR(ret);
 	}
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index d4cf96f..76871b2 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -67,6 +67,11 @@ struct mbox_chan_ops {
  * @txpoll_period:	If 'txdone_poll' is in effect, the API polls for
  *			last TX's status after these many millisecs
  * @of_xlate:		Controller driver specific mapping of channel via DT
+ * @global_xlate:	Controller driver specific mapping of channel for
+ *			non-DT based clients (like ACPI). The 'global_id'
+ *			argument is a token to uniquely identify the mbox_chan
+ *			fromm those provided by more than one such controllers.
+ *			'of_xlate' takes precedence for DT based clients.
  * @poll:		API private. Used to poll for TXDONE on all channels.
  * @node:		API private. To hook into list of controllers.
  */
@@ -80,6 +85,8 @@ struct mbox_controller {
 	unsigned txpoll_period;
 	struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
 				      const struct of_phandle_args *sp);
+	struct mbox_chan *(*global_xlate)(struct mbox_controller *mbox,
+					  int global_id);
 	/* Internal to API */
 	struct timer_list poll;
 	struct list_head node;
-- 
1.8.1.2

