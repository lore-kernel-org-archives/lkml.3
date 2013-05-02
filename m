Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3EBG0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:26:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56716 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab3EBG0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:26:07 -0400
From: Ambresh K <ambresh@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Rajendra <rnayak@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [Patch 3/3] clk: Avoid re-parenting orphan clk's having invalid parent index.
Date: Thu, 2 May 2013 11:55:29 +0530
Message-ID: <1367475929-32166-4-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1367475929-32166-1-git-send-email-ambresh@ti.com>
References: <1367475929-32166-1-git-send-email-ambresh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

Add orhan clk nodes having invalid parent index to list and use
the list to skip re-parenting orphan clk having invalid parents.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 drivers/clk/clk.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4d2c73..54d2aa3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -32,6 +32,7 @@ static int enable_refcnt;
 
 static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
+static HLIST_HEAD(clk_orphan_invalid_parent);
 static LIST_HEAD(clk_notifier_list);
 
 /***           locking             ***/
@@ -1532,8 +1533,8 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
  */
 int __clk_init(struct device *dev, struct clk *clk)
 {
-	int i, ret = 0;
-	struct clk *orphan;
+	int i, ret = 0, skip = 0;
+	struct clk *orphan, *has_invalid_parent;
 	struct hlist_node *tmp2;
 
 	if (!clk)
@@ -1639,11 +1640,27 @@ int __clk_init(struct device *dev, struct clk *clk)
 		if (!strcmp(clk->name, orphan->name))
 			continue;
 
+		/* Skip iteration if orphan has invalid parent */
+		hlist_for_each_entry(has_invalid_parent,
+				&clk_orphan_invalid_parent, child_node) {
+			if (!strcmp(orphan->name, has_invalid_parent->name)) {
+				skip = 1;
+				break;
+			}
+		}
+
+		if (skip) {
+			skip = 0;
+			continue;
+		}
+
 		if (orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
 			if (i < 0) {
 				pr_err("%s: orphan clk(%s) invalid parent\n",
 						__func__, orphan->name);
+				hlist_add_head(&orphan->child_node,
+						&clk_orphan_invalid_parent);
 				continue;
 			}
 			if (!strcmp(clk->name, orphan->parent_names[i]))
-- 
1.7.4.1

