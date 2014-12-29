Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaL2Ou2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:50:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29910 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaL2OuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:50:11 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4d-54a16a218a0c
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/4] clk: use kstrdup_const for clock name allocations
Date: Mon, 29 Dec 2014 15:48:29 +0100
Message-id: <1419864510-24834-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJMWRmVeSWpSXmKPExsVy+t/xq7qKWQtDDJ5/UrC4te4cq8XlXXPY
	LO6t+c9qsfbIXXYHFo9Nnyaxe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfGtY5TzAVn+Sqe
	/GlnbmBs5+li5OSQEDCRuL7iPzuELSZx4d56ti5GLg4hgaWMEtuOfmWGcPqYJA4fmQRWxSag
	KfF38002EFsEqOPjmctARRwczAIlErfOioGEhQW8JLZNWc4EEmYRUJV4+cIJJMwr4Cyxa8Nk
	ZohdchInj01mBSnhFHCR+NsVBxIWAir5uWQK+wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS
	9ZLzczcxQsLjyw7GxcesDjEKcDAq8fAmnFgQIsSaWFZcmXuIUYKDWUmEV9pyYYgQb0piZVVq
	UX58UWlOavEhRiYOTqkGRjMG/Ufvovb5CHDf04zh3PJxPfvTgq9Lp0nfLVz1eK39UyOpi5Z3
	eG56VU2RCln7UiAv8WnjjOc9BclFKemG7bVRHwJjQj3/bz44nXtCVdKpqX/CFD/mSxtd1GbQ
	8inyvnf96kHXp0Ve2379FBG43VCVHLH75mwOTc28VevPcl2ecSrnnuOGl0osxRmJhlrMRcWJ
	AAo5DnvtAQAA
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

