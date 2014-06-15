Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaFODmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:42:10 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37329 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaFODmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:42:08 -0400
Message-ID: <539D160E.5080208@gmail.com>
Date: Sat, 14 Jun 2014 20:42:06 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Grant Likely <grant.likely@linaro.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] OF: fix of_find_node_by_path() assumption that of_allnodes
 is root
References: <539A91E2.7000606@gmail.com> <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com> <CACxGe6sG+h7j9Npd-xR4-E13i=_p8OtbisgJv1PUzf981nGHUw@mail.gmail.com> <CACxGe6tv8H8yUYCs9N959T3KKDUDiDqJQ1LRfO5RJE3bxw5r5A@mail.gmail.com> <539D14CA.1060105@gmail.com> <539D1559.8080603@gmail.com>
In-Reply-To: <539D1559.8080603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2014 8:39 PM, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
> 
> of_find_node_by_path() is borked because of_allnodes is not guaranteed to
> contain the root of the tree after using any of the dynamic update functions
> because some other nodes ends up as of_allnodes.
> 
> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases
> Reported-by: pantelis.antoniou@konsulko.com
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
> 
> v2:
>   Remove change to function header, no longer needed.
>   Remove BUG_ON(), no longer needed.
>   Add np as np->parent->allnext instead of np->parent->allnext, as suggested

Aaaargh, cut and paste error, that should be:

    Add np as np->parent->allnext instead of of_allnodes->allnext, as suggested

>     by Grant Likely.
> 
> 
>  drivers/of/base.c |    4 	2 +	2 -	0 !
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/of/base.c
> ===================================================================
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1960,9 +1960,9 @@ int of_attach_node(struct device_node *n
>  
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
>  	np->sibling = np->parent->child;
> -	np->allnext = of_allnodes;
> +	np->allnext = np->parent->allnext;
> +	np->parent->allnext = np;
>  	np->parent->child = np;
> -	of_allnodes = np;
>  	of_node_clear_flag(np, OF_DETACHED);
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
> 

