Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3ETPle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:41:34 -0400
Received: from smtp-out-219.synserver.de ([212.40.185.219]:1081 "EHLO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752024Ab3ETPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:41:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17363
From: Lars-Peter Clausen <lars@metafoo.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] drivers/rtc/rtc-pl031.c: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 17:41:11 +0200
Message-Id: <1369064471-30613-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() expects the same pointer that was passed to request_irq(), otherwise
the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/rtc/rtc-pl031.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 8900ea7..0f0609b 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -306,7 +306,7 @@ static int pl031_remove(struct amba_device *adev)
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);
 
 	amba_set_drvdata(adev, NULL);
-	free_irq(adev->irq[0], ldata->rtc);
+	free_irq(adev->irq[0], ldata);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
 	kfree(ldata);
-- 
1.8.0

