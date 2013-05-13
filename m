Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3EMUBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:01:30 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41155 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab3EMUB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:01:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1366388904-13903-2-git-send-email-james.hogan@imgtec.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, James Hogan <james.hogan@imgtec.com>
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
 <1366388904-13903-2-git-send-email-james.hogan@imgtec.com>
Message-ID: <20130513200123.10068.57183@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2 1/3] clk: abstract parent cache
Date: Mon, 13 May 2013 13:01:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-04-19 09:28:22)
> Abstract access to the clock parent cache by defining
> __clk_get_parent_by_index(clk, index). This allows access to parent
> clocks from clock drivers.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  drivers/clk/clk.c            | 21 ++++++++++++++-------
>  include/linux/clk-provider.h |  1 +
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index ed87b24..79d5deb 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -415,6 +415,19 @@ struct clk *__clk_get_parent(struct clk *clk)
>         return !clk ? NULL : clk->parent;
>  }
>  
> +struct clk *__clk_get_parent_by_index(struct clk *clk, u8 index)

This looks good, but in the next version can you remove the double
underscore?  I'm getting rid of a lot of those double underscore
helpers now that the reentrancy patch is merged and I think this is a
reasonable top-level API for a clock provider to have.

Thanks,
Mike

> +{
> +       if (!clk || index >= clk->num_parents)
> +               return NULL;
> +       else if (!clk->parents)
> +               return __clk_lookup(clk->parent_names[index]);
> +       else if (!clk->parents[index])
> +               return clk->parents[index] =
> +                       __clk_lookup(clk->parent_names[index]);
> +       else
> +               return clk->parents[index];
> +}
> +
>  unsigned int __clk_get_enable_count(struct clk *clk)
>  {
>         return !clk ? 0 : clk->enable_count;
> @@ -1150,13 +1163,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
>                         kzalloc((sizeof(struct clk*) * clk->num_parents),
>                                         GFP_KERNEL);
>  
> -       if (!clk->parents)
> -               ret = __clk_lookup(clk->parent_names[index]);
> -       else if (!clk->parents[index])
> -               ret = clk->parents[index] =
> -                       __clk_lookup(clk->parent_names[index]);
> -       else
> -               ret = clk->parents[index];
> +       ret = __clk_get_parent_by_index(clk, index);
>  
>  out:
>         return ret;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 7f197d7..4e0b634 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -347,6 +347,7 @@ const char *__clk_get_name(struct clk *clk);
>  struct clk_hw *__clk_get_hw(struct clk *clk);
>  u8 __clk_get_num_parents(struct clk *clk);
>  struct clk *__clk_get_parent(struct clk *clk);
> +struct clk *__clk_get_parent_by_index(struct clk *clk, u8 index);
>  unsigned int __clk_get_enable_count(struct clk *clk);
>  unsigned int __clk_get_prepare_count(struct clk *clk);
>  unsigned long __clk_get_rate(struct clk *clk);
> -- 
> 1.8.1.2
