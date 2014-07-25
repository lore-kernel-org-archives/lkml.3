Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbaGYIWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:22:48 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:6517
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbaGYIWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:22:44 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: =?iso-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHPoM+g9rJqVrp5SkK+NRByw9cq15uwoguA///bVQCAAAP18A==
Date: Fri, 25 Jul 2014 08:22:40 +0000
Message-ID: <055ba866a1ac4d9385360bf51ab73f80@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140725021853.GA11052@shlinux1.ap.freescale.net>
 <20140725080738.GA9756@kwain>
In-Reply-To: <20140725080738.GA9756@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(24454002)(107046002)(86362001)(85306003)(20776003)(74662001)(81542001)(31966008)(81342001)(21056001)(101416001)(77096002)(92566001)(99396002)(83072002)(110136001)(85852003)(33646002)(74502001)(66066001)(76176999)(76482001)(54356999)(50986999)(106356001)(87936001)(46102001)(93886003)(76576001)(77982001)(4396001)(80022001)(64706001)(74316001)(99286002)(79102001)(105586002)(2656002)(95666004)(106116001)(83322001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0769;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> On Fri, Jul 25, 2014 at 10:18:54AM +0800, Peter Chen wrote:
> > On Wed, Jul 16, 2014 at 10:26:01AM +0200, Antoine Ténart wrote:
> > > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock and
> > > DMA mask, to support USB2 ChipIdea controllers that don't need
> > > specific functions.
> >
> > You may need to indicate it is a generic usb2 glue layer driver at
> > both subject and context.
> 
> "USB2 ChipIdea driver for ci13xxx" seemed quite generic to me.
> 

ok

> > >
> > > Needed for the Marvell Berlin SoCs USB controllers.
> >
> > You can say it is tested at Marvell Berlin SoCs USB controllers.
> 
> Ok, I'll explicitly say it.
> 
> > > +
> > > +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> > > +				    struct ci_hdrc_platform_data *ci_pdata,
> > > +				    struct ci_hdrc_usb2_priv *priv) {
> > > +	u32 mask;
> > > +	int ret;
> > > +
> > > +	priv->clk = devm_clk_get(dev, NULL);
> > > +	if (!IS_ERR(priv->clk)) {
> > > +		ret = clk_prepare_enable(priv->clk);
> > > +		if (ret) {
> > > +			dev_err(dev, "failed to enable the clock: %d\n", ret);
> > > +			return ret;
> > > +		}
> > > +	}
> >
> > The clk API may be needed for both DT and non-DT cases.
> 
> Yes sure, I'll move this to the ci_hdrc_usb2_probe().
> 
 
> > > +
> > > +	if (of_property_read_u32(dev->of_node, "dma-mask", &mask))
> > > +		priv->dma_mask = mask;
> > > +
> > According to discussion, you may not need dma_mask in driver any more,
> > and use below API for both DT and non-DT case.
> >
> >         err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> >         if (err)
> >         	                handle error;
> 
> This would only be needed in non-dt cases, as the DMA mask is configured
> in drivers/of/platform.c otherwise.
> 
 
Get it, thanks.

Peter
