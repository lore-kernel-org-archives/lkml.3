Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3JTHtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:49:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60603 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3JTHtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:49:08 -0400
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: linux-kernel@vger.kernel.org, mturquette@linaro.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH] clk: mux: fix the return value of get_parent
Date: Sun, 20 Oct 2013 15:48:55 +0800
Message-Id: <1382255335-8131-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there're no parents on the clock mux node, it should return 0, not an
errnor code.

The orphan clock node is using get_parent() to get the index of its
parents in__clk_init(). If the return value is negative, it'll be
transformed to a u8 value (clk_mux_get_parent()). Then the orphan clock
node tries to get its parent with the invalid index. It will only cause
accessing memory beyond border.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 drivers/clk/clk-mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 4f96ff3..cc06015 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -51,7 +51,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 		for (i = 0; i < num_parents; i++)
 			if (mux->table[i] == val)
 				return i;
-		return -EINVAL;
+		return 0;
 	}
 
 	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
@@ -61,7 +61,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 		val--;
 
 	if (val >= num_parents)
-		return -EINVAL;
+		return 0;
 
 	return val;
 }
-- 
1.8.1.2

