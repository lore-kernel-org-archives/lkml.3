Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964Ab3DDVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:37:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:41524 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764942Ab3DDVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,411,1363158000"; 
   d="scan'208";a="312561416"
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Joe Perches <joe@perches.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] staging/adt7316 Fix some 'interesting' string operations
Date: Thu, 04 Apr 2013 14:37:24 -0700
Message-Id: <515df29417437372eb@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling memcmp() to check the value of the first byte in a string is overkill.
Just use buf[0] == '1' or buf[0] != '1' as appropriate.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

[Inspired by a rant on IRC about a different driver doing something similar]

diff --git a/drivers/staging/iio/addac/adt7316.c b/drivers/staging/iio/addac/adt7316.c
index 0b431bc..506b5a7 100644
--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -256,7 +256,7 @@ static ssize_t adt7316_store_enabled(struct device *dev,
 	struct adt7316_chip_info *chip = iio_priv(dev_info);
 	int enable;
 
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		enable = 1;
 	else
 		enable = 0;
@@ -299,7 +299,7 @@ static ssize_t adt7316_store_select_ex_temp(struct device *dev,
 		return -EPERM;
 
 	config1 = chip->config1 & (~ADT7516_SEL_EX_TEMP);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config1 |= ADT7516_SEL_EX_TEMP;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG1, config1);
@@ -495,7 +495,7 @@ static ssize_t adt7316_store_disable_averaging(struct device *dev,
 	int ret;
 
 	config2 = chip->config2 & (~ADT7316_DISABLE_AVERAGING);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config2 |= ADT7316_DISABLE_AVERAGING;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG2, config2);
@@ -534,7 +534,7 @@ static ssize_t adt7316_store_enable_smbus_timeout(struct device *dev,
 	int ret;
 
 	config2 = chip->config2 & (~ADT7316_EN_SMBUS_TIMEOUT);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config2 |= ADT7316_EN_SMBUS_TIMEOUT;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG2, config2);
@@ -597,7 +597,7 @@ static ssize_t adt7316_store_powerdown(struct device *dev,
 	int ret;
 
 	config1 = chip->config1 & (~ADT7316_PD);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config1 |= ADT7316_PD;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG1, config1);
@@ -635,7 +635,7 @@ static ssize_t adt7316_store_fast_ad_clock(struct device *dev,
 	int ret;
 
 	config3 = chip->config3 & (~ADT7316_ADCLK_22_5);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config3 |= ADT7316_ADCLK_22_5;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
@@ -681,7 +681,7 @@ static ssize_t adt7316_store_da_high_resolution(struct device *dev,
 
 	chip->dac_bits = 8;
 
-	if (!memcmp(buf, "1", 1)) {
+	if (buf[0] == '1') {
 		config3 = chip->config3 | ADT7316_DA_HIGH_RESOLUTION;
 		if (chip->id == ID_ADT7316 || chip->id == ID_ADT7516)
 			chip->dac_bits = 12;
@@ -731,7 +731,7 @@ static ssize_t adt7316_store_AIN_internal_Vref(struct device *dev,
 	if ((chip->id & ID_FAMILY_MASK) != ID_ADT75XX)
 		return -EPERM;
 
-	if (memcmp(buf, "1", 1))
+	if (buf[0] != '1')
 		config3 = chip->config3 & (~ADT7516_AIN_IN_VREF);
 	else
 		config3 = chip->config3 | ADT7516_AIN_IN_VREF;
@@ -773,7 +773,7 @@ static ssize_t adt7316_store_enable_prop_DACA(struct device *dev,
 	int ret;
 
 	config3 = chip->config3 & (~ADT7316_EN_IN_TEMP_PROP_DACA);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config3 |= ADT7316_EN_IN_TEMP_PROP_DACA;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
@@ -812,7 +812,7 @@ static ssize_t adt7316_store_enable_prop_DACB(struct device *dev,
 	int ret;
 
 	config3 = chip->config3 & (~ADT7316_EN_EX_TEMP_PROP_DACB);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config3 |= ADT7316_EN_EX_TEMP_PROP_DACB;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
@@ -1018,7 +1018,7 @@ static ssize_t adt7316_store_DA_AB_Vref_bypass(struct device *dev,
 		return -EPERM;
 
 	dac_config = chip->dac_config & (~ADT7316_VREF_BYPASS_DAC_AB);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		dac_config |= ADT7316_VREF_BYPASS_DAC_AB;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_DAC_CONFIG, dac_config);
@@ -1063,7 +1063,7 @@ static ssize_t adt7316_store_DA_CD_Vref_bypass(struct device *dev,
 		return -EPERM;
 
 	dac_config = chip->dac_config & (~ADT7316_VREF_BYPASS_DAC_CD);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		dac_config |= ADT7316_VREF_BYPASS_DAC_CD;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_DAC_CONFIG, dac_config);
@@ -1982,7 +1982,7 @@ static ssize_t adt7316_set_int_enabled(struct device *dev,
 	int ret;
 
 	config1 = chip->config1 & (~ADT7316_INT_EN);
-	if (!memcmp(buf, "1", 1))
+	if (buf[0] == '1')
 		config1 |= ADT7316_INT_EN;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG1, config1);
