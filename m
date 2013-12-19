Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3LSGGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:06:46 -0500
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:51226
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab3LSGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:06:44 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z579ehz98dI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MY1I4U-07-8M1-02
X-M-MSG: 
Date: Thu, 19 Dec 2013 13:46:51 +0800
From: Huang Rui <ray.huang@amd.com>
To: Roger Quadros <rogerq@ti.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] usb: usbtest: Always clear halt else further tests
 will fail
Message-ID: <20131219054651.GD19091@hr-dev.amd.com>
References: <1387361411-15139-1-git-send-email-rogerq@ti.com>
 <1387361411-15139-2-git-send-email-rogerq@ti.com>
 <20131219040146.GC19091@hr-dev.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131219040146.GC19091@hr-dev.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:01:47PM +0800, Huang Rui wrote:
> On Wed, Dec 18, 2013 at 03:40:11PM +0530, Roger Quadros wrote:
> > In test_halt() we set an endpoint halt condition and return on halt verification
> > failure, then the enpoint will remain halted and all further tests related
                      ^^^^^^^
> > to that enpoint will fail. This is because we don't tackle endpoint halt error condition
            ^^^^^^^
BTW, please fix these typo.

Thanks,
Rui

> > in any of the tests. To avoid that situation, make sure to clear the
> > halt condition before exiting test_halt().
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> Acked-by: Huang Rui <ray.huang@amd.com>
> 
> > ---
> >  drivers/usb/misc/usbtest.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
> > index 6294e1b..300b726 100644
> > --- a/drivers/usb/misc/usbtest.c
> > +++ b/drivers/usb/misc/usbtest.c
> > @@ -1545,8 +1545,17 @@ static int test_halt(struct usbtest_dev *tdev, int ep, struct urb *urb)
> >  		return retval;
> >  	}
> >  	retval = verify_halted(tdev, ep, urb);
> > -	if (retval < 0)
> > +	if (retval < 0) {
> > +		int ret;
> > +
> > +		/* clear halt anyways, else further tests will fail */
> > +		ret = usb_clear_halt(urb->dev, urb->pipe);
> > +		if (ret)
> > +			ERROR(tdev, "ep %02x couldn't clear halt, %d\n",
> > +			      ep, ret);
> > +
> >  		return retval;
> > +	}
> >  
> >  	/* clear halt (tests API + protocol), verify it worked */
> >  	retval = usb_clear_halt(urb->dev, urb->pipe);
> > -- 
> > 1.8.3.2
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

