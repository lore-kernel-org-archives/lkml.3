Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaLaJDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:03:51 -0500
Received: from www.osadl.org ([62.245.132.105]:56732 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaLaJDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 04:03:48 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC] iio: iadc: wait_for_completion_timeout time in jiffies
Date: Wed, 31 Dec 2014 03:59:46 -0500
Message-Id: <1420016386-19638-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timeout value to wait_for_completion_timeout is in jiffies but
the value being passed seems like it was intended to by microseconds
Note that the timeout was extremely long thus it might be too short
now. In any case it probably should be passed through usecs_to_jiffies()
or msecs_to_jiffies()

patch is against linux-next 3.19.0-rc1 -next-20141226

patch was only compile-tested x86_64_defcofnig + CONFIG_SPMI=m
CONFIG_IIO=m, CONFIG_QCOM_SPMI_IADC=m

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/iio/adc/qcom-spmi-iadc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
index b9666f2..3080562 100644
--- a/drivers/iio/adc/qcom-spmi-iadc.c
+++ b/drivers/iio/adc/qcom-spmi-iadc.c
@@ -296,7 +296,8 @@ static int iadc_do_conversion(struct iadc_chip *iadc, int chan, u16 *data)
 	if (iadc->poll_eoc) {
 		ret = iadc_poll_wait_eoc(iadc, wait);
 	} else {
-		ret = wait_for_completion_timeout(&iadc->complete, wait);
+		ret = wait_for_completion_timeout(&iadc->complete,
+			usecs_to_jiffies(wait));
 		if (!ret)
 			ret = -ETIMEDOUT;
 		else
-- 
1.7.10.4

