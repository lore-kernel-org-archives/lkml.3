Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006AbaGAV6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:58:46 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:12201 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbaGAVxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:51 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/50] mars: add new file drivers/block/mars/lamport.c
Date: Tue,  1 Jul 2014 23:46:42 +0200
Message-Id: <1404251250-22992-3-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 drivers/block/mars/lamport.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 drivers/block/mars/lamport.c

diff --git a/drivers/block/mars/lamport.c b/drivers/block/mars/lamport.c
new file mode 100644
index 0000000..67484c5
--- /dev/null
+++ b/drivers/block/mars/lamport.c
@@ -0,0 +1,48 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/semaphore.h>
+
+#include <linux/brick/lamport.h>
+
+/*  TODO: replace with spinlock if possible (first check) */
+struct semaphore lamport_sem = __SEMAPHORE_INITIALIZER(lamport_sem, 1);
+struct timespec lamport_now = {};
+
+void get_lamport(struct timespec *now)
+{
+	int diff;
+
+	down(&lamport_sem);
+
+	*now = CURRENT_TIME;
+	diff = timespec_compare(now, &lamport_now);
+	if (diff >= 0) {
+		timespec_add_ns(now, 1);
+		memcpy(&lamport_now, now, sizeof(lamport_now));
+		timespec_add_ns(&lamport_now, 1);
+	} else {
+		timespec_add_ns(&lamport_now, 1);
+		memcpy(now, &lamport_now, sizeof(*now));
+	}
+
+	up(&lamport_sem);
+}
+EXPORT_SYMBOL_GPL(get_lamport);
+
+void set_lamport(struct timespec *old)
+{
+	int diff;
+
+	down(&lamport_sem);
+
+	diff = timespec_compare(old, &lamport_now);
+	if (diff >= 0) {
+		memcpy(&lamport_now, old, sizeof(lamport_now));
+		timespec_add_ns(&lamport_now, 1);
+	}
+
+	up(&lamport_sem);
+}
+EXPORT_SYMBOL_GPL(set_lamport);
-- 
2.0.0

