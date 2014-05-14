Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaEMNpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:45:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:42666 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760534AbaEMNpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:45:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="510901150"
Date: Tue, 13 May 2014 21:45:51 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, liping.zhou@intel.com,
        david.a.cohen@linux.intel.com
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Message-ID: <20140514014551.GA16153@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140507215344.GH19925@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507215344.GH19925@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,

Do you have any comment for this patch?

Thanks
Jincan

On Wed, May 07, 2014 at 05:53:44PM -0400, Zhuang Jin Can wrote:
> A delayed status request may be queued before composite framework returns
> USB_GADGET_DELAYED_STATUS, because the thread queueing the request can run
> on a different core in parallel with the control request irq.
> 
> SETUP XferComplete IRQ        		fsg_main_thread
> ----------------------        		---------------
> 	|					|
> spin_lock_irqsave(&dwc->lock)               sleeping
> 	|					|
> 	...					...
> dwc3_ep0_inspect_setup()			|
> 	|					|
> dwc3_ep0_delegate_req() 			|
> 	|					|
> 	...					|
> spin_unlock(&dwc->lock);			|
> 	|					|
> fsg_set_alt()   ======> Signal Wakeup ====>	|
> 	| 					|
> other gadgets->set_alt() 	       handle exception
> 	|					|
> 	|			usb_composite_setup_continue()
> 	|					|
> 	|			spin_lock_irqsave(&dwc->lock)
>   	|			     __dwc3_gadget_ep0_queue()
> 	|				 delay_status is false
> 	|			spin_unlock_irqrestore(&dwc->lock)
> 	|					|
> 	|				     sleeping
> spin_lock(&dwc->lock); 				|
> 	|					|
> delayed_status=true				|
> 	|					|
> 
> 		STATUS XferNotReady IRQ
> 		------------------------
> 			|
> 		dwc3_ep0_xfernotready()
> 			|
> 		   delayed_status is true, return;
> 
> The result is the status packet will never be transferred, and
> delayed_status is not cleared.
> 
> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> Reported-by: Zhou Liping <liping.zhou@intel.com>
> ---
>  drivers/usb/dwc3/ep0.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
> index 21a3520..07292c0 100644
> --- a/drivers/usb/dwc3/ep0.c
> +++ b/drivers/usb/dwc3/ep0.c
> @@ -1020,7 +1020,11 @@ static void dwc3_ep0_xfernotready(struct dwc3 *dwc,
>  		if (dwc->delayed_status) {
>  			WARN_ON_ONCE(event->endpoint_number != 1);
>  			dev_vdbg(dwc->dev, "Mass Storage delayed status\n");
> -			return;
> +
> +			if (list_empty(&dwc->eps[0]->request_list))
> +				return;
> +			else
> +				dwc->delayed_status = false;
>  		}
>  
>  		dwc3_ep0_do_control_status(dwc, event);
> -- 
