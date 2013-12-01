Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3LATAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:00:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52791 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3LATAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:00:13 -0500
Message-ID: <529B8739.60701@wwwdotorg.org>
Date: Sun, 01 Dec 2013 12:00:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCHv6+++ 01/13] of: introduce of_property_for_earch_phandle_with_args()
References: <20131121.191720.1487772262083864095.hdoyu@nvidia.com><528E577C.2050506@wwwdotorg.org><20131128.145818.1345100874304396564.hdoyu@nvidia.com> <20131129.134625.431945240074254704.hdoyu@nvidia.com>
In-Reply-To: <20131129.134625.431945240074254704.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 04:46 AM, Hiroshi Doyu wrote:
...
> Iterating over a property containing a list of phandles with arguments
> is a common operation for device drivers. This patch adds a new
> of_property_for_each_phandle_with_args() macro to make the iteration
> simpler.
> 
> Introduced a new struct "of_phandle_iter" to keep the state when
> iterating over the list.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
> v6+++:

Surely that's v9; "+++" is rather unusual.

> diff --git a/drivers/of/base.c b/drivers/of/base.c

> +void of_phandle_iter_next(struct of_phandle_iter *iter,
> +			  struct of_phandle_args *out_args)
> +{
> +	phandle phandle;
> +	struct device_node *dn;
> +	int i, count = iter->cell_count;
> +
> +	iter->err = -EINVAL;
> +	if (!iter->cells_name && !iter->cell_count)
> +		return;

Wasn't that already checked in _start()?

Why not set err = -EINVAL inside the if, rather than setting it to an
error value here by default, then having to over-write it at the end of
the function?

> +static void __of_phandle_iter_set(struct of_phandle_iter *iter,

This is only used in one place; why not simply inline this into
of_phandle_iter_start()? It would make the code simpler.

> +void of_phandle_iter_start(struct of_phandle_iter *iter,

> +	iter->cells_name = cells_name;
> +	iter->cell_count = cell_count;

Why not pass these values into of_phandle_iter_next() instead? There's
no need to pass them just to _start() so they can be read by _next()
instead.

> diff --git a/include/linux/of.h b/include/linux/of.h

> +/*
> + * keep the state at iterating a list of phandles with variable number
> + * of args
> + */
> +struct of_phandle_iter {
> +	int		err;
> +	const __be32	*cur;		/* current phandle */
> +	const __be32	*end;		/* end of the last phandle */

Can't you detect an error case by e.g. (cur == NULL) and thus avoid
requiring an explicit err field?

Together with removing:

> +	const char	*cells_name;
> +	int		cell_count;

... then you'd only be left with cur/end, so I think you could get away
without a struct at all, but simply "cur" as the iterator variable, plus
"end" as the one temp variable.
