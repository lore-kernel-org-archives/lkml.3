Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423456Ab3FUREN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:04:13 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60848 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423203Ab3FUREL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:04:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        James Hogan <james.hogan@imgtec.com>
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>
Message-ID: <20130621170407.20448.35605@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v5 0/5] clk: implement remuxing during set_rate
Date: Fri, 21 Jun 2013 10:04:07 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-06-13 09:05:57)
> This patchset adds support for automatic selection of the best parent
> for a clock mux, i.e. the one which can provide the closest clock rate
> to that requested. It can be disabled by a new CLK_SET_RATE_NO_REPARENT
> flag (which is set for all uses of clk_register_mux().
> 
> This works by way of adding a new op, determine_rate, similar to
> round_rate but with an extra parameter to allow the clock driver to
> optionally select a different parent clock. This is used in
> clk_calc_new_rates to decide whether to initiate a set_parent operation.

Hi James,

I'm going to hold off on this one for 3.11. I'll revisit it after the
next merge window.

Regards,
Mike

> 
> Changes in v5:
> 
> * Rebased on latest clk-next ("clk: tegra: Use common of_clk_init
>   function")
> * Updated clock hardware characteristics table in documentation.
> 
> Changes in v4:
> 
> * rebased on clk-next ("clk: sun5i: Add compatibles for Allwinner A13").
> * replace __clk_set_parent_no_recalc with __clk_set_parent.
> * never pass NULL to determine_rate's best_parent_clk parameter, and
>   slight refactor of __clk_round_rate to use local copy of clk->parent.
> * a few new comments around use of clk::new_child.
> * new patch (patch 2) split out of patch 3 to avoid having to declare
>   static __clk_set_parent() at the top of clk.c, and to ease readability
>   of patch 3.
> 
> Changes in v3:
> 
> * rebased on v3.10-rc1.
> * remove double underscore prefix from clk_get_parent_by_index()
> * store new_parent_index in struct clk too (calculated from
>   clk_fetch_parent_index, and passed through __clk_set_parent_no_recalc
>   to __clk_set_parent).
> * allow determine_rate to satisfy recalc_rate check in __clk_init.
> * rename/invert CLK_SET_RATE_REMUX to CLK_SET_RATE_NO_REPARENT and move
>   to patch 3.
> * patch 3: add CLK_SET_RATE_NO_REPARENT flag to all callers of
>   clk_register_mux. If you don't mind your clocks being reparented in
>   response to set_rate please let me know and I'll drop the relevant
>   portion of the patch.
> 
> Changes in v2:
> 
> I've moved the mux determine_rate implementation into a core helper, but
> I haven't pushed it fully into the core, as I think it just wouldn't
> work correctly for more complex clocks, e.g. if you (theoretically) had
> a combined mux and divide, you'd want to intercept the determine_rate
> and ask for a larger rate from the parent clocks, then return the
> divided rate. This should be possible by wrapping the mux determine_rate
> helper.
> 
> Patch 1 still exports the __clk_get_parent_by_index as it seems like it
> might be a useful thing for clock implementations to have access to if
> they ever wanted to do something more fancy with changing clock parents.
> 
> I haven't made any attempt to implement the atomic set_parent+set_rate
> as I don't have hardware that could take proper advantage of it, but it
> shouldn't be too difficult for others to implement if they wanted since
> they're fairly close to one another (in clk_change_rate()).
> 
> * switched to using new determine_rate op rather than adding an argument
>   to round_rate.
> * moved mux implementation into a single helper which should be usable
>   from more complex clocks which can mux.
> * rewrite main implementation so that no changes are made until after
>   the PRE notifications have been sent, and in a way that should ensure
>   correct notifications without duplicates, and I think should be safe
>   in the event of a notification failing.
> * various tidy ups and fixes.
> 
> James Hogan (5):
>   clk: abstract parent cache
>   clk: move some parent related functions upwards
>   clk: add support for clock reparent on set_rate
>   clk: add CLK_SET_RATE_NO_REPARENT flag
>   clk: clk-mux: implement remuxing on set_rate
> 
>  Documentation/clk.txt                |  46 ++--
>  arch/arm/mach-imx/clk.h              |   5 +-
>  drivers/clk/clk-mux.c                |   1 +
>  drivers/clk/clk.c                    | 420 ++++++++++++++++++++++-------------
>  drivers/clk/mmp/clk-mmp2.c           |  39 ++--
>  drivers/clk/mmp/clk-pxa168.c         |  40 ++--
>  drivers/clk/mmp/clk-pxa910.c         |  31 ++-
>  drivers/clk/mxs/clk.h                |   4 +-
>  drivers/clk/samsung/clk.h            |   2 +-
>  drivers/clk/spear/spear1310_clock.c  | 179 ++++++++-------
>  drivers/clk/spear/spear1340_clock.c  |  97 ++++----
>  drivers/clk/spear/spear3xx_clock.c   |  57 +++--
>  drivers/clk/spear/spear6xx_clock.c   |  35 +--
>  drivers/clk/sunxi/clk-sunxi.c        |   3 +-
>  drivers/clk/tegra/clk-tegra114.c     |  36 ++-
>  drivers/clk/tegra/clk-tegra20.c      |   6 +-
>  drivers/clk/tegra/clk-tegra30.c      |  33 ++-
>  drivers/clk/versatile/clk-vexpress.c |   4 +-
>  include/linux/clk-private.h          |   3 +
>  include/linux/clk-provider.h         |  12 +
>  20 files changed, 638 insertions(+), 415 deletions(-)
> 
> -- 
> 1.8.1.2
