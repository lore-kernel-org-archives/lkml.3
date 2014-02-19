Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaBSMsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:48:35 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33345 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaBSMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:48:21 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 2/4] of: reimplement the matching method for __of_match_node()
To: Kevin Hao <haokexin@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392797745-7561-1-git-send-email-haokexin@gmail.com>
References: <20140219075812.GE14031@pek-khao-d1.corp.ad.wrs.com> < 1392797745-7561-1-git-send-email-haokexin@gmail.com>
Date: Wed, 19 Feb 2014 12:48:13 +0000
Message-Id: <20140219124813.8FD66C4088D@trevor.secretlab.ca>
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
>  	const char* cp;
>  	int cplen, l;
> +	int score = 0;
>  
>  	cp = __of_get_property(device, "compatible", &cplen);
>  	if (cp == NULL)
>  		return 0;
>  	while (cplen > 0) {
> -		if (of_compat_cmp(cp, compat, strlen(compat)) == 0)
> +		score++;
> +		if (of_compat_cmp(cp, compat, strlen(compat)) == 0) {
> +			if (pscore)
> +				*pscore = score;
>  			return 1;
> +		}
>  		l = strlen(cp) + 1;
>  		cp += l;
>  		cplen -= l;
> @@ -368,6 +375,15 @@ static int __of_device_is_compatible(const struct device_node *device,
>  /** Checks if the given "compat" string matches one of the strings in
>   * the device's "compatible" property
>   */
> +static int __of_device_is_compatible(const struct device_node *device,
> +				     const char *compat)
> +{
> +	return __of_device_is_compatible_score(device, compat, NULL);
> +}
> +
> +/** Checks if the given "compat" string matches one of the strings in
> + * the device's "compatible" property
> + */
>  int of_device_is_compatible(const struct device_node *device,
>  		const char *compat)
>  {
> @@ -734,25 +750,55 @@ static
>  const struct of_device_id *__of_match_node(const struct of_device_id *matches,
>  					   const struct device_node *node)
>  {
> +	const struct of_device_id *best_match = NULL;
> +	int best_score = 0;
> +
>  	if (!matches)
>  		return NULL;
>  
>  	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
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
> +		int score = 0;
> +
> +		/*
> +		 * Matching compatible is better than matching type and name,
> +		 * and the specific compatible is better than the general.
> +		 */
> +		if (matches->compatible[0]) {
> +			if (__of_device_is_compatible_score(node,
> +						matches->compatible, &score))
> +				score = INT_MAX - 4 * score;
> +			else
> +				score = INT_MIN;
> +		}
> +
> +		/*
> +		 * Matching type is better than matching name, but matching
> +		 * both is even better than that.
> +		 */
> +		if (matches->type[0]) {
> +			if (node->type && !strcmp(matches->type, node->type))
> +				score += 2;
> +			else
> +				score = INT_MIN;
> +		}
> +
> +		/* Matching name is a bit better than not */
> +		if (matches->name[0]) {
> +			if (node->name && !strcmp(matches->name, node->name))
> +				score++;
> +			else
> +				score = INT_MIN;
> +		}

All that mucking about with setting the score to INT_MIN is pretty ugly.
I've reworked the patch to 'continue;' whenever one of the above matches
fail. That completely eliminates any possibility of accepting an entry
that has a failed match. Here's my diff. I'll merge this change into the
patch before committing. All of the test cases still pass with my
rework.

---

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 8f79f006d86f..fcb65d27d071 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -756,7 +756,7 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 	if (!matches)
 		return NULL;
 
-	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
+	for (; matches->name[0] || matches->type[0] || matches->compatible[0]; matches++) {
 		int score = 0;
 
 		/*
@@ -764,11 +764,10 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 		 * and the specific compatible is better than the general.
 		 */
 		if (matches->compatible[0]) {
-			if (__of_device_is_compatible_score(node,
+			if (!__of_device_is_compatible_score(node,
 						matches->compatible, &score))
-				score = INT_MAX - 4 * score;
-			else
-				score = INT_MIN;
+				continue;
+			score = INT_MAX - 4 * score;
 		}
 
 		/*
@@ -776,26 +775,22 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 		 * both is even better than that.
 		 */
 		if (matches->type[0]) {
-			if (node->type && !strcmp(matches->type, node->type))
-				score += 2;
-			else
-				score = INT_MIN;
+			if (!node->type || strcmp(matches->type, node->type))
+				continue;
+			score += 2;
 		}
 
 		/* Matching name is a bit better than not */
 		if (matches->name[0]) {
-			if (node->name && !strcmp(matches->name, node->name))
-				score++;
-			else
-				score = INT_MIN;
+			if (!node->name || strcmp(matches->name, node->name))
+				continue;
+			score++;
 		}
 
 		if (score > best_score) {
 			best_match = matches;
 			best_score = score;
 		}
-
-		matches++;
 	}
 
 	return best_match;

