Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaLYCmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 21:42:55 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18031 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaLYCmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 21:42:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 24 Dec 2014 18:37:29 -0800
Message-ID: <549B79B2.6010301@nvidia.com>
Date: Thu, 25 Dec 2014 10:42:58 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        <bskeggs@redhat.com>, <martin.peres@free.fr>,
        <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nouveau 06/11] platform: complete the power up/down sequence
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>	 <1419331204-26679-7-git-send-email-vinceh@nvidia.com> <1419427385.2179.13.camel@lynxeye.de>
In-Reply-To: <1419427385.2179.13.camel@lynxeye.de>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 drhkmail101.nvidia.com (10.25.59.15)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/24/2014 09:23 PM, Lucas Stach wrote:
> Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
>> This patch adds some missing pieces of the rail gaing/ungating sequence that
>> can improve the stability in theory.
>>
>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>> ---
>>   drm/nouveau_platform.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   drm/nouveau_platform.h |  3 +++
>>   2 files changed, 45 insertions(+)
>>
>> diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
>> index 68788b17a45c..527fe2358fc9 100644
>> --- a/drm/nouveau_platform.c
>> +++ b/drm/nouveau_platform.c
>> @@ -25,9 +25,11 @@
>>   #include <linux/module.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/of.h>
>> +#include <linux/of_platform.h>
>>   #include <linux/reset.h>
>>   #include <linux/regulator/consumer.h>
>>   #include <soc/tegra/fuse.h>
>> +#include <soc/tegra/mc.h>
>>   #include <soc/tegra/pmc.h>
>>   
>>   #include "nouveau_drm.h"
>> @@ -61,6 +63,9 @@ static int nouveau_platform_power_up(struct nouveau_platform_gpu *gpu)
>>   	reset_control_deassert(gpu->rst);
>>   	udelay(10);
>>   
>> +	tegra_mc_flush(gpu->mc, gpu->swgroup, false);
>> +	udelay(10);
>> +
>>   	return 0;
>>   
>>   err_clamp:
>> @@ -77,6 +82,14 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
>>   {
>>   	int err;
>>   
>> +	tegra_mc_flush(gpu->mc, gpu->swgroup, true);
>> +	udelay(10);
>> +
>> +	err = tegra_powergate_gpu_set_clamping(true);
>> +	if (err)
>> +		return err;
>> +	udelay(10);
>> +
>>   	reset_control_assert(gpu->rst);
>>   	udelay(10);
>>   
>> @@ -91,6 +104,31 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
>>   	return 0;
>>   }
>>   
>> +static int nouveau_platform_get_mc(struct device *dev,
>> +		struct tegra_mc **mc, unsigned int *swgroup)
> Uhm, no. If this is needed this has to be a Tegra MC function and not
> burried into nouveau code. You are using knowledge about the internal
> workings of the MC driver here.
>
> Also this should probably only take the Dt node pointer as argument and
> return a something like a tegra_mc_client struct that contains both the
> MC device pointer and the swgroup so you can pass that to
> tegra_mc_flush().
Good idea. I will have something as below in V2 if there is no other 
comments for this.

tegra_mc_client *tegra_mc_find_client(struct device_node *node)
{
     ...
     ret = of_parse_phandle_with_args(node, "nvidia,memory-client", ...)
     ...
}

There were some discussion about this few weeks ago. I'm not sure 
whether we have some conclusion/implementation though. Thierry?

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/308703.html

>
>> +{
>> +	struct of_phandle_args args;
>> +	struct platform_device *pdev;
>> +	int ret;
>> +
>> +	ret = of_parse_phandle_with_fixed_args(dev->of_node, "mc",
>> +				1, 0, &args);
>> +	if (ret)
>> +		return ret;
>> +
>> +	pdev = of_find_device_by_node(args.np);
>> +	if (!pdev)
>> +		return -EINVAL;
> This is wrong, you need to handle -EPROBE_DEFER here.
Indeed. Will fix.
>
>> +
>> +	*mc = platform_get_drvdata(pdev);
>> +	if (!*mc)
>> +		return -EINVAL;
>> +
>> +	*swgroup = args.args[0];
>> +
>> +	return 0;
>> +}
>> +
>>   static int nouveau_platform_probe(struct platform_device *pdev)
>>   {
>>   	struct nouveau_platform_gpu *gpu;
>> @@ -118,6 +156,10 @@ static int nouveau_platform_probe(struct platform_device *pdev)
>>   	if (IS_ERR(gpu->clk_pwr))
>>   		return PTR_ERR(gpu->clk_pwr);
>>   
>> +	err = nouveau_platform_get_mc(&pdev->dev, &gpu->mc, &gpu->swgroup);
>> +	if (err)
>> +		return err;
>> +
>>   	err = nouveau_platform_power_up(gpu);
>>   	if (err)
>>   		return err;
>> diff --git a/drm/nouveau_platform.h b/drm/nouveau_platform.h
>> index 58c28b5653d5..969dbddd786d 100644
>> --- a/drm/nouveau_platform.h
>> +++ b/drm/nouveau_platform.h
>> @@ -35,6 +35,9 @@ struct nouveau_platform_gpu {
>>   	struct clk *clk_pwr;
>>   
>>   	struct regulator *vdd;
>> +
>> +	struct tegra_mc *mc;
>> +	unsigned int swgroup;
>>   };
>>   
>>   struct nouveau_platform_device {
>

