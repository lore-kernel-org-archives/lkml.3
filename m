Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaBSM6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:58:07 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38876 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaBSM6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:58:04 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 2/4] of: reimplement the matching method for __of_match_node()
To: Kevin Hao <haokexin@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392797745-7561-1-git-send-email-haokexin@gmail.com>
References: <20140219075812.GE14031@pek-khao-d1.corp.ad.wrs.com> < 1392797745-7561-1-git-send-email-haokexin@gmail.com>
Date: Wed, 19 Feb 2014 12:57:55 +0000
Message-Id: <20140219125755.9FA9CC4088D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 16:15:45 +0800, Kevin Hao <haokexin@gmail.com> wrote:
> In the current implementation of __of_match_node(), it will compare
> each given match entry against all the node's compatible strings
> with of_device_is_compatible().
> 
> To achieve multiple compatible strings per node with ordering from
> specific to generic, this requires given matches to be ordered from
> specific to generic. For most of the drivers this is not true and
> also an alphabetical ordering is more sane there.
> 
> Therefore, we define a following priority order for the match, and
> then scan all the entries to find the best match.
>   1. specific compatible && type && name
>   2. specific compatible && type
>   3. specific compatible && name
>   4. specific compatible
>   5. general compatible && type && name
>   6. general compatible && type
>   7. general compatible && name
>   8. general compatible
>   9. type && name
>   10. type
>   11. name
> 
> This is based on some pseudo-codes provided by Grant Likely.
> 
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> [grant.likely: Changed multiplier to 4 which makes more sense]
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
> v3: Also need to bail out when there does have a compatible member in match
>     entry, but it doesn't match with the device node's compatible.
>  
> v2: Fix the bug such as we get the same score for the following two match
> entries:
> 	name2 { }
> 
> 	struct of_device_id matches[] = {
> 		{.name = "name2", },
> 		{.name = "name2", .type = "type1", },
> 		{}
> 	};

BTW, I prefer patch version information like the above to appear before
the '---' line so that it shows up in the final commit log. It is often
useful to have the revision history in mainline.

> 
>  drivers/of/base.c | 96 ++++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 77 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index ba195fbce4c6..8f79f006d86f 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -342,21 +342,28 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
>  }
>  EXPORT_SYMBOL(of_get_cpu_node);
>  
> -/** Checks if the given "compat" string matches one of the strings in
> - * the device's "compatible" property
> +/*
> + * Compare with the __of_device_is_compatible, this will return a score for the
> + * matching strings. The smaller value indicates the match for the more specific
> + * compatible string.
>   */
> -static int __of_device_is_compatible(const struct device_node *device,
> -				     const char *compat)
> +static int __of_device_is_compatible_score(const struct device_node *device,
> +				     const char *compat, int *pscore)
>  {

Another note: I've removed this new function. There are only three users
of __of_device_is_compatible, and they are all in this file. Adding a
field is just fine. I'm also considering rolling the name and
device_type checks into this function, but that goes beyond the bug fix
so it will wait until the next merge window.

g.
