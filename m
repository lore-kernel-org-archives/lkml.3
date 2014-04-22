Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaDVN11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:27:27 -0400
Received: from [141.85.227.118] ([141.85.227.118]:49571 "EHLO swarm.cs.pub.ro"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaDVN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:27:21 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2014 09:27:21 EDT
From: Valentin Ilie <valentin.ilie@gmail.com>
To: mturquette@linaro.org, pankaj.dev@st.com, gabriel.fernandez@st.com
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] clk: st: Fix memory leak
Date: Tue, 22 Apr 2014 16:15:54 +0300
Message-Id: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it fails to allocate div, gate should be free'd before return

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/clk/st/clkgen-pll.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index bca0a0b..a886702 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -521,8 +521,10 @@ static struct clk * __init clkgen_odf_register(const char *parent_name,
 	gate->lock = odf_lock;
 
 	div = kzalloc(sizeof(*div), GFP_KERNEL);
-	if (!div)
+	if (!div) {
+		kfree(gate);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	div->flags = CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO;
 	div->reg = reg + pll_data->odf[odf].offset;
-- 
1.8.3.2

