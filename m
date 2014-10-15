Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaJOJSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:18:11 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33589 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaJOJSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:18:09 -0400
Date: Wed, 15 Oct 2014 14:47:57 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [PATCH] usb: dwc2: gadget: sparse warning of context imbalance
Message-ID: <20141015091757.GA3575@sudip-PC>
References: <1412946579-6805-1-git-send-email-sudipm.mukherjee@gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E225E@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E225E@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 08:55:55PM +0000, Paul Zimmerman wrote:
> > From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> > Sent: Friday, October 10, 2014 6:10 AM
> > 
> > sparse was giving the following warning:
> > 	warning: context imbalance in 's3c_hsotg_ep_enable'
> > 	- different lock contexts for basic block
> > 
> > we were returning ENOMEM while still holding the spinlock.
> > The sparse warning was fixed by releasing the spinlock before return.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  drivers/usb/dwc2/gadget.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > index 7b5856f..046e90d 100644
> > --- a/drivers/usb/dwc2/gadget.c
> > +++ b/drivers/usb/dwc2/gadget.c
> > @@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> >  			hs_ep->fifo_size = val;
> >  			break;
> >  		}
> > -		if (i == 8)
> > +		if (i == 8) {
> > +			spin_unlock_irqrestore(&hsotg->lock, flags);
> >  			return -ENOMEM;
> > +		}
> >  	}
> > 
> >  	/* for non control endpoints, set PID to D0 */
> 
> For a long function like this, I'd rather keep a single return point at
> the end. Something like this:
> 
>  		}
> -		if (i == 8)
> -			return -ENOMEM;
> +		if (i == 8) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
>  	}
> ...
>  
> +out:
>  	spin_unlock_irqrestore(&hsotg->lock, flags);
>  	return ret;
>  }
> 
> Care to respin the patch like that?
> 
sure , modified patch will be in your inbox in a short time. 

thanks
sudip
> -- 
> Paul
> 
