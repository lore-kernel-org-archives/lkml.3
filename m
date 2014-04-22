Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaDVUOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:14:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbaDVUOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:14:43 -0400
From: Colin King <colin.king@canonical.com>
To: Mike Turquette <mturquette@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Pankaj Dev <pankaj.dev@st.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: st: fix memory leak on gate
Date: Tue, 22 Apr 2014 21:14:39 +0100
Message-Id: <1398197679-4149-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck detected a memory leak:
[drivers/clk/st/clkgen-pll.c:525]: (error) Memory leak: gate

free gate on div allocation failure return path.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
1.9.1

