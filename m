Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3AUKPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:15:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3AUKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:51 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 28/33] serial: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:21 +0100
Message-Id: <1358762966-20791-29-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:i6l4gdsjY/RPcr7DFxmHd+WxBA2NNUwwqW5LCfE36BR
 lEY1OgydRvqY4553mYGiu3Qf3xEzkqEhiO2u9GQ0Mf7Zg22ak8
 nhvRw5uvpUwUIPq4S9pzoV2R7CwPH7CZATO0RIpV7QA+7+9YAn
 F+2UvikeHCQJtGr5bC+QyY8cHObnxms2whV34p1AclDw26ODVp
 GnqSiV4vcj/nkSaA7p7sgmqRI6ZuwOGSdw9SSJl4QMZUV3V9iK
 846Qj9PDK+nWRLMjmcsYoHE5pVsCQgl2YIOGyZaLQKwW8MUw3u
 EnJw9N2Fi+UkqTdAec5vJCtKc9fVCd0pqcT0maIcz6mRSKiR/M
 Xovysguq9uZlhCxM80pINW63mhSyh3vrsE5cr1iEZnNqY6DhGr
 rfvlIt1zy3T5Stq7NlFZovPDfVXu0Q+9hQmr2pHbiRAp5XTr60
 dbWlM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/sccnxp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sccnxp.c b/drivers/tty/serial/sccnxp.c
index 418b495..e869eab 100644
--- a/drivers/tty/serial/sccnxp.c
+++ b/drivers/tty/serial/sccnxp.c
@@ -15,6 +15,7 @@
 #define SUPPORT_SYSRQ
 #endif
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/console.h>
@@ -875,10 +876,9 @@ static int sccnxp_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	membase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!membase) {
-		dev_err(&pdev->dev, "Failed to ioremap\n");
-		ret = -EIO;
+	membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(membase)) {
+		ret = PTR_ERR(membase);
 		goto err_out;
 	}
 
-- 
1.8.1.1

