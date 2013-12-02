Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3LBOKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:10:01 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34589 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3LBOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:09:59 -0500
Message-ID: <529C94B2.3040408@gmail.com>
Date: Mon, 02 Dec 2013 15:09:54 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
To: Rob Herring <robherring2@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Meelis Roos <mroos@linux.ee>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] OF: base: match each node compatible against all given
 matches first
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131202120300.GA12793@ulmo.nvidia.com> <529C927A.9000303@gmail.com>
In-Reply-To: <529C927A.9000303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/13 15:00, Rob Herring wrote:
> On 12/02/2013 06:03 AM, Thierry Reding wrote:
>> On Thu, Nov 28, 2013 at 07:36:25PM +0100, Sebastian Hesselbarth
>> wrote:
>>> Currently, of_match_node compares each given match against all
>>> node's compatible strings with of_device_is_compatible.
>>>
>>> To achieve multiple compatible strings per node with ordering
>>> from specific to generic, this requires given matches to be
>>> ordered from specific to generic. For most of the drivers this
>>> is not true and also an alphabetical ordering is more sane
>>> there.
>>>
>>> Therefore, this patch modifies of_match_node to match each of
>>> the node's compatible strings against all given matches first,
>>> before checking the next compatible string. This implies that
>>> node's compatibles are ordered from specific to generic while
>>> given matches can be in any order.
>>>
>>> Signed-off-by: Sebastian Hesselbarth
[...]
>> That said, I think you might actually have nailed it with this
>> patch. From what I remember all earlier attempt failed because
>> they didn't match all compatible/name/type combinations properly.
>> I'm adding a few people on Cc who were involved with the other
>> patches, perhaps they can give your patch a spin and see if it
>> fixes things for them.
>
> I agree and the change here is simple enough I think the chances of a
> regression are low. But there is one issue...
>
>>
>> Thierry
>>
>> [0]: https://lkml.org/lkml/2013/10/3/585
>>
>>> diff --git a/drivers/of/base.c b/drivers/of/base.c index
>>> 7d4c70f..183a9c7 100644 --- a/drivers/of/base.c +++
>>> b/drivers/of/base.c @@ -713,23 +713,37 @@ static const struct
>>> of_device_id *__of_match_node(const struct of_device_id *matches,
>>> const struct device_node *node) { +	const char *cp; + int cplen,
>>> l; + if (!matches) return NULL;
>>>
>>> -	while (matches->name[0] || matches->type[0] ||
>>> matches->compatible[0]) { -		int match = 1; -		if
>>> (matches->name[0]) -			match &= node->name -				&&
>>> !strcmp(matches->name, node->name); -		if (matches->type[0]) -
>>> match &= node->type -				&& !strcmp(matches->type, node->type);
>>> - if (matches->compatible[0]) -			match &=
>>> __of_device_is_compatible(node, -							   matches->compatible);
>>>   -		if (match) -			return matches; -		matches++; +	cp =
>>> __of_get_property(node, "compatible", &cplen); +	if (!cp) +
>>> return NULL;
>
> No compatible property and matching on name and/or type only is valid.
> Remove the if here and changing the following should work:
>
>>> + +	while (cplen > 0) {
>
> do {
>
>>> +		const struct of_device_id *m = matches; + +		while
>>> (m->name[0] || m->type[0] || m->compatible[0]) { +			int match =
>>> 1; +			if (m->name[0]) +				match &= node->name +					&&
>>> !strcmp(m->name, node->name); +			if (m->type[0]) +				match &=
>>> node->type + && !strcmp(m->type, node->type); +			if
>>> (m->compatible[0])
>
> if (cp && m->compatible[0])
>
>>> +				match &= !of_compat_cmp(cp, m->compatible, +
>>> strlen(m->compatible)); +			if (match) +				return m; +			m++; +
>>> } +		l = strlen(cp) + 1; +		cp += l; +		cplen -= l; }
>
>
> } while (cp && (cplen > 0));

Rob,

although quoting somehow got messed up, I see the point. The pointer
arith right above loop end condition needs to be skipped too if !cp.

I will rework the loop to allow name/type matching with cp == NULL
and resend in a day or two.

Sebastian

