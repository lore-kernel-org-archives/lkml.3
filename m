Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKZUji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:39:38 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:49781 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:39:36 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v2] null_blk: boundary check queue_mode and irqmode
Date: Wed, 26 Nov 2014 21:39:24 +0100
Message-Id: <1417034364-2841-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When either queue_mode or irq_mode parameter is set outside its boundaries, the
driver will not complete requests. This stalls driver initialization when
partitions are probed. Fix by setting out of bound values to the parameters
default.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/block/null_blk.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 8001e81..9b865ed 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -78,7 +78,34 @@ module_param(home_node, int, S_IRUGO);
 MODULE_PARM_DESC(home_node, "Home node for the device");
 
 static int queue_mode = NULL_Q_MQ;
-module_param(queue_mode, int, S_IRUGO);
+
+static int null_set_queue_mode(const char *val, const struct kernel_param *kp)
+{
+	int ret, new_queue_mode;
+
+	ret = kstrtoint(val, 10, &new_queue_mode);
+	if (ret)
+		goto fail;
+
+	if (new_queue_mode < 0 || new_queue_mode > 2) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	queue_mode = new_queue_mode;
+
+	return 0;
+fail:
+	pr_warn("null_blk: defaults queue_mode to multiqueue\n");
+	return ret;
+}
+
+static struct kernel_param_ops null_queue_mode_param_ops = {
+	.set	= null_set_queue_mode,
+	.get	= param_get_int,
+};
+
+device_param_cb(queue_mode, &null_queue_mode_param_ops, &queue_mode, S_IRUGO);
 MODULE_PARM_DESC(queue_mode, "Block interface to use (0=bio,1=rq,2=multiqueue)");
 
 static int gb = 250;
@@ -94,7 +121,34 @@ module_param(nr_devices, int, S_IRUGO);
 MODULE_PARM_DESC(nr_devices, "Number of devices to register");
 
 static int irqmode = NULL_IRQ_SOFTIRQ;
-module_param(irqmode, int, S_IRUGO);
+
+static int null_set_irqmode(const char *val, const struct kernel_param *kp)
+{
+	int ret, new_irqmode;
+
+	ret = kstrtoint(val, 10, &new_irqmode);
+	if (ret)
+		goto fail;
+
+	if (new_irqmode < 0 || new_irqmode > 2) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	irqmode = new_irqmode;
+
+	return 0;
+fail:
+	pr_warn("null_blk: defaults to irqmode to softirq\n");
+	return ret;
+}
+
+static struct kernel_param_ops null_irqmode_param_ops = {
+	.set	= null_set_irqmode,
+	.get	= param_get_int,
+};
+
+device_param_cb(irqmode, &null_irqmode_param_ops, &irqmode, S_IRUGO);
 MODULE_PARM_DESC(irqmode, "IRQ completion handler. 0-none, 1-softirq, 2-timer");
 
 static int completion_nsec = 10000;
-- 
2.1.0

