Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaEZP3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:29:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59232 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaEZPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:18:26 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v3 03/15] thunderbolt: Setup control channel
Date: Mon, 26 May 2014 17:18:00 +0200
Message-Id: <1401117492-2870-4-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
References: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct tb which will contain our view of the thunderbolt bus.  For
now it just contains a pointer to the control channel and a workqueue
for hotplug events.

Add thunderbolt_alloc_and_start() and thunderbolt_shutdown_and_free()
which are responsible for setup and teardown of struct tb.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/Makefile |   2 +-
 drivers/thunderbolt/nhi.c    |  18 +++++-
 drivers/thunderbolt/tb.c     | 134 +++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h     |  35 +++++++++++
 4 files changed, 186 insertions(+), 3 deletions(-)
 create mode 100644 drivers/thunderbolt/tb.c
 create mode 100644 drivers/thunderbolt/tb.h

diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
index 4b21c99..1f996bb 100644
--- a/drivers/thunderbolt/Makefile
+++ b/drivers/thunderbolt/Makefile
@@ -1,3 +1,3 @@
 obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
-thunderbolt-objs := nhi.o ctl.o
+thunderbolt-objs := nhi.o ctl.o tb.o
 
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index d73a744..f3a4ac2 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -16,6 +16,7 @@
 
 #include "nhi.h"
 #include "nhi_regs.h"
+#include "tb.h"
 
 #define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
 
@@ -517,6 +518,7 @@ static void nhi_shutdown(struct tb_nhi *nhi)
 static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct tb_nhi *nhi;
+	struct tb *tb;
 	int res;
 
 	res = pcim_enable_device(pdev);
@@ -575,14 +577,26 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* magic value - clock related? */
 	iowrite32(3906250 / 10000, nhi->iobase + 0x38c00);
 
-	pci_set_drvdata(pdev, nhi);
+	dev_info(&nhi->pdev->dev, "NHI initialized, starting thunderbolt\n");
+	tb = thunderbolt_alloc_and_start(nhi);
+	if (!tb) {
+		/*
+		 * At this point the RX/TX rings might already have been
+		 * activated. Do a proper shutdown.
+		 */
+		nhi_shutdown(nhi);
+		return -EIO;
+	}
+	pci_set_drvdata(pdev, tb);
 
 	return 0;
 }
 
 static void nhi_remove(struct pci_dev *pdev)
 {
-	struct tb_nhi *nhi = pci_get_drvdata(pdev);
+	struct tb *tb = pci_get_drvdata(pdev);
+	struct tb_nhi *nhi = tb->nhi;
+	thunderbolt_shutdown_and_free(tb);
 	nhi_shutdown(nhi);
 }
 
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
new file mode 100644
index 0000000..6920979
--- /dev/null
+++ b/drivers/thunderbolt/tb.c
@@ -0,0 +1,134 @@
+/*
+ * Thunderbolt Cactus Ridge driver - bus logic (NHI independent)
+ *
+ * Copyright (c) 2014 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+
+#include "tb.h"
+
+/* hotplug handling */
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
+ * Executes on tb->wq.
+ */
+static void tb_handle_hotplug(struct work_struct *work)
+{
+	struct tb_hotplug_event *ev = container_of(work, typeof(*ev), work);
+	struct tb *tb = ev->tb;
+	mutex_lock(&tb->lock);
+	if (!tb->hotplug_active)
+		goto out; /* during init, suspend or shutdown */
+
+	/* do nothing for now */
+out:
+	mutex_unlock(&tb->lock);
+	kfree(ev);
+}
+
+/**
+ * tb_schedule_hotplug_handler() - callback function for the control channel
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
+ * Free all switches and the config channel.
+ *
+ * Used in the error path of thunderbolt_alloc_and_start.
+ */
+void thunderbolt_shutdown_and_free(struct tb *tb)
+{
+	mutex_lock(&tb->lock);
+
+	if (tb->ctl) {
+		tb_ctl_stop(tb->ctl);
+		tb_ctl_free(tb->ctl);
+	}
+	tb->ctl = NULL;
+	tb->hotplug_active = false; /* signal tb_handle_hotplug to quit */
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
+ * Allocates a tb_cfg control channel, initializes the root switch, enables
+ * plug events and activates pci devices.
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
+	tb->ctl = tb_ctl_alloc(tb->nhi, tb_schedule_hotplug_handler, tb);
+	if (!tb->ctl)
+		goto err_locked;
+	/*
+	 * tb_schedule_hotplug_handler may be called as soon as the config
+	 * channel is started. Thats why we have to hold the lock here.
+	 */
+	tb_ctl_start(tb->ctl);
+
+	/* Allow tb_handle_hotplug to progress events */
+	tb->hotplug_active = true;
+	mutex_unlock(&tb->lock);
+	return tb;
+
+err_locked:
+	mutex_unlock(&tb->lock);
+	thunderbolt_shutdown_and_free(tb);
+	return NULL;
+}
+
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
new file mode 100644
index 0000000..6055dfd
--- /dev/null
+++ b/drivers/thunderbolt/tb.h
@@ -0,0 +1,35 @@
+/*
+ * Thunderbolt Cactus Ridge driver - bus logic (NHI independent)
+ *
+ * Copyright (c) 2014 Andreas Noever <andreas.noever@gmail.com>
+ */
+
+#ifndef TB_H_
+#define TB_H_
+
+#include "ctl.h"
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
+	struct tb_ctl *ctl;
+	struct workqueue_struct *wq; /* ordered workqueue for plug events */
+	bool hotplug_active; /*
+			      * tb_handle_hotplug will stop progressing plug
+			      * events and exit if this is not set (it needs to
+			      * acquire the lock one more time). Used to drain
+			      * wq after cfg has been paused.
+			      */
+
+};
+
+struct tb *thunderbolt_alloc_and_start(struct tb_nhi *nhi);
+void thunderbolt_shutdown_and_free(struct tb *tb);
+
+#endif
-- 
1.9.3

