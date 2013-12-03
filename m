Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3LCUO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:14:26 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48294 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab3LCUOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:14:23 -0500
Date: Tue, 3 Dec 2013 22:14:19 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Scott Wood <scottwood@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] OF: base: match each node compatible against all
 given matches first
In-Reply-To: <1386078720-8756-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.SOC.1.00.1312032210480.25191@math.ut.ee>
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com> <1386078720-8756-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently, of_match_node compares each given match against all node's
> compatible strings with of_device_is_compatible.
> 
> To achieve multiple compatible strings per node with ordering from
> specific to generic, this requires given matches to be ordered from
> specific to generic. For most of the drivers this is not true and also
> an alphabetical ordering is more sane there.
> 
> Therefore, this patch modifies of_match_node to match each of the node's
> compatible strings against all given matches first, before checking the
> next compatible string. This implies that node's compatibles are ordered
> from specific to generic while given matches can be in any order.

I think I am on the CC: list because of a CPU detection problem report 
on sparc64 (183912d352a242a276a7877852f107459a13aff9 (of: move 
of_get_cpu_node implementation to DT core library) caused trouble and 
was reverted). So while your V2 patch does not cause any visible harm on 
the same Sun E3500, my gut feeling is that an additional patch would be 
needed to actually test it (a patch like 
183912d352a242a276a7877852f107459a13aff9).

Is this correct or am I missing something?

> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v1->v2:
> - Allow checks against nodes with no compatible (Reported by Rob Herring)
> - Add some comments
> 
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Meelis Roos <mroos@linux.ee>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Scott Wood <scottwood@freescale.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/of/base.c |   53 +++++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f807d0e..8d007d8 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -731,24 +731,42 @@ static
>  const struct of_device_id *__of_match_node(const struct of_device_id *matches,
>  					   const struct device_node *node)
>  {
> +	const char *cp;
> +	int cplen, l;
> +
>  	if (!matches)
>  		return NULL;
>  
> -	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
> -		int match = 1;
> -		if (matches->name[0])
> -			match &= node->name
> -				&& !strcmp(matches->name, node->name);
> -		if (matches->type[0])
> -			match &= node->type
> -				&& !strcmp(matches->type, node->type);
> -		if (matches->compatible[0])
> -			match &= __of_device_is_compatible(node,
> -							   matches->compatible);
> -		if (match)
> -			return matches;
> -		matches++;
> -	}
> +	cp = __of_get_property(node, "compatible", &cplen);
> +	do {
> +		const struct of_device_id *m = matches;
> +
> +		/* Check against matches with current compatible string */
> +		while (m->name[0] || m->type[0] || m->compatible[0]) {
> +			int match = 1;
> +			if (m->name[0])
> +				match &= node->name
> +					&& !strcmp(m->name, node->name);
> +			if (m->type[0])
> +				match &= node->type
> +					&& !strcmp(m->type, node->type);
> +			if (m->compatible[0])
> +				match &= cp
> +					&& !of_compat_cmp(m->compatible, cp,
> +							strlen(m->compatible));
> +			if (match)
> +				return m;
> +			m++;
> +		}
> +
> +		/* Get node's next compatible string */ 
> +		if (cp) {
> +			l = strlen(cp) + 1;
> +			cp += l;
> +			cplen -= l;
> +		}
> +	} while (cp && (cplen > 0));
> +
>  	return NULL;
>  }
>  
> @@ -757,7 +775,10 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
>   *	@matches:	array of of device match structures to search in
>   *	@node:		the of device structure to match against
>   *
> - *	Low level utility function used by device matching.
> + *	Low level utility function used by device matching. Matching order
> + *	is to compare each of the node's compatibles with all given matches
> + *	first. This implies node's compatible is sorted from specific to
> + *	generic while matches can be in any order.
>   */
>  const struct of_device_id *of_match_node(const struct of_device_id *matches,
>  					 const struct device_node *node)
> 

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
