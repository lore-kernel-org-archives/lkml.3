Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbaLLQVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:21:18 -0500
Received: from mail-bn1bn0100.outbound.protection.outlook.com ([157.56.110.100]:46080
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964851AbaLLQVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:21:16 -0500
Date: Fri, 12 Dec 2014 08:21:03 -0800
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
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21172.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <f754e0fd1e704d18913a5d89c607e57f@BN1BFFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(164054003)(189002)(24454002)(377424004)(199003)(110136001)(33646002)(85202003)(76176999)(104016003)(54356999)(50986999)(106466001)(87936001)(85182001)(230783001)(83506001)(92726002)(53416004)(108616004)(93886004)(86362001)(92566001)(23676002)(20776003)(64706001)(99396003)(62966003)(47776003)(77156002)(74316001)(46102003)(50466002)(120916001)(31966008)(107046002)(21056001)(4396001)(6806004)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB052;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB052;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB052;
X-Forefront-PRVS: 04238CD941
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB052;
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

I looked at merging these arrays. Unfortunately that doesn't work that
easy.
There are two arrays. The first one establishes a mapping from
strings used in DT to specify pinconf parameters to a pinconf parameter.
This array has some entries which map to the same pinconf parameter.
E.g. 'input-enable' and 'input-disable', the only difference in those
entries is the resulting value of the parameter.

The second array establishes a debugfs representation for each pinconf
parameter.
So, for the core parameters, the number of entries in these arrays
differ.

For this patch, I was assuming that these arrays match in size. I'd keep
it the way it is now and if it turns out that this is not sufficient,
passing the size of the second array too is an easy addition.

	Thanks,
	Sören
