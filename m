Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaIDBBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:01:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39501 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbaIDBBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:01:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/4] clk: Recalc rate and accuracy in underscore functions if not caching
Date: Wed,  3 Sep 2014 18:01:03 -0700
Message-Id: <1409792466-5092-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we move this code to use ww_mutex we'll need to call
__clk_get_rate() and __clk_get_accuracy(), instead of their
non-underscore counterparts, while holding the clock's prepare
mutex. Move the recalculation of these values into the underscore
functions so that we can call __clk_get_rate() and
__clk_get_accuracy() while holding locks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b76fa69b44cb..1feaf708aa49 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -591,6 +591,8 @@ unsigned int __clk_get_prepare_count(struct clk *clk)
 	return !clk ? 0 : clk->prepare_count;
 }
 
+static void __clk_recalc_rates(struct clk *clk, unsigned long msg);
+
 unsigned long __clk_get_rate(struct clk *clk)
 {
 	unsigned long ret;
@@ -600,6 +602,9 @@ unsigned long __clk_get_rate(struct clk *clk)
 		goto out;
 	}
 
+	if (clk->flags & CLK_GET_RATE_NOCACHE)
+		__clk_recalc_rates(clk, 0);
+
 	ret = clk->rate;
 
 	if (clk->flags & CLK_IS_ROOT)
@@ -613,11 +618,16 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_get_rate);
 
+static void __clk_recalc_accuracies(struct clk *clk);
+
 unsigned long __clk_get_accuracy(struct clk *clk)
 {
 	if (!clk)
 		return 0;
 
+	if (clk->flags & CLK_GET_ACCURACY_NOCACHE)
+		__clk_recalc_accuracies(clk);
+
 	return clk->accuracy;
 }
 
@@ -1083,9 +1093,6 @@ long clk_get_accuracy(struct clk *clk)
 	unsigned long accuracy;
 
 	clk_prepare_lock();
-	if (clk && (clk->flags & CLK_GET_ACCURACY_NOCACHE))
-		__clk_recalc_accuracies(clk);
-
 	accuracy = __clk_get_accuracy(clk);
 	clk_prepare_unlock();
 
@@ -1151,10 +1158,6 @@ unsigned long clk_get_rate(struct clk *clk)
 	unsigned long rate;
 
 	clk_prepare_lock();
-
-	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
-		__clk_recalc_rates(clk, 0);
-
 	rate = __clk_get_rate(clk);
 	clk_prepare_unlock();
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

