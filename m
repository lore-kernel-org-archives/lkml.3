Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbbAFMNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:13:16 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15754 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbbAFMNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:13:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Jan 2015 04:11:40 -0800
Message-ID: <54ABD14D.30003@nvidia.com>
Date: Tue, 6 Jan 2015 20:13:01 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Lucas Stach <dev@lynxeye.de>, <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        <bskeggs@redhat.com>, <martin.peres@free.fr>,
        <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nouveau 06/11] platform: complete the power up/down sequence
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com> <1419331204-26679-7-git-send-email-vinceh@nvidia.com> <1419427385.2179.13.camel@lynxeye.de> <549B79B2.6010301@nvidia.com> <20150105152552.GH12010@ulmo.nvidia.com> <54ABAC09.4080306@nvidia.com> <20150106113626.GC31830@ulmo.nvidia.com>
In-Reply-To: <20150106113626.GC31830@ulmo.nvidia.com>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL103.nvidia.com (10.18.16.12) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/06/2015 07:36 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jan 06, 2015 at 05:34:01PM +0800, Vince Hsu wrote:
>> On 01/05/2015 11:25 PM, Thierry Reding wrote:
>>>> Old Signed by an unknown key
>>> On Thu, Dec 25, 2014 at 10:42:58AM +0800, Vince Hsu wrote:
>>>> On 12/24/2014 09:23 PM, Lucas Stach wrote:
>>>>> Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
>>>>>> This patch adds some missing pieces of the rail gaing/ungating sequence that
>>>>>> can improve the stability in theory.
>>>>>>
>>>>>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>>>>>> ---
>>>>>>   drm/nouveau_platform.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>>>>>   drm/nouveau_platform.h |  3 +++
>>>>>>   2 files changed, 45 insertions(+)
>>>>>>
>>>>>> diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
>>>>>> index 68788b17a45c..527fe2358fc9 100644
>>>>>> --- a/drm/nouveau_platform.c
>>>>>> +++ b/drm/nouveau_platform.c
>>>>>> @@ -25,9 +25,11 @@
>>>>>>   #include <linux/module.h>
>>>>>>   #include <linux/platform_device.h>
>>>>>>   #include <linux/of.h>
>>>>>> +#include <linux/of_platform.h>
>>>>>>   #include <linux/reset.h>
>>>>>>   #include <linux/regulator/consumer.h>
>>>>>>   #include <soc/tegra/fuse.h>
>>>>>> +#include <soc/tegra/mc.h>
>>>>>>   #include <soc/tegra/pmc.h>
>>>>>>   #include "nouveau_drm.h"
>>>>>> @@ -61,6 +63,9 @@ static int nouveau_platform_power_up(struct nouveau_platform_gpu *gpu)
>>>>>>   	reset_control_deassert(gpu->rst);
>>>>>>   	udelay(10);
>>>>>> +	tegra_mc_flush(gpu->mc, gpu->swgroup, false);
>>>>>> +	udelay(10);
>>>>>> +
>>>>>>   	return 0;
>>>>>>   err_clamp:
>>>>>> @@ -77,6 +82,14 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
>>>>>>   {
>>>>>>   	int err;
>>>>>> +	tegra_mc_flush(gpu->mc, gpu->swgroup, true);
>>>>>> +	udelay(10);
>>>>>> +
>>>>>> +	err = tegra_powergate_gpu_set_clamping(true);
>>>>>> +	if (err)
>>>>>> +		return err;
>>>>>> +	udelay(10);
>>>>>> +
>>>>>>   	reset_control_assert(gpu->rst);
>>>>>>   	udelay(10);
>>>>>> @@ -91,6 +104,31 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
>>>>>>   	return 0;
>>>>>>   }
>>>>>> +static int nouveau_platform_get_mc(struct device *dev,
>>>>>> +		struct tegra_mc **mc, unsigned int *swgroup)
>>>>> Uhm, no. If this is needed this has to be a Tegra MC function and not
>>>>> burried into nouveau code. You are using knowledge about the internal
>>>>> workings of the MC driver here.
>>>>>
>>>>> Also this should probably only take the Dt node pointer as argument and
>>>>> return a something like a tegra_mc_client struct that contains both the
>>>>> MC device pointer and the swgroup so you can pass that to
>>>>> tegra_mc_flush().
>>>> Good idea. I will have something as below in V2 if there is no other
>>>> comments for this.
>>>>
>>>> tegra_mc_client *tegra_mc_find_client(struct device_node *node)
>>>> {
>>>>      ...
>>>>      ret = of_parse_phandle_with_args(node, "nvidia,memory-client", ...)
>>>>      ...
>>>> }
>>>>
>>>> There were some discussion about this few weeks ago. I'm not sure whether we
>>>> have some conclusion/implementation though. Thierry?
>>>>
>>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/308703.html
>>> I don't think client is a good fit here. Flushing is done per SWGROUP
>>> (on all clients of the SWGROUP). So I think we'll want something like:
>>>
>>> 	gpu@0,57000000 {
>>> 		...
>>> 		nvidia,swgroup = <&mc TEGRA_SWGROUP_GPU>;
>>> 		...
>>> 	};
>>>
>>> In the DT and return a struct tegra_mc_swgroup along the lines of:
>>>
>>> 	struct tegra_mc_client {
>>> 		unsigned int id;
>>> 		unsigned int swgroup;
>>>
>>> 		struct list_head list;
>>> 	};
>>>
>>> 	struct tegra_mc_swgroup {
>>> 		struct list_head clients;
>>> 		unsigned int id;
>>> 	};
>>>
>>> Where tegra_mc_swgroup.clients is a list of struct tegra_mc_client
>>> structures, each representing a memory client pertaining to the
>>> SWGROUP.
>> Based on your suggestion above, I created a struct tegra_mc_swgroup:
>>
>> struct tegra_mc_swgroup {
>>      unsigned int id;
>>      struct tegra_mc *mc;
>>      struct list_head head;
>>      struct list_head clients;
>> };
>>
>> And added the list head in the struct tegra_mc_soc.
>>
>> struct tegra_mc_soc {
>>      struct tegra_mc_client *clients;
>>      unsigned int num_clients;
>>
>>      struct tegra_mc_hr *hr_clients;
>>      unsigned int num_hr_clients;
> Why do you still need these?
This part is added in "[PATCH 2/11] memory: tegra: add mc flush support" 
and
"[PATCH 3/11] memory: tegra: add flush operation for Tegra124 memory 
clients"
for the hotreset registers.

>
>>      struct list_head swgroups;
> This doesn't belong in struct tegra_mc_soc because that's meant to be
> static information about the specific variant of the memory-controller.
> Put it in struct tegra_mc instead.
Okay.

>
>> ...
>>
>> Created one function to build the swgroup list.
>>
>> static int tegra_mc_build_swgroup(struct tegra_mc *mc)
>> {
>>      int i;
>>
>>      for (i = 0; i < mc->soc->num_clients; i++) {
>>          struct tegra_mc_swgroup *sg;
>>          bool found = false;
>>
>>          list_for_each_entry(sg, &mc->soc->swgroups, head) {
>>              if (sg->id == mc->soc->clients[i].swgroup) {
>>                  found = true;
>>                  break;
>>              }
>>          }
> Can't you use your new tegra_mc_find_swgroup() function here? That way
> you could turn it into something slightly more readable:
The tegra_mc_build_swgroup() is called during driver probe, and after that
the swgroup list is established and then the tegra_mc_find_swgroup() can 
work.

>
> 	unsigned int swgroup = mc->soc->clients[i].swgroup;
> 	struct tegra_mc_swgroup *group;
>
> 	group = tegra_mc_find_swgroup(mc, swgroup);
The tegra_mc_find_swgroup() is expected to be called outside the mc 
driver and
can only take the device node as argument because other drivers do not have
the mc instance information unless they call tegra_mc_find_swgroup() or
tegra_mc_find_client().


> 	if (!group) {
> 		/* allocates and adds to mc->swgroups */
> 		group = tegra_mc_add_swgroup(mc, swgroup);
> 		if (!group)
> 			return -ENOMEM;
> 	}
>
> 	list_add_tail(&group->list, &mc->swgroups);
>
> where tegra_mc_add_swgroup() is something like this:
>
> 	group = devm_kzalloc(mc->dev, sizeof(*group), GFP_KERNEL);
> 	if (!group)
> 		return NULL;
>
> 	INIT_LIST_HEAD(&group->clients);
> 	group->mc = mc;
> 	group->id = id;
>
> I don't like very much how this duplicates information that is already
> available in tegra_mc_soc, but I can't think of a better way to couple
> the SWGROUP ID with the struct tegra_mc *, so I think we'll have to
> proceed with something like the above.
Yeah.

Thanks,
Vince




