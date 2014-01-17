Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaAQS3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:29:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44978 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaAQS3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:29:43 -0500
Date: Fri, 17 Jan 2014 12:26:50 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] usb: phy: msm: fix compilation errors when
 !CONFIG_PM_SLEEP
Message-ID: <20140117182650.GZ8153@joshc.qualcomm.com>
References: <87lhyemr3y.fsf@linaro.org>
 <1389981531-15539-1-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389981531-15539-1-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 11:58:51AM -0600, Josh Cartwright wrote:
> Both the PM_RUNTIME and PM_SLEEP callbacks call into the common
> msm_otg_{suspend,resume} routines, however these routines are only being
> built when CONFIG_PM_SLEEP.  In addition, msm_otg_{suspend,resume} also
> depends on msm_hsusb_config_vddcx(), which is only built when
> CONFIG_PM_SLEEP.
> 
> Fix the CONFIG_PM_RUNTIME, !CONFIG_PM_SLEEP case by changing the
> preprocessor conditional, and moving msm_hsusb_config_vddcx().
> 
> While we're here, eliminate the CONFIG_PM conditional for setting
> up the dev_pm_ops.
> 
> This address the following errors Russell King has hit doing randconfig
> builds:
> 
> drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_suspend':
> drivers/usb/phy/phy-msm-usb.c:1691:2: error: implicit declaration of function 'msm_otg_suspend'
> drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_resume':
> drivers/usb/phy/phy-msm-usb.c:1699:2: error: implicit declaration of function 'msm_otg_resume'
> 
> Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
> v1->v2: Change conditional to simply CONFIG_PM (thanks ccov and khilman!)
> 
>  drivers/usb/phy/phy-msm-usb.c | 57 ++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index 8546c8d..5b169a7 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
[..]
> @@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
>  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
>  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
>  
> -#ifdef CONFIG_PM_SLEEP
> +#if CONFIG_PM

*sigh*.  This, of course, should have been #ifdef CONFIG_PM.  Fixed
v3 below.

Thanks,

  Josh

-- 8< --
Subject: [PATCH v3] usb: phy: msm: fix compilation errors when !CONFIG_PM_SLEEP

Both the PM_RUNTIME and PM_SLEEP callbacks call into the common
msm_otg_{suspend,resume} routines, however these routines are only being
built when CONFIG_PM_SLEEP.  In addition, msm_otg_{suspend,resume} also
depends on msm_hsusb_config_vddcx(), which is only built when
CONFIG_PM_SLEEP.

Fix the CONFIG_PM_RUNTIME, !CONFIG_PM_SLEEP case by changing the
preprocessor conditional, and moving msm_hsusb_config_vddcx().

While we're here, eliminate the CONFIG_PM conditional for setting
up the dev_pm_ops.

This address the following errors Russell King has hit doing randconfig
builds:

drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_suspend':
drivers/usb/phy/phy-msm-usb.c:1691:2: error: implicit declaration of function 'msm_otg_suspend'
drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_resume':
drivers/usb/phy/phy-msm-usb.c:1699:2: error: implicit declaration of function 'msm_otg_resume'

Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/usb/phy/phy-msm-usb.c | 57 ++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 8546c8d..d204f74 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -159,32 +159,6 @@ put_3p3:
 	return rc;
 }
 
-#ifdef CONFIG_PM_SLEEP
-#define USB_PHY_SUSP_DIG_VOL  500000
-static int msm_hsusb_config_vddcx(int high)
-{
-	int max_vol = USB_PHY_VDD_DIG_VOL_MAX;
-	int min_vol;
-	int ret;
-
-	if (high)
-		min_vol = USB_PHY_VDD_DIG_VOL_MIN;
-	else
-		min_vol = USB_PHY_SUSP_DIG_VOL;
-
-	ret = regulator_set_voltage(hsusb_vddcx, min_vol, max_vol);
-	if (ret) {
-		pr_err("%s: unable to set the voltage for regulator "
-			"HSUSB_VDDCX\n", __func__);
-		return ret;
-	}
-
-	pr_debug("%s: min_vol:%d max_vol:%d\n", __func__, min_vol, max_vol);
-
-	return ret;
-}
-#endif
-
 static int msm_hsusb_ldo_set_mode(int on)
 {
 	int ret = 0;
@@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
 #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
 #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
+
+#define USB_PHY_SUSP_DIG_VOL  500000
+static int msm_hsusb_config_vddcx(int high)
+{
+	int max_vol = USB_PHY_VDD_DIG_VOL_MAX;
+	int min_vol;
+	int ret;
+
+	if (high)
+		min_vol = USB_PHY_VDD_DIG_VOL_MIN;
+	else
+		min_vol = USB_PHY_SUSP_DIG_VOL;
+
+	ret = regulator_set_voltage(hsusb_vddcx, min_vol, max_vol);
+	if (ret) {
+		pr_err("%s: unable to set the voltage for regulator "
+			"HSUSB_VDDCX\n", __func__);
+		return ret;
+	}
+
+	pr_debug("%s: min_vol:%d max_vol:%d\n", __func__, min_vol, max_vol);
+
+	return ret;
+}
+
 static int msm_otg_suspend(struct msm_otg *motg)
 {
 	struct usb_phy *phy = &motg->phy;
@@ -1733,22 +1732,18 @@ static int msm_otg_pm_resume(struct device *dev)
 }
 #endif
 
-#ifdef CONFIG_PM
 static const struct dev_pm_ops msm_otg_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
 	SET_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
 				msm_otg_runtime_idle)
 };
-#endif
 
 static struct platform_driver msm_otg_driver = {
 	.remove = msm_otg_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm = &msm_otg_dev_pm_ops,
-#endif
 	},
 };
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
