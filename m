Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3EBLlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:41:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30898 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3EBLlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:41:50 -0400
Message-ID: <51825086.3010205@huawei.com>
Date: Thu, 2 May 2013 19:39:50 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <key@linux.vnet.ibm.com>, <mail@srajiv.net>, <tpmdd@selhorst.net>,
        <tpmdd@sirrix.com>
CC: <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] tpm_tis: fix missing platform_driver_unregister
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add missing unregister tis_drv after register pdev fail

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/char/tpm/tpm_tis.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 8a41b6b..d5b0af4 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -884,8 +884,11 @@ static int __init init_tis(void)
 	rc = platform_driver_register(&tis_drv);
 	if (rc < 0)
 		return rc;
-	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
-		return PTR_ERR(pdev);
+	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
+	if (IS_ERR(pdev) {
+	    platform_driver_unregister(&tis_drv);
+	    return PTR_ERR(pdev);
+	}
 	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
 		platform_device_unregister(pdev);
 		platform_driver_unregister(&tis_drv);
-- 
1.7.1

