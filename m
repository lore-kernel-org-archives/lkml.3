Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3CACIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:08:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:11010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab3CACIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:08:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="scan'208";a="293351475"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Li, Fei" <fei.li@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFZMb6/3FwJCIKUGVv/+y/WGnrJiQFrmA
Date: Fri, 1 Mar 2013 02:07:54 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A24264B@SHSMSX101.ccr.corp.intel.com>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
In-Reply-To: <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2128Gti018432



> -----Original Message-----
> From: Li, Fei
> Sent: Thursday, February 28, 2013 5:06 PM
> To: gregkh@linuxfoundation.org; Lan, Tianyu; stern@rowland.harvard.edu;
> sarah.a.sharp@linux.intel.com
> Cc: rjw@sisk.pl; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Liu,
> Chuansheng; Li, Fei
> Subject: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
> pm_runtime_get_sync failed case
> 
> 
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.
> 
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  drivers/usb/core/hub.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 5480352..f72dede 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3148,12 +3148,13 @@ int usb_port_resume(struct usb_device *udev,
> pm_message_t msg)
> 
>  	if (port_dev->did_runtime_put) {
>  		status = pm_runtime_get_sync(&port_dev->dev);
> -		port_dev->did_runtime_put = false;
>  		if (status < 0) {
>  			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
>  					status);
> +			pm_runtime_put_sync(&port_dev->dev);
Rechecked the usb similar codes, in usb_autoresume_device() and usb_autopm_get_interface(),
when pm_runtime_get_sync() failed, the paired pm_runtime_put_sync() will be called.
Alan and Rafael, is it reasonable to consider this cleanup patch also? Thanks.

>  			return status;
>  		}
> +		port_dev->did_runtime_put = false;
>  	}
> 
>  	/* Skip the initial Clear-Suspend step for a remote wakeup */
> --
> 1.7.4.1
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
