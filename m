Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3IYBN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:13:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3IYAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: [ 031/110] iio: mxs-lradc: Fix misuse of iio->trig
Date: Tue, 24 Sep 2013 17:14:29 -0700
Message-Id: <20130925001326.787125595@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit e1b1fa66a0398f0b52ae79a2bdc7de87c205d074 upstream.

The struct iio_dev .trig field is to be used only by the IIO core,
the driver shall not fill this field. This fixes ugly crash when
the driver is compiled as a module and the module is rmmod'd.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/mxs-lradc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -661,12 +661,13 @@ static int mxs_lradc_trigger_init(struct
 {
 	int ret;
 	struct iio_trigger *trig;
+	struct mxs_lradc *lradc = iio_priv(iio);
 
 	trig = iio_trigger_alloc("%s-dev%i", iio->name, iio->id);
 	if (trig == NULL)
 		return -ENOMEM;
 
-	trig->dev.parent = iio->dev.parent;
+	trig->dev.parent = lradc->dev;
 	iio_trigger_set_drvdata(trig, iio);
 	trig->ops = &mxs_lradc_trigger_ops;
 
@@ -676,15 +677,17 @@ static int mxs_lradc_trigger_init(struct
 		return ret;
 	}
 
-	iio->trig = trig;
+	lradc->trig = trig;
 
 	return 0;
 }
 
 static void mxs_lradc_trigger_remove(struct iio_dev *iio)
 {
-	iio_trigger_unregister(iio->trig);
-	iio_trigger_free(iio->trig);
+	struct mxs_lradc *lradc = iio_priv(iio);
+
+	iio_trigger_unregister(lradc->trig);
+	iio_trigger_free(lradc->trig);
 }
 
 static int mxs_lradc_buffer_preenable(struct iio_dev *iio)


