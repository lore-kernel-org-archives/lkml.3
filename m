Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbaGYIdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:33:38 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:14962
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756912AbaGYIdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:33:32 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: =?iso-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
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
Subject: RE: [PATCH v2 8/8] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Thread-Topic: [PATCH v2 8/8] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Thread-Index: AQHPoDqYz1sPbv1cX0qBxRYCBd3s2ZuvrZCA//+G0YCAAMQ40IAAh6uAgAAEyMA=
Date: Fri, 25 Jul 2014 08:33:28 +0000
Message-ID: <2ca1959dbb8c44659e6ec4e0c9426e24@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140724113941.GB26984@shlinux1.ap.freescale.net>
 <20140724122557.GB21062@kwain>
 <76c0b6bc5b7f477998462d8b48d96272@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20140725081349.GB9756@kwain>
In-Reply-To: <20140725081349.GB9756@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(76576001)(93886003)(46102001)(77982001)(50986999)(54356999)(87936001)(106356001)(79102001)(105586002)(99286002)(74316001)(19580405001)(95666004)(83322001)(106116001)(2656002)(4396001)(19580395003)(64706001)(80022001)(31966008)(74662001)(20776003)(81542001)(81342001)(21056001)(107046002)(86362001)(85306003)(85852003)(110136001)(76176999)(76482001)(74502001)(33646002)(66066001)(77096002)(92566001)(101416001)(83072002)(99396002)(108616002)(41533002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0769;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > >
> >
> > Just add OTG member into ci_hdrc structure, see below patch
> >
> > diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> > index 9563cb5..186fb3f 100644
> > --- a/drivers/usb/chipidea/ci.h
> > +++ b/drivers/usb/chipidea/ci.h
> > @@ -207,6 +207,7 @@ struct ci_hdrc {
> >         bool                            id_event;
> >         bool                            b_sess_valid_event;
> >         bool                            imx28_write_fix;
> > +       struct usb_otg                  otg;
> >  };
> >
> >  static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci) diff
> > --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> > index a93d950..70d7fe2 100644
> > --- a/drivers/usb/chipidea/host.c
> > +++ b/drivers/usb/chipidea/host.c
> > @@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
> >         if (ret) {
> >                 goto disable_reg;
> >         } else {
> > -               struct usb_otg *otg = ci->transceiver->otg;
> > +               struct usb_otg *otg = &ci->otg;
> >
> >                 ci->hcd = hcd;
> >                 if (otg) {
> > diff --git a/drivers/usb/chipidea/otg_fsm.c
> > b/drivers/usb/chipidea/otg_fsm.c index 8cb2508..fc8847e 100644
> > --- a/drivers/usb/chipidea/otg_fsm.c
> > +++ b/drivers/usb/chipidea/otg_fsm.c
> > @@ -778,20 +778,8 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
> > int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)  {
> >         int retval = 0;
> > -       struct usb_otg *otg;
> >
> > -       otg = devm_kzalloc(ci->dev,
> > -                       sizeof(struct usb_otg), GFP_KERNEL);
> > -       if (!otg) {
> > -               dev_err(ci->dev,
> > -               "Failed to allocate usb_otg structure for ci hdrc
> otg!\n");
> > -               return -ENOMEM;
> > -       }
> > -
> > -       otg->phy = ci->transceiver;
> > -       otg->gadget = &ci->gadget;
> > -       ci->fsm.otg = otg;
> > -       ci->transceiver->otg = ci->fsm.otg;
> > +       ci->fsm.otg = &ci->otg;
> >         ci->fsm.power_up = 1;
> >         ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
> >         ci->fsm.otg->state = OTG_STATE_UNDEFINED; diff --git
> > a/include/linux/usb/otg.h b/include/linux/usb/otg.h index
> > 33d3480..b2f7587 100644
> > --- a/include/linux/usb/otg.h
> > +++ b/include/linux/usb/otg.h
> > @@ -14,7 +14,6 @@
> >  struct usb_otg {
> >         u8                      default_a;
> >
> > -       struct usb_phy          *phy;
> >         struct usb_bus          *host;
> >         struct usb_gadget       *gadget;
> >
> > diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h index
> > ac7d791..b732541 100644
> > --- a/include/linux/usb/phy.h
> > +++ b/include/linux/usb/phy.h
> > @@ -79,8 +79,6 @@ struct usb_phy {
> >         enum usb_phy_type       type;
> >         enum usb_phy_events     last_event;
> >
> > -       struct usb_otg          *otg;
> > -
> >         struct device           *io_dev;
> >         struct usb_phy_io_ops   *io_ops;
> >         void __iomem            *io_priv;
> > b29397@shlinux1:~/work/projects/upstream/usb/usb$ git diff > a.diff
> > b29397@shlinux1:~/work/projects/upstream/usb/usb$ cat a.diff diff
> > --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h index
> > 9563cb5..186fb3f 100644
> > --- a/drivers/usb/chipidea/ci.h
> > +++ b/drivers/usb/chipidea/ci.h
> > @@ -207,6 +207,7 @@ struct ci_hdrc {
> >  	bool				id_event;
> >  	bool				b_sess_valid_event;
> >  	bool				imx28_write_fix;
> > +	struct usb_otg			otg;
> >  };
> >
> >  static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci) diff
> > --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> > index a93d950..70d7fe2 100644
> > --- a/drivers/usb/chipidea/host.c
> > +++ b/drivers/usb/chipidea/host.c
> > @@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
> >  	if (ret) {
> >  		goto disable_reg;
> >  	} else {
> > -		struct usb_otg *otg = ci->transceiver->otg;
> > +		struct usb_otg *otg = &ci->otg;
> >
> >  		ci->hcd = hcd;
> >  		if (otg) {
> > diff --git a/drivers/usb/chipidea/otg_fsm.c
> > b/drivers/usb/chipidea/otg_fsm.c index 8cb2508..fc8847e 100644
> > --- a/drivers/usb/chipidea/otg_fsm.c
> > +++ b/drivers/usb/chipidea/otg_fsm.c
> > @@ -778,20 +778,8 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
> > int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)  {
> >  	int retval = 0;
> > -	struct usb_otg *otg;
> >
> > -	otg = devm_kzalloc(ci->dev,
> > -			sizeof(struct usb_otg), GFP_KERNEL);
> > -	if (!otg) {
> > -		dev_err(ci->dev,
> > -		"Failed to allocate usb_otg structure for ci hdrc otg!\n");
> > -		return -ENOMEM;
> > -	}
> > -
> > -	otg->phy = ci->transceiver;
> > -	otg->gadget = &ci->gadget;
> > -	ci->fsm.otg = otg;
> > -	ci->transceiver->otg = ci->fsm.otg;
> > +	ci->fsm.otg = &ci->otg;
> >  	ci->fsm.power_up = 1;
> >  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
> >  	ci->fsm.otg->state = OTG_STATE_UNDEFINED; diff --git
> > a/include/linux/usb/otg.h b/include/linux/usb/otg.h index
> > 33d3480..b2f7587 100644
> > --- a/include/linux/usb/otg.h
> > +++ b/include/linux/usb/otg.h
> > @@ -14,7 +14,6 @@
> >  struct usb_otg {
> >  	u8			default_a;
> >
> > -	struct usb_phy		*phy;
> >  	struct usb_bus		*host;
> >  	struct usb_gadget	*gadget;
> >
> > diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h index
> > ac7d791..b732541 100644
> > --- a/include/linux/usb/phy.h
> > +++ b/include/linux/usb/phy.h
> > @@ -79,8 +79,6 @@ struct usb_phy {
> >  	enum usb_phy_type	type;
> >  	enum usb_phy_events	last_event;
> >
> > -	struct usb_otg		*otg;
> > -
> >  	struct device		*io_dev;
> >  	struct usb_phy_io_ops	*io_ops;
> >  	void __iomem		*io_priv;
> 
> Where does the ci->otg setup occurs? It seems to me it's never filled.
> 

Currently, only two fields at struct usb_otg are needed for chipidea, they are:
struct usb_bus          *host;
enum usb_otg_state      state;

They are initialized at:
ci_hdrc_otg_fsm_init and host_start.

Peter
