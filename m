Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3JVSBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:01:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:55324 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab3JVSBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:01:04 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mathias Leblanc <mathias.leblanc@st.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 07/15] tpm: st33: Remove chip->data_buffer access from this driver
Date: Tue, 22 Oct 2013 20:00:32 +0200
Message-Id: <1382464840-7639-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
References: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:0fTJcSKLodSm2g69kYyOWWhnaZ1704vldMmUapI7T0Y4IVd4llC
 9qB4sK4YG162POL1m2OV/S4BAJ8aqrEXu2TFXLOjhvhLbQhZoEb5Lr9BD2FKHa/4Fynuoi+
 YtV4HFKLGHwXVJdQirT89T4pVRrHmbZFMfmpE5ve1ZCEmGi6q31b2U8wFP2nZLG8j1mN2In
 RC41mm0hUEtK0ZMU9o2Xw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

For some reason this driver thinks that chip->data_buffer needs
to be set before it can call tpm_pm_*. This is not true. data_buffer
is used only by /dev/tpmX, which is why it is managed exclusively
by the fops functions.

Cc: Mathias Leblanc <mathias.leblanc@st.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 1c68d93..b2390b6 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -805,24 +805,18 @@ static int tpm_st33_i2c_remove(struct i2c_client *client)
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
@@ -847,8 +841,6 @@ static int tpm_st33_i2c_pm_resume(struct device *dev)
 					  TPM_STS_VALID) == TPM_STS_VALID,
 					  chip->vendor.timeout_b);
 	} else {
-		if (chip->data_buffer == NULL)
-			chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
 		ret = tpm_pm_resume(dev);
 		if (!ret)
 			tpm_do_selftest(chip);
-- 
1.7.5.4

