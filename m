Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaBOS1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:27:20 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52137 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbaBOS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:27:17 -0500
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com
Subject: [PATCHv3 6/6] mailbox: move the internal definitions into a private file
Date: Sat, 15 Feb 2014 23:57:02 +0530
Message-Id: <1392488822-18178-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

This is needed for extracting the omap_mbox. The OMAP mailbox
code has a need for exporting some pre-existing API to not
break the current clients.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/mailbox/mailbox.c          | 62 +-----------------------------
 drivers/mailbox/mailbox_internal.h | 77 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 61 deletions(-)
 create mode 100644 drivers/mailbox/mailbox_internal.h

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index bac767e..b0e7126 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -14,67 +14,7 @@
 #include <linux/mailbox_client.h>
 #include <linux/mailbox_controller.h>
 
-/*
- * The length of circular buffer for queuing messages from a client.
- * 'msg_count' tracks the number of buffered messages while 'msg_free'
- * is the index where the next message would be buffered.
- * We shouldn't need it too big because every transferr is interrupt
- * triggered and if we have lots of data to transfer, the interrupt
- * latencies are going to be the bottleneck, not the buffer length.
- * Besides, ipc_send_message could be called from atomic context and
- * the client could also queue another message from the notifier 'txcb'
- * of the last transfer done.
- * REVIST: If too many platforms see the "Try increasing MBOX_TX_QUEUE_LEN"
- * print, it needs to be taken from config option or somesuch.
- */
-#define MBOX_TX_QUEUE_LEN	20
-
-#define TXDONE_BY_IRQ	(1 << 0) /* controller has remote RTR irq */
-#define TXDONE_BY_POLL	(1 << 1) /* controller can read status of last TX */
-#define TXDONE_BY_ACK	(1 << 2) /* S/W ACK recevied by Client ticks the TX */
-
-struct ipc_chan {
-	char name[16]; /* link_name */
-	struct ipc_con *con; /* Parent Controller */
-	unsigned txdone_method;
-
-	/* Cached values from controller */
-	struct ipc_link *link;
-	struct ipc_link_ops *link_ops;
-
-	/* Cached values from client */
-	void *cl_id;
-	void (*rxcb)(void *cl_id, void *mssg);
-	void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
-	bool tx_block;
-	unsigned long tx_tout;
-	struct completion tx_complete;
-
-	void *active_req;
-	unsigned msg_count, msg_free;
-	void *msg_data[MBOX_TX_QUEUE_LEN];
-	bool assigned;
-	/* Serialize access to the channel */
-	spinlock_t lock;
-	/* Hook to add to the controller's list of channels */
-	struct list_head node;
-	/* Notifier to all clients waiting on aquiring this channel */
-	struct blocking_notifier_head avail;
-};
-
-/* Internal representation of a controller */
-struct ipc_con {
-	char name[16]; /* controller_name */
-	struct list_head channels;
-	/*
-	 * If the controller supports only TXDONE_BY_POLL,
-	 * this timer polls all the links for txdone.
-	 */
-	struct timer_list poll;
-	unsigned period;
-	/* Hook to add to the global controller list */
-	struct list_head node;
-};
+#include "mailbox_internal.h"
 
 static LIST_HEAD(ipc_cons);
 static DEFINE_MUTEX(con_mutex);
diff --git a/drivers/mailbox/mailbox_internal.h b/drivers/mailbox/mailbox_internal.h
new file mode 100644
index 0000000..a39dcb7
--- /dev/null
+++ b/drivers/mailbox/mailbox_internal.h
@@ -0,0 +1,77 @@
+/*
+ * mailbox: interprocessor communication module
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef MAILBOX_INTERNAL_H
+#define MAILBOX_INTERNAL_H
+
+#include <linux/device.h>
+#include <linux/mailbox_controller.h>
+
+/*
+ * The length of circular buffer for queuing messages from a client.
+ * 'msg_count' tracks the number of buffered messages while 'msg_free'
+ * is the index where the next message would be buffered.
+ * We shouldn't need it too big because every transferr is interrupt
+ * triggered and if we have lots of data to transfer, the interrupt
+ * latencies are going to be the bottleneck, not the buffer length.
+ * Besides, ipc_send_message could be called from atomic context and
+ * the client could also queue another message from the notifier 'txcb'
+ * of the last transfer done.
+ * REVIST: If too many platforms see the "Try increasing MBOX_TX_QUEUE_LEN"
+ * print, it needs to be taken from config option or somesuch.
+ */
+#define MBOX_TX_QUEUE_LEN	20
+
+#define TXDONE_BY_IRQ	(1 << 0) /* controller has remote RTR irq */
+#define TXDONE_BY_POLL	(1 << 1) /* controller can read status of last TX */
+#define TXDONE_BY_ACK	(1 << 2) /* S/W ACK recevied by Client ticks the TX */
+
+struct ipc_chan {
+	char name[16]; /* link_name */
+	struct ipc_con *con; /* Parent Controller */
+	unsigned txdone_method;
+
+	/* Cached values from controller */
+	struct ipc_link *link;
+	struct ipc_link_ops *link_ops;
+
+	/* Cached values from client */
+	void *cl_id;
+	void (*rxcb)(void *cl_id, void *mssg);
+	void (*txcb)(void *cl_id, void *mssg, enum xfer_result r);
+	bool tx_block;
+	unsigned long tx_tout;
+	struct completion tx_complete;
+
+	void *active_req;
+	unsigned msg_count, msg_free;
+	void *msg_data[MBOX_TX_QUEUE_LEN];
+	bool assigned;
+	/* Serialize access to the channel */
+	spinlock_t lock;
+	/* Hook to add to the controller's list of channels */
+	struct list_head node;
+	/* Notifier to all clients waiting on aquiring this channel */
+	struct blocking_notifier_head avail;
+};
+
+/* Internal representation of a controller */
+struct ipc_con {
+	char name[16]; /* controller_name */
+	struct list_head channels;
+	/*
+	 * If the controller supports only TXDONE_BY_POLL,
+	 * this timer polls all the links for txdone.
+	 */
+	struct timer_list poll;
+	unsigned period;
+	/* Hook to add to the global controller list */
+	struct list_head node;
+};
+
+#endif /* MAILBOX_INTERNAL_H */
-- 
1.8.1.2

