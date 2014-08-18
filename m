Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaHRQ5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:57:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56616 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaHRQ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:57:20 -0400
From: Nishanth Menon <nm@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] clk: ti: dra7-atl: Provide error check for incoming parameters in set_rate
Date: Mon, 18 Aug 2014 11:56:55 -0500
Message-ID: <1408381015-16042-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408381015-16042-1-git-send-email-nm@ti.com>
References: <1408381015-16042-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for valid parameters in check rate. Else, we end up getting
errors.

This occurs as part of the inital clock tree update of child clock
nodes where new_rate could be 0 for non functional clocks.

Fixes: 9ac33b0ce81fa48 (" CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/clk/ti/clk-dra7-atl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 4a65b41..af29359 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -139,9 +139,13 @@ static long atl_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 static int atl_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 			    unsigned long parent_rate)
 {
-	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+	struct dra7_atl_desc *cdesc;
 	u32 divider;
 
+	if (!hw || !rate)
+		return -EINVAL;
+
+	cdesc = to_atl_desc(hw);
 	divider = ((parent_rate + rate / 2) / rate) - 1;
 	if (divider > DRA7_ATL_DIVIDER_MASK)
 		divider = DRA7_ATL_DIVIDER_MASK;
-- 
1.7.9.5

