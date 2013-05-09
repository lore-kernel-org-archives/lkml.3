Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3EIUB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:01:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39325 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3EIUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:01:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,642,1363158000"; 
   d="scan'208";a="45723556"
Message-ID: <518C0097.50300@codeaurora.org>
Date: Thu, 09 May 2013 13:01:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] clk: add support for clock reparent on set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <1366388904-13903-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1366388904-13903-3-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/13 09:28, James Hogan wrote:
> Add core support to allow clock implementations to select the best
> parent clock when rounding a rate, e.g. the one which can provide the
> closest clock rate to that requested. This is by way of adding a new
> clock op, determine_rate(), which is like round_rate() but has an extra
> parameter to allow the clock implementation to optionally select a
> different parent clock. The core then takes care of reparenting the
> clock when setting the rate.
>
> The parent change takes place with the help of two new private data
> members. struct clk::new_parent specifies a clock's new parent (NULL
> indicates no change), and struct clk::new_child specifies a clock's new
> child (whose new_parent member points back to it). The purpose of these
> are to allow correct walking of the future tree for notifications prior
> to actually reparenting any clocks, specifically to skip child clocks
> who are being reparented to another clock (they will be notified via the
> new parent), and to include any new child clock. These pointers are set
> by clk_calc_subtree(), and the new_child pointer gets cleared when a
> child is actually reparented to avoid duplicate POST_RATE_CHANGE
> notifications.
>
> Each place where round_rate() is called, determine_rate is checked first
> and called in preference, passing NULL to the new parent argument if not
> needed (e.g. in __clk_round_rate). This restructures a few of the call
> sites to simplify the logic into if/else blocks.
>
> A new __clk_set_parent_no_recalc() is created similar to
> clk_set_parent() but without calling __clk_recalc_rates(). This is for
> clk_change_rate() to use, where rate recalculation and notifications are
> already handled.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

I believe we'll need to update the check in __clk_init() to allow you to
have either a .round_rate or a .determine_rate op if you have a
.recalc_rate op. Right now it fails to register the clock and then
oopses later on while setting up clock debugfs.

Here's a (probably whitespace damaged) patch for the first one.

----8<-----

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index e6e759e..d56291c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1668,8 +1668,8 @@ int __clk_init(struct device *dev, struct clk *clk)
 
        /* check that clk_ops are sane.  See Documentation/clk.txt */
        if (clk->ops->set_rate &&
-                       !(clk->ops->round_rate && clk->ops->recalc_rate)) {
-               pr_warning("%s: %s must implement .round_rate & .recalc_rate\n",
+                       !((clk->ops->round_rate || clk->ops->determine_rate) && clk->ops->recalc_rate)) {
+               pr_warning("%s: %s must implement .round_rate or .determine_rate in addition to .recalc_rate\n",
                                __func__, clk->name);
                ret = -EINVAL;
                goto out;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

