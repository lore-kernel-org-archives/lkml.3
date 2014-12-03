Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaLCXEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:04:42 -0500
Received: from mail-by2on0063.outbound.protection.outlook.com ([207.46.100.63]:18284
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382AbaLCXEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:04:40 -0500
Date: Wed, 3 Dec 2014 15:04:27 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: Re: [PATCH v2 1/7] pinctrl: pinconf-generic: Infer map type from DT
 property
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
 <1417137993-8337-2-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdbd2cAD5osYnwKTg4d1MwSjNF9i3Y+6ryjc_qLsg46Wtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbd2cAD5osYnwKTg4d1MwSjNF9i3Y+6ryjc_qLsg46Wtg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21148.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <942cd3fb168944d5a3379b8312bc6894@BY2FFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(164054003)(51704005)(377424004)(189002)(377454003)(199003)(50986999)(86362001)(85182001)(47776003)(46102003)(44976005)(120916001)(62966003)(4396001)(50466002)(92566001)(54356999)(64706001)(21056001)(107046002)(19580405001)(19580395003)(6806004)(31966008)(106466001)(85202003)(76176999)(20776003)(95666004)(108616004)(99396003)(53416004)(104016003)(23676002)(87936001)(74316001)(102836001)(77156002)(110136001)(41533002)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB056;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB056;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB056;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB056;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 2014-12-02 at 04:01PM +0100, Linus Walleij wrote:
> On Fri, Nov 28, 2014 at 2:26 AM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > With the new 'groups' property, the DT parser can infer the map type
> > from the fact whether 'pins' or 'groups' is used to specify the pin
> > group to work on.
> > To maintain backwards compatibitliy with current usage of the DT
> > binding, this is only done when an invalid map type is passed to the
> > parsing function.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Tested-by: Andreas Färber <afaerber@suse.de>
> > ---
> > Changes since RFC v2:
> >  - none
> 
> OK there are problems with this.
> 
> > @@ -264,6 +264,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
> >         unsigned reserve;
> >         struct property *prop;
> >         const char *group;
> > +       const char *dt_pin_specifier = "pins";
> 
> Something called "dt_pin_specifier" contains the string "pins"...
> 
> >
> >         ret = of_property_read_string(np, "function", &function);
> >         if (ret < 0) {
> > @@ -284,10 +285,20 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
> >                 reserve++;
> >         if (num_configs)
> >                 reserve++;
> > +
> >         ret = of_property_count_strings(np, "pins");
> >         if (ret < 0) {
> > -               dev_err(dev, "could not parse property pins\n");
> > -               goto exit;
> > +               ret = of_property_count_strings(np, "groups");
> > +               if (ret < 0) {
> > +                       dev_err(dev, "could not parse property pins/groups\n");
> > +                       goto exit;
> > +               }
> > +               if (type == PIN_MAP_TYPE_INVALID)
> > +                       type = PIN_MAP_TYPE_CONFIGS_GROUP;
> > +               dt_pin_specifier = "groups";
> 
> Then suddenly "groups".
> 
> The pointer variable should be named something like "subnode_target_type"
> or so.

I will rename it accordingly in the next version.

> 
> > +++ b/include/linux/pinctrl/pinconf-generic.h
> > @@ -174,6 +174,13 @@ static inline int pinconf_generic_dt_node_to_map_pin(
> >                         PIN_MAP_TYPE_CONFIGS_PIN);
> >  }
> >
> > +static inline int pinconf_generic_dt_node_to_map_all(
> > +               struct pinctrl_dev *pctldev, struct device_node *np_config,
> > +               struct pinctrl_map **map, unsigned *num_maps)
> > +{
> > +       return pinconf_generic_dt_node_to_map(pctldev, np_config, map, num_maps,
> > +                       PIN_MAP_TYPE_INVALID);
> > +}
> 
> First add some comment describing what happens here and why
> INVALID is specified.
> 
> Then what does this have to do with the $subject?
> 
> Atleast mention in the commit text that a new helper is added, though unused.

Ok. I'll put a comment in the header and one or two sentences regarding
this helper in the commit message.

	Thanks,
	Sören
