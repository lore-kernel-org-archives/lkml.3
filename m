Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3HVHR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:17:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42505 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3HVHRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:17:55 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH] clk: handle NULL struct clk gracefully
Date: Thu, 22 Aug 2013 00:17:47 -0700
Message-Id: <1377155867-15552-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At some point changes to clk_set_rate and clk_set_parent introduced a
bug whereby NULL struct clk pointers were treated as an error. This is
in violation of the API in include/linux/clk.h. Reintroduce graceful
handling of NULL clk's by bailing from clk_set_rate and clk_set_parent
with return codes of zero.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bc02037..7c43762 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1428,6 +1428,9 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	struct clk *top, *fail_clk;
 	int ret = 0;
 
+	if (!clk)
+		return 0;
+
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
@@ -1567,7 +1570,10 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	u8 p_index = 0;
 	unsigned long p_rate = 0;
 
-	if (!clk || !clk->ops)
+	if (!clk)
+		return 0;
+
+	if (!clk->ops)
 		return -EINVAL;
 
 	/* verify ops for for multi-parent clks */
-- 
1.8.1.2

