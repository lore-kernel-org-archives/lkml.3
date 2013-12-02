Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3LBOAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:00:34 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49474 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3LBOAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:00:30 -0500
Message-ID: <529C927A.9000303@gmail.com>
Date: Mon, 02 Dec 2013 08:00:26 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Meelis Roos <mroos@linux.ee>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] OF: base: match each node compatible against all given
 matches first
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131202120300.GA12793@ulmo.nvidia.com>
In-Reply-To: <20131202120300.GA12793@ulmo.nvidia.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:03 AM, Thierry Reding wrote:
> On Thu, Nov 28, 2013 at 07:36:25PM +0100, Sebastian Hesselbarth 
> wrote:
>> Currently, of_match_node compares each given match against all 
>> node's compatible strings with of_device_is_compatible.
>> 
>> To achieve multiple compatible strings per node with ordering 
>> from specific to generic, this requires given matches to be 
>> ordered from specific to generic. For most of the drivers this
>> is not true and also an alphabetical ordering is more sane
>> there.
>> 
>> Therefore, this patch modifies of_match_node to match each of
>> the node's compatible strings against all given matches first,
>> before checking the next compatible string. This implies that
>> node's compatibles are ordered from specific to generic while
>> given matches can be in any order.
>> 
>> Signed-off-by: Sebastian Hesselbarth 
>> <sebastian.hesselbarth@gmail.com> --- Cc: Grant Likely 
>> <grant.likely@linaro.org> Cc: Rob Herring 
>> <rob.herring@calxeda.com> Cc: Benjamin Herrenschmidt 
>> <benh@kernel.crashing.org> Cc: Russell King 
>> <linux@arm.linux.org.uk> Cc: devicetree@vger.kernel.org Cc: 
>> linux-arm-kernel@lists.infradead.org Cc: 
>> linux-kernel@vger.kernel.org --- drivers/of/base.c |   47 
>> ++++++++++++++++++++++++++++++++--------------- 1 file changed, 
>> 32 insertions(+), 15 deletions(-)
> 
> Hi Sebastian,
> 
> I think you're one in a long line of people attempting to fix
> this. I tried myself over a year ago (commit 107a84e61cdd 'of:
> match by compatible property first') but it caused a subtle
> regression late in the release cycle and was reverted (commit
> bc51b0c22ceb 'Revert "of: match by compatible property first").
> 
> Only recently there was another attempt [0] but it's pretty much 
> equivalent to what I did back then.
> 
> That said, I think you might actually have nailed it with this 
> patch. From what I remember all earlier attempt failed because
> they didn't match all compatible/name/type combinations properly.
> I'm adding a few people on Cc who were involved with the other
> patches, perhaps they can give your patch a spin and see if it
> fixes things for them.

I agree and the change here is simple enough I think the chances of a
regression are low. But there is one issue...

> 
> Thierry
> 
> [0]: https://lkml.org/lkml/2013/10/3/585
> 
>> diff --git a/drivers/of/base.c b/drivers/of/base.c index 
>> 7d4c70f..183a9c7 100644 --- a/drivers/of/base.c +++ 
>> b/drivers/of/base.c @@ -713,23 +713,37 @@ static const struct 
>> of_device_id *__of_match_node(const struct of_device_id *matches,
>> const struct device_node *node) { +	const char *cp; + int cplen,
>> l; + if (!matches) return NULL;
>> 
>> -	while (matches->name[0] || matches->type[0] || 
>> matches->compatible[0]) { -		int match = 1; -		if 
>> (matches->name[0]) -			match &= node->name -				&& 
>> !strcmp(matches->name, node->name); -		if (matches->type[0]) - 
>> match &= node->type -				&& !strcmp(matches->type, node->type);
>> - if (matches->compatible[0]) -			match &= 
>> __of_device_is_compatible(node, -							   matches->compatible);
>>  -		if (match) -			return matches; -		matches++; +	cp = 
>> __of_get_property(node, "compatible", &cplen); +	if (!cp) + 
>> return NULL;

No compatible property and matching on name and/or type only is valid.
Remove the if here and changing the following should work:

>> + +	while (cplen > 0) {

do {

>> +		const struct of_device_id *m = matches; + +		while
>> (m->name[0] || m->type[0] || m->compatible[0]) { +			int match =
>> 1; +			if (m->name[0]) +				match &= node->name +					&&
>> !strcmp(m->name, node->name); +			if (m->type[0]) +				match &=
>> node->type + && !strcmp(m->type, node->type); +			if
>> (m->compatible[0])

if (cp && m->compatible[0])

>> +				match &= !of_compat_cmp(cp, m->compatible, + 
>> strlen(m->compatible)); +			if (match) +				return m; +			m++; + 
>> } +		l = strlen(cp) + 1; +		cp += l; +		cplen -= l; }


} while (cp && (cplen > 0));


>> return NULL; } @@ -739,7 +753,10 @@ const struct of_device_id 
>> *__of_match_node(const struct of_device_id *matches, *	@matches: 
>> array of of device match structures to search in *	@node:		the
>> of device structure to match against * - *	Low level utility 
>> function used by device matching. + *	Low level utility function 
>> used by device matching. Matching order + *	is to compare each
>> of the node's compatibles with all given matches + *	first. This 
>> implies node's compatible is sorted from specific to + *	generic 
>> while matches can be in any order. */ const struct of_device_id 
>> *of_match_node(const struct of_device_id *matches, const struct 
>> device_node *node) -- 1.7.10.4
>> 
>> 
>> _______________________________________________ linux-arm-kernel 
>> mailing list linux-arm-kernel@lists.infradead.org 
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

