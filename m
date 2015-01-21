Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbbAUQNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:13:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39468 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbAUQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:13:05 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v2] clk: Introduce clk_has_parent()
Date: Wed, 21 Jan 2015 17:13:00 +0100
Message-Id: <1421856780-32103-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
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

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- lookup parent name in parent names array and make function lockless
- rename function from clk_try_parent() to clk_has_parent()
- return boolean

 drivers/clk/clk.c   | 30 ++++++++++++++++++++++++++++++
 include/linux/clk.h | 17 +++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index af06b7377d37..470266297dea 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1672,6 +1672,36 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 }
 
 /**
+ * clk_has_parent - check if a clock is a possible parent for another
+ * @clk: clock source
+ * @parent: parent clock source
+ *
+ * This function can be used in drivers that need to check that a clock can be
+ * the parent of another without actually changing the parent.
+ *
+ * Returns true if @parent is a possible parent for @clk, false otherwise.
+ */
+bool clk_has_parent(struct clk *clk, struct clk *parent)
+{
+	unsigned int i;
+
+	/* NULL clocks should be nops, so return success if either is NULL. */
+	if (!clk || !parent)
+		return true;
+
+	/* Optimize for the case where the parent is already the parent. */
+	if (clk->parent == parent)
+		return true;
+
+	for (i = 0; i < clk->num_parents; i++)
+		if (strcmp(clk->parent_names[i], parent->name) == 0)
+			return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(clk_has_parent);
+
+/**
  * clk_set_parent - switch the parent of a mux clk
  * @clk: the mux clk whose input we are switching
  * @parent: the new input to clk
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb1ac65f127c..df28673be2a1 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -328,6 +328,18 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
 int clk_set_rate(struct clk *clk, unsigned long rate);
 
 /**
+ * clk_has_parent - check if a clock is a possible parent for another
+ * @clk: clock source
+ * @parent: parent clock source
+ *
+ * This function can be used in drivers that need to check that a clock can be
+ * the parent of another without actually changing the parent.
+ *
+ * Returns true if @parent is a possible parent for @clk, false otherwise.
+ */
+bool clk_has_parent(struct clk *clk, struct clk *parent);
+
+/**
  * clk_set_parent - set the parent clock source for this clock
  * @clk: clock source
  * @parent: parent clock source
@@ -400,6 +412,11 @@ static inline long clk_round_rate(struct clk *clk, unsigned long rate)
 	return 0;
 }
 
+static inline bool clk_has_parent(struct clk *clk, struct clk *parent)
+{
+	return true;
+}
+
 static inline int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	return 0;
-- 
2.1.3

