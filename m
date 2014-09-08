Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaIHNaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:30:23 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51133 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaIHNaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:30:21 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: make sure of_alias is initialized before accessing
 it
To: Laurentiu Tudor <b10716@freescale.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Laurentiu Tudor <Laurentiu.Tudor@freescale.com>
In-Reply-To: <53FDE6A3.3080303@freescale.com>
References: <53FDE6A3.3080303@freescale.com>
Date: Mon, 08 Sep 2014 14:29:56 +0100
Message-Id: <20140908132956.646FEC40AE5@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 17:09:39 +0300, Laurentiu Tudor <b10716@freescale.com> wrote:
> Simply swap of_alias and of_chosen initialization so
> that of_alias ends up read first. This must be done
> because it is accessed couple of lines below when
> trying to initialize the of_stdout using the alias
> based legacy method.
> 
> [Fixes a752ee5 - tty: Update hypervisor tty drivers to                          
> use core stdout parsing code]
> 
> Signed-off-by: Laurentiu Tudor <Laurentiu.Tudor@freescale.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/of/base.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d8574ad..52f8506 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1847,6 +1847,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  {
>  	struct property *pp;
>  
> +	of_aliases = of_find_node_by_path("/aliases");
> +	if (!of_aliases)
> +		return;
> +
>  	of_chosen = of_find_node_by_path("/chosen");
>  	if (of_chosen == NULL)
>  		of_chosen = of_find_node_by_path("/chosen@0");
> @@ -1862,10 +1866,6 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  			of_stdout = of_find_node_by_path(name);
>  	}
>  
> -	of_aliases = of_find_node_by_path("/aliases");
> -	if (!of_aliases)
> -		return;
> -

Close, but not quite. The 'if (!of_aliases)' test should not be moved.
Only the search for of_find_node_by_path(). I've fixed it up and
applied.

g.

>  	for_each_property_of_node(of_aliases, pp) {
>  		const char *start = pp->name;
>  		const char *end = start + strlen(start);
> -- 
> 1.8.3.1

