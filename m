Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaCJRMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:12:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55863 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbaCJRMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:12:38 -0400
Message-ID: <531DF250.5060100@ti.com>
Date: Mon, 10 Mar 2014 12:11:44 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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
References: <1392755543-28335-1-git-send-email-nm@ti.com> <1392755543-28335-4-git-send-email-nm@ti.com> <20140224015826.GU25940@sirena.org.uk> <530B594F.2030500@ti.com> <20140303035426.GC2411@sirena.org.uk>
In-Reply-To: <20140303035426.GC2411@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 09:54 PM, Mark Brown wrote:
> On Mon, Feb 24, 2014 at 08:38:07AM -0600, Nishanth Menon wrote:
> 
>> Intent here is to allow drivers such as cpufreq-cpu0 to be reused on
>> platforms such as TI's OMAP derivatives, and other SoCs which differ
>> only by the sequence involved in voltage scale operations. So, this
>> patch provides a framework for registering the underlying
>> implementation of the SoC specific voltage change methodology.
> 
> That bit is clear, what's very opaque from the code is how this is going
> to be accomplished.
The SoC specific voltage domain drivers register with
devm_voltdm_register. the fops provide the abstraction needed for the
SoC (example in patch #5 - which introduces OMAP specific voltage
domain which handles ABB and VDD regulators).

What would you suggest that we do to clarify the usage here?

>> Overall the sequence takes place after this patch is as follows:
>> a) voltage domain drivers such as those of TI or others register with
>> voltage domain with devm_voltdm_register.
>> b) cpufreq-cpu0/devfreq drivers:
>> of_pm_voltdm_notifier_register(introduced as part of patch #1) to
>> register notifiers around clk of interest. This request is linked to
>> the specific voltage domain using phandle in device tree.
>> c) when cpufreq-cpu0/devfreq does a clk_set_rate, the common clock
>> framework triggers notifiers in voltage domain core which in turn,
>> invokes the corresponding handlers for the voltage domain driver
>> ensuring the right dvfs sequence specific to the SoC is triggered.
> 
> So the first question I have here is what happens if multiple clocks
> need to be updated in lock step - if we're only triggering off clock
> notifiers that seems tricky.  The other thing here is that the fact that
Yes, that is true, however, there are ways to implement them, for
example: We could implement an higher level clock that takes care of
the multiple clock node control to handle this kind of scenario.

I can elaborate that in the commit message, if that is desirable.

> your API is "of_" suggests that it is in fact linked very srongly to DT
> - it'd be good to split out the layers to make sure things make sense
> standalone, the DT helpers are obviously good but the API should be able
> to stand separately.

You are correct, I had intended the RFC as purely "OF only". I will
make it independent of of in the next revision.

-- 
Regards,
Nishanth Menon
