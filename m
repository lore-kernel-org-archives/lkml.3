Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaL2CtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 21:49:23 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13875 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaL2CtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 21:49:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 28 Dec 2014 18:43:21 -0800
Message-ID: <54A0C148.6030400@nvidia.com>
Date: Mon, 29 Dec 2014 10:49:44 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        <bskeggs@redhat.com>, <martin.peres@free.fr>,
        <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>		 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>	 <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com> <1419539683.2165.6.camel@lynxeye.de>
In-Reply-To: <1419539683.2165.6.camel@lynxeye.de>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 drhkmail101.nvidia.com (10.25.59.15)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/26/2014 04:34 AM, Lucas Stach wrote:
> Am Donnerstag, den 25.12.2014, 10:28 +0800 schrieb Vince Hsu:
>> On 12/24/2014 09:16 PM, Lucas Stach wrote:
>>> Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
>>>> The Tegra124 and later Tegra SoCs have a sepatate rail gating register
>>>> to enable/disable the clamp. The original function
>>>> tegra_powergate_remove_clamping() is not sufficient for the enable
>>>> function. So add a new function which is dedicated to the GPU rail
>>>> gating. Also don't refer to the powergate ID since the GPU ID makes no
>>>> sense here.
>>>>
>>>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>>> To be honest I don't see the point of this patch.
>>> You are bloating the PMC interface by introducing another exported
>>> function that does nothing different than what the current function
>>> already does.
>>>
>>> If you need a way to assert the clamp I would have expected you to
>>> introduce a common function to do this for all power partitions.
>> I thought about adding an tegra_powergate_assert_clamping(), but that
>> doesn't make sense to all the power partitions except GPU. Note the
>> difference in TRM. Any suggestion for the common function?
> Is there anything speaking against adding this function and only accept
> the GPU partition as valid parameter for now. So at least the interface
> stays symmetric and can be easily extended if any future partitions have
> similar characteristics as the GPU one.
The register APBDEV_PMC_GPU_RG_CNTRL_0 is only for GPU and can be used 
for assertion and deassertion. The APBDEV_PMC_REMOVE_CLAMPING_CMD_0 is 
only used for deassertion. If we have any future partitions that can be 
asserted by SW like GPU, we can improve the interface then.

>
>>> Other comments inline.
>>>
>>> Regards,
>>> Lucas
>>>
>>>> ---
>>>>    drivers/soc/tegra/pmc.c | 34 +++++++++++++++++++++++-----------
>>>>    include/soc/tegra/pmc.h |  2 ++
>>>>    2 files changed, 25 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
>>>> index a2c0ceb95f8f..7798c530ead1 100644
>>>> --- a/drivers/soc/tegra/pmc.c
>>>> +++ b/drivers/soc/tegra/pmc.c
>>>> @@ -225,17 +225,6 @@ int tegra_powergate_remove_clamping(int id)
>>>>    		return -EINVAL;
>>>>    
>>>>    	/*
>>>> -	 * The Tegra124 GPU has a separate register (with different semantics)
>>>> -	 * to remove clamps.
>>>> -	 */
>>>> -	if (tegra_get_chip_id() == TEGRA124) {
>>>> -		if (id == TEGRA_POWERGATE_3D) {
>>>> -			tegra_pmc_writel(0, GPU_RG_CNTRL);
>>>> -			return 0;
>>>> -		}
>>>> -	}
>>>> -
>>>> -	/*
>>>>    	 * Tegra 2 has a bug where PCIE and VDE clamping masks are
>>>>    	 * swapped relatively to the partition ids
>>>>    	 */
>>>> @@ -253,6 +242,29 @@ int tegra_powergate_remove_clamping(int id)
>>>>    EXPORT_SYMBOL(tegra_powergate_remove_clamping);
>>>>    
>>>>    /**
>>>> + * tegra_powergate_gpu_set_clamping - control GPU-SOC clamps
>>>> + *
>>>> + * The post-Tegra114 chips have a separate rail gating register to configure
>>>> + * clamps.
>>>> + *
>>>> + * @assert: true to assert clamp, and false to remove
>>>> + */
>>>> +int tegra_powergate_gpu_set_clamping(bool assert)
>>> Those functions with a bool parameter to set/unset something are really
>>> annoying. Please avoid this pattern. The naming of the original function
>>> is much more intuitive.
>> But the original function is not sufficient. Maybe add a
>> tegra_powergate_assert_gpu_clamping()? That way I will prefer to adding
>> one more removal function for GPU. And then again that's a bloat, too.
>>>> +{
>>>> +	if (!pmc->soc)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (tegra_get_chip_id() == TEGRA124) {
>>>> +		tegra_pmc_writel(assert ? 1 : 0, GPU_RG_CNTRL);
>>>> +		tegra_pmc_readl(GPU_RG_CNTRL);
>>> You are reading the register back here, which to me seems like you are
>>> trying to make sure that the write is flushed. Why is this needed?
>>> I also observed the need to do this while working on Tegra124 PCIe in
>>> Barebox, otherwise the partition wouldn't power up. I didn't have time
>>> to follow up on this yet, so it would be nice if you could explain why
>>> this is needed, or if you don't know ask HW about it.
>> That's a read fence to assure the post of the previous writes through
>> Tegra interconnect. (copy-paster from
>> https://android.googlesource.com/kernel/tegra.git/+/28b107dcb3aa122de8e94e48af548140d519298f)
> I see what it does, the question is more about why this is needed.
> What is the Tegra interconnect? According to the TRM the Tegra contains
> some standard AXI <-> AHB <-> APB bridges. That a read is needed to
> assure the write is posted to the APB bus seems to imply that there is
> some write buffering in one of those bridges. Can we get this documented
> somewhere?
The TRM does mention a read after the write. Check the section 32.2.2.3.

Thanks,
Vince

>
> And isn't it needed for the other partition ungating function too then?
I believe yes.

>
> Regards,
> Lucas
>
>

