Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3CAAiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:38:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:20654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab3CAAiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:38:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="scan'208";a="262889678"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, "Li, Fei" <fei.li@intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFZMb6/3FwJCIKUGVv/+y/WGnrJiO3A8AgAEh+oA=
Date: Fri, 1 Mar 2013 00:38:07 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A24253F@SHSMSX101.ccr.corp.intel.com>
References: <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <Pine.LNX.4.44L0.1302281015330.1352-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302281015330.1352-100000@iolanthe.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, February 28, 2013 11:17 PM
> To: Li, Fei
> Cc: gregkh@linuxfoundation.org; Lan, Tianyu; sarah.a.sharp@linux.intel.com;
> rjw@sisk.pl; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Liu,
> Chuansheng
> Subject: Re: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
> pm_runtime_get_sync failed case
> 
> On Thu, 28 Feb 2013, Li Fei wrote:
> 
> >
> > Even in failed case of pm_runtime_get_sync, the usage_count
> > is incremented. In order to keep the usage_count with correct
> > value and runtime power management to behave correctly, call
> > pm_runtime_put(_sync) in such case.
> >
> > Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> > Signed-off-by: Li Fei <fei.li@intel.com>
> > ---
> >  drivers/usb/core/hub.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index 5480352..f72dede 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -3148,12 +3148,13 @@ int usb_port_resume(struct usb_device *udev,
> pm_message_t msg)
> >
> >  	if (port_dev->did_runtime_put) {
> >  		status = pm_runtime_get_sync(&port_dev->dev);
> > -		port_dev->did_runtime_put = false;
> >  		if (status < 0) {
> >  			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
> >  					status);
> > +			pm_runtime_put_sync(&port_dev->dev);
> >  			return status;
> >  		}
> > +		port_dev->did_runtime_put = false;
> >  	}
> 
> I don't see much point in this.  After a failed resume, the port's
> runtime PM status is undefined.  Whether or not you do a
> pm_runtime_put_sync won't make any difference.
In case of failed resume, calling pm_runtime_put_sync() is just for decrease the dev->power.usage_count,
because pm_runtime_get_sync() always increase the dev->power.usage_count even failed.

If not pairing runtime_get/put, after that case, the device can not enter runtime suspend any more due to dev->power.usage_count > 0 always.
Is it making sense?

Thanks.
> 
> Alan Stern

