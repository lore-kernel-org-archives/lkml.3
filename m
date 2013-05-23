Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab3EWPaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:30:04 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41232 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496Ab3EWPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/16] mfd: ab3100-otp: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:04 +0100
Message-Id: <1369322717-30429-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab3100-otp.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index d7ce016..c9af16c 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -187,7 +187,7 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 	int err = 0;
 	int i;
 
-	otp = kzalloc(sizeof(struct ab3100_otp), GFP_KERNEL);
+	otp = devm_kzalloc(&pdev->dev, sizeof(struct ab3100_otp), GFP_KERNEL);
 	if (!otp) {
 		dev_err(&pdev->dev, "could not allocate AB3100 OTP device\n");
 		return -ENOMEM;
@@ -199,7 +199,7 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 
 	err = ab3100_otp_read(otp);
 	if (err)
-		goto err_otp_read;
+		return err;
 
 	dev_info(&pdev->dev, "AB3100 OTP readout registered\n");
 
@@ -208,22 +208,19 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 		err = device_create_file(&pdev->dev,
 					 &ab3100_otp_attrs[i]);
 		if (err)
-			goto err_create_file;
+			goto err;
 	}
 
 	/* debugfs entries */
 	err = ab3100_otp_init_debugfs(&pdev->dev, otp);
 	if (err)
-		goto err_init_debugfs;
+		goto err;
 
 	return 0;
 
-err_init_debugfs:
-err_create_file:
+err:
 	while (--i >= 0)
 		device_remove_file(&pdev->dev, &ab3100_otp_attrs[i]);
-err_otp_read:
-	kfree(otp);
 	return err;
 }
 
@@ -236,7 +233,6 @@ static int __exit ab3100_otp_remove(struct platform_device *pdev)
 		device_remove_file(&pdev->dev,
 				   &ab3100_otp_attrs[i]);
 	ab3100_otp_exit_debugfs(otp);
-	kfree(otp);
 	return 0;
 }
 
-- 
1.7.10.4

