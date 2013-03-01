Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3CAA72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:59:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:20514 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3CAA71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:59:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="scan'208";a="262897441"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>, "Li, Fei" <fei.li@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFhXVpfLUIMJT1ESqSqn94PWo1ZiQActg
Date: Fri, 1 Mar 2013 00:59:23 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A24257F@SHSMSX101.ccr.corp.intel.com>
References: <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <Pine.LNX.4.44L0.1302281015330.1352-100000@iolanthe.rowland.org>
 <27240C0AC20F114CBF8149A2696CBE4A24253F@SHSMSX101.ccr.corp.intel.com>
 <35852055.MkFUspWUco@vostro.rjw.lan>
In-Reply-To: <35852055.MkFUspWUco@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r210xT1O018205



> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Friday, March 01, 2013 8:51 AM
> To: Liu, Chuansheng
> Cc: Alan Stern; Li, Fei; gregkh@linuxfoundation.org; Lan, Tianyu;
> sarah.a.sharp@linux.intel.com; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
> pm_runtime_get_sync failed case
> 
> On Friday, March 01, 2013 12:38:07 AM Liu, Chuansheng wrote:
> >
> > > -----Original Message-----
> > > From: Alan Stern [mailto:stern@rowland.harvard.edu]
> > > Sent: Thursday, February 28, 2013 11:17 PM
> > > To: Li, Fei
> > > Cc: gregkh@linuxfoundation.org; Lan, Tianyu;
> sarah.a.sharp@linux.intel.com;
> > > rjw@sisk.pl; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Liu,
> > > Chuansheng
> > > Subject: Re: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
> > > pm_runtime_get_sync failed case
> > >
> > > On Thu, 28 Feb 2013, Li Fei wrote:
> > >
> > > >
> > > > Even in failed case of pm_runtime_get_sync, the usage_count
> > > > is incremented. In order to keep the usage_count with correct
> > > > value and runtime power management to behave correctly, call
> > > > pm_runtime_put(_sync) in such case.
> > > >
> > > > Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> > > > Signed-off-by: Li Fei <fei.li@intel.com>
> > > > ---
> > > >  drivers/usb/core/hub.c |    3 ++-
> > > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > >
> > > > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > > > index 5480352..f72dede 100644
> > > > --- a/drivers/usb/core/hub.c
> > > > +++ b/drivers/usb/core/hub.c
> > > > @@ -3148,12 +3148,13 @@ int usb_port_resume(struct usb_device
> *udev,
> > > pm_message_t msg)
> > > >
> > > >  	if (port_dev->did_runtime_put) {
> > > >  		status = pm_runtime_get_sync(&port_dev->dev);
> > > > -		port_dev->did_runtime_put = false;
> > > >  		if (status < 0) {
> > > >  			dev_dbg(&udev->dev, "can't resume usb port,
> status %d\n",
> > > >  					status);
> > > > +			pm_runtime_put_sync(&port_dev->dev);
> > > >  			return status;
> > > >  		}
> > > > +		port_dev->did_runtime_put = false;
> > > >  	}
> > >
> > > I don't see much point in this.  After a failed resume, the port's
> > > runtime PM status is undefined.  Whether or not you do a
> > > pm_runtime_put_sync won't make any difference.
> > In case of failed resume, calling pm_runtime_put_sync() is just for decrease
> the dev->power.usage_count,
> > because pm_runtime_get_sync() always increase the
> dev->power.usage_count even failed.
> >
> > If not pairing runtime_get/put, after that case, the device can not enter
> runtime suspend any more due to dev->power.usage_count > 0 always.
> > Is it making sense?
> 
> Well, not really.
> 
> Before returning an error code, rpm_callback() assigns that code to
> dev->power.runtime_error and that will effectively disable runtime PM for dev
> going forward anyway.
Thanks your pointing out.
dev->power.runtime_error!=0 will really block the runtime PM resume/suspend to continue.

But in case of rpm_resume return error when dev->power.disable_depth > 0, the dev->power.runtime_error
is not set yet. Is it the case? Thanks your comments again.

And another case is when user called pm_runtime_set_status to clear the runtime_error after dev->power.runtime_error
is set during pm_runtime_get_sync(), the runtime_resume/suspend() can be tried again? But the dev->power.usage_count is still wrong?
Thanks your correction again:)
> 
> Thanks,
> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
