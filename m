Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaKKLmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:42:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaKKLKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 092/170] iio: adc: mxs-lradc: Disable the clock on probe failure
Date: Tue, 11 Nov 2014 11:07:31 +0000
Message-Id: <1415704129-12709-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 75d7ed3b9e7cb79a3b0e1f417fb674d54b4fc668 upstream.

We should disable lradc->clk in the case of errors in the probe function.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 52d7517b342e..6d500c21cc58 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1565,14 +1565,16 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 	/* Grab all IRQ sources */
 	for (i = 0; i < of_cfg->irq_count; i++) {
 		lradc->irq[i] = platform_get_irq(pdev, i);
-		if (lradc->irq[i] < 0)
-			return lradc->irq[i];
+		if (lradc->irq[i] < 0) {
+			ret = lradc->irq[i];
+			goto err_clk;
+		}
 
 		ret = devm_request_irq(dev, lradc->irq[i],
 					mxs_lradc_handle_irq, 0,
 					of_cfg->irq_name[i], iio);
 		if (ret)
-			return ret;
+			goto err_clk;
 	}
 
 	lradc->vref_mv = of_cfg->vref_mv;
@@ -1594,7 +1596,7 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 				&mxs_lradc_trigger_handler,
 				&mxs_lradc_buffer_ops);
 	if (ret)
-		return ret;
+		goto err_clk;
 
 	ret = mxs_lradc_trigger_init(iio);
 	if (ret)
@@ -1649,6 +1651,8 @@ err_dev:
 	mxs_lradc_trigger_remove(iio);
 err_trig:
 	iio_triggered_buffer_cleanup(iio);
+err_clk:
+	clk_disable_unprepare(lradc->clk);
 	return ret;
 }
 
-- 
2.1.0

