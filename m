Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3G2LZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:25:43 -0400
Received: from multi.imgtec.com ([194.200.65.239]:48085 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab3G2LZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:25:40 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "James Hogan" <james.hogan@imgtec.com>
Subject: [PATCH v6 1/5] clk: abstract parent cache
Date: Mon, 29 Jul 2013 12:24:58 +0100
Message-ID: <1375097102-28892-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375097102-28892-1-git-send-email-james.hogan@imgtec.com>
References: <1375097102-28892-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_29_12_25_39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract access to the clock parent cache by defining
clk_get_parent_by_index(clk, index). This allows access to parent
clocks from clock drivers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
Changes in v3:

* remove double underscore prefix from clk_get_parent_by_index()

 drivers/clk/clk.c            | 21 ++++++++++++++-------
 include/linux/clk-provider.h |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 54a191c..e06a9ac 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -559,6 +559,19 @@ struct clk *__clk_get_parent(struct clk *clk)
 	return !clk ? NULL : clk->parent;
 }
 
+struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
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
@@ -1315,13 +1328,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 			kzalloc((sizeof(struct clk*) * clk->num_parents),
 					GFP_KERNEL);
 
-	if (!clk->parents)
-		ret = __clk_lookup(clk->parent_names[index]);
-	else if (!clk->parents[index])
-		ret = clk->parents[index] =
-			__clk_lookup(clk->parent_names[index]);
-	else
-		ret = clk->parents[index];
+	ret = clk_get_parent_by_index(clk, index);
 
 out:
 	return ret;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1ec14a7..e54dac5 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -418,6 +418,7 @@ const char *__clk_get_name(struct clk *clk);
 struct clk_hw *__clk_get_hw(struct clk *clk);
 u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
+struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
 unsigned int __clk_get_enable_count(struct clk *clk);
 unsigned int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
-- 
1.8.1.2


