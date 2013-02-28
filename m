Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3B1JAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:00:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:25446 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3B1JAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:00:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="297078965"
From: "Li, Fei" <fei.li@intel.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH 4/5] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 4/5] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFYmArxInazwNrkapyH/h0ASnj5iObHaAgACK67A=
Date: Thu, 28 Feb 2013 09:00:05 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634407F48@SHSMSX102.ccr.corp.intel.com>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
  <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
  <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <512F1741.60202@intel.com>
In-Reply-To: <512F1741.60202@intel.com>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1S90Ven012679

> -----Original Message-----
> From: Lan, Tianyu
> Sent: Thursday, February 28, 2013 4:37 PM
> To: Li, Fei; stern@rowland.harvard.edu
> Cc: gregkh@linuxfoundation.org; sarah.a.sharp@linux.intel.com; rjw@sisk.pl;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: Re: [PATCH 4/5] usb: call pm_runtime_put_sync in
> pm_runtime_get_sync failed case
> 
> On 2013å¹´02æœˆ28æ—¥ 15:57, Li Fei wrote:
> >
> > Even in failed case of pm_runtime_get_sync, the usage_count
> > is incremented. In order to keep the usage_count with correct
> > value and runtime power management to behave correctly, call
> > pm_runtime_put(_sync) in such case.
> 
> Hi Fei:
> 	It's not necessary. Because the did_runtime_put == true means the
> port's usage count has already been decreased during
> usb_port_suspend().So to keep usage count balance, we should increase
> the usage count in the usb_port_resume() whatever.

Thanks for your reminder.
Sorry, I forget to keep did_runtime_put as false in pm_runtime_get_sync
failed case. I'll submit patch V2 to update it.

> >
> > Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> > Signed-off-by: Li Fei <fei.li@intel.com>
> > ---
> >  drivers/usb/core/hub.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index 5480352..b68493b 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -3152,6 +3152,7 @@ int usb_port_resume(struct usb_device *udev,
> pm_message_t msg)
> >  		if (status < 0) {
> >  			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
> >  					status);
> > +			pm_runtime_put_sync(&port_dev->dev);
> >  			return status;
> >  		}
> >  	}
> >
> Hi Alan:
> 	Further thinking, the device should be disconnected since the port
> can't be resumed and the device will not work normally. Something like
> following. Does this make sense?
> ---
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index d5d3de4..cf36b11 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3170,6 +3170,7 @@ int usb_port_resume(struct usb_device *udev,
> pm_message_t msg)
>                 if (status < 0) {
>                         dev_dbg(&udev->dev, "can't resume usb port,
> status %d\n",
>                                         status);
> +                       hub_port_logical_disconnect(hub, port1);

IMHO, this can't keep the usage_count balance.

Best Regards,
Li Fei 

>                         return status;
>                 }
>         }
> 
> 
> --
> Best regards
> Tianyu Lan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
