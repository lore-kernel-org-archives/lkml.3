Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab3CVPo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:44:58 -0400
Received: from multi.imgtec.com ([194.200.65.239]:32808 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933337Ab3CVPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:44:56 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Chao Xie <xiechao.mail@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [RFC PATCH v1 1/3] clk: abstract parent cache
Date: Fri, 22 Mar 2013 15:43:49 +0000
Message-ID: <1363967031-22781-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
References: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_22_15_44_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract access to the clock parent cache by defining
__clk_get_parent_by_index(clk, index). This allows access to parent
clocks from clock drivers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/clk/clk.c            | 21 ++++++++++++++-------
 include/linux/clk-provider.h |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..79d5deb 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -415,6 +415,19 @@ struct clk *__clk_get_parent(struct clk *clk)
 	return !clk ? NULL : clk->parent;
 }
 
+struct clk *__clk_get_parent_by_index(struct clk *clk, u8 index)
+{
+	if (!clk || index >= clk->num_parents)
+		return NULL;
+	else if (!clk->parents)
+		return __clk_lookup(clk->parent_names[index]);
+	else if (!clk->parents[index])
+		return clk->parents[index] =
+			__clk_lookup(clk->parent_names[index]);
+	else
+		return clk->parents[index];
+}
+
 unsigned int __clk_get_enable_count(struct clk *clk)
 {
 	return !clk ? 0 : clk->enable_count;
@@ -1150,13 +1163,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 			kzalloc((sizeof(struct clk*) * clk->num_parents),
 					GFP_KERNEL);
 
-	if (!clk->parents)
-		ret = __clk_lookup(clk->parent_names[index]);
-	else if (!clk->parents[index])
-		ret = clk->parents[index] =
-			__clk_lookup(clk->parent_names[index]);
-	else
-		ret = clk->parents[index];
+	ret = __clk_get_parent_by_index(clk, index);
 
 out:
 	return ret;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7f197d7..4e0b634 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -347,6 +347,7 @@ const char *__clk_get_name(struct clk *clk);
 struct clk_hw *__clk_get_hw(struct clk *clk);
 u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
+struct clk *__clk_get_parent_by_index(struct clk *clk, u8 index);
 unsigned int __clk_get_enable_count(struct clk *clk);
 unsigned int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
-- 
1.8.1.2


