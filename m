Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3C0QaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:30:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45498 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3C0QaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:30:24 -0400
Message-ID: <51531E92.9070805@wwwdotorg.org>
Date: Wed, 27 Mar 2013 10:30:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [REPOST Patch v1 2/3] power: power_supply: Add core support for
 supplied_from
References: <1364264690-2124-1-git-send-email-rklein@nvidia.com> <1364264690-2124-3-git-send-email-rklein@nvidia.com>
In-Reply-To: <1364264690-2124-3-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 08:24 PM, Rhyland Klein wrote:
> This patch adds support for supplies to register a list of char *'s
> which represent the list of supplies which supply them. This is the
> opposite as the supplied_to list.
> 
> This change maintains support for supplied_to until all drivers which
> make use of it already are converted.

> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c

> +static int __power_supply_is_supplied_by(struct power_supply *supplier,
> +					 struct power_supply *supply)

Shouldn't this function return a Boolean since it's "is" something? At
least, 1 for yes 0 for no would be more comprehensible than 0 for yes
and error for no?

> +{
> +	int i;
> +
> +	if (!supply->supplied_from && !supplier->supplied_to)
> +		return -EINVAL;
> +
> +	/* Support both supplied_to and supplied_from modes */
> +	if (supply->supplied_from) {
> +		for (i = 0; i < supply->num_supplies; i++) {
> +			if (!supplier->name)
> +				continue;

That test is loop invariant. Why put it inside the loop?

Why wouldn't a supply have a name? The loop in
__power_supply_changed_work() that this function replaces doesn't test
for NULL names.

> +			if (!strcmp(supplier->name, supply->supplied_from[i]))
> +				return 0;

Don't you want to return something true here, so that the if block
inside __power_supply_changed_work() is executed in this case?

Similar comment for the else block.

>  static int __power_supply_changed_work(struct device *dev, void *data)

> -	for (i = 0; i < psy->num_supplicants; i++)
> -		if (!strcmp(psy->supplied_to[i], pst->name)) {
> -			if (pst->external_power_changed)
> -				pst->external_power_changed(pst);
> -		}
> +	if (__power_supply_is_supplied_by(psy, pst)) {
> +		if (pst->external_power_changed)
> +			pst->external_power_changed(pst);
> +	}
> +
>  	return 0;
>  }

