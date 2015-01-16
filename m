Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbbAPK0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:26:55 -0500
Received: from down.free-electrons.com ([37.187.137.238]:32933 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751512AbbAPK0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:26:54 -0500
Date: Fri, 16 Jan 2015 11:26:51 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/8] ARM: at91: pm: rework cpu detection
Message-ID: <20150116102651.GA3843@piout.net>
References: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421333971-7581-2-git-send-email-alexandre.belloni@free-electrons.com>
 <B256D81BAE5131468A838E5D7A243641BFCE1327@penmbx01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B256D81BAE5131468A838E5D7A243641BFCE1327@penmbx01>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16/01/2015 at 02:44:39 +0000, Yang, Wenyou wrote :
> > -	/* AT91RM9200 SDRAM low-power mode cannot be used with self-refresh.
> > */
> > -	if (cpu_is_at91rm9200())
> > +	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
> > +
> > +	if (of_machine_is_compatible("atmel,at91rm9200")) {
> > +		/*
> > +		 * AT91RM9200 SDRAM low-power mode cannot be used with
> > +		 * self-refresh.
> > +		 */
> >  		at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
> > -
> > +
> > +		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP |
> > +					    AT91RM9200_PMC_UDP;
> > +		at91_pm_data.memctrl = AT91_MEMCTRL_MC;
> > +	} else if (of_machine_is_compatible("atmel,at91sam9260") ||
> > +		   of_machine_is_compatible("atmel,at91sam9g20") ||
> > +		   of_machine_is_compatible("atmel,at91sam9261") ||
> > +		   of_machine_is_compatible("atmel,at91sam9g10") ||
> > +		   of_machine_is_compatible("atmel,at91sam9263")) {
> > +		at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP |
> > +					    AT91SAM926x_PMC_UDP;
> > +	} else if (of_machine_is_compatible("atmel,at91sam9g45")) {
> > +		at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
> > +	}
> > +
> About the memory controller type, I prefer to get it during the memory controller initialization, from the sram_ids[].data which defined in the setup.c,
> As this,
> static const struct at91_ramc_of_data at91rm9200_ramc_of_data = {
> 	.ramc_type = AT91_MEMCTRL_MC,
> };
> ...
> static struct of_device_id ramc_ids[] = {
> 	{ .compatible = "atmel,at91rm9200-sdramc", .data = &at91rm9200_ramc_of_data},
> 	... ...
> 	{ /*sentinel*/ }
> };
> 
> What about you? 

Yes, we agreed that using of_machine_is_compatible is not nice and that
is why I remove that usage in patch 4.

We still have to fill the uhp_udp_mask and that would mean adding a
match on the pmc compatible string. I would prefer not doing that. Or
maybe we can just remove the check, I don't think it it necessary
anymore.

At some point in time, I would like to be able to get rid of the
ramc_ids in mach-at91 but I'm not sure how yet.

Maybe we can do what you suggest after
http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/316771.html
Because then, the ram detection is local to pm.c


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
