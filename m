Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaLBKod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:44:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57221 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLBKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:44:31 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] clk: Do not complain about correctly set read-only muxes when assigning clock parents from device tree
Date: Tue,  2 Dec 2014 11:44:28 +0100
Message-Id: <1417517068-31804-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning a clock parent to a mux with the CLK_MUX_READ_ONLY flag causes an
error "clk: failed to reparent read_only_mux to already_set_parent: -38"
even if the hardware is already set to the correct parent clock.

This patch avoids the error message by checking whether the correct parent
is already set before calling clk_set_parent. This allows to use the
assigned-clock-parents device tree binding for clock muxes that are not
allowed to be changed anymore at the time of_clk_set_defaults is called.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
Changes since v1:
 - Move the (rc < 0) check into the body of if (pclk != __clk_get_parent(clk)),
   as suggested by Uwe Kleine-König. No functional change.
---
 drivers/clk/clk-conf.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
index aad4796..bb4dc02 100644
--- a/drivers/clk/clk-conf.c
+++ b/drivers/clk/clk-conf.c
@@ -62,10 +62,13 @@ static int __set_clk_parents(struct device_node *node, bool clk_supplier)
 			goto err;
 		}
 
-		rc = clk_set_parent(clk, pclk);
-		if (rc < 0)
-			pr_err("clk: failed to reparent %s to %s: %d\n",
-			       __clk_get_name(clk), __clk_get_name(pclk), rc);
+		if (pclk != __clk_get_parent(clk)) {
+			rc = clk_set_parent(clk, pclk);
+			if (rc < 0)
+				pr_err("clk: failed to reparent %s to %s: %d\n",
+				       __clk_get_name(clk),
+				       __clk_get_name(pclk), rc);
+		}
 		clk_put(clk);
 		clk_put(pclk);
 	}
-- 
2.1.3

