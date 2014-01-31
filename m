Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbaAaXGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:06:17 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35262 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaAaXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:06:14 -0500
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mmc@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Chris Ball <chris@printf.net>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Tejun Heo <tj@kernel.org>, Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] mmc: move clock gating work to power efficient workqueue
Date: Fri, 31 Jan 2014 15:05:41 -0800
Message-Id: <1391209541-17288-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

Instead of binding the clock gating work to the CPU that scheduled it,
allow the scheduler to select the best CPU to handle it. This extends
idle residency times and conserves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Chris Ball <chris@printf.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Baatz <gmbnomis@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel. Added commit message.
Fixed code alignment.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/mmc/core/host.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 49bc403..a787f1b 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -207,8 +207,9 @@ void mmc_host_clk_release(struct mmc_host *host)
 	host->clk_requests--;
 	if (mmc_host_may_gate_card(host->card) &&
 	    !host->clk_requests)
-		schedule_delayed_work(&host->clk_gate_work,
-				      msecs_to_jiffies(host->clkgate_delay));
+		queue_delayed_work(system_power_efficient_wq,
+				   &host->clk_gate_work,
+				   msecs_to_jiffies(host->clkgate_delay));
 	spin_unlock_irqrestore(&host->clk_lock, flags);
 }
 
-- 
1.7.9.5

