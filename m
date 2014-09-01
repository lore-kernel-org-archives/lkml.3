Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaIABOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:14:00 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:21291
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751429AbaIABN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:13:57 -0400
Date: Mon, 1 Sep 2014 09:13:43 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Message-ID: <20140901011341.GD3854@peterchendt>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
 <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140826102239.GD16758@peterchendt> <20140829142535.GA16609@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140829142535.GA16609@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(51704005)(199003)(81156004)(6806004)(33716001)(79102001)(83506001)(19580395003)(26826002)(105606002)(92726001)(16601075003)(15202345003)(85306004)(99396002)(21056001)(104016003)(85852003)(31966008)(102836001)(74662001)(33656002)(74502001)(15975445006)(87936001)(90102001)(47776003)(57986006)(76176999)(46102001)(83072002)(50986999)(83322001)(76482001)(97736001)(86362001)(64706001)(4396001)(110136001)(44976005)(95666004)(107046002)(81342001)(68736004)(93886004)(106466001)(77982001)(50466002)(20776003)(92566001)(81542001)(84676001)(23756003)(80022001)(69596002)(54356999);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB562;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 04:25:35PM +0200, Antoine Tenart wrote:
> Hi,
> 
> On Tue, Aug 26, 2014 at 06:22:40PM +0800, Peter Chen wrote:
> > On Fri, Aug 22, 2014 at 05:50:19PM +0200, Antoine Ténart wrote:
> > 
> > If the common usb_otg and usb_phy struct still has another's pointer, you
> > may not need to add this patch.
> 
> Except if we want to access the OTG member when not using an USB PHY.

If there is no USB PHY, the probe at core.c will turn error.
> 
> > > diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> > > index 0b67d78dd953..0952d4adfa4c 100644
> > > --- a/drivers/usb/chipidea/host.c
> > > +++ b/drivers/usb/chipidea/host.c
> > > @@ -85,13 +85,11 @@ static int host_start(struct ci_hdrc *ci)
> > >  	if (ret) {
> > >  		goto disable_reg;
> > >  	} else {
> > > -		struct usb_otg *otg = ci->usb_phy->otg;
> > > +		struct usb_otg *otg = &ci->otg;
> > >  
> > >  		ci->hcd = hcd;
> > > -		if (otg) {
> > > -			otg->host = &hcd->self;
> > > -			hcd->self.otg_port = 1;
> > > -		}
> > > +		otg->host = &hcd->self;
> > > +		hcd->self.otg_port = 1;
> > >  	}
> > 
> > You may need use other way to identify if otg is supported or not
> 
> How would you do that?


ci_otg_is_fsm_mode(ci)

> 
> > > -	otg->usb_phy = ci->usb_phy;
> > > -	otg->gadget = &ci->gadget;
> > > -	ci->fsm.otg = otg;
> > > -	ci->usb_phy->otg = ci->fsm.otg;
> > > +	ci->otg.usb_phy = ci->usb_phy;
> > > +	ci->fsm.otg = &ci->otg;
> > >  	ci->fsm.power_up = 1;
> > >  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
> > >  	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
> > 
> > Why otg->gadget and ci->usb_phy->otg initialization are deleted?
> > At least, the parameters of usb_otg_state_string at your 7th patch uses it.
> 
> Sure, I'll fix this
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
