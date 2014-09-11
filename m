Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaIKRBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:01:43 -0400
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:1845
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750970AbaIKRBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:01:41 -0400
Date: Thu, 11 Sep 2014 11:40:13 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Weike Chen <alvin.chen@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/4 v3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
In-Reply-To: <1410286081-16653-5-git-send-email-alvin.chen@intel.com>
Message-ID: <alpine.DEB.2.02.1409111138080.4869@atx-linux-37>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com> <1410286081-16653-5-git-send-email-alvin.chen@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0043.namprd08.prod.outlook.com (10.242.217.171) To
 BLUPR03MB309.namprd03.prod.outlook.com (10.141.48.22)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51704005)(199003)(189002)(92566001)(95666004)(47776003)(53416004)(92726001)(97736003)(85852003)(83072002)(86152002)(42186005)(107046002)(87976001)(106356001)(83506001)(77096002)(21056001)(23726002)(81156004)(105586002)(54356999)(101416001)(50986999)(99396002)(69596002)(81542001)(80022001)(64706001)(20776003)(46406003)(50466002)(81342001)(46102001)(66066001)(90102001)(85306004)(102836001)(76482001)(79102001)(86362001)(83322001)(76176999)(110136001)(33716001)(74662001)(77982001)(74502001)(4396001)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB309;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Weike Chen wrote:

>  
>  struct dwapb_gpio;
> +struct dwapb_context;
>  
>  struct dwapb_gpio_port {
>  	struct bgpio_chip	bgc;
>  	bool			is_registered;
>  	struct dwapb_gpio	*gpio;
> +	struct dwapb_context	*ctx;

Alvin,

Will this build if CONFIG_PM_SLEEP is not defined?

Alan

> +	unsigned int		idx;
>  };
>  

>  struct dwapb_gpio {
> @@ -377,6 +380,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
>  
>  	port = &gpio->ports[offs];
>  	port->gpio = gpio;
> +	port->idx = pp->idx;
>  
>  	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
>  	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
> @@ -584,10 +588,115 @@ static const struct of_device_id dwapb_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, dwapb_of_match);
>  
> +#ifdef CONFIG_PM_SLEEP
> +/* Store GPIO context across system-wide suspend/resume transitions */
> +struct dwapb_context {
> +	u32 data;
> +	u32 dir;
> +	u32 ext;
> +	u32 int_en;
> +	u32 int_mask;
> +	u32 int_type;
> +	u32 int_pol;
> +	u32 int_deb;
> +};
> +
