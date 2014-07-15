Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbaGOR27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:28:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52670 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaGORCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:06 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Tero Kristo <t-kristo@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 05/94] clk: ti: set CLK_SET_RATE_NO_REPARENT for ti,mux-clock
Date: Tue, 15 Jul 2014 20:00:20 +0300
Message-Id: <1405443709-15288-5-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

When setting the rate of a clock, by default the clock framework will
change the parent of the clock to the most suitable one in
__clk_mux_determine_rate() (most suitable by looking at the clock rate).

This is a rather dangerous default, and causes problems on AM43x when
using display and ethernet. There are multiple ways to select the clock
muxes on AM43x, and some of those clock paths have the same source
clocks for display and ethernet. When changing the clock rate for the
display subsystem, the clock framework decides to change the display mux
from the dedicated display PLL to a shared PLL which is used by the
ethernet, and then changes the rate of the shared PLL, breaking the
ethernet.

As I don't think there ever is a case where we want the clock framework
to automatically change the parent clock of a clock mux, this patch sets
the CLK_SET_RATE_NO_REPARENT for all ti,mux-clocks.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reviewed-by: Paul Walmsley <paul@pwsan.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/ti/mux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index 0197a47..e9d650e 100644
--- a/drivers/clk/ti/mux.c
+++ b/drivers/clk/ti/mux.c
@@ -160,7 +160,7 @@ static void of_mux_clk_setup(struct device_node *node)
 	u8 clk_mux_flags = 0;
 	u32 mask = 0;
 	u32 shift = 0;
-	u32 flags = 0;
+	u32 flags = CLK_SET_RATE_NO_REPARENT;
 
 	num_parents = of_clk_get_parent_count(node);
 	if (num_parents < 2) {
-- 
1.7.10.4

