Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIVHzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:55:21 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:24800
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753217AbaIVHzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:55:18 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Shengchao Guo <Shawn.Guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Topic: [PATCH v2] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Index: AQHP1ivP6iPjbz3fVkqnPQX8I2eld5wMuXuAgAAGPDA=
Date: Mon, 22 Sep 2014 07:55:14 +0000
Message-ID: <e7a0fe3cbe4c4ed0bcc489853a392f35@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411366160-42685-1-git-send-email-Li.Xiubo@freescale.com>
 <20140922070037.GR3755@pengutronix.de>
In-Reply-To: <20140922070037.GR3755@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(64706001)(66066001)(85852003)(95666004)(76482002)(15975445006)(90102001)(77096002)(74662003)(101416001)(86362001)(46102003)(107046002)(120916001)(85306004)(74502003)(76576001)(110136001)(81542003)(108616004)(79102003)(21056001)(105586002)(99286002)(92566001)(31966008)(106356001)(2656002)(20776003)(83322001)(19580395003)(77982003)(76176999)(50986999)(74316001)(99396002)(87936001)(54356999)(83072002)(4396001)(97736003)(15202345003)(81342003)(80022003)(33646002)(106116001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


[...]
> > +++ b/arch/arm/mach-imx/clk-ls1021a.c
> > @@ -0,0 +1,124 @@
> > +/*
> > + * Copyright 2014 Freescale Semiconductor, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> This empty line can be removed.
> 
Okay.

[...]
> > +static void __init ls1021a_clocks_init(struct device_node *np)
> > +{
> > +	void __iomem *dcfg_base;
> > +
> > +#define DCFG_CCSR_DEVDISR1	(dcfg_base + 0x70)
> > +#define DCFG_CCSR_DEVDISR2	(dcfg_base + 0x74)
> > +#define DCFG_CCSR_DEVDISR3	(dcfg_base + 0x78)
> > +#define DCFG_CCSR_DEVDISR4	(dcfg_base + 0x7c)
> > +#define DCFG_CCSR_DEVDISR5	(dcfg_base + 0x80)
> > +
> > +	dcfg_base = of_iomap(np, 0);
> > +
> > +	BUG_ON(!dcfg_base);
> Is this worth a BUG? 
Yes, I do think so.

There is one story about my platform:
We are using the imx2_wdt watchdog device, which cannot stop or suspend
once it has started.
And our platform will also support the Power Management, if the gating
Clock initialized failed, so when the system enters sleep mode, we cannot
Stop the imx2_wdt IP block, so it will reset the board after 180 seconds at
most.

So using this gating clock, the watchdog IP block's clock could be disabled
When the system enter sleep mode.

So I think BUG_ON here is make sense.
 
Doesn't it ?

> Or is it enough to do
> 	if (!dcfg_base) {
> 		pr_warn("failed to map fsl,ls1021a-gate device\n");
> 		return
> 	}
> 
> > +
> > +	clk[LS1021A_CLK_PBL_EN] = ls1021a_clk_gate("pbl_en", "dummy",
> > +						DCFG_CCSR_DEVDISR1, 0, true);
> If the machine's device tree contains two (or more) nodes that are
> compatible to "fsl,ls1021a-gate", you overwrite your static clk array. Is
> it worth to add another check here?:
> 
On LS1021A SoC, I can make sure that there will only be one gate node. But for
More compatibly using one dynamic clk array will be better.

> 	if (clk[LS1021A_CLK_PBL_EN]) {
> 		pr_warn("only a single instance of fsl,ls1021a-gate supported\n");
> 		return;
> 	}
> 
> (Is it a valid case that ls1021a_clk_gate returns NULL? In this case the
> condition above is wrong.)

Yes, maybe.

I'll have a check of these.

[...]
> > +	clk[LS1021A_CLK_FLEXCAN1_EN] = ls1021a_clk_gate("flexcan1_en", "dummy",
> > +						DCFG_CCSR_DEVDISR5, 12, true);
> > +	clk[LS1021A_CLK_FLEXCAN234_EN] = ls1021a_clk_gate("flexcan234_en",
> > +					"dummy", DCFG_CCSR_DEVDISR5, 13, true);
> > +	/* For flextiemr 2/3/4/5/6/7/8 */
> s/tiemr/timer/
> 
Yes.

[...]
> > +	clk[LS1021A_CLK_FLEXTIMER1_EN] = ls1021a_clk_gate("flextimer1_en",
> > +					"dummy", DCFG_CCSR_DEVDISR5, 31, true);
> > +
> > +	/* Add the clocks to provider list */
> > +	clk_data.clks = clk;
> > +	clk_data.clk_num = ARRAY_SIZE(clk);
> These two could be initialised statically.
> 
Yes, I will use LS1021A_CLK_END instead of ARRAY_SIZE(clk).

> > +	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> > +}
> > +CLK_OF_DECLARE(ls1021a, "fsl,ls1021a-gate", ls1021a_clocks_init);
> > diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
> > index 4cdf8b6..dd9e369 100644
> > --- a/arch/arm/mach-imx/clk.h
> > +++ b/arch/arm/mach-imx/clk.h
> > @@ -107,6 +107,27 @@ static inline struct clk *imx_clk_gate_dis(const char
> *name, const char *parent,
> >  			shift, CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
> >  }
> >
> > +/* The DCFG registers are in big endian mode on LS1021A SoC */
> > +static inline u8 ls1021a_clk_calculate_shift(u8 shift)
> > +{
> > +	int m, n;
> > +
> > +	m = shift / 8;
> > +	n = shift % 8;
> > +
> > +	return (3 - m) * 8 + n;
> > +}
> > +
> > +static inline struct clk *ls1021a_clk_gate(const char *name, const char
> *parent,
> > +		void __iomem *reg, u8 shift, bool big_endian)
> > +{
> > +	if (big_endian)
> This is always true up to now. Does this change in the future?
Yes.

> If not I
> suggest to drop the parameter. Even if this might change, I would
> prefer:
> 
> 	clk[LS1021A_CLK_FLEXTIMER1_EN] =
> 			ls1021a_clk_gate("flextimer1_en",
> 					 "dummy", DCFG_CCSR_DEVDISR5,
> 					 ls1021a_clk_shift_be(31));
> 
> which is moreover more likely to be optimizable by the compiler.
> But maybe that's only me.
> 
Yes, this looks good to me too.

Thanks very much for your comments.

BRs
Xiubo


> > +		shift = ls1021a_clk_calculate_shift(shift);
> > +
> > +	return clk_register_gate(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
> > +			shift, CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
> > +}
> > +
> >  static inline struct clk *imx_clk_mux(const char *name, void __iomem *reg,
> >  		u8 shift, u8 width, const char **parents, int num_parents)
> >  {
> 
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
