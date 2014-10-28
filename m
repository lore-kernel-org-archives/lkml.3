Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaJ1QOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:14:49 -0400
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:49373
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbaJ1QOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:14:47 -0400
Date: Tue, 28 Oct 2014 09:14:35 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC v2 1/8] pinctrl: Add driver for Zynq
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
 <1413479495-14206-2-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdaPiXiDegibiaqGdFxApowNEmbG0L4RDJVv-t+xhGBmjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaPiXiDegibiaqGdFxApowNEmbG0L4RDJVv-t+xhGBmjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21058.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <c465a69d1c6e48bca66cc29a1692c13a@BL2FFO11FD015.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(199003)(51704005)(189002)(377424004)(24454002)(377454003)(4396001)(95666004)(19580405001)(19580395003)(77096002)(106466001)(6806004)(85202003)(102836001)(50466002)(85852003)(74316001)(110136001)(47776003)(64706001)(46102003)(80022003)(83506001)(85306004)(23676002)(85182001)(107046002)(44976005)(20776003)(87936001)(92566001)(31966008)(86362001)(76176999)(53416004)(21056001)(50986999)(108616004)(120916001)(54356999)(76482002)(104016003)(107986001)(24736002)(217873001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB029;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB029;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 03:53PM +0100, Linus Walleij wrote:
> On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > changes since RFC:
> >  - use syscon/regmap to access registers in SLCR space
> >  - add pinctrl to zc702 DT
> >  - rebase to 3.18: rename enable -> set_mux
> >  - add kernel-doc
> >  - support pinconf
> >    - supported attributes
> >      - pin-bias: pull up, tristate, disable
> >      - slew-rate: 0 == slow, 1 == fast; generic pinconf does not display
> >        argument
> 
> Great progress!!

Thans.

> 
> (...)
> > +++ b/arch/arm/mach-zynq/Kconfig
> > @@ -9,6 +9,7 @@ config ARCH_ZYNQ
> >         select HAVE_ARM_TWD if SMP
> >         select ICST
> >         select MFD_SYSCON
> > +       select PINCTRL
> 
> Don't you also want to select PINCTRL_ZYNQ or is it
> really optional?

Yep, you're right. I did some testing and it is required. I already have
that included in my work tree.

> 
> >         select SOC_BUS
> >         help
> >           Support for Xilinx Zynq ARM Cortex A9 Platform
> 
> Please split these machine changes into a separate patch. It is hitting
> a totally different subsystem.

OK

> 
> (...)
> > +++ b/drivers/pinctrl/pinctrl-zynq.c
> (...)
> > +static const struct pinctrl_ops zynq_pctrl_ops = {
> > +       .get_groups_count = zynq_pctrl_get_groups_count,
> > +       .get_group_name = zynq_pctrl_get_group_name,
> > +       .get_group_pins = zynq_pctrl_get_group_pins,
> > +       .dt_node_to_map = pinconf_generic_dt_node_to_map_group,
> > +       .dt_free_map = pinctrl_utils_dt_free_map
> > +};
> 
> Nice use of generic functions!

Yeah, but for it to really work I need the changes I made to
pinconf-generic. Otherwise things just don't work well since I would
only be able to either select pin groups or pins in DT.

> 
> > +static int zynq_pinconf_cfg_get(struct pinctrl_dev *pctldev,
> > +                               unsigned pin,
> > +                               unsigned long *config)
> > +{
> > +       u32 reg;
> > +       int ret;
> > +       unsigned int arg = 0;
> > +       unsigned int param = pinconf_to_config_param(*config);
> > +       struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
> > +
> > +       if (pin > 53)
> > +               return -ENOTSUPP;
> 
> 53 looks a bit magical? #define or comment here to explain what's
> going on?

Yep, I'll add something like ZYNQ_NUM_MIOS

> 
> Apart from these small things this looks like merge material.

That is good to hear, thank you. But before merging this the
pinconf-generic changes need to go through. Even though I didn't order
things that way in this series (I wanted to show how my work proceeded),
proper operation depends of the driver depends on those pinconf-generic
changes.

	Thanks,
	Sören
