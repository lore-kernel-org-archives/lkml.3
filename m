Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3FNQV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:21:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3FNQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:21:54 -0400
Date: Fri, 14 Jun 2013 09:22:31 -0700
From: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Fernando Soto <fsoto@bluecatnetworks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Message-ID: <20130614162231.GA14829@kroah.com>
References: <88E08D85EE353144A618C55479FE1117411FD9A9@TORMBXW01.bluecatnetworks.corp>
 <21ce39ca10234c2fae6f98b029d86b5c@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21ce39ca10234c2fae6f98b029d86b5c@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 02:13:44AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Fernando Soto [mailto:fsoto@bluecatnetworks.com]
> > Sent: Thursday, June 13, 2013 8:11 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: KY Srinivasan; Haiyang Zhang
> > Subject: [PATCH] Drivers: hv: vmbus: incorrect device name is printed when child
> > device is unregistered
> > 
> > From: Fernando Soto <fsoto@bluecatnetworks.com>
> > Please CC me, I am not subscribed to the list.
> > 
> > Whenever a device is unregistered in vmbus_device_unregister
> > (drivers/hv/vmbus_drv.c), the device name in the log message may contain
> > garbage as the memory has already been freed by the time pr_info is called. Log
> > example:
> >  [ 3149.170475] hv_vmbus: child device ахsии0_5 unregistered
> > 
> > By logging the message just before calling device_unregister, the correct device
> > name is printed:
> > [ 3145.034652] hv_vmbus: child device vmbus_0_5 unregistered
> > 
> > Signed-off-by: Fernando M Soto <fsoto@bluecatnetworks.com>
> Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> > --- linux-3.10-rc5/drivers/hv/vmbus_drv.c.orig	2013-06-13 19:20:55.359511352 -
> > 0400
> > +++ linux-3.10-rc5/drivers/hv/vmbus_drv.c	2013-06-13 19:21:39.299511695 -
> > 0400
> > @@ -698,14 +698,14 @@ int vmbus_device_register(struct hv_devi
> >   */
> >  void vmbus_device_unregister(struct hv_device *device_obj)
> >  {
> > +	pr_info("child device %s unregistered\n",
> > +		dev_name(&device_obj->device));
> > +
> >  	/*
> >  	 * Kick off the process of unregistering the device.
> >  	 * This will call vmbus_remove() and eventually vmbus_device_release()
> >  	 */
> >  	device_unregister(&device_obj->device);
> > -
> > -	pr_info("child device %s unregistered\n",
> > -		dev_name(&device_obj->device));

No, please just remove these entirely, or make them pr_debug(), you
shouldn't clutter up the kernel log for stuff like this.

thanks,

greg k-h
