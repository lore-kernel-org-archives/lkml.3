Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaFMNwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:52:39 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61139 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFMNwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:52:37 -0400
MIME-Version: 1.0
In-Reply-To: <539A91E2.7000606@gmail.com>
References: <539A91E2.7000606@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 13 Jun 2014 08:52:16 -0500
Message-ID: <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com>
Subject: Re: [RFC PATCH] OF: fix of_find_node_by_path() assumption that
 of_allnodes is root
To: Frank Rowand <frowand.list@gmail.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:53 AM, Frank Rowand <frowand.list@gmail.com> wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
>
> Pantelis Antoniou reports that of_find_node_by_path() is borked because
> of_allnodes is not guaranteed to contain the root of the tree after using
> any of the dynamic update functions because some other nodes ends up as
> of_allnodes.
>
> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases

Is it not possible to do a fix in of_find_node_by_path instead? I just
wonder if this could have any other unintended side-effects on
of_attach_node's behavior.

Rob

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
>
>  drivers/of/base.c |    8       6 +     2 -     0 !
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> Index: b/drivers/of/base.c
> ===================================================================
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1948,6 +1948,9 @@ int of_reconfig_notify(unsigned long act
>
>  /**
>   * of_attach_node - Plug a device node into the tree and global list.
> + *
> + * Put the device node after of_allnodes in the global list so that
> + * of_allnodes remains the root.
>   */
>  int of_attach_node(struct device_node *np)
>  {
> @@ -1958,11 +1961,12 @@ int of_attach_node(struct device_node *n
>         if (rc)
>                 return rc;
>
> +       BUG_ON(!of_allnodes);
>         raw_spin_lock_irqsave(&devtree_lock, flags);
>         np->sibling = np->parent->child;
> -       np->allnext = of_allnodes;
> +       np->allnext = of_allnodes->allnext;
>         np->parent->child = np;
> -       of_allnodes = np;
> +       of_allnodes->allnext = np;
>         of_node_clear_flag(np, OF_DETACHED);
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>
