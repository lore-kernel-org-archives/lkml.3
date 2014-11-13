Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaKMOuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:50:20 -0500
Received: from gloria.sntech.de ([95.129.55.99]:47466 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaKMOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:50:19 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] clk: add property for force to update clock setting
Date: Thu, 13 Nov 2014 15:53:45 +0100
Message-ID: <1641362.yfrjtMOWge@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1415884826-7877-2-git-send-email-kever.yang@rock-chips.com>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com> <1415884826-7877-2-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. November 2014, 21:20:25 schrieb Kever Yang:
> Usually we assigned a clock to a default rate in dts,
> there is a situation that the clock already initialized to the rate
> we intend to set before kernel(hardware default or init in uboot etc).
> For the PLLs we can get a rate from different PLL parameter configure,
> we can't change the PLL parameter if the rate is not changed by now.
> 
> This patch adds a option property 'assigned-clock-force-rates'
> to make sure we update all the setting even if we don't need to
> update the clock rate.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
>  drivers/clk/clk-conf.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
> index aad4796..0c9df48 100644
> --- a/drivers/clk/clk-conf.c
> +++ b/drivers/clk/clk-conf.c
> @@ -84,7 +84,7 @@ static int __set_clk_rates(struct device_node *node, bool
> clk_supplier) struct clk *clk;
>  	u32 rate;
> 
> -	of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
> +	of_property_for_each_u32(node, "assigned-force-rates", prop, cur, rate) {
>  		if (rate) {
>  			rc = of_parse_phandle_with_args(node, "assigned-clocks",
>  					"#clock-cells",	index, &clkspec);
> @@ -104,7 +104,38 @@ static int __set_clk_rates(struct device_node *node,
> bool clk_supplier) index, node->full_name);
>  				return PTR_ERR(clk);
>  			}
> +			/* change the old rate to 0 to make sure we can get into
> +			 * clk_change_rate */
> +			clk->rate = 0;
> +			rc = clk_set_rate(clk, rate);
> +			if (rc < 0)
> +				pr_err("clk: couldn't set %s clock rate: %d\n",
> +				       __clk_get_name(clk), rc);
> +			clk_put(clk);

Forcing clocks to 0 at first will probably create issues on some platfoms.
I think what Doug meant was something like [0], which would then enable
the clk_conf part to force the rate change. I haven't tested this yet, but it
seems the check in clk_set_rate is the only one checking for identical new
and old rates.

My one-for-all assigned-clock-force-rates param might be debatable.


Heiko


[0]

diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
index aad4796..421422f 100644
--- a/drivers/clk/clk-conf.c
+++ b/drivers/clk/clk-conf.c
@@ -83,6 +83,7 @@ static int __set_clk_rates(struct device_node *node, bool clk_supplier)
 	int rc, index = 0;
 	struct clk *clk;
 	u32 rate;
+	bool force = of_property_read_bool(node, "assigned-clock-force-rates");
 
 	of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
 		if (rate) {
@@ -105,7 +106,7 @@ static int __set_clk_rates(struct device_node *node, bool clk_supplier)
 				return PTR_ERR(clk);
 			}
 
-			rc = clk_set_rate(clk, rate);
+			rc = __clk_set_rate(clk, rate, force);
 			if (rc < 0)
 				pr_err("clk: couldn't set %s clock rate: %d\n",
 				       __clk_get_name(clk), rc);
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9..26d183d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1528,7 +1528,7 @@ static void clk_change_rate(struct clk *clk)
  *
  * Returns 0 on success, -EERROR otherwise.
  */
-int clk_set_rate(struct clk *clk, unsigned long rate)
+int __clk_set_rate(struct clk *clk, unsigned long rate, bool force)
 {
 	struct clk *top, *fail_clk;
 	int ret = 0;
@@ -1540,7 +1540,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_prepare_lock();
 
 	/* bail early if nothing to do */
-	if (rate == clk_get_rate(clk))
+	if (rate == clk_get_rate(clk) && !force)
 		goto out;
 
 	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
@@ -1573,6 +1573,11 @@ out:
 
 	return ret;
 }
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return __clk_set_rate(clk, rate, false);
+}
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
 /**
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index be21af1..c7c3a37 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -555,6 +555,7 @@ struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk **best_parent_p);
+int __clk_set_rate(struct clk *clk, unsigned long rate, bool force);
 
 /*
  * FIXME clock api without lock protection

