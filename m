Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaLLXEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:04:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37488 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaLLXET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:04:19 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH] clk: Really fix deadlock with mmap_sem
Date: Fri, 12 Dec 2014 15:04:16 -0800
Message-Id: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6314b6796e3c (clk: Don't hold prepare_lock across debugfs
creation, 2014-09-04) forgot to update one place where we hold
the prepare_lock while creating debugfs directories. This means
we still have the chance of a deadlock that the commit was trying
to fix. Actually fix it by moving the debugfs creation outside
the prepare_lock.

Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Fixes: 6314b6796e3c "clk: Don't hold prepare_lock across debugfs creation"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 44cdc47a6cc5..c9430653ddc9 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -240,12 +240,13 @@ static const struct file_operations clk_dump_fops = {
 	.release	= single_release,
 };
 
-/* caller must hold prepare_lock */
 static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 {
 	struct dentry *d;
 	int ret = -ENOMEM;
 
+	lockdep_assert_held(clk_debug_lock);
+
 	if (!clk || !pdentry) {
 		ret = -EINVAL;
 		goto out;
@@ -1944,7 +1945,6 @@ int __clk_init(struct device *dev, struct clk *clk)
 	else
 		clk->rate = 0;
 
-	clk_debug_register(clk);
 	/*
 	 * walk the list of orphan clocks and reparent any that are children of
 	 * this clock
@@ -1979,6 +1979,9 @@ int __clk_init(struct device *dev, struct clk *clk)
 out:
 	clk_prepare_unlock();
 
+	if (!ret)
+		clk_debug_register(clk);
+
 	return ret;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

