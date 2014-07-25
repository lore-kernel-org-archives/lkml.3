Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbaGYIiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:38:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53889 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759487AbaGYIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:38:14 -0400
Date: Fri, 25 Jul 2014 10:38:10 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "balbi@ti.com" <balbi@ti.com>,
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
Subject: Re: [PATCH v2 8/8] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140725083810.GC9756@kwain>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140724113941.GB26984@shlinux1.ap.freescale.net>
 <20140724122557.GB21062@kwain>
 <76c0b6bc5b7f477998462d8b48d96272@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20140725081349.GB9756@kwain>
 <2ca1959dbb8c44659e6ec4e0c9426e24@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ca1959dbb8c44659e6ec4e0c9426e24@BN1PR0301MB0772.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 08:33:28AM +0000, Peter Chen wrote:
>  
> > > >
> > >
> > > Just add OTG member into ci_hdrc structure, see below patch
> > >
> > > diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> > > index 9563cb5..186fb3f 100644
> > > --- a/drivers/usb/chipidea/ci.h
> > > +++ b/drivers/usb/chipidea/ci.h
> > > @@ -207,6 +207,7 @@ struct ci_hdrc {
> > >         bool                            id_event;
> > >         bool                            b_sess_valid_event;
> > >         bool                            imx28_write_fix;
> > > +       struct usb_otg                  otg;
> > >  };
> > >
> > >  static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci) diff
> > > --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> > > index a93d950..70d7fe2 100644
> > > --- a/drivers/usb/chipidea/host.c
> > > +++ b/drivers/usb/chipidea/host.c
> > > @@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
> > >         if (ret) {
> > >                 goto disable_reg;
> > >         } else {
> > > -               struct usb_otg *otg = ci->transceiver->otg;
> > > +               struct usb_otg *otg = &ci->otg;
> > >
> > >                 ci->hcd = hcd;
> > >                 if (otg) {
> > > diff --git a/drivers/usb/chipidea/otg_fsm.c
> > > b/drivers/usb/chipidea/otg_fsm.c index 8cb2508..fc8847e 100644
> > > --- a/drivers/usb/chipidea/otg_fsm.c
> > > +++ b/drivers/usb/chipidea/otg_fsm.c
> > > @@ -778,20 +778,8 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
> > > int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)  {
> > >         int retval = 0;
> > > -       struct usb_otg *otg;
> > >
> > > -       otg = devm_kzalloc(ci->dev,
> > > -                       sizeof(struct usb_otg), GFP_KERNEL);
> > > -       if (!otg) {
> > > -               dev_err(ci->dev,
> > > -               "Failed to allocate usb_otg structure for ci hdrc
> > otg!\n");
> > > -               return -ENOMEM;
> > > -       }
> > > -
> > > -       otg->phy = ci->transceiver;
> > > -       otg->gadget = &ci->gadget;
> > > -       ci->fsm.otg = otg;
> > > -       ci->transceiver->otg = ci->fsm.otg;
> > > +       ci->fsm.otg = &ci->otg;
> > >         ci->fsm.power_up = 1;
> > >         ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
> > >         ci->fsm.otg->state = OTG_STATE_UNDEFINED; diff --git
> > > a/include/linux/usb/otg.h b/include/linux/usb/otg.h index
> > > 33d3480..b2f7587 100644
> > > --- a/include/linux/usb/otg.h
> > > +++ b/include/linux/usb/otg.h
> > > @@ -14,7 +14,6 @@
> > >  struct usb_otg {
> > >         u8                      default_a;
> > >
> > > -       struct usb_phy          *phy;
> > >         struct usb_bus          *host;
> > >         struct usb_gadget       *gadget;
> > >
> > > diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h index
> > > ac7d791..b732541 100644
> > > --- a/include/linux/usb/phy.h
> > > +++ b/include/linux/usb/phy.h
> > > @@ -79,8 +79,6 @@ struct usb_phy {
> > >         enum usb_phy_type       type;
> > >         enum usb_phy_events     last_event;
> > >
> > > -       struct usb_otg          *otg;
> > > -
> > >         struct device           *io_dev;
> > >         struct usb_phy_io_ops   *io_ops;
> > >         void __iomem            *io_priv;
> > > b29397@shlinux1:~/work/projects/upstream/usb/usb$ git diff > a.diff
> > > b29397@shlinux1:~/work/projects/upstream/usb/usb$ cat a.diff diff
> > > --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h index
> > > 9563cb5..186fb3f 100644
> > > --- a/drivers/usb/chipidea/ci.h
> > > +++ b/drivers/usb/chipidea/ci.h
> > > @@ -207,6 +207,7 @@ struct ci_hdrc {
> > >  	bool				id_event;
> > >  	bool				b_sess_valid_event;
> > >  	bool				imx28_write_fix;
> > > +	struct usb_otg			otg;
> > >  };
> > >
> > >  static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci) diff
> > > --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> > > index a93d950..70d7fe2 100644
> > > --- a/drivers/usb/chipidea/host.c
> > > +++ b/drivers/usb/chipidea/host.c
> > > @@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
> > >  	if (ret) {
> > >  		goto disable_reg;
> > >  	} else {
> > > -		struct usb_otg *otg = ci->transceiver->otg;
> > > +		struct usb_otg *otg = &ci->otg;
> > >
> > >  		ci->hcd = hcd;
> > >  		if (otg) {
> > > diff --git a/drivers/usb/chipidea/otg_fsm.c
> > > b/drivers/usb/chipidea/otg_fsm.c index 8cb2508..fc8847e 100644
> > > --- a/drivers/usb/chipidea/otg_fsm.c
> > > +++ b/drivers/usb/chipidea/otg_fsm.c
> > > @@ -778,20 +778,8 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
> > > int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)  {
> > >  	int retval = 0;
> > > -	struct usb_otg *otg;
> > >
> > > -	otg = devm_kzalloc(ci->dev,
> > > -			sizeof(struct usb_otg), GFP_KERNEL);
> > > -	if (!otg) {
> > > -		dev_err(ci->dev,
> > > -		"Failed to allocate usb_otg structure for ci hdrc otg!\n");
> > > -		return -ENOMEM;
> > > -	}
> > > -
> > > -	otg->phy = ci->transceiver;
> > > -	otg->gadget = &ci->gadget;
> > > -	ci->fsm.otg = otg;
> > > -	ci->transceiver->otg = ci->fsm.otg;
> > > +	ci->fsm.otg = &ci->otg;
> > >  	ci->fsm.power_up = 1;
> > >  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
> > >  	ci->fsm.otg->state = OTG_STATE_UNDEFINED; diff --git
> > > a/include/linux/usb/otg.h b/include/linux/usb/otg.h index
> > > 33d3480..b2f7587 100644
> > > --- a/include/linux/usb/otg.h
> > > +++ b/include/linux/usb/otg.h
> > > @@ -14,7 +14,6 @@
> > >  struct usb_otg {
> > >  	u8			default_a;
> > >
> > > -	struct usb_phy		*phy;
> > >  	struct usb_bus		*host;
> > >  	struct usb_gadget	*gadget;
> > >
> > > diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h index
> > > ac7d791..b732541 100644
> > > --- a/include/linux/usb/phy.h
> > > +++ b/include/linux/usb/phy.h
> > > @@ -79,8 +79,6 @@ struct usb_phy {
> > >  	enum usb_phy_type	type;
> > >  	enum usb_phy_events	last_event;
> > >
> > > -	struct usb_otg		*otg;
> > > -
> > >  	struct device		*io_dev;
> > >  	struct usb_phy_io_ops	*io_ops;
> > >  	void __iomem		*io_priv;
> > 
> > Where does the ci->otg setup occurs? It seems to me it's never filled.
> > 
> 
> Currently, only two fields at struct usb_otg are needed for chipidea, they are:
> struct usb_bus          *host;
> enum usb_otg_state      state;
> 
> They are initialized at:
> ci_hdrc_otg_fsm_init and host_start.

Ok, I get it. I'll update and add an OTG member into the ci_hdrc
structure.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
