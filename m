Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3CLTA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:00:56 -0400
Received: from smtp-out-044.synserver.de ([212.40.185.44]:1044 "EHLO
	smtp-out-039.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932470Ab3CLTAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:00:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10785
Message-ID: <513F7BD2.5040800@metafoo.de>
Date: Tue, 12 Mar 2013 20:02:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: da903x_bl: switch to using SIMPLE_DEV_PM_OPS
References: <003d01ce1ee5$316a57c0$943f0740$%han@samsung.com>
In-Reply-To: <003d01ce1ee5$316a57c0$943f0740$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 06:48 AM, Jingoo Han wrote:
> This reduces #ifdefs in the code. Also, CONFIG_PM_SLEEP is used
> to avoid warnings of unused functions if CONFIG_PM_SLEEP is not
> defined.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

I think you can eliminate the suspend/resume functions all together by using
the blacklight subsystems CORE_SUSPENDRESUME feature.

E.g.

diff --git a/drivers/video/backlight/da903x_bl.c
b/drivers/video/backlight/da903x_bl.c
index 8179cef..80ba6b3 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -88,6 +88,9 @@ static int da903x_backlight_update_status(struct
 	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
 		brightness = 0;

+	if (bl->props.state & BL_CORE_SUSPENDED)
+		brightness = 0;
+
 	return da903x_backlight_set(bl, brightness);
 }

@@ -100,6 +103,7 @@ static int da903x_backlight_get_brightness(struct
 static const struct backlight_ops da903x_backlight_ops = {
 	.update_status	= da903x_backlight_update_status,
 	.get_brightness	= da903x_backlight_get_brightness,
+	.options	= BL_CORE_SUSPENDRESUME,
 };

 static int da903x_backlight_probe(struct platform_device *pdev)
@@ -161,35 +165,10 @@ static int da903x_backlight_remove(struct
 	return 0;
 }

-#ifdef CONFIG_PM
-static int da903x_backlight_suspend(struct device *dev)
-{
-	struct backlight_device *bl = dev_get_drvdata(dev);
-
-	return da903x_backlight_set(bl, 0);
-}
-
-static int da903x_backlight_resume(struct device *dev)
-{
-	struct backlight_device *bl = dev_get_drvdata(dev);
-
-	backlight_update_status(bl);
-	return 0;
-}
-
-static const struct dev_pm_ops da903x_backlight_pm_ops = {
-	.suspend	= da903x_backlight_suspend,
-	.resume		= da903x_backlight_resume,
-};
-#endif
-
 static struct platform_driver da903x_backlight_driver = {
 	.driver		= {
 		.name	= "da903x-backlight",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
-		.pm	= &da903x_backlight_pm_ops,
-#endif
 	},
 	.probe		= da903x_backlight_probe,
 	.remove		= da903x_backlight_remove,
