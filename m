Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3IWSUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:20:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60687 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab3IWSUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:20:05 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Mathias Leblanc <mathias.leblanc@st.com>
Subject: [PATCH 12/13] tpm: st33: Remove chip->data_buffer access from this driver
Date: Mon, 23 Sep 2013 12:14:42 -0600
Message-Id: <1379960083-8942-13-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason this driver thinks that chip->data_buffer needs
to be set before it can call tpm_pm_*. This is not true. data_buffer
is used only by /dev/tpmX, which is why it is managed exclusively
by the fops functions.

Cc: Mathias Leblanc <mathias.leblanc@st.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 8 --------
 drivers/char/tpm/tpm_spi_stm_st33.c | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index cd8c3e3..cb39876 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -770,24 +770,18 @@ static int tpm_st33_i2c_remove(struct i2c_client *client)
 #ifdef CONFIG_PM_SLEEP
 /*
  * tpm_st33_i2c_pm_suspend suspend the TPM device
- * Added: Work around when suspend and no tpm application is running, suspend
- * may fail because chip->data_buffer is not set (only set in tpm_open in Linux
- * TPM core)
  * @param: client, the i2c_client drescription (TPM I2C description).
  * @param: mesg, the power management message.
  * @return: 0 in case of success.
  */
 static int tpm_st33_i2c_pm_suspend(struct device *dev)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct st33zp24_platform_data *pin_infos = dev->platform_data;
 	int ret = 0;
 
 	if (power_mgt) {
 		gpio_set_value(pin_infos->io_lpcpd, 0);
 	} else {
-		if (chip->data_buffer == NULL)
-			chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
 		ret = tpm_pm_suspend(dev);
 	}
 	return ret;
@@ -812,8 +806,6 @@ static int tpm_st33_i2c_pm_resume(struct device *dev)
 					  TPM_STS_VALID) == TPM_STS_VALID,
 					  chip->vendor.timeout_b);
 	} else {
-		if (chip->data_buffer == NULL)
-			chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
 		ret = tpm_pm_resume(dev);
 		if (!ret)
 			tpm_do_selftest(chip);
diff --git a/drivers/char/tpm/tpm_spi_stm_st33.c b/drivers/char/tpm/tpm_spi_stm_st33.c
index 22f6e83..81c61f6 100644
--- a/drivers/char/tpm/tpm_spi_stm_st33.c
+++ b/drivers/char/tpm/tpm_spi_stm_st33.c
@@ -808,22 +808,16 @@ static int tpm_st33_spi_remove(struct spi_device *client)
 #ifdef CONFIG_PM_SLEEP
 /*
  * tpm_st33_spi_pm_suspend suspend the TPM device
- * Added: Work around when suspend and no tpm application is running, suspend
- * may fail because chip->data_buffer is not set (only set in tpm_open in Linux
- * TPM core)
  * @return: 0 in case of success.
  */
 static int tpm_st33_spi_pm_suspend(struct device *dev)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct st33zp24_platform_data *pin_infos = dev->platform_data;
 	int ret = 0;
 
 	if (power_mgt)
 		gpio_set_value(pin_infos->io_lpcpd, 0);
 	else {
-		if (chip->data_buffer == NULL)
-			chip->data_buffer = pin_infos->tpm_spi_buffer[0];
 		ret = tpm_pm_suspend(dev);
 		}
 	return ret;
@@ -847,8 +841,6 @@ static int tpm_st33_spi_pm_resume(struct device *dev)
 					  TPM_STS_VALID) == TPM_STS_VALID,
 					  chip->vendor.timeout_b);
 	} else {
-		if (chip->data_buffer == NULL)
-			chip->data_buffer = pin_infos->tpm_spi_buffer[0];
 		ret = tpm_pm_resume(dev);
 		if (!ret)
 			tpm_do_selftest(chip);
-- 
1.8.1.2

