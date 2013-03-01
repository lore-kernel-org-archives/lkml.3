Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3CACXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:23:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:36776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3CACXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:23:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="scan'208";a="292109027"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Li, Fei" <fei.li@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFiKtQmsbZj6sWk6IJpkmCrnN/JiQGvcA
Date: Fri, 1 Mar 2013 02:23:25 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A2426B4@SHSMSX101.ccr.corp.intel.com>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <27240C0AC20F114CBF8149A2696CBE4A24264B@SHSMSX101.ccr.corp.intel.com>
 <1500812.76gqUM2HnU@vostro.rjw.lan>
In-Reply-To: <1500812.76gqUM2HnU@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r212NVEe018469



> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Friday, March 01, 2013 10:22 AM
> To: Liu, Chuansheng
> Cc: Li, Fei; gregkh@linuxfoundation.org; Lan, Tianyu;
> stern@rowland.harvard.edu; sarah.a.sharp@linux.intel.com;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
> pm_runtime_get_sync failed case
> 
> On Friday, March 01, 2013 02:07:54 AM Liu, Chuansheng wrote:
> >
> > > -----Original Message-----
> > > From: Li, Fei
> > > Sent: Thursday, February 28, 2013 5:06 PM
> > > To: gregkh@linuxfoundation.org; Lan, Tianyu; stern@rowland.harvard.edu;
> > > sarah.a.sharp@linux.intel.com
> > > Cc: rjw@sisk.pl; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> Liu,
> > > Chuansheng; Li, Fei
> > > Subject: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
> > > pm_runtime_get_sync failed case
> > >
> > >
> > > Even in failed case of pm_runtime_get_sync, the usage_count
> > > is incremented. In order to keep the usage_count with correct
> > > value and runtime power management to behave correctly, call
> > > pm_runtime_put(_sync) in such case.
> > >
> > > Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> > > Signed-off-by: Li Fei <fei.li@intel.com>
> > > ---
> > >  drivers/usb/core/hub.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > > index 5480352..f72dede 100644
> > > --- a/drivers/usb/core/hub.c
> > > +++ b/drivers/usb/core/hub.c
> > > @@ -3148,12 +3148,13 @@ int usb_port_resume(struct usb_device
> *udev,
> > > pm_message_t msg)
> > >
> > >  	if (port_dev->did_runtime_put) {
> > >  		status = pm_runtime_get_sync(&port_dev->dev);
> > > -		port_dev->did_runtime_put = false;
> > >  		if (status < 0) {
> > >  			dev_dbg(&udev->dev, "can't resume usb port,
> status %d\n",
> > >  					status);
> > > +			pm_runtime_put_sync(&port_dev->dev);
> > Rechecked the usb similar codes, in usb_autoresume_device() and
> usb_autopm_get_interface(),
> > when pm_runtime_get_sync() failed, the paired pm_runtime_put_sync() will
> be called.
> > Alan and Rafael, is it reasonable to consider this cleanup patch also? Thanks.
> 
> You can very well use pm_runtime_put_noidle() here too.  Then, it will
> be kind of clear what it's for.
Thanks. Your advice really express we want to do. Will update the patch soon.

> 
> >
> > >  			return status;
> > >  		}
> > > +		port_dev->did_runtime_put = false;
> > >  	}
> > >
> > >  	/* Skip the initial Clear-Suspend step for a remote wakeup */
> > > --
> > > 1.7.4.1
> 
> Thanks,
> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
