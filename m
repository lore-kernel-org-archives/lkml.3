Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbaGXM0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:26:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47946 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757460AbaGXM0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:26:18 -0400
Date: Thu, 24 Jul 2014 14:25:57 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com, gregkh@linuxfoundation.org, kishon@ti.com,
        stern@rowland.harvard.edu, sergei.shtylyov@cogentembedded.com,
        yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140724122557.GB21062@kwain>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140724113941.GB26984@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140724113941.GB26984@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Jul 24, 2014 at 07:39:42PM +0800, Peter Chen wrote:
> On Tue, Jul 15, 2014 at 04:39:16PM +0200, Antoine Ténart wrote:
> >  
> >  /**
> > + * _ci_usb_phy_init: initialize phy taking in account both phy and usb_phy
> > + * interfaces
> > + * @ci: the controller
> > + *
> > + * This function returns an error code if the phy failed to init
> > + */
> > +static int _ci_usb_phy_init(struct ci_hdrc *ci)
> > +{
> > +	int ret;
> > +
> > +	if (ci->phy) {
> > +		ret = phy_init(ci->phy);
> > +		if (ret) {
> > +			phy_exit(ci->phy);
> 
> If phy_init fails, we still need to call phy_exit?
> 
> > +			return ret;
> > +		}
> > +		ret = phy_power_on(ci->phy);
> 
> If phy_power_on fails, we may need to call phy_exit

Sure, phy_exit() should be moved under the calling to phy_power_on().

> >  
> > -	if (ci->platdata->usb_phy)
> > +	if (ci->platdata->phy)
> > +		ci->phy = ci->platdata->phy;
> > +	else if (ci->platdata->usb_phy)
> >  		ci->usb_phy = ci->platdata->usb_phy;
> >  	else
> > -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > +		ci->phy = of_phy_get(dev->of_node, 0);
> 
> Here, we may need to consider both usb_phy and generic_phy, and
> the core device is not populated from device tree.
> 
> You can use devm_usb_get_phy and devm_phy_get for global phy case.

This is the case. If no PHY is found by of_phy_get() we try to get an
USB PHY by calling devm_usb_get_phy().

> 
> >  
> > -	if (IS_ERR(ci->usb_phy)) {
> > -		ret = PTR_ERR(ci->usb_phy);
> > +	if (IS_ERR(ci->phy)) {
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

[snip]

> > diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> > index d47cddd38e4a..77881a5ce48f 100644
> > --- a/drivers/usb/chipidea/debug.c
> > +++ b/drivers/usb/chipidea/debug.c
> > @@ -219,7 +219,9 @@ int ci_otg_show(struct seq_file *s, void *unused)
> >  	fsm = &ci->fsm;
> >  
> >  	/* ------ State ----- */
> > -		usb_otg_state_string(ci->usb_phy->otg.state));
> > +	if (ci->usb_phy)
> > +		seq_printf(s, "OTG state: %s\n\n",
> > +			usb_otg_state_string(ci->usb_phy->otg->state));
> 
> You may change wrongly here.

I thought a pointer to the OTG info wasn't available from there. I just
checked, and it seems we can retrieve if from the otg_fsm structure
here. I'll test and update.

> > @@ -85,13 +88,16 @@ static int host_start(struct ci_hdrc *ci)
> >  	if (ret) {
> >  		goto disable_reg;
> >  	} else {
> > -		struct usb_otg *otg = ci->usb_phy->otg;
> > +		if (ci->usb_phy) {
> > +			struct usb_otg *otg = ci->usb_phy->otg;
> >  
> > -		ci->hcd = hcd;
> > -		if (otg) {
> > -			otg->host = &hcd->self;
> > -			hcd->self.otg_port = 1;
> > +			if (otg) {
> > +				otg->host = &hcd->self;
> > +				hcd->self.otg_port = 1;
> > +			}
> >  		}
> 
> The otg port is still existed even use generic phy.

Yes. I don't know how to retrieve the OTG pointer when we do not use an
USB PHY. We may have to add an OTG member into the ci_hdrc structure,
but I didn't understand well where does occur this OTG setup.

I may have missed something. Do you know if CI OTG always is in FSM
mode? If so we could access the OTG pointer through ci_hdrc->fsm.

> >  
> >  	if (ci->platdata->flags & CI_HDRC_DISABLE_STREAMING)
> > diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
> > index 8a64ce87364e..2c11f260633c 100644
> > --- a/drivers/usb/chipidea/otg_fsm.c
> > +++ b/drivers/usb/chipidea/otg_fsm.c
> > @@ -788,10 +788,12 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
> >  		return -ENOMEM;
> >  	}
> >  
> > -	otg->usb_phy = ci->usb_phy;
> > +	if (ci->phy)
> > +		otg->phy = ci->phy;
> > +	else
> > +		otg->usb_phy = ci->usb_phy;
> >  	otg->gadget = &ci->gadget;
> >  	ci->fsm.otg = otg;
> > -	ci->usb_phy->otg = ci->fsm.otg;
> 
> Why you remove above line?

It shouldn't be removed as it is, because we still use it in CI. As far
as I know, this is not used in the common OTG code. If we manage to put
the OTG information into the ci_hdrc structure, we could safely remove
this line.

I guess the answer to the previous comment will also fix this :)


Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
