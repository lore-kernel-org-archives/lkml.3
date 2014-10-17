Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaJQTFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:05:22 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:48553 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJQTFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:05:20 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Thread-Topic: [PATCH v3 1/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Thread-Index: AQHP6cUIzDwuGd1Mj0WTmj6cZd6Hnpw0oliAgAB2X4D//4sekA==
Date: Fri, 17 Oct 2014 19:05:19 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E34A6@US01WEMBX2.internal.synopsys.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E345C@US01WEMBX2.internal.synopsys.com>
 <20141017185209.GY26260@saruman>
In-Reply-To: <20141017185209.GY26260@saruman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Friday, October 17, 2014 11:52 AM
> 
> On Fri, Oct 17, 2014 at 06:50:19PM +0000, Paul Zimmerman wrote:
> > > From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> > > Sent: Thursday, October 16, 2014 9:44 PM
> > >
> > > sparse was giving the following warning:
> > >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > > 	                - different lock contexts for basic block
> > >
> > > we were returning ENOMEM while still holding the spinlock.
> > > The sparse warning was fixed by releasing the spinlock before return.
> > >
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > ---
> > >  drivers/usb/dwc2/gadget.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > > index 7b5856f..7f25527 100644
> > > --- a/drivers/usb/dwc2/gadget.c
> > > +++ b/drivers/usb/dwc2/gadget.c
> > > @@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> > >  			hs_ep->fifo_size = val;
> > >  			break;
> > >  		}
> > > -		if (i == 8)
> > > -			return -ENOMEM;
> > > +		if (i == 8) {
> > > +			ret = -ENOMEM;
> > > +			goto error;
> > > +		}
> > >  	}
> > >
> > >  	/* for non control endpoints, set PID to D0 */
> > > @@ -2579,6 +2581,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> > >  	/* enable the endpoint interrupt */
> > >  	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
> > >
> > > +error:
> > >  	spin_unlock_irqrestore(&hsotg->lock, flags);
> > >  	return ret;
> > >  }
> >
> > Acked-by: Paul Zimmerman <paulz@synopsys.com>
> 
> v3.18-rc or v3.19 ?

v3.18-rc, since it's a bugfix. And I forgot, this should be marked for
3.17 stable too.

-- 
Paul

