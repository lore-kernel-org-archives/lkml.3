Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbaISHRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:17:08 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:52086 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbaISHRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:17:07 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: peterhuewe@gmx.de, ashley@ashleylai.com, tpmdd@selhorst.net
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kiran.padwal21@gmail.com, Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] char: tpm: Add missing error check for devm_kzalloc
Date: Fri, 19 Sep 2014 12:44:39 +0530
Message-Id: <1411110879-4106-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently these driver are missing a check on the return value of devm_kzalloc,
which would cause a NULL pointer dereference in a OOM situation.

This patch adds a missing check for tpm_i2c_atmel.c and tpm_i2c_nuvoton.c

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/char/tpm/tpm_i2c_atmel.c   |    4 ++++
 drivers/char/tpm/tpm_i2c_nuvoton.c |    5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 7727292..503a85a 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -168,6 +168,10 @@ static int i2c_atmel_probe(struct i2c_client *client,
 
 	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
 					 GFP_KERNEL);
+	if (!chip->vendor.priv) {
+		rc = -ENOMEM;
+		goto out_err;
+	}
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 7b158ef..23c7b13 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -538,6 +538,11 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 
 	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
 					 GFP_KERNEL);
+	if (!chip->vendor.priv) {
+		rc = -ENOMEM;
+		goto out_err;
+	}
+
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
 
-- 
1.7.9.5

