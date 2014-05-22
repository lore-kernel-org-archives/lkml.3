Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaEVJCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:02:31 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40693 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaEVJC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:02:29 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] clk: Enforce error checking
Date: Thu, 22 May 2014 11:00:08 +0200
Message-Id: <1400749208-3586-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This topic comes up every so often, so I figured that perhaps instead of
repeatedly telling people that they should check for errors returned by
clk_prepare_enable() and friends we should simply mark them __must_check
to settle this matter once and for all.

Unfortunately not even the clock core seems to get this right, though. A
few quick builds of a few platforms yield a massive amount of warnings.
It looks pretty grim.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clk/clk.c   | 22 ++++++++++++++++++----
 include/linux/clk.h | 16 ++++++++--------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4d562206d62f..e5dceabef92a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1240,6 +1240,7 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 {
 	unsigned long flags;
 	struct clk *old_parent = clk->parent;
+	int err;
 
 	/*
 	 * Migrate prepare state between parents and prevent race with
@@ -1260,8 +1261,16 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	 */
 	if (clk->prepare_count) {
 		__clk_prepare(parent);
-		clk_enable(parent);
-		clk_enable(clk);
+
+		err = clk_enable(parent);
+		if (err < 0)
+			pr_err("%s: failed to enable parent clock: %d\n",
+			       __func__, err);
+
+		err = clk_enable(clk);
+		if (err < 0)
+			pr_err("%s: failed to enable clock: %d\n", __func__,
+			       err);
 	}
 
 	/* update the clk tree topology */
@@ -2136,10 +2145,15 @@ void clk_unregister(struct clk *clk)
 	if (!hlist_empty(&clk->children)) {
 		struct clk *child;
 		struct hlist_node *t;
+		int err;
 
 		/* Reparent all children to the orphan list. */
-		hlist_for_each_entry_safe(child, t, &clk->children, child_node)
-			clk_set_parent(child, NULL);
+		hlist_for_each_entry_safe(child, t, &clk->children, child_node) {
+			err = clk_set_parent(child, NULL);
+			if (err < 0)
+				pr_err("%s: failed to orphan clock %s: %d\n",
+				       __func__, clk->name, err);
+		}
 	}
 
 	clk_debug_unregister(clk);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097d8f72..721b554a296f 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -124,9 +124,9 @@ static inline long clk_get_accuracy(struct clk *clk)
  * Must not be called from within atomic context.
  */
 #ifdef CONFIG_HAVE_CLK_PREPARE
-int clk_prepare(struct clk *clk);
+int __must_check clk_prepare(struct clk *clk);
 #else
-static inline int clk_prepare(struct clk *clk)
+static inline int __must_check clk_prepare(struct clk *clk)
 {
 	might_sleep();
 	return 0;
@@ -199,7 +199,7 @@ struct clk *devm_clk_get(struct device *dev, const char *id);
  *
  * Returns success (0) or negative errno.
  */
-int clk_enable(struct clk *clk);
+int __must_check clk_enable(struct clk *clk);
 
 /**
  * clk_disable - inform the system when the clock source is no longer required.
@@ -270,7 +270,7 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
  *
  * Returns success (0) or negative errno.
  */
-int clk_set_rate(struct clk *clk, unsigned long rate);
+int __must_check clk_set_rate(struct clk *clk, unsigned long rate);
 
 /**
  * clk_set_parent - set the parent clock source for this clock
@@ -279,7 +279,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate);
  *
  * Returns success (0) or negative errno.
  */
-int clk_set_parent(struct clk *clk, struct clk *parent);
+int __must_check clk_set_parent(struct clk *clk, struct clk *parent);
 
 /**
  * clk_get_parent - get the parent clock source for this clock
@@ -335,7 +335,7 @@ static inline unsigned long clk_get_rate(struct clk *clk)
 	return 0;
 }
 
-static inline int clk_set_rate(struct clk *clk, unsigned long rate)
+static inline int __must_check clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	return 0;
 }
@@ -345,7 +345,7 @@ static inline long clk_round_rate(struct clk *clk, unsigned long rate)
 	return 0;
 }
 
-static inline int clk_set_parent(struct clk *clk, struct clk *parent)
+static inline int __must_check clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	return 0;
 }
@@ -358,7 +358,7 @@ static inline struct clk *clk_get_parent(struct clk *clk)
 #endif
 
 /* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
-static inline int clk_prepare_enable(struct clk *clk)
+static inline int __must_check clk_prepare_enable(struct clk *clk)
 {
 	int ret;
 
-- 
1.9.2

