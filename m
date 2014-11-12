Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbaKLB3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaKLB3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:29:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.17 189/319] iio: adc: mxs-lradc: Disable the clock on probe failure
Date: Wed, 12 Nov 2014 10:15:27 +0900
Message-Id: <20141112011024.026769549@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 75d7ed3b9e7cb79a3b0e1f417fb674d54b4fc668 upstream.

We should disable lradc->clk in the case of errors in the probe function.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/mxs-lradc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1565,14 +1565,16 @@ static int mxs_lradc_probe(struct platfo
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
@@ -1594,7 +1596,7 @@ static int mxs_lradc_probe(struct platfo
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
 


