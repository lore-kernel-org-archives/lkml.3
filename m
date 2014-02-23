Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaBWRIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 12:08:01 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63892 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaBWRH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 12:07:58 -0500
Message-ID: <530A2ADF.902@gmail.com>
Date: Sun, 23 Feb 2014 18:07:43 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain
 look-up
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>	 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com> <1392828827.3445.54.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1392828827.3445.54.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 19.02.2014 17:53, Philipp Zabel wrote:
> Am Samstag, den 11.01.2014, 20:42 +0100 schrieb Tomasz Figa:

[snip]

>> +	pd = of_genpd_get_from_provider(&pd_args);
>> +	if (IS_ERR(pd))
>> +		return PTR_ERR(pd);
>> +
>> +	dev_dbg(dev, "adding to power domain %s\n", pd->name);
>> +
>> +	while (1) {
>> +		ret = pm_genpd_add_device(pd, dev);
>
> Since pm_genpd_add_device is used here, no gpd_timing_data can be
> provided. Do you have a plan to solve this? Should the timing data be
> provided from the device tree?

Hmm, a quick grep over kernel sources for genpd_.*_add_device
gives just a single user of __pm_genpd_name_add_device(), with custom 
timing data:

> arch/arm/mach-shmobile/pm-rmobile.c-void rmobile_add_device_to_domain_td(const char *domain_name,
> arch/arm/mach-shmobile/pm-rmobile.c-                                 struct platform_device *pdev,
> arch/arm/mach-shmobile/pm-rmobile.c-                                 struct gpd_timing_data *td)
> arch/arm/mach-shmobile/pm-rmobile.c-{
> arch/arm/mach-shmobile/pm-rmobile.c-    struct device *dev = &pdev->dev;
> arch/arm/mach-shmobile/pm-rmobile.c-
> arch/arm/mach-shmobile/pm-rmobile.c:    __pm_genpd_name_add_device(domain_name, dev, td);
> arch/arm/mach-shmobile/pm-rmobile.c-    if (pm_clk_no_clocks(dev))
> arch/arm/mach-shmobile/pm-rmobile.c-            pm_clk_add(dev, NULL);
> arch/arm/mach-shmobile/pm-rmobile.c-}
> arch/arm/mach-shmobile/pm-rmobile.c-
> arch/arm/mach-shmobile/pm-rmobile.c-void rmobile_add_devices_to_domains(struct pm_domain_device data[],
> arch/arm/mach-shmobile/pm-rmobile.c-                                int size)
> arch/arm/mach-shmobile/pm-rmobile.c-{
> arch/arm/mach-shmobile/pm-rmobile.c-    struct gpd_timing_data latencies = {
> arch/arm/mach-shmobile/pm-rmobile.c-            .stop_latency_ns = DEFAULT_DEV_LATENCY_NS,
> arch/arm/mach-shmobile/pm-rmobile.c-            .start_latency_ns = DEFAULT_DEV_LATENCY_NS,
> arch/arm/mach-shmobile/pm-rmobile.c-            .save_state_latency_ns = DEFAULT_DEV_LATENCY_NS,
> arch/arm/mach-shmobile/pm-rmobile.c-            .restore_state_latency_ns = DEFAULT_DEV_LATENCY_NS,
> arch/arm/mach-shmobile/pm-rmobile.c-    };
> arch/arm/mach-shmobile/pm-rmobile.c-    int j;
> arch/arm/mach-shmobile/pm-rmobile.c-
> arch/arm/mach-shmobile/pm-rmobile.c-    for (j = 0; j < size; j++)
> arch/arm/mach-shmobile/pm-rmobile.c-            rmobile_add_device_to_domain_td(data[j].domain_name,
> arch/arm/mach-shmobile/pm-rmobile.c-                                            data[j].pdev, &latencies);
> arch/arm/mach-shmobile/pm-rmobile.c-}

Moreover the timings used there are just defaults, which makes me wonder 
if there is any reason to specify them explicitly. Even more interesting 
is the fact that genpd code can measure those latencies itself.

Do you have a particular use case for those timing data or just 
wondering? I don't think we need to implement support for them right 
away, if there is no real need to do so. The code and bindings can be 
extended later to handle them, if needed.

As for whether DT is appropriate place to define them, I'm not quite 
sure. Stop and start latencies look like hardware parameters, but state 
save and restore are likely to be driver-specific, as it depends on 
driver code how much time it takes to save and restore needed state 
(e.g. driver with register cache will not need to do any state save), if 
I understand these timing data correctly.

Best regards,
Tomasz
