Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaGNJ5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:57:38 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16699 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaGNJ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:57:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Jul 2014 02:46:19 -0700
Message-ID: <53C3A986.9050602@nvidia.com>
Date: Mon, 14 Jul 2014 12:57:26 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-6-git-send-email-mperttunen@nvidia.com> <20140711145146.GA6523@ulmo> <53C00A57.5070102@kapsi.fi> <53C38D07.4030402@nvidia.com> <20140714081524.GI2081@ulmo> <53C39D98.9040802@nvidia.com> <20140714093136.GB9755@ulmo>
In-Reply-To: <20140714093136.GB9755@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 12:31, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jul 14, 2014 at 12:06:32PM +0300, Mikko Perttunen wrote:
>> On 14/07/14 11:15, Thierry Reding wrote:
>>>> Old Signed by an unknown key
>>>
>>> On Mon, Jul 14, 2014 at 10:55:51AM +0300, Mikko Perttunen wrote:
>>>> On 11/07/14 19:01, Mikko Perttunen wrote:
>>>>> On 07/11/2014 05:51 PM, Thierry Reding wrote:
>>>>>> On Fri, Jul 11, 2014 at 05:18:30PM +0300, Mikko Perttunen wrote:
>>>>>>> ...
>>>>>> ...
>>>>>
>>>>> In this case, all the registers that will be written are such that the
>>>>> MC driver will never need to write them. They are shadowed registers,
>>>>> meaning that all writes are stored and are only effective starting from
>>>>> the next time the EMC rate change state machine is activated, so writing
>>>>> them from anywhere except than the EMC driver would be pointless.
>>>>>
>>>>> I can find two users of these registers in downstream:
>>>>> 1) mc.c saves and loads them on suspend/restore (I don't know why, that
>>>>> shouldn't do anything. They will be overridden anyway during the next
>>>>> EMC rate change).
>>>>> 2) tegra12x_la.c reads MC_EMEM_ARB_MISC0 during a core_initcall to
>>>>> calculate a value which it then writes to a register that is also
>>>>> shadowed and that is part of downstream burst registers so that doesn't
>>>>> do anything either.
>>>>>
>>>>> The reason I implemented two ways to specify the MC register area was
>>>>> that this could be merged before an MC driver and retain
>>>>> backwards-compatibility after the MC driver arrives.
>>>>>
>>>>> If this is not acceptable, we can certainly wait for the MC driver to be
>>>>> merged first. (Although with the general rate of things, I hope I won't
>>>>> be back at school at that point..) I assume that this is blocked on the
>>>>> IOMMU bindings discussion? In that case, there are several options: the
>>>>> MC driver could have its own tables for each EMC rate or we could just
>>>>> make the EMC tables global (i.e. not under the EMC node). In any case,
>>>>> the MC driver would need to implement a function that would just write
>>>>> these values but be guaranteed to not do anything else, since that could
>>>>> cause nasty things during the EMC rate change sequence.
>>>>
>>>> Having taken another look at the code, I don't think the MC driver could do
>>>> anything that bad. There are also two other places where the EMC driver
>>>> needs to read MC registers: Inside the sequence, it reads a register but
>>>> discards its contents. According to comments, this acts as a memory barrier,
>>>> probably for the preceding step that writes into MC memory. If the register
>>>> writes are moved to the MC driver, it could also handle that. In another
>>>> place it reads the number of RAM modules from a MC register. The MC driver
>>>> could export this as another function.
>>>
>>> Exporting this functionality from the MC driver is the right thing to do
>>> in my opinion.
>>
>> Ok, let's do that then. Do you think I could make a bare-bones MC driver to
>> support the EMC driver before your MC driver with IOMMU/LA is ready? Can the
>> MC device tree node be stabilized yet? Of course, if things go well, that
>> concern might turn out to be unnecessary.
>
> Well, at this point this isn't 3.17 material anyway, so there's no need
> to rush things.

Very true.

> I'd prefer to take a patch on top of my proposed MC
> driver patch in anticipation of merging that for 3.18. But if it turns
> out that for whatever reason we can't do that, having a separate patch
> makes it easy to extract the changes into a bare-bones driver.

Yes, this sounds sensible. I'll make such a patch. I suppose having 
another timings table in the MC node with just the rate and 
mc-burst-data would separate the concerns best. It occurs to me that we 
could also write the regs in the pre-rate change notifier, but this 
would turn the dependency around and would mean that the regs are not 
written when entering backup rates. The latter shouldn't be a problem 
but the reversed dependency would, so I guess a custom function is the 
way to go, and we need to add at least one anyway.

The downstream kernel also overwrites most LA registers during EMC rate 
change without regard for the driver-set values, and we might have to 
read those values from the device tree too. Upstream can do this in rate 
change notifiers if needed. I'll look into this a bit more.

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>
