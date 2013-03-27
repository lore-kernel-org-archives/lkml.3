Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3C0VMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:12:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2255 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3C0VMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:12:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Mar 2013 14:12:11 -0700
Message-ID: <515360C0.1040108@nvidia.com>
Date: Wed, 27 Mar 2013 17:12:32 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [REPOST Patch v1 2/3] power: power_supply: Add core support for
 supplied_from
References: <1364264690-2124-1-git-send-email-rklein@nvidia.com> <1364264690-2124-3-git-send-email-rklein@nvidia.com> <51531E92.9070805@wwwdotorg.org>
In-Reply-To: <51531E92.9070805@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/2013 12:30 PM, Stephen Warren wrote:
> On 03/25/2013 08:24 PM, Rhyland Klein wrote:
>> This patch adds support for supplies to register a list of char *'s
>> which represent the list of supplies which supply them. This is the
>> opposite as the supplied_to list.
>>
>> This change maintains support for supplied_to until all drivers which
>> make use of it already are converted.
> 
>> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> 
>> +static int __power_supply_is_supplied_by(struct power_supply *supplier,
>> +					 struct power_supply *supply)
> 
> Shouldn't this function return a Boolean since it's "is" something? At
> least, 1 for yes 0 for no would be more comprehensible than 0 for yes
> and error for no?

Yes, 1 or 0 or a boolean makes much more sense. I think this is carry
over from a previous iteration.

> 
>> +{
>> +	int i;
>> +
>> +	if (!supply->supplied_from && !supplier->supplied_to)
>> +		return -EINVAL;
>> +
>> +	/* Support both supplied_to and supplied_from modes */
>> +	if (supply->supplied_from) {
>> +		for (i = 0; i < supply->num_supplies; i++) {
>> +			if (!supplier->name)
>> +				continue;
> 
> That test is loop invariant. Why put it inside the loop?

Will move before the loop.

> 
> Why wouldn't a supply have a name? The loop in
> __power_supply_changed_work() that this function replaces doesn't test
> for NULL names.

Looking at the registration path for a power_supply, the only check that
might catch a power_supply with no name being registered is the call to
kobject_set_name. From looking into it I am not sure if would explicitly
fail if there was no name set, meaning that it would be possible for
power_supplies to not have a name. Therefore, I figured it would be
harmless to add a check here just to be sure before I accessed a
possibly NULL value.

> 
>> +			if (!strcmp(supplier->name, supply->supplied_from[i]))
>> +				return 0;
> 
> Don't you want to return something true here, so that the if block
> inside __power_supply_changed_work() is executed in this case?
> 
> Similar comment for the else block.

Yes I think switching to boolean will cleanup the return codes and make
them make more sense.

> 
>>  static int __power_supply_changed_work(struct device *dev, void *data)
> 
>> -	for (i = 0; i < psy->num_supplicants; i++)
>> -		if (!strcmp(psy->supplied_to[i], pst->name)) {
>> -			if (pst->external_power_changed)
>> -				pst->external_power_changed(pst);
>> -		}
>> +	if (__power_supply_is_supplied_by(psy, pst)) {
>> +		if (pst->external_power_changed)
>> +			pst->external_power_changed(pst);
>> +	}
>> +
>>  	return 0;
>>  }
> 

Thanks.

-rhyland

-- 
nvpublic
