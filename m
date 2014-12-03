Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaLCRil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:38:41 -0500
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:54624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbaLCRij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:38:39 -0500
Date: Wed, 3 Dec 2014 09:38:31 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: Re: [PATCH v2 7/7] pinctrl: qcom-spmi-gpio: Migrate to
 pinconf-generic
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
 <1417137993-8337-8-git-send-email-soren.brinkmann@xilinx.com>
 <1417611812.30615.28.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417611812.30615.28.camel@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21148.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <d3d1b263bf6242aa9a1a0876be455cce@BN1BFFO11FD021.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(6009001)(438002)(199003)(189002)(377424004)(51704005)(24454002)(76176999)(50986999)(54356999)(31966008)(102836001)(92566001)(6806004)(44976005)(19580405001)(19580395003)(20776003)(47776003)(74316001)(64706001)(87936001)(83506001)(85182001)(21056001)(23676002)(86362001)(106466001)(4396001)(50466002)(99396003)(120916001)(77156002)(33646002)(230783001)(107046002)(46102003)(85202003)(62966003)(110136001)(108616004)(95666004)(53416004)(104016003)(41533002)(107986001)(24736002)(23106004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB041;H:xsj-pvapsmtpgw01;FPR:;MLV:ovrnspm;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB041;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB041;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB041;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 03:03PM +0200, Ivan T. Ivanov wrote:
> 
> On Thu, 2014-11-27 at 17:26 -0800, Soren Brinkmann wrote:
> > Instead of the driver caring about implementation details like device
> > tree, just provide information about driver specific pinconf parameters
> > to pinconf-generic which takes care of parsing the DT.
> > 
> > Signed-off-by: Soren Brinkmann brinkmann@xilinx.com>
> > ---
> > This is compile tested only. So, it's likely that it needs more tweaking
> > to make it actually work on HW. But it illustrates the potential
> > benefits of the pinconf-generic changes in this series.
> > ---
> >  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 125 +++----------------------------
> >  1 file changed, 11 insertions(+), 114 deletions(-)
> > 
> > diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > index b863b5080890..2db85e53ef73 100644
> > --- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > +++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > @@ -131,14 +131,14 @@ struct pmic_gpio_state {
> >         struct gpio_chip chip;
> >  };
> > 
> > -struct pmic_gpio_bindings {
> > -       const char*property;
> > -       unsigned      param;
> > +static const struct pinconf_generic_dt_params pmic_gpio_bindings[] = {
> > +       {"qcom,pull-up-strength",PMIC_GPIO_CONF_PULL_UP,0},
> > +       {"qcom,drive-strength",PMIC_GPIO_CONF_STRENGTH,0},
> >  };
> > 
> > -static struct pmic_gpio_bindings pmic_gpio_bindings[] = {
> > -       {"qcom,pull-up-strength",PMIC_GPIO_CONF_PULL_UP},
> > -       {"qcom,drive-strength",PMIC_GPIO_CONF_STRENGTH},
> > +static const struct pin_config_item pmic_conf_items[] = {
> > +       PCONFDUMP(PMIC_GPIO_CONF_PULL_UP,  "pull-up-strength", NULL, true),
> 
> s/pull-up-strength/qcom,pull-up-strength/

This is used for the debugfs output. I don't think you want the qcom
prefix here, do you?

> 
> > +       PCONFDUMP(PMIC_GPIO_CONF_STRENGTH, "drive-strength", NULL, true),
> >  };
> > 
> 
> 
> 
> I am not happy that we have to define the same think two times.

It's not really the same thing. One is the actual DT binding the other
how the property is displayed in debugfs. Two different things. It's how
the core does it. That's not new.

	Sören
