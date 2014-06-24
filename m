Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaFXN5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:57:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19790 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaFXN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:48 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e6-53a983d9ce65
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Subject: [PATCH 1/6] mmc: sdhci-s3c: Fix local I/O clock gating
Date: Tue, 24 Jun 2014 15:57:10 +0200
Message-id: <1403618235-19353-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xq7o3m1cGGxx/x2Qxad0BJosJl7cz
	WvQuuMpmsenxNVaLy7vmsFkc+d/PaDHj/D4mi7VH7rJbrJ/xmsVi1a4/jBbH14Y7cHv8XfWC
	2WPnrLvsHneu7WHz2Lyk3uPGq4VMHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXxoP0pa8Fi
	/orlk06yNTBe4Oli5OSQEDCR+Hx9PROELSZx4d56ti5GLg4hgaWMEi+m/WCEcPqYJOZMaGAB
	qWITUJP43PCIDcQWEVCV+Ny2gB2kiFngJZPE6i3tYEXCAvYSn252MYLYLEBF137+A1vBK+Ak
	MfnWO2aIdXISvdvegNmcAs4SO9u3sYLYQkA1/082MU1g5F3AyLCKUTS1NLmgOCk911CvODG3
	uDQvXS85P3cTIyQgv+xgXHzM6hCjAAejEg/vhV0rgoVYE8uKK3MPMUpwMCuJ8N6oWRksxJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgXFV6L6bM7+81g7q4+DMfBZoFPhd6ndjueoZv44lZgumWWft
	urR79cuUELPpKVl7vnh/cquPb/ngsTJkt+7PCjlWpsLvN6YJlFTtFJko0Mp5OWya7ssfGk3R
	s6ZM+lW5Vj5FtiNqCuOERWqxve7X6j5dVHGM27j735v6vuZSE2bnu/O89/+uuq7EUpyRaKjF
	XFScCADB/KM3JgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For internal card detection mechanism it is required that the local I/O
clock is always running. However while current implementation accounts
for this, it does so incorrectly leading to race conditions and warnings
about unbalanced clock disables.

This patch fixes it by inverting the logic, which now increases local
I/O clock enable count when internal card detect is used, instead of
decreasing it otherwise.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/sdhci-s3c.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index fa5954a..1795e1f 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -487,8 +487,13 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
 		goto err_pdata_io_clk;
 	}
 
-	/* enable the local io clock and keep it running for the moment. */
-	clk_prepare_enable(sc->clk_io);
+	/*
+	 * Keep local I/O clock enabled for internal card detect pin
+	 * or runtime PM is disabled.
+	 */
+	if (pdata->cd_type == S3C_SDHCI_CD_INTERNAL
+	    || !IS_ENABLED(CONFIG_PM_RUNTIME))
+		clk_prepare_enable(sc->clk_io);
 
 	for (clks = 0, ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
 		char name[14];
@@ -611,15 +616,13 @@ static int sdhci_s3c_probe(struct platform_device *pdev)
 		goto err_req_regs;
 	}
 
-#ifdef CONFIG_PM_RUNTIME
-	if (pdata->cd_type != S3C_SDHCI_CD_INTERNAL)
-		clk_disable_unprepare(sc->clk_io);
-#endif
 	return 0;
 
  err_req_regs:
  err_no_busclks:
-	clk_disable_unprepare(sc->clk_io);
+	if (pdata->cd_type == S3C_SDHCI_CD_INTERNAL
+	    || !IS_ENABLED(CONFIG_PM_RUNTIME))
+		clk_disable_unprepare(sc->clk_io);
 
  err_pdata_io_clk:
 	sdhci_free_host(host);
-- 
1.9.3

