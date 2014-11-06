Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKFWmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58826 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaKFWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 111/162] iio: adc: mxs-lradc: Disable the clock on probe failure
Date: Thu,  6 Nov 2014 14:36:15 -0800
Message-Id: <1415313426-9622-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 75d7ed3b9e7cb79a3b0e1f417fb674d54b4fc668 upstream.

We should disable lradc->clk in the case of errors in the probe function.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index cef5dde..da4f0b1 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1307,14 +1307,16 @@ static int mxs_lradc_probe(struct platform_device *pdev)
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
 
 	platform_set_drvdata(pdev, iio);
@@ -1334,7 +1336,7 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 				&mxs_lradc_trigger_handler,
 				&mxs_lradc_buffer_ops);
 	if (ret)
-		return ret;
+		goto err_clk;
 
 	ret = mxs_lradc_trigger_init(iio);
 	if (ret)
@@ -1369,6 +1371,8 @@ err_dev:
 	mxs_lradc_trigger_remove(iio);
 err_trig:
 	iio_triggered_buffer_cleanup(iio);
+err_clk:
+	clk_disable_unprepare(lradc->clk);
 	return ret;
 }
 
-- 
1.9.1

