Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbbALJV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:21:27 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27669 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbbALJUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:20:06 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e6-54b391c5045b
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] clk: convert clock name allocations to kstrdup_const
Date: Mon, 12 Jan 2015 10:18:41 +0100
Message-id: <1421054323-14430-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xK7pHJ24OMfh2i9ni1rpzrBZz1q9h
	szhy7Tu7xeV/b1gszja9AbJ2zWGzuLfmP6vF2iN32S2eTrjIZnH+73FWBy6P+Ts/Mnps+jSJ
	3ePOtT1sHidm/GbxWHJTzaNvyypGj8+b5Dw2PXnLFMARxWWTkpqTWZZapG+XwJVxreMUc8FZ
	voonf9qZGxjbeboYOTkkBEwkOl7MZIKwxSQu3FvP1sXIxSEksJRR4njTQxaQhJBAH5PEjzfS
	IDabgKbE38032UBsEaCGj2cuM4M0MAucYJJY/6sRbJKwgKfE4YnrwWwWAVWJ53/Ws4LYvALO
	Ek9Xd7BAbJOTOHlsMlicU8BF4uLOt8wQy5wlrh48zzyBkXcBI8MqRtHU0uSC4qT0XEO94sTc
	4tK8dL3k/NxNjJCA/LKDcfExq0OMAhyMSjy8E2Q2hwixJpYVV+YeYpTgYFYS4XUtAwrxpiRW
	VqUW5ccXleakFh9iZOLglGpgXNVj1PU8ZvkvW+eoBP+8vMSrTslHI7Y9Eq6dOmeNR7EG27ED
	KRdDxDgVIlYsVfY0awl1Lvzo7Nqa/mL++m/L9h586PL61czEr0k+7w08rwjPu8m02uDtRe31
	AR0eS5/L7JUMEX5pfyZeLme3+sOu6OrUr65aX6c4ehoy7ZHf2B9eZWgTWn9OiaU4I9FQi7mo
	OBEAsBGhxCYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock subsystem frequently performs duplication of strings located
in read-only memory section. Replacing kstrdup by kstrdup_const
allows to avoid such operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/clk/clk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7..27e644a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2048,7 +2048,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 		goto fail_out;
 	}
 
-	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
+	clk->name = kstrdup_const(hw->init->name, GFP_KERNEL);
 	if (!clk->name) {
 		pr_err("%s: could not allocate clk->name\n", __func__);
 		ret = -ENOMEM;
@@ -2075,7 +2075,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 
 	/* copy each string name in case parent_names is __initdata */
 	for (i = 0; i < clk->num_parents; i++) {
-		clk->parent_names[i] = kstrdup(hw->init->parent_names[i],
+		clk->parent_names[i] = kstrdup_const(hw->init->parent_names[i],
 						GFP_KERNEL);
 		if (!clk->parent_names[i]) {
 			pr_err("%s: could not copy parent_names\n", __func__);
@@ -2090,10 +2090,10 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 
 fail_parent_names_copy:
 	while (--i >= 0)
-		kfree(clk->parent_names[i]);
+		kfree_const(clk->parent_names[i]);
 	kfree(clk->parent_names);
 fail_parent_names:
-	kfree(clk->name);
+	kfree_const(clk->name);
 fail_name:
 	kfree(clk);
 fail_out:
@@ -2112,10 +2112,10 @@ static void __clk_release(struct kref *ref)
 
 	kfree(clk->parents);
 	while (--i >= 0)
-		kfree(clk->parent_names[i]);
+		kfree_const(clk->parent_names[i]);
 
 	kfree(clk->parent_names);
-	kfree(clk->name);
+	kfree_const(clk->name);
 	kfree(clk);
 }
 
-- 
1.9.1

