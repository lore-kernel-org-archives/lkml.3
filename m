Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaFBPAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:00:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52830 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbaFBPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:00:09 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/base: Replace alias if it already exists
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Date: Mon, 02 Jun 2014 15:59:54 +0100
Message-Id: <20140602145959.7E669C426F6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Jun 2014 15:01:23 +0300, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> wrote:
> The current code unconditionally adds aliases without check if it already
> exists, so it is not possible to alter an alias, from board DT file for
> example. Fix that by replacing an alias if it already exists
> 

Can you describe a more detailed use-case for altering an alias?

g.

> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  drivers/of/base.c |   34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 03e7fc6..99215f0 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2036,6 +2036,23 @@ static void of_alias_add(struct alias_prop *ap, struct device_node *np,
>  		 ap->alias, ap->stem, ap->id, of_node_full_name(np));
>  }
>  
> +static int of_alias_replace(struct device_node *np, int id, const char *stem,
> +			    int stem_len)
> +{
> +	struct alias_prop *ap;
> +
> +	list_for_each_entry(ap, &aliases_lookup, link) {
> +		if (strncmp(ap->stem, stem, stem_len))
> +			continue;
> +
> +		if (np == ap->np) {
> +			ap->id = id;
> +			return 0;
> +		}
> +	}
> +
> +	return -ENODEV;
> +}
>  /**
>   * of_alias_scan - Scan all properties of 'aliases' node
>   *
> @@ -2092,13 +2109,16 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  		if (kstrtoint(end, 10, &id) < 0)
>  			continue;
>  
> -		/* Allocate an alias_prop with enough space for the stem */
> -		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
> -		if (!ap)
> -			continue;
> -		memset(ap, 0, sizeof(*ap) + len + 1);
> -		ap->alias = start;
> -		of_alias_add(ap, np, id, start, len);
> +		if (of_alias_replace(np, id, start, len)) {
> +			/* Allocate an alias_prop with enough space for the stem
> +			 */
> +			ap = dt_alloc(sizeof(*ap) + len + 1, 4);
> +			if (!ap)
> +				continue;
> +			memset(ap, 0, sizeof(*ap) + len + 1);
> +			ap->alias = start;
> +			of_alias_add(ap, np, id, start, len);
> +		}
>  	}
>  }
>  
> -- 
> 1.7.9.5
> 

