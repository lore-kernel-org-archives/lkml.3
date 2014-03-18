Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaCRM6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:58:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31008 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaCRM6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:58:03 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-e6-532842d7caad
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: sec-core: Fix I2C dummy device resource leak on probe
 failure
Date: Tue, 18 Mar 2014 13:57:50 +0100
Message-id: <1395147470-24817-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t/xa7rXnTSCDfqWmFq8fmFocf/rUUaL
	y7vmsFmc7ma1uLjiC5MDq8eda3vYPOadDPTo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujOP7
	JzEWbOeomPZ3DmMD41u2LkZODgkBE4lpG3ezQthiEhfurQeKc3EICSxllJg9ezUjhNPHJHH3
	0S4WkCo2AWOJzcuXgFWJCPQxSpx/u4YRJMEsYCjx890fdhBbWCBUomH2ETCbRUBV4u3e28wg
	Nq+Au8T8vxeABnEArVOQmDPJZgIj9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYISHw
	dQfj0mNWhxgFOBiVeHhfsqkHC7EmlhVX5h5ilOBgVhLhZbfSCBbiTUmsrEotyo8vKs1JLT7E
	yMTBKdXAOFfM91n5gxm/zAKF9rAuLfr0/sT2Bd9fBC7Pqc85GbOyJ0fFutE6cxXr/sL7sbtu
	6XLyaE/uddo4Q+3b1T+ihnt3+bWu+C01J+jS+i4P59kzFayEL3y9pul4eq0Lg/ktb3Pmmxu8
	r2y/WMXoN2Pj5KuSx7T/Cl5+3Dl5iebEA0bN1Rua7CSO+iixFGckGmoxFxUnAgCgvVNP3wEA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy I2C device allocated in sec_pmic_probe() leaked if
devm_regmap_init_i2c() failed. Unregister it before returning from
probe.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 714e2135210e..6a6168ce3f79 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -260,7 +260,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(sec_pmic->regmap_rtc);
 		dev_err(&i2c->dev, "Failed to allocate RTC register map: %d\n",
 			ret);
-		return ret;
+		goto err_regmap_rtc;
 	}
 
 	if (pdata && pdata->cfg_pmic_irq)
@@ -293,14 +293,15 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	}
 
 	if (ret)
-		goto err;
+		goto err_mfd;
 
 	device_init_wakeup(sec_pmic->dev, sec_pmic->wakeup);
 
 	return ret;
 
-err:
+err_mfd:
 	sec_irq_exit(sec_pmic);
+err_regmap_rtc:
 	i2c_unregister_device(sec_pmic->rtc);
 	return ret;
 }
-- 
1.7.9.5

