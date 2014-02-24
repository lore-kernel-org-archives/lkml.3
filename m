Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaBXK5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:57:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42194 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaBXK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:56:59 -0500
Message-ID: <1393239379.3091.26.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power
 domain look-up
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 24 Feb 2014 11:56:19 +0100
In-Reply-To: <530A2ADF.902@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
		 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
	 <1392828827.3445.54.camel@pizza.hi.pengutronix.de> <530A2ADF.902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Am Sonntag, den 23.02.2014, 18:07 +0100 schrieb Tomasz Figa:
> Hi Philipp,
> 
> On 19.02.2014 17:53, Philipp Zabel wrote:
> > Am Samstag, den 11.01.2014, 20:42 +0100 schrieb Tomasz Figa:
> 
> [snip]
> 
> >> +	pd = of_genpd_get_from_provider(&pd_args);
> >> +	if (IS_ERR(pd))
> >> +		return PTR_ERR(pd);
> >> +
> >> +	dev_dbg(dev, "adding to power domain %s\n", pd->name);
> >> +
> >> +	while (1) {
> >> +		ret = pm_genpd_add_device(pd, dev);
> >
> > Since pm_genpd_add_device is used here, no gpd_timing_data can be
> > provided. Do you have a plan to solve this? Should the timing data be
> > provided from the device tree?
> 
> Hmm, a quick grep over kernel sources for genpd_.*_add_device
> gives just a single user of __pm_genpd_name_add_device(), with custom 
> timing data:

I had added this to my work progress i.MX patches to silence the noisy
"... latency exceeded, new value ..." warnings emitted by the power
domain framework: http://patchwork.ozlabs.org/patch/320084/

[...]
> Moreover the timings used there are just defaults, which makes me wonder 
> if there is any reason to specify them explicitly. Even more interesting 
> is the fact that genpd code can measure those latencies itself.
> 
> Do you have a particular use case for those timing data or just 
> wondering? I don't think we need to implement support for them right 
> away, if there is no real need to do so. The code and bindings can be 
> extended later to handle them, if needed.

You are right, this is just superficial.

> As for whether DT is appropriate place to define them, I'm not quite 
> sure. Stop and start latencies look like hardware parameters, but state 
> save and restore are likely to be driver-specific, as it depends on 
> driver code how much time it takes to save and restore needed state 
> (e.g. driver with register cache will not need to do any state save), if 
> I understand these timing data correctly.

I have one more, on i.MX6 I manually need to enable the clocks of
devices in the power domain during the power-up sequence so that the
reset signals can propagate.
So far, I have implemented this by registering the device clocks of
devices in the power domain with pm_clk_add and then let the genpd
power_on callback temporarily enable them using pm_clk_resume:

http://patchwork.ozlabs.org/patch/320085/

Whether this is needed seems to me to be a property of the power domain.
Do you think this is something we could add to of_genpd_add_to_domain,
depending on some flag set in struct generic_pm_domain?
I'd like to avoid having to register my own bus notifier and to deal
with ordering issues between that and of_genpd_notifier_call.

regards
Philipp

