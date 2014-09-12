Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaILJ2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:28:43 -0400
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:14963
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751131AbaILJ1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:27:24 -0400
Date: Fri, 12 Sep 2014 17:27:13 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "yoshihiro.shimoda.uh@renesas.com" <yoshihiro.shimoda.uh@renesas.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140912092711.GA2463@peterchendt>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-10-git-send-email-antoine.tenart@free-electrons.com>
 <20140911005446.GD3609@peterchendt> <20140911154222.GB11275@kwain>
 <e1957aca004047cd9333ebac74531a65@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20140912082125.GA18774@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140912082125.GA18774@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(33656002)(102836001)(99396002)(83072002)(26826002)(92566001)(68736004)(76176999)(110136001)(4396001)(95666004)(79102001)(44976005)(54356999)(23726002)(57986006)(50986999)(86362001)(85852003)(97756001)(81542001)(92726001)(87936001)(6806004)(83506001)(85306004)(83322001)(76482001)(84676001)(104016003)(46102001)(93886004)(97736003)(90102001)(81342001)(33716001)(74662001)(77982001)(80022001)(47776003)(31966008)(20776003)(64706001)(46406003)(50466002)(105606002)(21056001)(107046002)(74502001)(106466001)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1203;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:21:25AM +0200, Antoine Tenart wrote:
> Peter,
> 
> On Fri, Sep 12, 2014 at 01:10:33AM +0000, Peter Chen wrote:
> > > On Thu, Sep 11, 2014 at 08:54:47AM +0800, Peter Chen wrote:
> > > > On Wed, Sep 03, 2014 at 09:40:40AM +0200, Antoine Tenart wrote:
> > > > > @@ -595,23 +639,27 @@ static int ci_hdrc_probe(struct platform_device
> > > *pdev)
> > > > >  		return -ENODEV;
> > > > >  	}
> > > > >
> > > > > -	if (ci->platdata->usb_phy)
> > > > > +	if (ci->platdata->phy)
> > > > > +		ci->phy = ci->platdata->phy;
> > > > > +	else if (ci->platdata->usb_phy)
> > > > >  		ci->usb_phy = ci->platdata->usb_phy;
> > > > >  	else
> > > > > -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > > > +		ci->phy = devm_phy_get(dev, "usb-phy");
> > > > >
> > > > > -	if (IS_ERR(ci->usb_phy)) {
> > > > > -		ret = PTR_ERR(ci->usb_phy);
> > > > > +	if (IS_ERR(ci->phy) || (ci->phy == NULL && ci->usb_phy == NULL)) {
> > > > >  		/*
> > > > >  		 * if -ENXIO is returned, it means PHY layer wasn't
> > > > >  		 * enabled, so it makes no sense to return -EPROBE_DEFER
> > > > >  		 * in that case, since no PHY driver will ever probe.
> > > > >  		 */
> > > > > -		if (ret == -ENXIO)
> > > > > -			return ret;
> > > > > +		if (PTR_ERR(ci->phy) == -ENXIO)
> > > > > +			return -ENXIO;
> > > > >
> > > > > -		dev_err(dev, "no usb2 phy configured\n");
> > > > > -		return -EPROBE_DEFER;
> > > > > +		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > > > +		if (IS_ERR(ci->usb_phy)) {
> > > > > +			dev_err(dev, "no usb2 phy configured\n");
> > > > > +			return -EPROBE_DEFER;
> > > > > +		}
> > > > >  	}
> > > >
> > > > Sorry, I can't accept this change, why devm_usb_get_phy(dev,
> > > > USB_PHY_TYPE_USB2) is put at error path? Since current get PHY
> > > > operation is a little complicated, we may have a dedicate function to do it,
> > > dwc3 driver is a good example.
> > > 
> > > It's not the error path, it's the case when there is no PHY from the generic PHY
> > > framework available. Getting an USB PHY is a fallback solution.
> > > 
> > > I agree we can move this to a dedicated function. But even if doing so, we'll
> > > have to test ci->phy first.
> > > 
> > > Or do you have something else in mind?
> > > 
> >  
> > I still want devm_usb_get_phy(dev, USB_PHY_TYPE_USB2) to be called at the same place
> > like generic_phy, not in later error path, in error path, we only handle error.
> 
> Would this fit you?
> 
> if (ci->platdata->phy)
>         ci->phy = ci->platdata->phy;
> else if (ci->platdata->usb_phy)
>         ci->usb_phy = ci->platdata->usb_phy;
> 
> if (ci->phy == NULL && ci->usb_phy == NULL) {

You should use else if here.

>         ci->phy = devm_phy_get(dev, "usb-phy");
>         ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> 
>         /* if both generic PHY and USB PHY layers aren't enabled */
>         if (PTR_ERR(ci->phy) == -ENOSYS && PTR_ERR(ci->usb_phy) == -ENXIO)
>                 return -ENXIO;
> 
>         if (IS_ERR(ci->phy) && IS_ERR(ci->usb_phy))
>                 return -EPROBE_DEFER;
> 
>         /* if an usb_phy is available, but no phy is there */
>         if (PTR_ERR(ci->phy) == -ENODEV)
>                 ci->phy = NULL;
	if (ci->phy)
		ci->usb_phy = NULL;
	if (ci->usb_phy)
		ci->phy = NULL;

How about above?


-- 
Best Regards,
Peter Chen
