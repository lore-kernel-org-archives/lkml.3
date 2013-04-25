Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3DYLAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:00:06 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51021 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3DYLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-16-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:00:03 +0200
Message-ID: <CACRpkdZ1tSeqcctS138QkRn6PENMrjMyrnkHeMOYaOBW096N1g@mail.gmail.com>
Subject: Re: [PATCH 15/32] dmaengine: ste_dma40: Separate Logical Global
 Interrupt Mask (GIM) unmasking
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> During the initial setup of a logical channel, it is necessary to unmask
> the GIM in order to receive generated terminal count and error interrupts.
> We're separating out this required code so it will be possible to move
> the remaining code in d40_phy_cfg(), which is mostly runtime configuration
> into the runtime_config() routine.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This commit message needs to reflect the fact that you've observed
that one argument to the d40_phy_cfg() is hardcoded to false in the
runtime config, and that is why we can sink the use into
d40_alloc_chan_resources().

(...)
> @@ -2456,6 +2456,9 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
>                                 D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
>         }
>
> +       if (chan_is_logical(d40c))
> +               d40_log_gim_unmask(&d40c->src_def_cfg, &d40c->dst_def_cfg);

The clause right above is already a if (chan_is_logical(c)).
Just insert the function call into that clause.

> +void d40_log_gim_unmask(u32 *src_cfg, u32 *dst_cfg) {
> +
> +       *src_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;
> +       *dst_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;
> +}

Why create a separate function with two lines which is just called from
one single place?

Just sink this into the d40_alloc_chan_resources() function like that:

if (logical) {
  *d40c->src_def_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;
  *d40c->dst_def_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;

No need for a separate function and a separate header.

(...)
>  /* Sets up SRC and DST CFG register for both logical and physical channels */
>  void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
>                  u32 *src_cfg, u32 *dst_cfg, bool is_log)

Take this opportunity to:

(A) delete the argument is_log since it has no use whatsoever after this.
    Why pass it at all!

(B) De-indent the if (!is_log) clause... as a natural consequence.

Yours,
Linus Walleij
