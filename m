Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3EQVS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:18:57 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:56679 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3EQVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:18:55 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/4] clk: vt8500: Fix unbalanced spinlock in vt8500_dclk_set_rate()
Date: Sat, 18 May 2013 09:18:49 +1200
Message-Id: <1368825532-30917-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
References: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a DVO clock, a bug is now evident in the vt8500
clock code:
[    0.290000] WARNING: at init/main.c:698 do_one_initcall+0x158/0x18c()
[    0.300000] initcall wm8505fb_driver_init+0x0/0xc returned with disabled int

This is caused by an unbalanced spinlock in vt8500_dclk_set_rate().
Replace the second call to spin_lock_irqsave() with spin_unlock_irqrestore().

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index debf688..553ac35 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -183,7 +183,7 @@ static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	writel(divisor, cdev->div_reg);
 	vt8500_pmc_wait_busy();
 
-	spin_lock_irqsave(cdev->lock, flags);
+	spin_unlock_irqrestore(cdev->lock, flags);
 
 	return 0;
 }
-- 
1.7.9.5

