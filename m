Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbbAHEYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:24:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6512 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbAHEX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:23:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Jan 2015 20:16:35 -0800
Message-ID: <54AE0653.9020002@nvidia.com>
Date: Thu, 8 Jan 2015 12:23:47 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com> <1419331204-26679-2-git-send-email-vinceh@nvidia.com> <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com> <20150105150932.GG12010@ulmo.nvidia.com> <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com> <54AD0F37.5080609@nvidia.com> <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com> <20150107141938.GA7392@nvidia.com> <20150107151206.GG1621@ulmo>
In-Reply-To: <20150107151206.GG1621@ulmo>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/07/2015 11:12 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jan 07, 2015 at 10:19:52PM +0800, Vince Hsu wrote:
>> On 04:12:54PM Jan 07, Peter De Schrijver wrote:
>>> On Wed, Jan 07, 2015 at 06:49:27PM +0800, Vince Hsu wrote:
>>>> On 01/07/2015 06:19 PM, Peter De Schrijver wrote:
>>>>> On Mon, Jan 05, 2015 at 04:09:33PM +0100, Thierry Reding wrote:
>>>>>>> Old Signed by an unknown key
>>>>>> On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
>>>>>>> On 12/24/2014 09:16 PM, Lucas Stach wrote:
>>>>>>>> Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
>>>>>>>>> The Tegra124 and later Tegra SoCs have a sepatate rail gating register
>>>>>>>>> to enable/disable the clamp. The original function
>>>>>>>>> tegra_powergate_remove_clamping() is not sufficient for the enable
>>>>>>>>> function. So add a new function which is dedicated to the GPU rail
>>>>>>>>> gating. Also don't refer to the powergate ID since the GPU ID makes no
>>>>>>>>> sense here.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>>>>>>>> To be honest I don't see the point of this patch.
>>>>>>>> You are bloating the PMC interface by introducing another exported
>>>>>>>> function that does nothing different than what the current function
>>>>>>>> already does.
>>>>>>>>
>>>>>>>> If you need a way to assert the clamp I would have expected you to
>>>>>>>> introduce a common function to do this for all power partitions.
>>>>>>> I thought about adding an tegra_powergate_assert_clamping(), but that
>>>>>>> doesn't make sense to all the power partitions except GPU. Note the
>>>>>>> difference in TRM. Any suggestion for the common function?
>>>>>> I don't think extending the powergate API is useful at this point. We've
>>>>>> long had an open TODO item to replace this with a generic API. I did
>>>>>> some prototyping a while ago to use generic power domains for this, that
>>>>>> way all the details and dependencies between the partitions could be
>>>>>> properly modeled.
>>>>>>
>>>>>> Can you take a look at my staging/powergate branch here:
>>>>>>
>>>>>> 	https://github.com/thierryreding/linux/commits/staging/powergate
>>>>>>
>>>>>> and see if you can use that instead? The idea is to completely hide the
>>>>>> details of power partitions from drivers and use runtime PM instead.
>>>>>>
>>>>>> Also adding Peter whom I had discussed this with earlier. Can we finally
>>>>>> get this converted? I'd rather not keep complicating this custom API to
>>>>>> avoid making the conversion even more difficult.
>>>>> Conceptually I fully agree that we should use runtime PM and powerdomains.
>>>>> However I don't think the implementation you mentioned is correct. The resets
>>>>> of all modules in a domain need to be asserted and the memory clients need to
>>>>> be flushed. All this needs to be done with module clocks enabled (resets are
>>>>> synchronous).  Then all module clocks need to be disabled and then the
>>>>> partition can be powergated. After ungating, the module resets need to be
>>>>> deasserted and the FLUSH bit cleared with clocks enabled.
>>>> Yeah. I plan to have the information of all the clock client of the
>>>> partitions and
>>>> the memory clients be defined statically in c source, e.g. pmc-tegra124.c.
>>>> All modules can declare which domain they belong to in DT. One domain can
>>>> be really power gated only when no module is awake. Note the clock
>>>> clients of
>>>> one domain might not equal to the clocks of the module. The reset is
>>>> not either.
>>>> So I don't get the clock and reset from module. How do you think?
>>>>
>>> I think it's indeed better to have a direct reference to the required clocks
>>> to powergate/ungate a domain. As you said, there is no easy way to derive the
>>> required clocks from the DT module declarations. My suggestion would be to
>>> have powerdomain definitions in DT and for each domain have references to
>>> the required clocks and resets.
>>>
>> And specify the dependencies between domains in DT?
> I think the dependencies could be in the driver. Of course the power
> domains are per-SoC data, so really shouldn't be in the DTS either (the
> data is all implied by the compatible value) but there's no good way to
> get at the clocks and resets without DT, so I think that's a reasonable
> trade-off.
>
> It seems to me like there are only two dependencies:
>
> 	DIS and DISB depend on SOR
> 	VE depends on DIS
>
> That's according to 5.6.6 "Programming Guide for Power Gating and
> Ungating" of the Tegra K1 TRM. It also seems like a bunch of modules are
> part of seemingly unrelated domains. Especially SOR seems to cover a
> large range of modules (MIPI-CAL, DPAUX, SOR, HDMI, DSI, DSIB and
> HDA2HDMI).
>
> Given that we may want to more fine-grainedly control clocks to save
> power, don't we need to control clocks and resets within the drivers? I
> think the runtime PM framework makes sure to call this in the right
> order, so for suspend, the sequence would be:
We need to control clocks and resets within the drivers. I believe the
powergate sequence is just to provide a clean hardware state. The
driver can do whatever it wants to the clocks and reset as long as
that's correct procedure.

>
> 	1) device->suspend
> 	2) domain->suspend
>
> and for resume:
>
> 	1) domain->resume
> 	2) device->resume
>
> But then we're back to square one, namely that the MC flush doesn't work
> properly, since it needs to be implemented in domain->suspend. Does that
> mean we can't clock-gate modules? In order to ensure a proper powergate
> sequence, the domain code would need to clk_enable() the module clock to
> make sure it stays on during the reset sequence. But if the domain code
> has a reference to the clock, then the driver can't clock-gate the
> module anymore by calling clk_disable().
The module can definitely flush its memory client when the driver wants
to reset the module.

e.g.
The VENC domain needs to flush swgroup ISP, ISPB, VI for domain gating.
The ISP module only needs to flush swgroup ISP when reset.

That means we have to define "nvidia,swgroup = <&pmc ISP>" for both
of the domain VENC and module ISP.

Besides that last step in the un-powergating sequence is disabling all
the module clocks. The module driver has to enable it's module clock
later if need be. So there is no clock reference problem.

Thanks,
Vince

>
> Am I missing something?
>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1

