Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaBXOip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:38:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBXOik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:38:40 -0500
Message-ID: <530B594F.2030500@ti.com>
Date: Mon, 24 Feb 2014 08:38:07 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 3/6] PM / Voltagedomain: introduce voltage domain
 driver support
References: <1392755543-28335-1-git-send-email-nm@ti.com> <1392755543-28335-4-git-send-email-nm@ti.com> <20140224015826.GU25940@sirena.org.uk>
In-Reply-To: <20140224015826.GU25940@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 07:58 PM, Mark Brown wrote:
> On Tue, Feb 18, 2014 at 02:32:20PM -0600, Nishanth Menon wrote:
> 
>> The current regulator model provides the basic building blocks for the
>> transitions, however SoC drivers specific to each of these devices, be
>> it cpufreq/devfreq have to replicate the logic for functionality.
> 
>> To simply the logic, we can hence introduce a layer that takes care
>> of the mundane transition logic, registration mechanisms to provide
>> the "user drivers" such as cpufreq/devfreq a generic interface, whose
>> details are abstracted by the device tree description for the SoC on
>> which the driver operates on.
> 
> This doesn't really provide a picture of what the generic interface
> that's being offered is and...
I should have probably picked up part of the cover letter[1] and
elaborated further in the commit message here.

Intent here is to allow drivers such as cpufreq-cpu0 to be reused on
platforms such as TI's OMAP derivatives, and other SoCs which differ
only by the sequence involved in voltage scale operations. So, this
patch provides a framework for registering the underlying
implementation of the SoC specific voltage change methodology.

Overall the sequence takes place after this patch is as follows:
a) voltage domain drivers such as those of TI or others register with
voltage domain with devm_voltdm_register.
b) cpufreq-cpu0/devfreq drivers:
of_pm_voltdm_notifier_register(introduced as part of patch #1) to
register notifiers around clk of interest. This request is linked to
the specific voltage domain using phandle in device tree.
c) when cpufreq-cpu0/devfreq does a clk_set_rate, the common clock
framework triggers notifiers in voltage domain core which in turn,
invokes the corresponding handlers for the voltage domain driver
ensuring the right dvfs sequence specific to the SoC is triggered.

With this patch, the logic for a SoC specific voltage domain
intricacies can now be abstracted out to the voltage domain layer.
This allows reuse of the logic by multiple drivers such as
devfreq/cpufreq and allows these to remain consistent with very
minimal SoC(if any at all) specific implementations in them.

Among the other obvious alternatives to this approach are:
a) To duplicate the logic multiple times for various drivers such as
devfreq/cpufreq and try to ensure the logic sequences are proper.
basically, create cpufreq-abb-omap, cpufreq-avs-omap,
devfreq-abb-omap, devfreq-avs-omap etc..
b) introduce a specific API for voltage change (something like
pm_dev_scale_opp_frequency or the equivalent).


> 
>>  drivers/power/voltdm/Kconfig                  |    5 +
>>  drivers/power/voltdm/Makefile                 |    3 +
>>  drivers/power/voltdm/core.c                   |  347 +++++++++++++++++++++++--
>>  drivers/power/voltdm/voltage_domain_private.h |   86 ++++++
>>  4 files changed, 424 insertions(+), 17 deletions(-)
> 
> ...the diffstat doesn't make it obvious what the external interface is
> either.  It would be much easier to review this with a clearer picture
> of what it's aiming to implement.

The drivers such as cpufreq/devfreq has the same interface introduced
by patch #1 in this series of_pm_voltdm_notifier_register/unregister
which is exposed by include/linux/pm_voltage_domain.h

Underlying implementation of the SoC specific voltage change
methodology can now be isolated by voltage domain driver using
voltage_domain_private.h and services provided by core.c

> 
>> +	voltdm_np = of_parse_phandle(np, prop_name, 0);
>> +	if (voltdm_np) {
>> +		ret = of_parse_phandle_with_args(np, prop_name, "#voltdm-cells",
>> +						 0, args);
>> +		if (ret)
>> +			return ERR_PTR(ret);
> 
> There seems to be some DT stuff going on here, is the interface DT only?
> 
yes. i will make that clear in the documentation.

[1] http://marc.info/?l=linux-kernel&m=139275560531711&w=2
-- 
Regards,
Nishanth Menon
