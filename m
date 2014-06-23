Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaFWIrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:47:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56386 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaFWIrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:47:46 -0400
Date: Mon, 23 Jun 2014 09:47:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Obsolete Bug in file drivers/mfd/pcf50633-core.c
Message-ID: <20140623084741.GC8847@lee--X1>
References: <CAPDOMVj1C=ELSrV7fT0PdW+Kxpu6CN+y3TNzbfhH1rzt7uLGnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDOMVj1C=ELSrV7fT0PdW+Kxpu6CN+y3TNzbfhH1rzt7uLGnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Nick Krause wrote:
> There seems to be a obsolete bug in this file that has been reported about
> a NULL
> check for  platform_device_add_data() in function pcf50633_probe(). This
> bug seems
> to be fixed by the lines I wrote in my comment on Bugzilla. The attached
> link should
> give you an idea of if closing this bug is a good idea.
>  https://bugzilla.kernel.org/show_bug.cgi?id=78521
> <https://bugzilla.kernel.org/show_bug.cgi?id=78521>
> Thanks Nick

This bug was fixed by Alan Cox 2 years ago:

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
