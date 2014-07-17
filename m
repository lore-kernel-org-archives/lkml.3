Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbaGQOtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:49:11 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33797 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968AbaGQOtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:49:07 -0400
From: Bastian Hecht <hechtb@gmail.com>
To: linux-i2c@vger.kernel.org
Cc: Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        Bastian Hecht <hechtb@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Jean Delvare <jdelvare@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andreas Werner <wernerandy@gmx.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/5] i2c: eg20t: Remove suspension check
Date: Thu, 17 Jul 2014 16:48:37 +0200
Message-Id: <1405608520-5644-2-git-send-email-hechtb@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now take care of suspension in the i2c core code. So we can remove this
check here.

Signed-off-by: Bastian Hecht <hechtb@gmail.com>
---
same as v1

 drivers/i2c/busses/i2c-eg20t.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index a44ea13..aae0413 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -162,15 +162,12 @@ struct i2c_algo_pch_data {
  * struct adapter_info - This structure holds the adapter information for the
 			 PCH i2c controller
  * @pch_data:		stores a list of i2c_algo_pch_data
- * @pch_i2c_suspended:	specifies whether the system is suspended or not
- *			perhaps with more lines and words.
  * @ch_num:		specifies the number of i2c instance
  *
  * pch_data has as many elements as maximum I2C channels
  */
 struct adapter_info {
 	struct i2c_algo_pch_data pch_data[PCH_I2C_MAX_DEV];
-	bool pch_i2c_suspended;
 	int ch_num;
 };
 
@@ -677,13 +674,6 @@ static s32 pch_i2c_xfer(struct i2c_adapter *i2c_adap,
 	if (ret)
 		return ret;
 
-	if (adap->p_adapter_info->pch_i2c_suspended) {
-		mutex_unlock(&pch_mutex);
-		return -EBUSY;
-	}
-
-	pch_dbg(adap, "adap->p_adapter_info->pch_i2c_suspended is %d\n",
-		adap->p_adapter_info->pch_i2c_suspended);
 	/* transfer not completed */
 	adap->pch_i2c_xfer_in_progress = true;
 
@@ -786,7 +776,6 @@ static int pch_i2c_probe(struct pci_dev *pdev,
 
 	for (i = 0; i < adap_info->ch_num; i++) {
 		pch_adap = &adap_info->pch_data[i].pch_adapter;
-		adap_info->pch_i2c_suspended = false;
 
 		adap_info->pch_data[i].p_adapter_info = adap_info;
 
@@ -862,8 +851,6 @@ static int pch_i2c_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct adapter_info *adap_info = pci_get_drvdata(pdev);
 	void __iomem *p = adap_info->pch_data[0].pch_base_address;
 
-	adap_info->pch_i2c_suspended = true;
-
 	for (i = 0; i < adap_info->ch_num; i++) {
 		while ((adap_info->pch_data[i].pch_i2c_xfer_in_progress)) {
 			/* Wait until all channel transfers are completed */
@@ -912,8 +899,6 @@ static int pch_i2c_resume(struct pci_dev *pdev)
 	for (i = 0; i < adap_info->ch_num; i++)
 		pch_i2c_init(&adap_info->pch_data[i]);
 
-	adap_info->pch_i2c_suspended = false;
-
 	return 0;
 }
 #else
-- 
1.9.1

