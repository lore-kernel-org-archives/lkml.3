Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaIYIak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:30:40 -0400
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:45891
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750977AbaIYIae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:30:34 -0400
Date: Thu, 25 Sep 2014 16:29:41 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: ls1021a: add gating clocks to IP blocks.
Message-ID: <20140925082940.GF6405@dragon>
References: <1411366160-42685-1-git-send-email-Li.Xiubo@freescale.com>
 <20140922070037.GR3755@pengutronix.de>
 <e7a0fe3cbe4c4ed0bcc489853a392f35@BY2PR0301MB0613.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e7a0fe3cbe4c4ed0bcc489853a392f35@BY2PR0301MB0613.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SINPR01CA009.apcprd01.prod.exchangelabs.com (10.242.48.19)
 To BY2PR03MB346.namprd03.prod.outlook.com (10.141.139.15)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB346;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(51704005)(199003)(97756001)(85306004)(46102003)(42186005)(92726001)(102836001)(95666004)(107046002)(85852003)(66066001)(21056001)(33656002)(83072002)(81342003)(46406003)(74502003)(110136001)(90102001)(97736003)(50466002)(80022003)(92566001)(101416001)(76176999)(79102003)(64706001)(83506001)(81542003)(77096002)(76482002)(105586002)(47776003)(20776003)(106356001)(87976001)(74662003)(33716001)(54356999)(4396001)(23726002)(77982003)(86362001)(99396003)(10300001)(83322001)(31966008)(120916001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB346;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB128;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:55:14PM +0800, Xiubo Li-B47053 wrote:
> > > +static void __init ls1021a_clocks_init(struct device_node *np)
> > > +{
> > > +	void __iomem *dcfg_base;
> > > +
> > > +#define DCFG_CCSR_DEVDISR1	(dcfg_base + 0x70)
> > > +#define DCFG_CCSR_DEVDISR2	(dcfg_base + 0x74)
> > > +#define DCFG_CCSR_DEVDISR3	(dcfg_base + 0x78)
> > > +#define DCFG_CCSR_DEVDISR4	(dcfg_base + 0x7c)
> > > +#define DCFG_CCSR_DEVDISR5	(dcfg_base + 0x80)
> > > +
> > > +	dcfg_base = of_iomap(np, 0);
> > > +
> > > +	BUG_ON(!dcfg_base);
> > Is this worth a BUG? 
> Yes, I do think so.
> 
> There is one story about my platform:
> We are using the imx2_wdt watchdog device, which cannot stop or suspend
> once it has started.
> And our platform will also support the Power Management, if the gating
> Clock initialized failed, so when the system enters sleep mode, we cannot
> Stop the imx2_wdt IP block, so it will reset the board after 180 seconds at
> most.
> 
> So using this gating clock, the watchdog IP block's clock could be disabled
> When the system enter sleep mode.
> 
> So I think BUG_ON here is make sense.
>  
> Doesn't it ?
> 
> > Or is it enough to do
> > 	if (!dcfg_base) {
> > 		pr_warn("failed to map fsl,ls1021a-gate device\n");
> > 		return
> > 	}
> > 
> > > +
> > > +	clk[LS1021A_CLK_PBL_EN] = ls1021a_clk_gate("pbl_en", "dummy",
> > > +						DCFG_CCSR_DEVDISR1, 0, true);
> > If the machine's device tree contains two (or more) nodes that are
> > compatible to "fsl,ls1021a-gate", you overwrite your static clk array. Is
> > it worth to add another check here?:
> > 
> On LS1021A SoC, I can make sure that there will only be one gate node. But for
> More compatibly using one dynamic clk array will be better.

I do not think it's really necessary to use dynamic allocation.  Making
dcfg_base a static variable and check if it's null at the beginning of
the function is probably enough.

Shawn
