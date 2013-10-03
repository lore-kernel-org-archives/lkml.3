Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3JCUiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:38:01 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:59325 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3JCUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:37:59 -0400
Message-ID: <524DD5A6.6020204@gmail.com>
Date: Thu, 03 Oct 2013 15:37:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1380826284-18381-1-git-send-email-mkl@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 01:51 PM, Marc Kleine-Budde wrote:
> The function of_match_device() should tell if a struct device matches an
> of_device_id list and return the specific entry of that table matches the
> device best.
> 
> The underlying __of_match_node() implements the wrong search algorithm. It
> iterates over the list of of_device_ids, comparing the first compatible with
> _all_ compatibles of the struct device, then the second compatible of
> of_device_id and so on.
> 
> This leads to a problem, if the device has more than one compatible that match
> the of_device_id list. The implemented search algorithm may find not the "best"
> match. As the compatible list in the device is sorted from most to least
> specific.
> 
> For example:
> 
> The imx28.dtsi gives this compatible string for its CAN core:
> 
>> 	compatible = "fsl,imx28-flexcan", "fsl,p1010-flexcan";
> 
> The flexcan driver defines:
> 
>> static const struct of_device_id flexcan_of_match[] = {
>> 	{ .compatible = "fsl,p1010-flexcan", .data = &fsl_p1010_devtype_data, },
>> 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
>> 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
>> 	{ /* sentinel */ },
>> };
> 
> The "p1010" was the first Freescale SoC with the flexcan core. But this SoC has
> a bug, so a workaround has to be enabled in the driver. The mx28 has this bug
> fixed, so we don't need this quite costly workaround.
> 
> The __of_match_node() will compare:
> 
>     from  of_device_id		from device
>     fsl,p1010-flexcan		fsl,imx28-flexcan
>     fsl,p1010-flexcan		fsl,p1010-flexcan	-> MATCH
> 
> The of_match_device() function as it currently is implemented will always
> return p1010 not the mx28.
> 
> This patch fixes the problem by exchanging outer and inner loop. The first
> compatible of a device is compared against all compatible from the of_device_id
> list, then the second device compatible and so on.

This has been an issue for some time. A fix has been attempted before
and reverted if you look at the git history:

commit bc51b0c22cebf5c311a6f1895fcca9f78efd0478
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 10 12:49:32 2012 -0700

    Revert "of: match by compatible property first"

    This reverts commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6.

    Meelis Roos reports a regression since 3.5-rc5 that stops Sun Fire V100
    and Sun Netra X1 sparc64 machines from booting, hanging after enabling
    serial console.  He bisected it to commit 107a84e61cdd.

    Rob Herring explains:
     "The problem is match combinations of compatible plus name and/or type
      fail to match correctly.  I have a fix for this, but given how late it
      is for 3.5 I think it is best to revert this for now.  There could be
      other cases that rely on the current although wrong behavior.  I will
      post an updated version for 3.6."

    Bisected-and-reported-by: Meelis Roos <mroos@linux.ee>
    Requested-by: Rob Herring <rob.herring@calxeda.com>
    Cc: Thierry Reding <thierry.reding@avionic-design.de>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

There was also a fix attempted for this and the discussion here:

http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg60163.html

You patch would hit the same issues I believe.

Rob

> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/of/base.c | 40 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 865d3f6..5bff2fe 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -349,6 +349,35 @@ static int __of_device_is_compatible(const struct device_node *device,
>  	return 0;
>  }
>  
> +/** Returns the specific of_device_id, if the it matches one of the
> + * strings in the device's "compatible" property
> + */
> +static
> +const struct of_device_id *__of_device_matches_compatible(const struct device_node *device,
> +							  const struct of_device_id *matches)
> +{
> +	const struct of_device_id *m;
> +	const char* cp;
> +	int cplen, l;
> +
> +	cp = __of_get_property(device, "compatible", &cplen);
> +	if (cp == NULL)
> +		return NULL;
> +	while (cplen > 0) {
> +		m = matches;
> +		while (m->compatible[0]) {
> +			if (of_compat_cmp(cp, m->compatible, strlen(m->compatible)) == 0)
> +				return m;
> +			m++;
> +		}
> +		l = strlen(cp) + 1;
> +		cp += l;
> +		cplen -= l;
> +	}
> +
> +	return NULL;
> +}
> +
>  /** Checks if the given "compat" string matches one of the strings in
>   * the device's "compatible" property
>   */
> @@ -717,22 +746,23 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
>  {
>  	if (!matches)
>  		return NULL;
> -
> -	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
> +	while (matches->name[0] || matches->type[0]) {
>  		int match = 1;
> +
>  		if (matches->name[0])
>  			match &= node->name
>  				&& !strcmp(matches->name, node->name);
>  		if (matches->type[0])
>  			match &= node->type
>  				&& !strcmp(matches->type, node->type);
> -		if (matches->compatible[0])
> -			match &= __of_device_is_compatible(node,
> -							   matches->compatible);
>  		if (match)
>  			return matches;
>  		matches++;
>  	}
> +
> +	if (matches->compatible[0])
> +		return __of_device_matches_compatible(node, matches);
> +
>  	return NULL;
>  }
>  
> 

