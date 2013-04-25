Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3DYHHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:07:50 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45356 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYHHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:07:49 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 15:07:47 +0800
Message-ID: <CAPgLHd9-Ji3TaH9iFGt7d0R3rtQMkbmMvYQnSwwcehEn1=qP5g@mail.gmail.com>
Subject: [PATCH] tpm_tis: missing platform_driver_unregister() on error in init_tis()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: key@linux.vnet.ibm.com, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com
Cc: yongjun_wei@trendmicro.com.cn, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing platform_driver_unregister() before return
from init_tis() in the device register error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/char/tpm/tpm_tis.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 8a41b6b..2f777a4 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -884,13 +884,20 @@ static int __init init_tis(void)
 	rc = platform_driver_register(&tis_drv);
 	if (rc < 0)
 		return rc;
-	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
-		return PTR_ERR(pdev);
-	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
-		platform_device_unregister(pdev);
-		platform_driver_unregister(&tis_drv);
+	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		rc = PTR_ERR(pdev);
+		goto err_dev;
 	}
-	return rc;
+	rc = tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0);
+	if (rc)
+		goto err_init;
+	return 0;
+err_init:
+	platform_device_unregister(pdev);
+err_dev:
+	platform_driver_unregister(&tis_drv);
+	return rc;
 }
 
 static void __exit cleanup_tis(void)

