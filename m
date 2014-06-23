Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaFWIxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:53:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52837 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaFWIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:53:50 -0400
Date: Mon, 23 Jun 2014 09:53:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: gnomes@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Alan, can you revisit a patch you authored please?
Message-ID: <20140623085345.GD8847@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I'm looking at a patch you wrote which can be foudn below at [1].  Are
you sure it's correct to ignore i.e not return -ENOMEM from
platform_device_add_data() in pcf50633_probe()?  I believe if
platform_device_add_data() returns an error we should
platform_device_put() and return immediately.  Can you tell me if you
agree.  If you don't, would you mind explaining to me why please?

Kind regards,
Lee

[1]
commit 18273c5b463d9f98ef81f1a6217a7f4168dd809a
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Fri Jul 13 16:43:32 2012 +0100

    mfd: Add missing out of memory check for pcf50633
    
    Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44561
    Reported-by: <rucsoftsec@gmail.com>
    Cc: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 29c122b..45ce1fb 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -253,8 +253,13 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
                }
 
                pdev->dev.parent = pcf->dev;
-               platform_device_add_data(pdev, &pdata->reg_init_data[i],
-                                       sizeof(pdata->reg_init_data[i]));
+               if (platform_device_add_data(pdev, &pdata->reg_init_data[i],
+                                       sizeof(pdata->reg_init_data[i])) < 0) {
+                       platform_device_put(pdev);
+                       dev_err(pcf->dev, "Out of memory for regulator parameters %d\n",
+                                                                       i);
+                       continue;
+               }
                pcf->regulator_pdev[i] = pdev;
 
                platform_device_add(pdev);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
