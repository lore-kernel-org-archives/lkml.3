Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3CKBld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:41:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:55199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3CKBlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,819,1355126400"; 
   d="scan'208";a="299519656"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Li, Fei" <fei.li@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>
Subject: RE: [PATCH] pm: print the name of failed suspend function for
 platform device
Thread-Topic: [PATCH] pm: print the name of failed suspend function for
 platform device
Thread-Index: AQHOA1+2yq2QFiWxoU21cM2hUaCfK5if6wOQ
Date: Mon, 11 Mar 2013 01:41:28 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A254DD3@SHSMSX101.ccr.corp.intel.com>
References: <1360041183.15311.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
In-Reply-To: <1360041183.15311.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2B1fXF9004862

Hi Greg,

I just noticed some other cases need the more log also.
https://lkml.org/lkml/2013/3/8/71

Could you consider the below patch, thanks?

Best Regards
Liu chuansheng

> -----Original Message-----
> From: Li, Fei
> Sent: Tuesday, February 05, 2013 1:13 PM
> To: gregkh@linuxfoundation.org; rjw@sisk.pl; akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; Liu, Chuansheng; Li, Fei
> Subject: [PATCH] pm: print the name of failed suspend function for platform
> device
> 
> 
> Print more info when platform device suspend function failed.
> Without this patch, we can not get the real platform device suspend
> API info.
> 
> Example without this patch:
> pm_op(): platform_pm_suspend+0x0/0x50 returns -11
> PM: Device power.0 failed to suspend: error -11
> 
> And with this patch:
> platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
> pm_op(): platform_pm_suspend+0x0/0x80 returns -11
> PM: Device power.0 failed to suspend: error -11
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  drivers/base/platform.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index c0b8df3..96a452a 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -747,8 +747,10 @@ static int platform_legacy_suspend(struct device
> *dev, pm_message_t mesg)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	int ret = 0;
> 
> -	if (dev->driver && pdrv->suspend)
> +	if (dev->driver && pdrv->suspend) {
>  		ret = pdrv->suspend(pdev, mesg);
> +		suspend_report_result(pdrv->suspend, ret);
> +	}
> 
>  	return ret;
>  }
> @@ -778,10 +780,13 @@ int platform_pm_suspend(struct device *dev)
>  		return 0;
> 
>  	if (drv->pm) {
> -		if (drv->pm->suspend)
> +		if (drv->pm->suspend) {
>  			ret = drv->pm->suspend(dev);
> +			suspend_report_result(drv->pm->suspend, ret);
> +		}
>  	} else {
>  		ret = platform_legacy_suspend(dev, PMSG_SUSPEND);
> +		suspend_report_result(platform_legacy_suspend, ret);
>  	}
> 
>  	return ret;
> @@ -818,10 +823,13 @@ int platform_pm_freeze(struct device *dev)
>  		return 0;
> 
>  	if (drv->pm) {
> -		if (drv->pm->freeze)
> +		if (drv->pm->freeze) {
>  			ret = drv->pm->freeze(dev);
> +			suspend_report_result(drv->pm->freeze, ret);
> +		}
>  	} else {
>  		ret = platform_legacy_suspend(dev, PMSG_FREEZE);
> +		suspend_report_result(platform_legacy_suspend, ret);
>  	}
> 
>  	return ret;
> @@ -854,10 +862,13 @@ int platform_pm_poweroff(struct device *dev)
>  		return 0;
> 
>  	if (drv->pm) {
> -		if (drv->pm->poweroff)
> +		if (drv->pm->poweroff) {
>  			ret = drv->pm->poweroff(dev);
> +			suspend_report_result(drv->pm->poweroff, ret);
> +		}
>  	} else {
>  		ret = platform_legacy_suspend(dev, PMSG_HIBERNATE);
> +		suspend_report_result(platform_legacy_suspend, ret);
>  	}
> 
>  	return ret;
> --
> 1.7.4.1
> 
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
