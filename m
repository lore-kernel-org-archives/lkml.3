Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3JaKhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:37:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34829 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3JaKhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:37:01 -0400
MIME-Version: 1.0
Date: Thu, 31 Oct 2013 18:36:59 +0800
Message-ID: <CAPgLHd_PCo3SC+CVH6agnRfQf1+E85Lyec7YiBFZ7j9wNPvUHg@mail.gmail.com>
Subject: [PATCH -next] clk: keystone: fix return value check in _of_pll_clk_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@linaro.org, santosh.shilimkar@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

clk_register_pll() returns ERR_PTR() when memory alloc fail and NULL
in the other case, the user of this function should used IS_ERR_OR_NULL()
to check the return value. this patch change clk_register_pll() to return
only ERR_PTR(), and also fixed the user.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/keystone/pll.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/keystone/pll.c b/drivers/clk/keystone/pll.c
index 47a1bd9..78a6e0e 100644
--- a/drivers/clk/keystone/pll.c
+++ b/drivers/clk/keystone/pll.c
@@ -127,12 +127,9 @@ static struct clk *clk_register_pll(struct device *dev,
 
 	clk = clk_register(NULL, &pll->hw);
 	if (IS_ERR(clk))
-		goto out;
+		kfree(pll);
 
 	return clk;
-out:
-	kfree(pll);
-	return NULL;
 }
 
 /**
@@ -182,7 +179,7 @@ static void __init _of_pll_clk_init(struct device_node *node, bool pllctrl)
 	}
 
 	clk = clk_register_pll(NULL, node->name, parent_name, pll_data);
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		return;
 	}

