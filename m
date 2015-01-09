Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbbAII22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:28:28 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14081 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbbAII20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:28:26 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-1c-54af91283698
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] clk: Use lockdep asserts to find missing hold of prepare_lock
Date: Fri, 09 Jan 2015 09:28:10 +0100
Message-id: <1420792090-14174-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t/xy7oaE9eHGDzs5LF4/cLQ4vKuOWwW
	TydcZLP4caabxYHF43JfL5PHnWt72Dz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/cV4YKJ
	ghV9b1+xNzC+4e1i5OSQEDCR6NzwjwnCFpO4cG89WxcjF4eQwFJGiT0HG1kgnD4miTmrfrKD
	VLEJGEtsXr6EDcQWEciXmLXuNguIzSxgKPHz3R+wGmEBP4mlC7vBalgEVCXevJ0BFucVcJdY
	vns/M8Q2OYmTxyazTmDkXsDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjxPdfdjAuPmZ1
	iFGAg1GJh3eH6voQIdbEsuLK3EOMEhzMSiK8spZAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzh
	7nZ83M/2M/B0HP28Ou9394/VBVUcTW66u87eXcbt8jGo8vW7hicHMgNly5VV7xxcYPhTd5IV
	N0/KOrbswh7D0/t3R19kOyDxyz7iY97eY4+UZ3UWrQlKOGcjmKau0H/G/+SZ2qfbtksKfdiq
	ZDg5/KP2RhfdE8/uHL/4b/0t5lydORJpTuuVWIozEg21mIuKEwHdxf9r2wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockdep asserts for holding the prepare_lock to all functions
marking this as a requirement in description. Add this to private and
exported functions so all locking misuse could be detected during
debugging.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7d4e17..cdbfaa34ace4 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -432,6 +432,8 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 {
 	struct clk *child;
 
+	lockdep_assert_held(&prepare_lock);
+
 	if (!clk)
 		return;
 
@@ -458,6 +460,8 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	struct clk *child;
 	unsigned long flags;
 
+	lockdep_assert_held(&prepare_lock);
+
 	if (!clk)
 		goto out;
 
@@ -947,6 +951,8 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 	struct clk *parent;
 	struct clk_hw *parent_hw;
 
+	lockdep_assert_held(&prepare_lock);
+
 	if (!clk)
 		return 0;
 
@@ -1040,6 +1046,8 @@ static void __clk_recalc_accuracies(struct clk *clk)
 	unsigned long parent_accuracy = 0;
 	struct clk *child;
 
+	lockdep_assert_held(&prepare_lock);
+
 	if (clk->parent)
 		parent_accuracy = clk->parent->accuracy;
 
@@ -1104,6 +1112,8 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 	unsigned long parent_rate = 0;
 	struct clk *child;
 
+	lockdep_assert_held(&prepare_lock);
+
 	old_rate = clk->rate;
 
 	if (clk->parent)
@@ -1297,6 +1307,8 @@ static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
 
+	lockdep_assert_held(&prepare_lock);
+
 	new_rate = clk_recalc(clk, parent_rate);
 
 	/* abort rate change if a driver returns NOTIFY_BAD or NOTIFY_STOP */
@@ -2110,6 +2122,8 @@ static void __clk_release(struct kref *ref)
 	struct clk *clk = container_of(ref, struct clk, ref);
 	int i = clk->num_parents;
 
+	lockdep_assert_held(&prepare_lock);
+
 	kfree(clk->parents);
 	while (--i >= 0)
 		kfree(clk->parent_names[i]);
-- 
1.9.1

