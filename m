Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaIXFLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:11:37 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:41838 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaIXFLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:11:35 -0400
From: Michal Sojka <sojka@merica.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: Re: [PATCH v5 1/3] usb: gadget: Refactor request completion
In-Reply-To: <20140917152801.GD6903@saruman.home>
References: <1410938473-29385-1-git-send-email-sojka@merica.cz> <1410938473-29385-2-git-send-email-sojka@merica.cz> <20140917152801.GD6903@saruman.home>
User-Agent: Notmuch/0.18.1+101~g56b0ff0 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Sep 2014 10:09:22 +0200
Message-ID: <874mvyahcd.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Felipe,

On Wed, Sep 17 2014, Felipe Balbi wrote:
> On Wed, Sep 17, 2014 at 09:21:11AM +0200, Michal Sojka wrote:
>> All USB peripheral controller drivers called completion routines
>> directly. This patch moves the completion call from drivers to
>> usb_gadget_giveback_request(), in order to have a place where common
>> functionality can be added.
>> 
>> All places in drivers/usb/ matching "[-.]complete(" were replaced with a
>> call to usb_gadget_giveback_request(). This was compile-tested with all
>> ARM drivers enabled and runtime-tested for musb.
>> 
>> Signed-off-by: Michal Sojka <sojka@merica.cz>
>> ---
>>  drivers/usb/chipidea/udc.c              |  6 +++---
>>  drivers/usb/dwc2/gadget.c               |  6 +++---
>>  drivers/usb/dwc3/gadget.c               |  2 +-
>>  drivers/usb/gadget/udc/amd5536udc.c     |  2 +-
>>  drivers/usb/gadget/udc/at91_udc.c       |  2 +-
>>  drivers/usb/gadget/udc/atmel_usba_udc.c |  4 ++--
>>  drivers/usb/gadget/udc/bcm63xx_udc.c    |  2 +-
>>  drivers/usb/gadget/udc/dummy_hcd.c      | 10 +++++-----
>>  drivers/usb/gadget/udc/fotg210-udc.c    |  2 +-
>>  drivers/usb/gadget/udc/fsl_qe_udc.c     |  6 +-----
>>  drivers/usb/gadget/udc/fsl_udc_core.c   |  6 ++----
>>  drivers/usb/gadget/udc/fusb300_udc.c    |  2 +-
>>  drivers/usb/gadget/udc/goku_udc.c       |  2 +-
>>  drivers/usb/gadget/udc/gr_udc.c         |  2 +-
>>  drivers/usb/gadget/udc/lpc32xx_udc.c    |  2 +-
>>  drivers/usb/gadget/udc/m66592-udc.c     |  2 +-
>>  drivers/usb/gadget/udc/mv_u3d_core.c    |  8 ++------
>>  drivers/usb/gadget/udc/mv_udc_core.c    |  8 ++------
>>  drivers/usb/gadget/udc/net2272.c        |  2 +-
>>  drivers/usb/gadget/udc/net2280.c        |  2 +-
>>  drivers/usb/gadget/udc/omap_udc.c       |  2 +-
>>  drivers/usb/gadget/udc/pch_udc.c        |  2 +-
>>  drivers/usb/gadget/udc/pxa25x_udc.c     |  2 +-
>>  drivers/usb/gadget/udc/pxa27x_udc.c     |  2 +-
>>  drivers/usb/gadget/udc/r8a66597-udc.c   |  2 +-
>>  drivers/usb/gadget/udc/s3c-hsudc.c      |  3 +--
>>  drivers/usb/gadget/udc/s3c2410_udc.c    |  2 +-
>>  drivers/usb/gadget/udc/udc-core.c       | 19 +++++++++++++++++++
>>  drivers/usb/musb/musb_gadget.c          |  2 +-
>>  drivers/usb/renesas_usbhs/mod_gadget.c  |  2 +-
>>  include/linux/usb/gadget.h              |  8 ++++++++
>
> I would rather split this into several patches, btw. With the
> introduction of usb_gadget_giveback_request() being the first one in the
> series. It's easier to review that way.

This would be no problem.

>> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
>> index b0d9817..29789f1 100644
>> --- a/drivers/usb/gadget/udc/udc-core.c
>> +++ b/drivers/usb/gadget/udc/udc-core.c
>> @@ -106,6 +106,25 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>>  
>>  /* ------------------------------------------------------------------------- */
>>  
>> +/**
>> + * usb_gadget_giveback_request - give the request back to the gadget layer
>> + * Context: in_interrupt()
>> + *
>> + * This is called by device controller drivers in order to return the
>> + * completed request back to the gadget layer.
>> + */
>> +void usb_gadget_giveback_request(struct usb_ep *ep,
>> +		struct usb_request *req)
>> +{
>> +	if (likely(req->complete))
>> +		req->complete(ep, req);
>> +	else
>> +		pr_err("%s : req->complete must not be NULL\n", __func__);
>
> let it Oops. We require ->complete to be valid, if there's any gadget
> driver not setting ->complete, it deserves to oops so we can the
> error.

The Oops was there before, but I removed it because greg k-h didn't want
it. See http://marc.info/?l=linux-usb&m=140917381611947&w=2. Do you
still want the oops here?

-Michal
