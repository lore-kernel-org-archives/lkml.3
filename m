Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaH2OWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:22:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49338 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbaH2OWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:22:04 -0400
Date: Fri, 29 Aug 2014 16:22:00 +0200
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
Subject: Re: [PATCH v3 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140829142200.GB3848@kwain>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
 <1408722621-3635-10-git-send-email-antoine.tenart@free-electrons.com>
 <20140826104241.GE16758@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826104241.GE16758@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 26, 2014 at 06:42:42PM +0800, Peter Chen wrote:
> On Fri, Aug 22, 2014 at 05:50:20PM +0200, Antoine Ténart wrote:
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
> > +			return ret;
> > +		}
> > +		ret = phy_power_on(ci->phy);
> 
> phy_exit is needed to call after phy_power_on failed

I was pretty sure I made the change. Sorry for the noise, I'll fix that
in the next version.

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
> 
> I am a little puzzled of your above change, if ci->phy == NULL, any chances
> for devm_usb_get_phy(dev, USB_PHY_TYPE_USB2) is invoded?

Right, now that there's two PHY pointers we need to check if ci->phy is
NULL too.

> > diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> > index 5a7ea93011dd..9e9da190a144 100644
> > --- a/drivers/usb/chipidea/debug.c
> > +++ b/drivers/usb/chipidea/debug.c
> > @@ -219,7 +219,9 @@ static int ci_otg_show(struct seq_file *s, void *unused)
> >  	fsm = &ci->fsm;
> >  
> >  	/* ------ State ----- */
> > -		usb_otg_state_string(ci->usb_phy->otg.state));
> > +	if (ci->usb_phy)
> > +		seq_printf(s, "OTG state: %s\n\n",
> 
> Why above line is added? Did you delete wrongly before?

I'll fix that.

> > +			usb_otg_state_string(ci->usb_phy->otg->state));
> >  

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
