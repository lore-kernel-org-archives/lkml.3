Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3B1Ty3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:54:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18285 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3B1Ty1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:54:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Feb 2013 11:48:55 -0800
Message-ID: <512FB5F0.3090805@nvidia.com>
Date: Thu, 28 Feb 2013 14:54:24 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-3-git-send-email-rklein@nvidia.com> <5127CBD9.9050501@wwwdotorg.org> <5127E95E.4010500@nvidia.com> <5127F8B5.10002@wwwdotorg.org>
In-Reply-To: <5127F8B5.10002@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2013 6:01 PM, Stephen Warren wrote:
> On 02/22/2013 02:55 PM, Rhyland Klein wrote:
>> On 2/22/2013 2:49 PM, Stephen Warren wrote:
>>> On 02/21/2013 04:11 PM, Rhyland Klein wrote:
>>>> With the growing support for dt, it make sense to try to make use of
>>>> dt features to make the general code cleaner. This patch is an
>>>> attempt to commonize how chargers and their supplies are linked.
>>>>
>>>> Following common dt convention, the "supplied-to" char** list is
>>>> replaced with phandle lists defined in the supplies which contain
>>>> phandles of their suppliers.
>>>>
>>>> This has the effect however of introducing an inversion in the internal
>>>> mechanics of how this information is stored. In the case of non-dt,
>>>> the char** list of supplies is stored in the charger. In the dt case,
>>>> a device_node * list is stored in the supplies of their chargers,
>>>> however this seems to be the only way to support this.
>>> When parsing the DT, you can convert from phandle (or struct device_node
>>> *) to the name of the referenced supply by simple lookup. So, you could
>>> store supply names rather than device_node *. Can't you then also fill
>>> in the referenced supply's existing char** list of supplies?
>>>
>>> Of course, making this interact-with/use -EPROBE_DEFERRED might be
>>> challenging, since this would be operating in the inverse order to other
>>> producer/consumer relationships, which might cause loops.
>> The main problem I ran into when I was essentially trying to do this,
>> was that the list of names that
>> are used to match the power_supplies are the strings set as "name" in
>> the power_supply structs. This
>> doesn't get set automatically based on their nodes, and it is currently
>> up to each driver to define their
>> own name.
>>
>> For example, the sbs-battery driver uses the name "sbs-XXX" where XX is
>> its dev_name. Other drivers
>> use "%s-$%d" as i2c_device_id->name, + instance number. Then the only
>> solution I see is to require a new
>> property that defines the power-supply's name in the devicetree.
>>
>> This solution with device_nodes, while not ideal, seems the be the best
>> bet from what I see. Maybe
>> someone else has a better idea.
> For other resource types, this is handled by the (phandle -> whatever)
> conversion process actually being a function call on the referenced
> object, so that the driver code for it can look up the data in the
> actual device/... object etc. See the various .of_xlate functions that
> exist in the kernel.

I think this makes sense assuming we can change the existing supplies_to 
property
to match this style so that there isn't an inversion in the 2 paths.

Then I think the idea of an of_xlate function would work fine given that 
there are no
circular dependencies (causes issues with -EPROBE_DEFER). If that is the 
case, then
we could add a step to power_supply registration where it would generate the
char * list of supplies and store it in the power_supply being 
registered. In that way,
from then on, it wouldn't matter how the power_supply was registered, 
and the list
of supplies would be the same in either case.

Anton, David, have you seen it, or can you potentially see a case where 
circular
dependencies could arise? I can't but maybe you know of a situation I don't.

I will start working on patches to support this, including changing the way
supplied_to currently works, while I await answers whether or not it 
would be
acceptable.

-rhyland

-- 
nvpublic

