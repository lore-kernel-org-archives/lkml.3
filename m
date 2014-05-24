Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaEXA4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:56:52 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34691 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEXA4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:56:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <elder@linaro.org>, mporter@linaro.org, bcm@fixthebug.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <537FD8AF.8060004@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1400592297-22171-1-git-send-email-elder@linaro.org>
 <20140523231849.23136.70991@quantum> <537FD8AF.8060004@linaro.org>
Message-ID: <20140524005640.23136.58952@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: bcm/kona: implement determine_rate()
Date: Fri, 23 May 2014 17:56:40 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2014-05-23 16:24:31)
> On 05/23/2014 06:18 PM, Mike Turquette wrote:
> > Quoting Alex Elder (2014-05-20 06:24:57)
> >> Implement the clk->determine_rate method for Broadcom Kona peripheral
> >> clocks.  This allows a peripheral clock to be re-parented in order to
> >> satisfy a rate change request.  This takes the place of the previous
> >> kona_peri_clk_round_rate() functionality, though that function remains
> >> because it is used by the new one.
> >>
> >> The parent clock that allows the peripheral clock to produce a rate
> >> closest to the one requested is the one selected, though the current
> >> parent is used by default.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >> This patch is based on Mike Turquette's current "clk-next" branch.
> >>     6ed8eb5 Merge tag 'clk-hisi-for-v3.16' of https://git.kern...
> >>
> >> It is available here:
> >>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
> >>     Branch review/bcm-determine-rate
> >>
> >>  drivers/clk/bcm/clk-kona.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 52 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> >> index d603c4e..1a4eccc 100644
> >> --- a/drivers/clk/bcm/clk-kona.c
> >> +++ b/drivers/clk/bcm/clk-kona.c
> >> @@ -1031,6 +1031,57 @@ static long kona_peri_clk_round_rate(struct clk_hw *hw, unsigned long rate,
> >>                                 rate ? rate : 1, *parent_rate, NULL);
> >>  }
> >>  
> >> +static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
> >> +               unsigned long *best_parent_rate, struct clk **best_parent)
> >> +{
> >> +       struct kona_clk *bcm_clk = to_kona_clk(hw);
> >> +       struct clk *clk = hw->clk;
> >> +       struct clk *current_parent;
> >> +       unsigned long parent_rate;
> >> +       unsigned long best_delta;
> >> +       unsigned long best_rate;
> >> +       u32 parent_count;
> >> +       u32 which;
> >> +
> >> +       /*
> >> +        * If there is no other parent to choose, use the current one.
> >> +        * Note:  We don't honor (or use) CLK_SET_RATE_NO_REPARENT.
> >> +        */
> > 
> > A WARN_ONCE is appropriate upon detection of CLK_SET_RATE_NO_REPARENT.
> > It will certainly help someone that is debugging why that flag has no
> > effect.
> 
> I'll add that.

Thanks!

> 
> > Otherwise the patch looks good to me.
> 
> Would you like me to send an updated patch as a pull request?

It's up to you. For a single patch I can easily pick it. If you want to
bundle it up with the other pending patches (prereq clocks, etc) then a
pull request would be nice once all that stuff gets sorted.

Regards,
Mike

> 
> Thanks.
> 
>                                         -Alex
> 
> > Regards,
> > Mike
> > 
> >> +       parent_count = (u32)bcm_clk->init_data.num_parents;
> >> +       if (parent_count < 2)
> >> +               return kona_peri_clk_round_rate(hw, rate, best_parent_rate);
> >> +
> >> +       /* Unless we can do better, stick with current parent */
> >> +       current_parent = clk_get_parent(clk);
> >> +       parent_rate = __clk_get_rate(current_parent);
> >> +       best_rate = kona_peri_clk_round_rate(hw, rate, &parent_rate);
> >> +       best_delta = abs(best_rate - rate);
> >> +
> >> +       /* Check whether any other parent clock can produce a better result */
> >> +       for (which = 0; which < parent_count; which++) {
> >> +               struct clk *parent = clk_get_parent_by_index(clk, which);
> >> +               unsigned long delta;
> >> +               unsigned long other_rate;
> >> +
> >> +               BUG_ON(!parent);
> >> +               if (parent == current_parent)
> >> +                       continue;
> >> +
> >> +               /* We don't support CLK_SET_RATE_PARENT */
> >> +               parent_rate = __clk_get_rate(parent);
> >> +               other_rate = kona_peri_clk_round_rate(hw, rate, &parent_rate);
> >> +               delta = abs(other_rate - rate);
> >> +               if (delta < best_delta) {
> >> +                       best_delta = delta;
> >> +                       best_rate = other_rate;
> >> +                       *best_parent = parent;
> >> +                       *best_parent_rate = parent_rate;
> >> +               }
> >> +       }
> >> +
> >> +       return best_rate;
> >> +}
> >> +
> >>  static int kona_peri_clk_set_parent(struct clk_hw *hw, u8 index)
> >>  {
> >>         struct kona_clk *bcm_clk = to_kona_clk(hw);
> >> @@ -1135,7 +1186,7 @@ struct clk_ops kona_peri_clk_ops = {
> >>         .disable = kona_peri_clk_disable,
> >>         .is_enabled = kona_peri_clk_is_enabled,
> >>         .recalc_rate = kona_peri_clk_recalc_rate,
> >> -       .round_rate = kona_peri_clk_round_rate,
> >> +       .determine_rate = kona_peri_clk_determine_rate,
> >>         .set_parent = kona_peri_clk_set_parent,
> >>         .get_parent = kona_peri_clk_get_parent,
> >>         .set_rate = kona_peri_clk_set_rate,
> >> -- 
> >> 1.9.1
> >>
> 
