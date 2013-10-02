Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3JBBkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:40:37 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63800 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3JBBkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:40:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1380415036-15997-1-git-send-email-tomasz.figa@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
References: <1380415036-15997-1-git-send-email-tomasz.figa@gmail.com>
Message-ID: <20131002014031.9338.76351@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 1/3] clk: Add error handling to clk_fetch_parent_index()
Date: Tue, 01 Oct 2013 18:40:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomasz Figa (2013-09-28 17:37:14)
> There are at least two different error cases that can happen in
> clk_fetch_parent_index() function:
>  - allocation failure,
>  - parent clock lookup failure,
> however it returns only an u8, which is supposed to contain parent clock
> index.
> 
> This patch modified the function to return full int instead allowing
> positive clock indices and negative error codes to be returned. All
> users of this function are adjusted as well to handle the return value
> correctly.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>

Thanks for the fixes. Taken into clk-next.

Regards,
Mike

> ---
>  drivers/clk/clk.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index a004769..9e0a837 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1080,13 +1080,16 @@ unsigned long clk_get_rate(struct clk *clk)
>  }
>  EXPORT_SYMBOL_GPL(clk_get_rate);
>  
> -static u8 clk_fetch_parent_index(struct clk *clk, struct clk *parent)
> +static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
>  {
> -       u8 i;
> +       int i;
>  
> -       if (!clk->parents)
> +       if (!clk->parents) {
>                 clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
>                                                                 GFP_KERNEL);
> +               if (!clk->parents)
> +                       return -ENOMEM;
> +       }
>  
>         /*
>          * find index of new parent clock using cached parent ptrs,
> @@ -1095,15 +1098,15 @@ static u8 clk_fetch_parent_index(struct clk *clk, struct clk *parent)
>          */
>         for (i = 0; i < clk->num_parents; i++) {
>                 if (clk->parents && clk->parents[i] == parent)
> -                       break;
> +                       return i;
>                 else if (!strcmp(clk->parent_names[i], parent->name)) {
>                         if (clk->parents)
>                                 clk->parents[i] = __clk_lookup(parent->name);
> -                       break;
> +                       return i;
>                 }
>         }
>  
> -       return i;
> +       return -EINVAL;
>  }
>  
>  static void clk_reparent(struct clk *clk, struct clk *new_parent)
> @@ -1265,7 +1268,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>         struct clk *old_parent, *parent;
>         unsigned long best_parent_rate = 0;
>         unsigned long new_rate;
> -       u8 p_index = 0;
> +       int p_index = 0;
>  
>         /* sanity */
>         if (IS_ERR_OR_NULL(clk))
> @@ -1306,7 +1309,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>         /* try finding the new parent index */
>         if (parent) {
>                 p_index = clk_fetch_parent_index(clk, parent);
> -               if (p_index == clk->num_parents) {
> +               if (p_index < 0) {
>                         pr_debug("%s: clk %s can not be parent of clk %s\n",
>                                  __func__, parent->name, clk->name);
>                         return NULL;
> @@ -1568,7 +1571,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  int clk_set_parent(struct clk *clk, struct clk *parent)
>  {
>         int ret = 0;
> -       u8 p_index = 0;
> +       int p_index = 0;
>         unsigned long p_rate = 0;
>  
>         if (!clk)
> @@ -1597,10 +1600,10 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>         if (parent) {
>                 p_index = clk_fetch_parent_index(clk, parent);
>                 p_rate = parent->rate;
> -               if (p_index == clk->num_parents) {
> +               if (p_index < 0) {
>                         pr_debug("%s: clk %s can not be parent of clk %s\n",
>                                         __func__, parent->name, clk->name);
> -                       ret = -EINVAL;
> +                       ret = p_index;
>                         goto out;
>                 }
>         }
> -- 
> 1.8.3.2
