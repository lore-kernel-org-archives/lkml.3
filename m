Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043AbaGYAep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:34:45 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:40329
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934872AbaGYAen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:34:43 -0400
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
Thread-Index: AQHPoDqYz1sPbv1cX0qBxRYCBd3s2ZuvrZCA//+G0YCAAMQ40A==
Date: Fri, 25 Jul 2014 00:34:39 +0000
Message-ID: <76c0b6bc5b7f477998462d8b48d96272@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140724113941.GB26984@shlinux1.ap.freescale.net>
 <20140724122557.GB21062@kwain>
In-Reply-To: <20140724122557.GB21062@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(199002)(74662001)(20776003)(19580395003)(83072002)(110136001)(76576001)(83322001)(50986999)(46102001)(19580405001)(99286002)(85306003)(92566001)(95666004)(64706001)(77982001)(81542001)(86362001)(76482001)(106116001)(66066001)(4396001)(81342001)(74316001)(79102001)(54356999)(93886003)(87936001)(101416001)(74502001)(2656002)(76176999)(99396002)(85852003)(105586002)(107046002)(77096002)(80022001)(21056001)(106356001)(31966008)(33646002)(41533002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > >
> > > -	if (ci->platdata->usb_phy)
> > > +	if (ci->platdata->phy)
> > > +		ci->phy = ci->platdata->phy;
> > > +	else if (ci->platdata->usb_phy)
> > >  		ci->usb_phy = ci->platdata->usb_phy;
> > >  	else
> > > -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> > > +		ci->phy = of_phy_get(dev->of_node, 0);
> >
> > Here, we may need to consider both usb_phy and generic_phy, and the
> > core device is not populated from device tree.
> >
> > You can use devm_usb_get_phy and devm_phy_get for global phy case.
> 
> This is the case. If no PHY is found by of_phy_get() we try to get an USB
> PHY by calling devm_usb_get_phy().
> 

Like I said above, the core device is not populated from DT, so the DT version
phy API may not be needed. 

> >
> > >
> > > -	if (IS_ERR(ci->usb_phy)) {
> > > -		ret = PTR_ERR(ci->usb_phy);
> > > +	if (IS_ERR(ci->phy)) {
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
> 
> [snip]
> 
> > > diff --git a/drivers/usb/chipidea/debug.c
> > > b/drivers/usb/chipidea/debug.c index d47cddd38e4a..77881a5ce48f
> > > 100644
> > > --- a/drivers/usb/chipidea/debug.c
> > > +++ b/drivers/usb/chipidea/debug.c
> > > @@ -219,7 +219,9 @@ int ci_otg_show(struct seq_file *s, void *unused)
> > >  	fsm = &ci->fsm;
> > >
> > >  	/* ------ State ----- */
> > > -		usb_otg_state_string(ci->usb_phy->otg.state));
> > > +	if (ci->usb_phy)
> > > +		seq_printf(s, "OTG state: %s\n\n",
> > > +			usb_otg_state_string(ci->usb_phy->otg->state));
> >
> > You may change wrongly here.
> 
> I thought a pointer to the OTG info wasn't available from there. I just
> checked, and it seems we can retrieve if from the otg_fsm structure here.
> I'll test and update.
> 
> > > @@ -85,13 +88,16 @@ static int host_start(struct ci_hdrc *ci)
> > >  	if (ret) {
> > >  		goto disable_reg;
> > >  	} else {
> > > -		struct usb_otg *otg = ci->usb_phy->otg;
> > > +		if (ci->usb_phy) {
> > > +			struct usb_otg *otg = ci->usb_phy->otg;
> > >
> > > -		ci->hcd = hcd;
> > > -		if (otg) {
> > > -			otg->host = &hcd->self;
> > > -			hcd->self.otg_port = 1;
> > > +			if (otg) {
> > > +				otg->host = &hcd->self;
> > > +				hcd->self.otg_port = 1;
> > > +			}
> > >  		}
> >
> > The otg port is still existed even use generic phy.
> 
> Yes. I don't know how to retrieve the OTG pointer when we do not use an
> USB PHY. We may have to add an OTG member into the ci_hdrc structure, but
> I didn't understand well where does occur this OTG setup.
> 
> I may have missed something. Do you know if CI OTG always is in FSM mode?
> If so we could access the OTG pointer through ci_hdrc->fsm.
> 

Just add OTG member into ci_hdrc structure, see below patch

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 9563cb5..186fb3f 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -207,6 +207,7 @@ struct ci_hdrc {
        bool                            id_event;
        bool                            b_sess_valid_event;
        bool                            imx28_write_fix;
+       struct usb_otg                  otg;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index a93d950..70d7fe2 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
        if (ret) {
                goto disable_reg;
        } else {
-               struct usb_otg *otg = ci->transceiver->otg;
+               struct usb_otg *otg = &ci->otg;
 
                ci->hcd = hcd;
                if (otg) {
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 8cb2508..fc8847e 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -778,20 +778,8 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
 int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 {
        int retval = 0;
-       struct usb_otg *otg;
 
-       otg = devm_kzalloc(ci->dev,
-                       sizeof(struct usb_otg), GFP_KERNEL);
-       if (!otg) {
-               dev_err(ci->dev,
-               "Failed to allocate usb_otg structure for ci hdrc otg!\n");
-               return -ENOMEM;
-       }
-
-       otg->phy = ci->transceiver;
-       otg->gadget = &ci->gadget;
-       ci->fsm.otg = otg;
-       ci->transceiver->otg = ci->fsm.otg;
+       ci->fsm.otg = &ci->otg;
        ci->fsm.power_up = 1;
        ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
        ci->fsm.otg->state = OTG_STATE_UNDEFINED;
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 33d3480..b2f7587 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -14,7 +14,6 @@
 struct usb_otg {
        u8                      default_a;
 
-       struct usb_phy          *phy;
        struct usb_bus          *host;
        struct usb_gadget       *gadget;
 
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index ac7d791..b732541 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -79,8 +79,6 @@ struct usb_phy {
        enum usb_phy_type       type;
        enum usb_phy_events     last_event;
 
-       struct usb_otg          *otg;
-
        struct device           *io_dev;
        struct usb_phy_io_ops   *io_ops;
        void __iomem            *io_priv;
b29397@shlinux1:~/work/projects/upstream/usb/usb$ git diff > a.diff
b29397@shlinux1:~/work/projects/upstream/usb/usb$ cat a.diff
diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 9563cb5..186fb3f 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -207,6 +207,7 @@ struct ci_hdrc {
 	bool				id_event;
 	bool				b_sess_valid_event;
 	bool				imx28_write_fix;
+	struct usb_otg			otg;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index a93d950..70d7fe2 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
 	if (ret) {
 		goto disable_reg;
 	} else {
-		struct usb_otg *otg = ci->transceiver->otg;
+		struct usb_otg *otg = &ci->otg;
 
 		ci->hcd = hcd;
 		if (otg) {
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 8cb2508..fc8847e 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -778,20 +778,8 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
 int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 {
 	int retval = 0;
-	struct usb_otg *otg;
 
-	otg = devm_kzalloc(ci->dev,
-			sizeof(struct usb_otg), GFP_KERNEL);
-	if (!otg) {
-		dev_err(ci->dev,
-		"Failed to allocate usb_otg structure for ci hdrc otg!\n");
-		return -ENOMEM;
-	}
-
-	otg->phy = ci->transceiver;
-	otg->gadget = &ci->gadget;
-	ci->fsm.otg = otg;
-	ci->transceiver->otg = ci->fsm.otg;
+	ci->fsm.otg = &ci->otg;
 	ci->fsm.power_up = 1;
 	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
 	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 33d3480..b2f7587 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -14,7 +14,6 @@
 struct usb_otg {
 	u8			default_a;
 
-	struct usb_phy		*phy;
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
 
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index ac7d791..b732541 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -79,8 +79,6 @@ struct usb_phy {
 	enum usb_phy_type	type;
 	enum usb_phy_events	last_event;
 
-	struct usb_otg		*otg;
-
 	struct device		*io_dev;
 	struct usb_phy_io_ops	*io_ops;
 	void __iomem		*io_priv;


Peter
