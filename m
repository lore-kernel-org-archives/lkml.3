Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaDWONR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:13:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10814 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaDWONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:13:13 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-cd-5357ca76b87a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 RESEND 1/2] mfd: sec-core: Remove duplicated device type
 from sec_pmic_dev
Date: Wed, 23 Apr 2014 16:13:05 +0200
Message-id: <1398262386-10568-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xK7plp8KDDS69tLJ4/cLQ4v7Xo4wW
	l3fNYbM43c1qcXHFFyYHVo871/awecw7GejRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGX+n
	7GYteCFWsezgL9YGxptCXYycHBICJhLHPjcyQ9hiEhfurWfrYuTiEBJYyijx6Mdfdginj0li
	w+TZ7CBVbALGEpuXLwGrEhHoY5Q4/3YNI0iCWcBQ4ue7P2BFwgLxEt9/TgazWQRUJeZf+8sK
	YvMKuEvsnN4CtU5O4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJgi87
	GBcfszrEKMDBqMTDK7E8LFiINbGsuDL3EKMEB7OSCO+SReHBQrwpiZVVqUX58UWlOanFhxiZ
	ODilGhhL9rUG/yhdbHLLy+wz244DxxM2vo4WeZshcyvt5s/aZfVvsgvvdPDsPZ8bx5mSOvON
	7neZA+/UJVMsxLY4yzovrrvD86/s1C2Ro05+KSVfpqsw5J/bPkM95fPtzofcdQ4JznfbhZhU
	C3VLrqg4KHH/vrFxuvePW4UTD4Ro8BpNL7N43zxl2k8lluKMREMt5qLiRACbnyUH4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device type was stored in sec_pmic_dev state container twice:
 - unsigned long type (initialized from of_device_id or i2c_device_id)
 - int device_type (initialized as above or from board files when there
   is no DTS)

The 'type' field was never used outside of probe so it can be safely
removed.

Change also the device_type in sec_pmic_dev and sec_platform_data to
unsigned long to avoid any casts.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>

---

Changes since v1:
 - Change device_type field of sec_platform_data from int to unsigned long.
 - Update commit msg.
---
 drivers/mfd/sec-core.c           | 5 +++--
 drivers/mfd/sec-irq.c            | 2 +-
 include/linux/mfd/samsung/core.h | 3 +--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 1cf27521fff4..700d9a3f2d8f 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -266,6 +266,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	const struct regmap_config *regmap, *regmap_rtc;
 	struct sec_pmic_dev *sec_pmic;
+	unsigned long device_type;
 	int ret;
 
 	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
@@ -277,7 +278,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	sec_pmic->dev = &i2c->dev;
 	sec_pmic->i2c = i2c;
 	sec_pmic->irq = i2c->irq;
-	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
+	device_type = sec_i2c_get_driver_data(i2c, id);
 
 	if (sec_pmic->dev->of_node) {
 		pdata = sec_pmic_i2c_parse_dt_pdata(sec_pmic->dev);
@@ -285,7 +286,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 			ret = PTR_ERR(pdata);
 			return ret;
 		}
-		pdata->device_type = sec_pmic->type;
+		pdata->device_type = device_type;
 	}
 	if (pdata) {
 		sec_pmic->device_type = pdata->device_type;
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 64e7913aadc6..654e2c1dbf7a 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -385,7 +385,7 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 				  &sec_pmic->irq_data);
 		break;
 	default:
-		dev_err(sec_pmic->dev, "Unknown device type %d\n",
+		dev_err(sec_pmic->dev, "Unknown device type %lu\n",
 			sec_pmic->device_type);
 		return -EINVAL;
 	}
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 157e32b6ca28..55540b524b5a 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -46,13 +46,12 @@ struct sec_pmic_dev {
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
 
-	int device_type;
+	unsigned long device_type;
 	int irq_base;
 	int irq;
 	struct regmap_irq_chip_data *irq_data;
 
 	int ono;
-	unsigned long type;
 	bool wakeup;
 	bool wtsr_smpl;
 };
-- 
1.9.1

