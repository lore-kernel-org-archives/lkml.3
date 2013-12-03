Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3LCUOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:14:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55508 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3LCUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:14:23 -0500
Message-ID: <529E3B9A.50207@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:14:18 -0700
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
References: <20131128.145818.1345100874304396564.hdoyu@nvidia.com><20131129.134625.431945240074254704.hdoyu@nvidia.com><529B8739.60701@wwwdotorg.org> <20131202.130220.1404999403649937134.hdoyu@nvidia.com>
In-Reply-To: <20131202.130220.1404999403649937134.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 04:02 AM, Hiroshi Doyu wrote:
...
> Iterating over a property containing a list of phandles with arguments
> is a common operation for device drivers. This patch adds a new
> of_property_for_each_phandle_with_args() macro to make the iteration
> simpler.

> diff --git a/drivers/of/base.c b/drivers/of/base.c

> +const __be32 *of_phandle_iter_init(const struct device_node *np,
> +				   const char *list_name,
> +				   const __be32 **end)
> +{
> +	size_t bytes;
> +	const __be32 *cur;
> +
> +	cur = of_get_property(np, list_name, &bytes);
> +	if (bytes)
> +		*end = cur + bytes / sizeof(*cur);
> +
> +	return cur;
> +}

"bytes" doesn't seem like the correct thing to check in that if
statement. The property might exist but be zero length. Perhaps if (cur)
would be better, or just initializing *end in all cases (the value won't
be used if (!cur), so setting *end to a bogus value in that case won't
matter).

> +const __be32 *of_phandle_iter_next(const char *cells_name, int cell_count,
> +				   const __be32 *cur, const __be32 *end,
> +				   struct of_phandle_args *out_args)
...
> +	if (!cur)
> +		return NULL;
> +
> +	if (end - cur <= 0)
> +		return NULL;

Related, don't you want if (cur >= end) there; just compare the pointers
directly rather than explicitly calculating and testing the difference?
