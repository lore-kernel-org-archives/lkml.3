Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3K2Blv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:41:51 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63744 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3K2BjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:39:21 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 03/12] thunderbolt: Setup configuration channel
Date: Fri, 29 Nov 2013 02:35:40 +0100
Message-Id: <1385688949-7101-4-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct tb which will contain our view of the thunderbolt bus. For
now it just contains a pointer to the configuration channel and a
workqueue for hotplug events.

Add thunderbolt_alloc_and_start() and thunderbolt_shutdown_and_free()
which are responsible for setup and teardown of struct tb.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/Makefile  |   2 +-
 drivers/thunderbolt/dsl3510.c |  18 +++++-
 drivers/thunderbolt/tb.c      | 124 ++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h      |  34 ++++++++++++
 4 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 drivers/thunderbolt/tb.c
 create mode 100644 drivers/thunderbolt/tb.h

diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
index f486295..7c5b811 100644
--- a/drivers/thunderbolt/Makefile
+++ b/drivers/thunderbolt/Makefile
@@ -1,3 +1,3 @@
 obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
-thunderbolt-objs := dsl3510.o tb_cfg.o
+thunderbolt-objs := dsl3510.o tb_cfg.o tb.o
 
diff --git a/drivers/thunderbolt/dsl3510.c b/drivers/thunderbolt/dsl3510.c
index 2a326f6..434812b 100644
--- a/drivers/thunderbolt/dsl3510.c
+++ b/drivers/thunderbolt/dsl3510.c
@@ -12,6 +12,7 @@
 
 #include "dsl3510.h"
 #include "dsl3510_regs.h"
+#include "tb.h"
 
 #define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
 
@@ -481,6 +482,7 @@ static void dsl3510_shutdown(struct tb_nhi *nhi)
 static int dsl3510_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct tb_nhi *nhi;
+	struct tb *tb;
 	int res;
 
 	res = pcim_enable_device(pdev);
@@ -543,14 +545,26 @@ static int dsl3510_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* magic value - clock related? */
 	iowrite32(3906250 / 10000, nhi->iobase + 0x38c00);
 
-	pci_set_drvdata(pdev, nhi); /* for dsl3510_remove only */
+	dev_info(&nhi->pdev->dev, "NHI initialized, starting thunderbolt\n");
+	tb = thunderbolt_alloc_and_start(nhi);
+	if (!tb) {
+		/*
+		 * At this point the RX/TX rings might already have been
+		 * activated. Do a proper shutdown.
+		 */
+		dsl3510_shutdown(nhi);
+		return -EIO;
+	}
+	pci_set_drvdata(pdev, tb); /* for dsl3510_remove only */
 
 	return 0;
 }
 
 static void dsl3510_remove(struct pci_dev *pdev)
 {
-	struct tb_nhi *nhi = pci_get_drvdata(pdev);
+	struct tb *tb = pci_get_drvdata(pdev);
+	struct tb_nhi *nhi = tb->nhi;
+	thunderbolt_shutdown_and_free(tb);
 	dsl3510_shutdown(nhi);
 }
 
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
new file mode 100644
index 0000000..64deb7b
--- /dev/null
+++ b/drivers/thunderbolt/tb.c
@@ -0,0 +1,124 @@
+/*
+ * Device independent Thunderbolt bus logic
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+
+#include "tb.h"
+
+struct tb_hotplug_event {
+	struct work_struct work;
+	struct tb *tb;
+	u64 route;
+	u8 port;
+	bool unplug;
+};
+
+/**
+ * tb_handle_hotplug() - handle hotplug event
+ *
+ * Executes on the tb->wq.
+ */
+static void tb_handle_hotplug(struct work_struct *work)
+{
+	struct tb_hotplug_event *ev = container_of(work, typeof(*ev), work);
+	struct tb *tb = ev->tb;
+	mutex_lock(&tb->lock);
+	if (tb->shutdown)
+		goto out;
+	/* do nothing for now */
+out:
+	mutex_unlock(&tb->lock);
+	kfree(ev);
+}
+
+/**
+ * tb_schedule_hotplug_handler() - callback function for the config channel
+ *
+ * Delegates to tb_handle_hotplug.
+ */
+static void tb_schedule_hotplug_handler(void *data, u64 route, u8 port,
+					bool unplug)
+{
+	struct tb *tb = data;
+	struct tb_hotplug_event *ev = kmalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return;
+	INIT_WORK(&ev->work, tb_handle_hotplug);
+	ev->tb = tb;
+	ev->route = route;
+	ev->port = port;
+	ev->unplug = unplug;
+	queue_work(tb->wq, &ev->work);
+}
+
+/**
+ * thunderbolt_shutdown_and_free() - shutdown everything
+ *
+ * Free the config channel.
+ */
+void thunderbolt_shutdown_and_free(struct tb *tb)
+{
+	mutex_lock(&tb->lock);
+	tb->shutdown = true; /* signal tb_handle_hotplug to quit */
+
+	if (tb->cfg)
+		tb_cfg_free(tb->cfg);
+	tb->cfg = NULL;
+
+	/* allow tb_handle_hotplug to acquire the lock */
+	mutex_unlock(&tb->lock);
+	if (tb->wq) {
+		flush_workqueue(tb->wq);
+		destroy_workqueue(tb->wq);
+		tb->wq = NULL;
+	}
+	mutex_destroy(&tb->lock);
+	kfree(tb);
+}
+
+/**
+ * thunderbolt_alloc_and_start() - setup the thunderbolt bus
+ *
+ * Allocates a tb_cfg control channel.
+ *
+ * Return: Returns NULL on error.
+ */
+struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi)
+{
+	struct tb *tb;
+
+	tb = kzalloc(sizeof(*tb), GFP_KERNEL);
+	if (!tb)
+		return NULL;
+
+	tb->nhi = nhi;
+	mutex_init(&tb->lock);
+	mutex_lock(&tb->lock);
+
+	tb->wq = alloc_ordered_workqueue("thunderbolt", 0);
+	if (!tb->wq)
+		goto err_locked;
+
+	/*
+	 * tb_schedule_hotplug_handler may be called as soon as the config
+	 * channel is allocated. Thats why we have to hold the lock here.
+	 */
+	tb->cfg = tb_cfg_alloc(tb->nhi, tb_schedule_hotplug_handler, tb);
+	if (!tb->cfg)
+		goto err_locked;
+
+	mutex_unlock(&tb->lock);
+	return tb;
+
+err_locked:
+	/* In case tb_handle_hotplug is already executing. */
+	tb->shutdown = true;
+	mutex_unlock(&tb->lock);
+	thunderbolt_shutdown_and_free(tb);
+	return NULL;
+}
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
new file mode 100644
index 0000000..a3378dc
--- /dev/null
+++ b/drivers/thunderbolt/tb.h
@@ -0,0 +1,34 @@
+/*
+ * Device independent Thunderbolt bus logic
+ *
+ * Copyright (c) 2013 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#ifndef TB_H_
+#define TB_H_
+
+#include <linux/pci.h>
+
+#include "tb_cfg.h"
+
+/**
+ * struct tb - main thunderbolt bus structure
+ */
+struct tb {
+	struct mutex lock;	/*
+				 * Big lock. Must be held when accessing cfg or
+				 * any struct tb_switch / struct tb_port.
+				 */
+	struct tb_nhi *nhi;
+	struct tb_cfg *cfg;
+	struct workqueue_struct *wq; /* ordered workqueue for plug events */
+	bool shutdown;	/*
+			 * Once this is set tb_handle_hotplug will exit (once it
+			 * can aquire lock at least once). Used to drain wq.
+			 */
+};
+
+struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi);
+void thunderbolt_shutdown_and_free(struct tb *tb);
+
+#endif
-- 
1.8.4.2

