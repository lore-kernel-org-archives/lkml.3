Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaIASsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:48:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47628 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaIASsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:48:15 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mike Turquette <mturquette@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 1/3] clk: mvebu: share locks between gate clocks
Date: Mon,  1 Sep 2014 11:47:03 -0700
Message-Id: <1409597225-24368-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
References: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor mvebu_clk_gating_setup() to use a common spinlock instead of a
unique lock for every instance of a struct clk_gating_ctrl object. This
will be used later for a separate mux clock type that shares a register
with gate clock types and needs to use the same lock to protect access
to the register.

Cc: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/mvebu/common.c | 9 ++++++---
 drivers/clk/mvebu/common.h | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
index 25ceccf..8145c4e 100644
--- a/drivers/clk/mvebu/common.c
+++ b/drivers/clk/mvebu/common.c
@@ -89,8 +89,10 @@ void __init mvebu_coreclk_setup(struct device_node *np,
  * Clock Gating Control
  */
 
+DEFINE_SPINLOCK(ctrl_gating_lock);
+
 struct clk_gating_ctrl {
-	spinlock_t lock;
+	spinlock_t *lock;
 	struct clk **gates;
 	int num_gates;
 };
@@ -138,7 +140,8 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 	if (WARN_ON(!ctrl))
 		goto ctrl_out;
 
-	spin_lock_init(&ctrl->lock);
+	/* lock must already be initialized */
+	ctrl->lock = &ctrl_gating_lock;
 
 	/* Count, allocate, and register clock gates */
 	for (n = 0; desc[n].name;)
@@ -155,7 +158,7 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 			(desc[n].parent) ? desc[n].parent : default_parent;
 		ctrl->gates[n] = clk_register_gate(NULL, desc[n].name, parent,
 					desc[n].flags, base, desc[n].bit_idx,
-					0, &ctrl->lock);
+					0, ctrl->lock);
 		WARN_ON(IS_ERR(ctrl->gates[n]));
 	}
 
diff --git a/drivers/clk/mvebu/common.h b/drivers/clk/mvebu/common.h
index f968b4d..8cd28e4 100644
--- a/drivers/clk/mvebu/common.h
+++ b/drivers/clk/mvebu/common.h
@@ -17,6 +17,8 @@
 
 #include <linux/kernel.h>
 
+extern spinlock_t ctrl_gating_lock;
+
 struct device_node;
 
 struct coreclk_ratio {
-- 
1.8.3.2

