Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaILK2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:28:43 -0400
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:60512
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752982AbaILK2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:28:42 -0400
X-Greylist: delayed 120823 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 06:28:41 EDT
Date: Fri, 12 Sep 2014 18:28:29 +0800
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
Message-ID: <20140912102828.GB2463@peterchendt>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-10-git-send-email-antoine.tenart@free-electrons.com>
 <20140911005446.GD3609@peterchendt> <20140911154222.GB11275@kwain>
 <e1957aca004047cd9333ebac74531a65@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20140912082125.GA18774@kwain> <20140912092711.GA2463@peterchendt>
 <20140912093550.GC18774@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140912093550.GC18774@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(24454002)(189002)(83506001)(21056001)(95666004)(106466001)(105606002)(47776003)(80022001)(79102001)(4396001)(57986006)(102836001)(97736003)(90102001)(15975445006)(33656002)(87936001)(16601075003)(84676001)(110136001)(107046002)(20776003)(81542001)(15202345003)(92726001)(83072002)(44976005)(93886004)(74662001)(31966008)(33716001)(6806004)(83322001)(104016003)(76176999)(68736004)(74502001)(19580395003)(50986999)(81342001)(86362001)(77982001)(85306004)(85852003)(26826002)(54356999)(46102001)(23756003)(92566001)(64706001)(76482001)(50466002)(99396002)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1215;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:35:50AM +0200, Antoine Tenart wrote:
> On Fri, Sep 12, 2014 at 05:27:13PM +0800, Peter Chen wrote:
> > On Fri, Sep 12, 2014 at 10:21:25AM +0200, Antoine Tenart wrote:
> > > Peter,
> > > 
> > > On Fri, Sep 12, 2014 at 01:10:33AM +0000, Peter Chen wrote:
> > > > > On Thu, Sep 11, 2014 at 08:54:47AM +0800, Peter Chen wrote:
> > > > > > On Wed, Sep 03, 2014 at 09:40:40AM +0200, Antoine Tenart wrote:
> > > > > > > @@ -595,23 +639,27 @@ static int ci_hdrc_probe(struct platform_device
> > > > > *pdev)
> > > > > > >  		return -ENODEV;
> > > > > > >  	}
> > > > > > >
> > > > > > > -	if (ci->platdata->usb_phy)
> > > > > > > +	if (ci->platdata->phy)
> > > > > > > +		ci->phy = ci->platdata->phy;
> > > > > > > +	else if (ci->platdata->usb_phy)
> > > > > > >  		ci->usb_phy = ci->platdata->usb_phy;
> > > > > > >  	else
> > > > > > > -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > > > > > +		ci->phy = devm_phy_get(dev, "usb-phy");
> > > > > > >
> > > > > > > -	if (IS_ERR(ci->usb_phy)) {
> > > > > > > -		ret = PTR_ERR(ci->usb_phy);
> > > > > > > +	if (IS_ERR(ci->phy) || (ci->phy == NULL && ci->usb_phy == NULL)) {
> > > > > > >  		/*
> > > > > > >  		 * if -ENXIO is returned, it means PHY layer wasn't
> > > > > > >  		 * enabled, so it makes no sense to return -EPROBE_DEFER
> > > > > > >  		 * in that case, since no PHY driver will ever probe.
> > > > > > >  		 */
> > > > > > > -		if (ret == -ENXIO)
> > > > > > > -			return ret;
> > > > > > > +		if (PTR_ERR(ci->phy) == -ENXIO)
> > > > > > > +			return -ENXIO;
> > > > > > >
> > > > > > > -		dev_err(dev, "no usb2 phy configured\n");
> > > > > > > -		return -EPROBE_DEFER;
> > > > > > > +		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > > > > > +		if (IS_ERR(ci->usb_phy)) {
> > > > > > > +			dev_err(dev, "no usb2 phy configured\n");
> > > > > > > +			return -EPROBE_DEFER;
> > > > > > > +		}
> > > > > > >  	}
> > > > > >
> > > > > > Sorry, I can't accept this change, why devm_usb_get_phy(dev,
> > > > > > USB_PHY_TYPE_USB2) is put at error path? Since current get PHY
> > > > > > operation is a little complicated, we may have a dedicate function to do it,
> > > > > dwc3 driver is a good example.
> > > > > 
> > > > > It's not the error path, it's the case when there is no PHY from the generic PHY
> > > > > framework available. Getting an USB PHY is a fallback solution.
> > > > > 
> > > > > I agree we can move this to a dedicated function. But even if doing so, we'll
> > > > > have to test ci->phy first.
> > > > > 
> > > > > Or do you have something else in mind?
> > > > > 
> > > >  
> > > > I still want devm_usb_get_phy(dev, USB_PHY_TYPE_USB2) to be called at the same place
> > > > like generic_phy, not in later error path, in error path, we only handle error.
> > > 
> > > Would this fit you?
> > > 
> > > if (ci->platdata->phy)
> > >         ci->phy = ci->platdata->phy;
> > > else if (ci->platdata->usb_phy)
> > >         ci->usb_phy = ci->platdata->usb_phy;
> > > 
> > > if (ci->phy == NULL && ci->usb_phy == NULL) {
> > 
> > You should use else if here.
> 
> Yes, sure.
> 
> > 
> > >         ci->phy = devm_phy_get(dev, "usb-phy");
> > >         ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > 
> > >         /* if both generic PHY and USB PHY layers aren't enabled */
> > >         if (PTR_ERR(ci->phy) == -ENOSYS && PTR_ERR(ci->usb_phy) == -ENXIO)
> > >                 return -ENXIO;
> > > 
> > >         if (IS_ERR(ci->phy) && IS_ERR(ci->usb_phy))
> > >                 return -EPROBE_DEFER;
> > > 
> > >         /* if an usb_phy is available, but no phy is there */
> > >         if (PTR_ERR(ci->phy) == -ENODEV)
> > >                 ci->phy = NULL;
> > 	if (ci->phy)
> > 		ci->usb_phy = NULL;
> > 	if (ci->usb_phy)
> > 		ci->phy = NULL;
> > 
> > How about above?
> 
> When no PHY or USB PHY is found, -ENODEV is returned. Doing the above
> would always end up having ci->phy and ci->usb_phy being NULL.

When we try to get generic phy, if -ENODEV is returned, the ci->usb_phy
should not be NULL, otherwise, your the second condition will return 
-EPROBE_DEFER, it means when the code goes here, there must be one PHY
is found.

> 
> We could have:
> 
> 	if (IS_ERR(ci->phy))
> 		ci->phy = NULL;
> 	else if (IS_ERR(ci->usb_phy))
> 		ci->usb_phy = NULL;
> 
> 
> Antoine
> 
> -- 
> Antoine Ténart, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

-- 
Best Regards,
Peter Chen
