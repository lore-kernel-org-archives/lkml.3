Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaFMHHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:07:40 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42452 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFMHHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:07:38 -0400
Subject: Re: [RFC PATCH]  OF: fix of_find_node_by_path() assumption that of_allnodes is root
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <539A91E2.7000606@gmail.com>
Date: Fri, 13 Jun 2014 10:07:33 +0300
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <CC628CCC-7C30-48BA-8A2A-49E60ED72854@konsulko.com>
References: <539A91E2.7000606@gmail.com>
To: frowand.list@gmail.com
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Jun 13, 2014, at 8:53 AM, Frank Rowand wrote:

> From: Frank Rowand <frank.rowand@sonymobile.com>
> 
> Pantelis Antoniou reports that of_find_node_by_path() is borked because
> of_allnodes is not guaranteed to contain the root of the tree after using
> any of the dynamic update functions because some other nodes ends up as
> of_allnodes.
> 
> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases
> 
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
> 
> 
> Pantelis,
> 
> Can you test whether the problem you reported in irc?
> 
> This patch has not been tested, not even compile tested.
> 

I can verify that this fixes the problem. Please make sure this gets 
applied to mainline otherwise every arch which updates DT on runtime
is going to break in subtle ways.

Regards

-- Pantelis

Tested-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

> 
> drivers/of/base.c |    8 	6 +	2 -	0 !
> 1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/of/base.c
> ===================================================================
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1948,6 +1948,9 @@ int of_reconfig_notify(unsigned long act
> 
> /**
>  * of_attach_node - Plug a device node into the tree and global list.
> + *
> + * Put the device node after of_allnodes in the global list so that
> + * of_allnodes remains the root.
>  */
> int of_attach_node(struct device_node *np)
> {
> @@ -1958,11 +1961,12 @@ int of_attach_node(struct device_node *n
> 	if (rc)
> 		return rc;
> 
> +	BUG_ON(!of_allnodes);
> 	raw_spin_lock_irqsave(&devtree_lock, flags);
> 	np->sibling = np->parent->child;
> -	np->allnext = of_allnodes;
> +	np->allnext = of_allnodes->allnext;
> 	np->parent->child = np;
> -	of_allnodes = np;
> +	of_allnodes->allnext = np;
> 	of_node_clear_flag(np, OF_DETACHED);
> 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

