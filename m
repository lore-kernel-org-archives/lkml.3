Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966181Ab3HHSzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:55:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46922 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966099Ab3HHSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:55:36 -0400
Message-ID: <5203E9A2.4080500@wwwdotorg.org>
Date: Thu, 08 Aug 2013 12:55:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/6] ARM: Tegra: Add CPU's OPPs for using cpufreq-cpu0
 driver
References: <cover.1375886595.git.viresh.kumar@linaro.org> <d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org> <52028719.8070908@wwwdotorg.org> <CAKohpo=MpOyMGFTGeZWmoCRwmZ7+nQtP_yCGokPanEVYL0xbMw@mail.gmail.com> <52029811.9080704@wwwdotorg.org> <CAKohpom658XKf5qPb3Wekb_uRfBEGHSxE=T06tEi30UTQ4K=Sg@mail.gmail.com>
In-Reply-To: <CAKohpom658XKf5qPb3Wekb_uRfBEGHSxE=T06tEi30UTQ4K=Sg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 08:57 PM, Viresh Kumar wrote:
> On 8 August 2013 00:25, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/07/2013 12:06 PM, Viresh Kumar wrote:
>>> On 7 August 2013 23:12, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
>>>>> cpufreq-cpu0 driver needs OPPs to be present in DT which can be probed by it to
>>>>> get frequency table. This patch adds OPPs and clock-latency to tegra cpu0 node
>>>>> for multiple SoCs.
>>>>>
>>>>> Voltage levels aren't used until now for tegra and so a flat value which would
>>>>> eventually be ignored is used to represent voltage.
>>>>
>>>> This patch is problematic w.r.t. DT being an ABI.
>>>
>>> :(
>>>
>>>> We can certainly add new optional properties to a DT binding that enable
>>>> new features. However, a new version of a binding can't require new
>>>> properties to exist that didn't before, since that means that old DTs
>>>> won't work with new kernels that require the new properties.
>>>
>>> To be honest I didn't get it completely. You meant operating-points
>>> wasn't present before? Its here:
>>>
>>> Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>>> Documentation/devicetree/bindings/power/opp.txt
>>>
>>> Or you meant, Tegra never required voltage levels and we are getting
>>> them in here.
>>
>> The current Tegra *.dts files do not contain this property. The current
>> Tegra *.dts files must continue to work without modification in future
>> kernels.
> 
> But that can't be true always.. Specially when we are moving things to
> DT...

It has to be, or DT isn't an ABI.

Since DT is defined as being an ABI, it has to be true.

The solution here that allows DT to be an ABI is to be the data into the
drivers (or core SoC support code) rather than DT.

> For example, we are moving your DMA driver to DT and hence in the
> platform code, we are making a new DT node + removing static
> platform device.
> 
> Now, old DT can't work with new kernel... That is just not possible.
> That statement might be true for cases where we are just upgrading
> existing DT support (but I doubt it there as well :) )..

Well yes, converting existing platforms to DT piece-meal was probably a
mistake in retrospect. What we should have done is added parallel DT and
non-DT support, and only allow features to be enabled when booting DT if
they were triggered by DT nodes, and never allowed additional drivers to
be registered by board files.

Your point is indeed why suddenly deciding that DT is an ABI when it
wasn't being enforced before is painful.

>>>> As such, I believe we do need some Tegra-specific piece of code that
>>>> defines these OPP tables in the kernel, so that the operating-points
>>>> property is not needed.
>>>
>>> Generic cpufreq driver depends on OPP library and so somebody has
>>> to provide them. Now you can do it by calling opp_add() for each OPP
>>> you have or otherwise.
>>
>> Sure. That's what the Tegra-specific cpufreq driver should do. It should
>> be the top-level cpufreq driver. If parts of the code can be implemented
>> by library functions or a core parameterizable driver, then presumably
>> the Tegra driver would simply exist to provide those parameters and/or
>> callback functions to the generic driver.
> 
> That would be something similar to what we are discussing on other
> thread about new platform device...
> 
> You are asking me to go back to platform specific code instead of DT.
> When there exists a generic enough way of providing this information
> via DT, why should we put this in a driver?

I think that drivers should include all data that doesn't need to vary;
there's no point putting data into DT just to parse it out into the same
tables that the driver could have embedded itself from the start.
