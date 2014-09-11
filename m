Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaIKPma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:42:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47640 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932070AbaIKPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:42:26 -0400
Date: Thu, 11 Sep 2014 17:42:22 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, kishon@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140911154222.GB11275@kwain>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-10-git-send-email-antoine.tenart@free-electrons.com>
 <20140911005446.GD3609@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140911005446.GD3609@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Thu, Sep 11, 2014 at 08:54:47AM +0800, Peter Chen wrote:
> On Wed, Sep 03, 2014 at 09:40:40AM +0200, Antoine Tenart wrote:
> > @@ -595,23 +639,27 @@ static int ci_hdrc_probe(struct platform_device *pdev)
> >  		return -ENODEV;
> >  	}
> >  
> > -	if (ci->platdata->usb_phy)
> > +	if (ci->platdata->phy)
> > +		ci->phy = ci->platdata->phy;
> > +	else if (ci->platdata->usb_phy)
> >  		ci->usb_phy = ci->platdata->usb_phy;
> >  	else
> > -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > +		ci->phy = devm_phy_get(dev, "usb-phy");
> >  
> > -	if (IS_ERR(ci->usb_phy)) {
> > -		ret = PTR_ERR(ci->usb_phy);
> > +	if (IS_ERR(ci->phy) || (ci->phy == NULL && ci->usb_phy == NULL)) {
> >  		/*
> >  		 * if -ENXIO is returned, it means PHY layer wasn't
> >  		 * enabled, so it makes no sense to return -EPROBE_DEFER
> >  		 * in that case, since no PHY driver will ever probe.
> >  		 */
> > -		if (ret == -ENXIO)
> > -			return ret;
> > +		if (PTR_ERR(ci->phy) == -ENXIO)
> > +			return -ENXIO;
> >  
> > -		dev_err(dev, "no usb2 phy configured\n");
> > -		return -EPROBE_DEFER;
> > +		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > +		if (IS_ERR(ci->usb_phy)) {
> > +			dev_err(dev, "no usb2 phy configured\n");
> > +			return -EPROBE_DEFER;
> > +		}
> >  	}
> 
> Sorry, I can't accept this change, why devm_usb_get_phy(dev, USB_PHY_TYPE_USB2)
> is put at error path? Since current get PHY operation is a little complicated,
> we may have a dedicate function to do it, dwc3 driver is a good example.

It's not the error path, it's the case when there is no PHY from the
generic PHY framework available. Getting an USB PHY is a fallback
solution.

I agree we can move this to a dedicated function. But even if doing so,
we'll have to test ci->phy first.

Or do you have something else in mind?

> > diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> > index 5a7ea93011dd..999e9d683d7a 100644
> > --- a/drivers/usb/chipidea/debug.c
> > +++ b/drivers/usb/chipidea/debug.c
> > @@ -219,7 +219,8 @@ static int ci_otg_show(struct seq_file *s, void *unused)
> >  	fsm = &ci->fsm;
> >  
> >  	/* ------ State ----- */
> > -		usb_otg_state_string(ci->usb_phy->otg.state));
> > +	seq_printf(s, "OTG state: %s\n\n",
> > +		   usb_otg_state_string(ci->otg.state));
> 
> Again, rebase error?

Yes, sorry about that. This will be fixed in the next version of this
series.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
