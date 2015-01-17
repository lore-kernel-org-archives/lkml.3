Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbbAQWFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:05:43 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64164 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbAQWFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:05:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <54987072.4050002@codeaurora.org>
Cc: "Rajendra Nayak" <rnayak@ti.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
References: <1419248747-3367-1-git-send-email-k.kozlowski@samsung.com>
 <54986525.3070305@codeaurora.org> <54987072.4050002@codeaurora.org>
Message-ID: <20150117220532.22722.48317@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: Fix __GFP_FS allocation with irqs disabled
Date: Sat, 17 Jan 2015 14:05:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2014-12-22 11:26:42)
> On 12/22/2014 10:38 AM, Stephen Boyd wrote:
> > On 12/22/2014 03:45 AM, Krzysztof Kozlowski wrote:
> >
> >> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> >> index f4963b7d4e17..35079302a650 100644
> >> --- a/drivers/clk/clk.c
> >> +++ b/drivers/clk/clk.c
> >> @@ -1150,6 +1150,12 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
> >>  {
> >>      int i;
> >>  
> >> +    if (clk->num_parents == 1) {
> >> +            if (IS_ERR_OR_NULL(clk->parent))
> >> +                    clk->parent = __clk_lookup(clk->parent_names[0]);
> >> +            return 0;
> >> +    }
> >> +
> >>      if (!clk->parents) {
> >>              clk->parents = kcalloc(clk->num_parents,
> >>                                      sizeof(struct clk *), GFP_KERNEL);
> > This may be a worthwhile optimization, but I wonder why the clk_ops for
> > this clock need to fetch the parent index at all? Which clock are we
> > actually dealing with here?
> >
> 
> The clk_set_rate() call should still be fixed, but we can probably do
> this too.
> 
> ---8<---
> 
> From: Stephen Boyd <sboyd@codeaurora.org>
> Date: Mon, 22 Dec 2014 11:24:28 -0800
> Subject: [PATCH] clk: Skip fetching index for single parent clocks
> 
> We don't need to fetch the parent index for clocks if they only
> have one parent. Doing this also avoid an unnecessary allocation
> for the parent cache.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clk/clk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 675f37a7329f..e3a2d36124fd 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1420,7 +1420,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>         }
>  
>         /* try finding the new parent index */
> -       if (parent) {
> +       if (parent && clk->num_parents > 1) {
>                 p_index = clk_fetch_parent_index(clk, parent);
>                 if (p_index < 0) {
>                         pr_debug("%s: clk %s can not be parent of clk %s\n",

Applied to clk-next.

Regards,
Mike

> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
