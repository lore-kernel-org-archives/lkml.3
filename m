Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3LNGHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 01:07:47 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54385 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3LNGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 01:07:45 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH] clocksource: sh_cmt: Add clk_prepare/unprepare support
Date: Sat, 14 Dec 2013 15:07:32 +0900
Message-Id: <d78e9474459768c9aaf8cfd8bc54957d44771f46.1387000863.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1387000863.git.horms+renesas@verge.net.au>
References: <cover.1387000863.git.horms+renesas@verge.net.au>
In-Reply-To: <cover.1387000863.git.horms+renesas@verge.net.au>
References: <cover.1387000863.git.horms+renesas@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Prepare the clock at probe time, as there is no other appropriate place
in the driver where we're allowed to sleep.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/clocksource/sh_cmt.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 0965e98..940341a 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -634,12 +634,18 @@ static int sh_cmt_clock_event_next(unsigned long delta,
 
 static void sh_cmt_clock_event_suspend(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweroff(&ced_to_sh_cmt(ced)->pdev->dev);
+	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+
+	pm_genpd_syscore_poweroff(&p->pdev->dev);
+	clk_unprepare(p->clk);
 }
 
 static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
 {
-	pm_genpd_syscore_poweron(&ced_to_sh_cmt(ced)->pdev->dev);
+	struct sh_cmt_priv *p = ced_to_sh_cmt(ced);
+
+	clk_prepare(p->clk);
+	pm_genpd_syscore_poweron(&p->pdev->dev);
 }
 
 static void sh_cmt_register_clockevent(struct sh_cmt_priv *p,
@@ -737,6 +743,10 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 		goto err2;
 	}
 
+	ret = clk_prepare(p->clk);
+	if (ret < 0)
+		goto err3;
+
 	if (res2 && (resource_size(res2) == 4)) {
 		/* assume both CMSTR and CMCSR to be 32-bit */
 		p->read_control = sh_cmt_read32;
@@ -773,19 +783,21 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 			      cfg->clocksource_rating);
 	if (ret) {
 		dev_err(&p->pdev->dev, "registration failed\n");
-		goto err3;
+		goto err4;
 	}
 	p->cs_enabled = false;
 
 	ret = setup_irq(irq, &p->irqaction);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to request irq %d\n", irq);
-		goto err3;
+		goto err4;
 	}
 
 	platform_set_drvdata(pdev, p);
 
 	return 0;
+err4:
+	clk_unprepare(p->clk);
 err3:
 	clk_put(p->clk);
 err2:
-- 
1.8.4

