Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3ENSyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:54:23 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35839 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3ENSyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:54:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1367383328-25700-1-git-send-email-skannan@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1367383328-25700-1-git-send-email-skannan@codeaurora.org>
Message-ID: <20130514185417.10068.5717@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: Fix race condition between clk_set_parent and clk_enable()
Date: Tue, 14 May 2013 11:54:17 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Saravana Kannan (2013-04-30 21:42:08)
> Without this patch, the following race conditions are possible.
> 
> Race condition 1:
> * clk-A has two parents - clk-X and clk-Y.
> * All three are disabled and clk-X is current parent.
> * Thread A: clk_set_parent(clk-A, clk-Y).
> * Thread A: <snip execution flow>
> * Thread A: Grabs enable lock.
> * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
> * Thread A: Updates clk-A SW parent to clk-Y
> * Thread A: Releases enable lock.
> * Thread B: clk_enable(clk-A).
> * Thread B: clk_enable() enables clk-Y, then enabled clk-A and returns.
> 
> clk-A is now enabled in software, but not clocking in hardware since the
> hardware parent is still clk-X.
> 
> The only way to avoid race conditions between clk_set_parent() and
> clk_enable/disable() is to ensure that clk_enable/disable() calls don't
> require changes to hardware enable state between changes to software clock
> topology and hardware clock topology.
> 
> There are options to achieve the above:
> 1. Grab the enable lock before changing software/hardware topology and
>    release it afterwards.
> 2. Keep the clock enabled for the duration of software/hardware topology
>    change so that any additional enable/disable calls don't try to change
>    the hardware state. Once the topology change is complete, the clock can
>    be put back in its original enable state.
> 
> Option (1) is not an acceptable solution since the set_parent() ops might
> need to sleep.
> 
> Therefore, this patch implements option (2).
> 
> This patch doesn't violate any API semantics. clk_disable() doesn't
> guarantee that the clock is actually disabled. So, no clients of a clock
> can assume that a clock is disabled after their last call to clk_disable().
> So, enabling the clock during a parent change is not a violation of any API
> semantics.
> 
> This also has the nice side effect of simplifying the error handling code.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

I've taken this patch into clk-next for testing.  The code itself looks
fine.  The only thing that remains to be seen is if any platforms have a
problem with disabled clocks getting turned on during a reparent
operation.

On platforms that I have worked on this is OK, but I suppose there could
be some platform out there where a clock is prepared and disabled, and
briefly enabling the clock during the reparent operation somehow puts
the hardware in a bad state.

Anyways that's a long shot and this look OK until somebody screams.

Regards,
Mike

> ---
> It's been a while since I submitted a patch. So, apologies if I'm cc'ing
> people who no longer care about the state of the common clock framework.
> 
>  drivers/clk/clk.c |   72 +++++++++++++++++++++++-----------------------------
>  1 files changed, 32 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 934cfd1..fe4055f 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1377,67 +1377,59 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
>         unsigned long flags;
>         int ret = 0;
>         struct clk *old_parent = clk->parent;
> -       bool migrated_enable = false;
>  
> -       /* migrate prepare */
> -       if (clk->prepare_count)
> +       /*
> +        * Migrate prepare state between parents and prevent race with
> +        * clk_enable().
> +        *
> +        * If the clock is not prepared, then a race with
> +        * clk_enable/disable() is impossible since we already have the
> +        * prepare lock (future calls to clk_enable() need to be preceded by
> +        * a clk_prepare()).
> +        *
> +        * If the clock is prepared, migrate the prepared state to the new
> +        * parent and also protect against a race with clk_enable() by
> +        * forcing the clock and the new parent on.  This ensures that all
> +        * future calls to clk_enable() are practically NOPs with respect to
> +        * hardware and software states.
> +        */
> +       if (clk->prepare_count) {
>                 __clk_prepare(parent);
> -
> -       flags = clk_enable_lock();
> -
> -       /* migrate enable */
> -       if (clk->enable_count) {
> -               __clk_enable(parent);
> -               migrated_enable = true;
> +               clk_enable(parent);
> +               clk_enable(clk);
>         }
>  
>         /* update the clk tree topology */
> +       flags = clk_enable_lock();
>         clk_reparent(clk, parent);
> -
>         clk_enable_unlock(flags);
>  
>         /* change clock input source */
>         if (parent && clk->ops->set_parent)
>                 ret = clk->ops->set_parent(clk->hw, p_index);
> -
>         if (ret) {
> -               /*
> -                * The error handling is tricky due to that we need to release
> -                * the spinlock while issuing the .set_parent callback. This
> -                * means the new parent might have been enabled/disabled in
> -                * between, which must be considered when doing rollback.
> -                */
> -               flags = clk_enable_lock();
>  
> +               flags = clk_enable_lock();
>                 clk_reparent(clk, old_parent);
> -
> -               if (migrated_enable && clk->enable_count) {
> -                       __clk_disable(parent);
> -               } else if (migrated_enable && (clk->enable_count == 0)) {
> -                       __clk_disable(old_parent);
> -               } else if (!migrated_enable && clk->enable_count) {
> -                       __clk_disable(parent);
> -                       __clk_enable(old_parent);
> -               }
> -
>                 clk_enable_unlock(flags);
>  
> -               if (clk->prepare_count)
> +               if (clk->prepare_count) {
> +                       clk_disable(clk);
> +                       clk_disable(parent);
>                         __clk_unprepare(parent);
> -
> +               }
>                 return ret;
>         }
>  
> -       /* clean up enable for old parent if migration was done */
> -       if (migrated_enable) {
> -               flags = clk_enable_lock();
> -               __clk_disable(old_parent);
> -               clk_enable_unlock(flags);
> -       }
> -
> -       /* clean up prepare for old parent if migration was done */
> -       if (clk->prepare_count)
> +       /*
> +        * Finish the migration of prepare state and undo the changes done
> +        * for preventing a race with clk_enable().
> +        */
> +       if (clk->prepare_count) {
> +               clk_disable(clk);
> +               clk_disable(old_parent);
>                 __clk_unprepare(old_parent);
> +       }
>  
>         /* update debugfs with new clk tree topology */
>         clk_debug_reparent(clk, parent);
> -- 
> 1.7.8.3
> 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
