Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaLCPnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:43:50 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59404 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaLCPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:43:49 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: Introduce clk_try_parent()
Date: Wed,  3 Dec 2014 16:43:44 +0100
Message-Id: <1417621424-9933-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This new function is similar to clk_set_parent(), except that it doesn't
actually change the parent. It merely checks that the given parent clock
can be a parent for the given clock.

A situation where this is useful is to check that a particular setup is
valid before switching to it. One specific use-case for this is atomic
modesetting in the DRM framework where setting a mode is divided into a
check phase where a given configuration is validated before applying
changes to the hardware.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clk/clk.c   | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/clk.h |  9 +++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 01e5009c3e86..7e1c819aa6fc 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1673,6 +1673,42 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 }
 
 /**
+ * clk_try_parent - check if a clock can be the parent clock source of another
+ * @clk: clock source
+ * @parent: parent clock source
+ *
+ * This is like clk_set_parent(), except that it only checks that parent can
+ * be the parent clock source for clock.
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_try_parent(struct clk *clk, struct clk *parent)
+{
+	int err = 0;
+
+	if (!clk || !parent)
+		return -EINVAL;
+
+	if ((clk->num_parents > 1) && !clk->ops->set_parent)
+		return -ENOSYS;
+
+	clk_prepare_lock();
+
+	if (clk->parent == parent)
+		goto unlock;
+
+	err = clk_fetch_parent_index(clk, parent);
+	if (err > 0)
+		err = 0;
+
+unlock:
+	clk_prepare_unlock();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(clk_try_parent);
+
+/**
  * clk_set_parent - switch the parent of a mux clk
  * @clk: the mux clk whose input we are switching
  * @parent: the new input to clk
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb1ac65f127c..d8e9b8865d38 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -328,6 +328,15 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
 int clk_set_rate(struct clk *clk, unsigned long rate);
 
 /**
+ * clk_try_parent - check if a clock can be the parent clock source of another
+ * @clk: clock source
+ * @parent: parent clock source
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_try_parent(struct clk *clk, struct clk *parent);
+
+/**
  * clk_set_parent - set the parent clock source for this clock
  * @clk: clock source
  * @parent: parent clock source
-- 
2.1.3

