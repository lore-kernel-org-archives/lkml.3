Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaILBKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 21:10:42 -0400
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:59665
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271AbaILBKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 21:10:40 -0400
From: Peter Chen <Peter.Chen@freescale.com>
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
Subject: RE: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Thread-Topic: [PATCH v4 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Thread-Index: AQHPx0pmMqv14jG3F0CrBo/N1sV+N5v7rX0AgABx4gCAAI0mMA==
Date: Fri, 12 Sep 2014 01:10:33 +0000
Message-ID: <e1957aca004047cd9333ebac74531a65@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-10-git-send-email-antoine.tenart@free-electrons.com>
 <20140911005446.GD3609@peterchendt> <20140911154222.GB11275@kwain>
In-Reply-To: <20140911154222.GB11275@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(24454002)(76482001)(76576001)(2656002)(83322001)(110136001)(21056001)(46102001)(107046002)(64706001)(77982001)(81342001)(79102001)(80022001)(77096002)(66066001)(74662001)(83072002)(74502001)(87936001)(106116001)(81542001)(105586002)(31966008)(106356001)(99396002)(99286002)(95666004)(33646002)(74316001)(50986999)(20776003)(54356999)(97736003)(101416001)(85306004)(85852003)(86362001)(90102001)(92566001)(76176999)(108616004)(93886004)(4396001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0770;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> On Thu, Sep 11, 2014 at 08:54:47AM +0800, Peter Chen wrote:
> > On Wed, Sep 03, 2014 at 09:40:40AM +0200, Antoine Tenart wrote:
> > > @@ -595,23 +639,27 @@ static int ci_hdrc_probe(struct platform_device
> *pdev)
> > >  		return -ENODEV;
> > >  	}
> > >
> > > -	if (ci->platdata->usb_phy)
> > > +	if (ci->platdata->phy)
> > > +		ci->phy = ci->platdata->phy;
> > > +	else if (ci->platdata->usb_phy)
> > >  		ci->usb_phy = ci->platdata->usb_phy;
> > >  	else
> > > -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > +		ci->phy = devm_phy_get(dev, "usb-phy");
> > >
> > > -	if (IS_ERR(ci->usb_phy)) {
> > > -		ret = PTR_ERR(ci->usb_phy);
> > > +	if (IS_ERR(ci->phy) || (ci->phy == NULL && ci->usb_phy == NULL)) {
> > >  		/*
> > >  		 * if -ENXIO is returned, it means PHY layer wasn't
> > >  		 * enabled, so it makes no sense to return -EPROBE_DEFER
> > >  		 * in that case, since no PHY driver will ever probe.
> > >  		 */
> > > -		if (ret == -ENXIO)
> > > -			return ret;
> > > +		if (PTR_ERR(ci->phy) == -ENXIO)
> > > +			return -ENXIO;
> > >
> > > -		dev_err(dev, "no usb2 phy configured\n");
> > > -		return -EPROBE_DEFER;
> > > +		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > +		if (IS_ERR(ci->usb_phy)) {
> > > +			dev_err(dev, "no usb2 phy configured\n");
> > > +			return -EPROBE_DEFER;
> > > +		}
> > >  	}
> >
> > Sorry, I can't accept this change, why devm_usb_get_phy(dev,
> > USB_PHY_TYPE_USB2) is put at error path? Since current get PHY
> > operation is a little complicated, we may have a dedicate function to do it,
> dwc3 driver is a good example.
> 
> It's not the error path, it's the case when there is no PHY from the generic PHY
> framework available. Getting an USB PHY is a fallback solution.
> 
> I agree we can move this to a dedicated function. But even if doing so, we'll
> have to test ci->phy first.
> 
> Or do you have something else in mind?
> 
 
I still want devm_usb_get_phy(dev, USB_PHY_TYPE_USB2) to be called at the same place
like generic_phy, not in later error path, in error path, we only handle error.

Peter
