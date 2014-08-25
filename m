Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaHYM2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:28:30 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58291 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbaHYM0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:41 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 10/12] mmc: sdhi: Fixup system PM suspend lock-up
Date: Mon, 25 Aug 2014 14:26:02 +0200
Message-Id: <1408969564-6335-11-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At system PM suspend, the tmio core accessed the internal registers of
the controller without first moving the device into active state. This
caused a lock-up in system PM suspend phase.

The reason for the register access were masking of IRQs. Since that is
managed via the runtime PM suspend path, let's just re-use that path
for system PM suspend.

In other words force the device into runtime PM suspend state at system
PM suspend and restore it to active state at system PM resume.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sh_mobile_sdhi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index 4cd0f09..2dafe28 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -332,7 +332,8 @@ static int sh_mobile_sdhi_remove(struct platform_device *pdev)
 }
 
 static const struct dev_pm_ops tmio_mmc_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tmio_mmc_host_suspend, tmio_mmc_host_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+			pm_runtime_force_resume)
 	SET_PM_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
 			tmio_mmc_host_runtime_resume,
 			NULL)
-- 
1.9.1

