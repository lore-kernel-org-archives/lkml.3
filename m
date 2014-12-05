Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaLERhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:37:19 -0500
Received: from mail-bl2on0064.outbound.protection.outlook.com ([65.55.169.64]:56416
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751209AbaLERhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:37:17 -0500
Date: Fri, 5 Dec 2014 09:37:03 -0800
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
 <1417766393.22963.9.camel@mm-sol.com>
 <bc08b9044a3f46f5a575dca2fa18a663@BY2FFO11FD057.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc08b9044a3f46f5a575dca2fa18a663@BY2FFO11FD057.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21152.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <40e6a2a0c9f54ba4805871cf33373561@BN1BFFO11FD003.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(24454002)(377424004)(189002)(199003)(51704005)(108616004)(76176999)(50986999)(106466001)(46102003)(4396001)(230783001)(77156002)(62966003)(104016003)(54356999)(74316001)(64706001)(92726002)(107046002)(20776003)(47776003)(85202003)(23676002)(86362001)(110136001)(31966008)(83506001)(92566001)(85182001)(87936001)(50466002)(21056001)(33646002)(99396003)(93886004)(120916001)(53416004)(6806004)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB005;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB005;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB005;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB005;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 09:08AM -0800, Sören Brinkmann wrote:
> On Fri, 2014-12-05 at 09:59AM +0200, Ivan T. Ivanov wrote:
> > 
> > On Thu, 2014-11-27 at 17:26 -0800, Soren Brinkmann wrote:
> > > 
> > >  static const struct pinconf_ops pmic_gpio_pinconf_ops = {
> > > +       .is_generic= true,
> > >         .pin_config_group_get= pmic_gpio_config_get,
> > >         .pin_config_group_set= pmic_gpio_config_set,
> > >         .pin_config_group_dbg_show= pmic_gpio_config_dbg_show,
> > > @@ -848,6 +742,9 @@ static int pmic_gpio_probe(struct platform_device *pdev)
> > >         pctrldesc->name = dev_name(dev);
> > >         pctrldesc->pins = pindesc;
> > >         pctrldesc->npins = npins;
> > > +       pctrldesc->num_dt_params = ARRAY_SIZE(pmic_gpio_bindings);
> > > +       pctrldesc->params = pmic_gpio_bindings;
> > > +       pctrldesc->conf_items = pmic_conf_items;
> > > 
> > 
> > What will happen if number of conf_items is less than number of params?
> 
> I suppose bad things :) You're right, that should probably be checked
> somewhere. Let me see whether I find a good place to put such a check.

Looking at it, it's not that straight forward. We only pass one size to
the core, so the core cannot really check that the number of entries in
both arrays are equal. And passing the size of both looks a little
redundant to me.
That would put the driver in charge of making sure these arrays are
aligned.

With the change given below, it would at least trigger a compiler
warning. I'll add that to the next iteration of this series.
Longer term, merging those arrays, as you suggested, may be a better
solution.

	Thanks,
	Sören

-------------8<-------------8<-------------------8<------------------------8<---
diff --git a/drivers/pinctrl/pinctrl-zynq.c b/drivers/pinctrl/pinctrl-zynq.c
index 29b75134771f..5942af4c2e67 100644
--- a/drivers/pinctrl/pinctrl-zynq.c
+++ b/drivers/pinctrl/pinctrl-zynq.c
@@ -924,7 +924,7 @@ static const struct pinconf_generic_dt_params zynq_dt_params[] = {
        { "io-standard", PIN_CONFIG_IOSTANDARD, zynq_iostd_lvcmos18},
 };
 
-static const struct pin_config_item zynq_conf_items[] = {
+static const struct pin_config_item zynq_conf_items[ARRAY_SIZE(zynq_dt_params)] = {
        PCONFDUMP(PIN_CONFIG_IOSTANDARD, "IO-standard", NULL, true),
 };
 
diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index c612aaa653d5..17f811c9c2c0 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -136,7 +136,7 @@ static const struct pinconf_generic_dt_params pmic_gpio_bindings[] = {
        {"qcom,drive-strength",         PMIC_GPIO_CONF_STRENGTH,        0},
 };
 
-static const struct pin_config_item pmic_conf_items[] = {
+static const struct pin_config_item pmic_conf_items[ARRAY_SIZE(pmic_gpio_bindings)] = {
        PCONFDUMP(PMIC_GPIO_CONF_PULL_UP,  "pull up strength", NULL, true),
        PCONFDUMP(PMIC_GPIO_CONF_STRENGTH, "drive-strength", NULL, true),
 };
