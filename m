Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaEXAyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:54:12 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51776 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEXAyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:54:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <elder@linaro.org>, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1400590362-11177-3-git-send-email-elder@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1400590362-11177-1-git-send-email-elder@linaro.org>
 <1400590362-11177-3-git-send-email-elder@linaro.org>
Message-ID: <20140524005358.23136.8918@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 2/5] clk: bcm281xx: implement prerequisite clocks
Date: Fri, 23 May 2014 17:53:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2014-05-20 05:52:39)
> @@ -743,11 +746,16 @@ struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
>         clk = clk_register(NULL, &bcm_clk->hw);
>         if (IS_ERR(clk)) {
>                 pr_err("%s: error registering clock %s (%ld)\n", __func__,
> -                       init_data->name, PTR_ERR(clk));
> +                       name, PTR_ERR(clk));
>                 goto out_teardown;
>         }
>         BUG_ON(!clk);
>  
> +       /*  Make it so we can look the clock up using clk_find() */

s/clk_find/clk_get/ ?

> +       bcm_clk->cl.con_id = name;
> +       bcm_clk->cl.clk = clk;
> +       clkdev_add(&bcm_clk->cl);

This is not so nice. I'll explain more below.

> +
>         return clk;
>  out_teardown:
>         bcm_clk_teardown(bcm_clk);
> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> index d8a7f38..fd070d6 100644
> --- a/drivers/clk/bcm/clk-kona.c
> +++ b/drivers/clk/bcm/clk-kona.c
> @@ -1195,6 +1195,48 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
>         return true;
>  }
>  
> +static bool __kona_clk_init(struct kona_clk *bcm_clk);
> +static bool __kona_prereq_init(struct kona_clk *bcm_clk)
> +{
> +       struct clk *clk;
> +       struct clk_hw *hw;
> +       struct kona_clk *prereq;
> +
> +       BUG_ON(clk_is_initialized(bcm_clk));
> +
> +       if (!bcm_clk->p.prereq)
> +               return true;
> +
> +       clk = clk_get(NULL, bcm_clk->p.prereq);

The clkdev global namespace is getting polluted with all of these new
prereq clocks. If there was an associated struct device *dev with them
then it wouldn't be a problem, but you might get collisions with other
clock drivers that also use NULL for the device.

It would be a lot nicer for the clocks that require a prereq clock to
just use clk_get(dev, "well_known_name"); in the same way that drivers
use it, without considering it a special case.

> +       if (IS_ERR(clk)) {
> +               pr_err("%s: unable to get prereq clock %s for %s\n",
> +                       __func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
> +               return false;
> +       }
> +       hw = __clk_get_hw(clk);
> +       if (!hw) {
> +               pr_err("%s: null hw pointer for clock %s\n", __func__,
> +                       bcm_clk->init_data.name);
> +               return false;
> +       }
> +       prereq = to_kona_clk(hw);
> +       if (prereq->ccu != bcm_clk->ccu) {
> +               pr_err("%s: prereq clock %s CCU different for clock %s\n",
> +                       __func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
> +               return false;
> +       }
> +
> +       /* Initialize the prerequisite clock first */
> +       if (!__kona_clk_init(prereq)) {
> +               pr_err("%s: failed to init prereq %s for clock %s\n",
> +                       __func__, bcm_clk->p.prereq, bcm_clk->init_data.name);
> +               return false;
> +       }
> +       bcm_clk->p.prereq_clk = clk;

The above seems like a lot effort to go to. Why not skip all of this and
just implement the prerequisite logic in the .enable & .disable
callbacks? E.g. your kona clk .enable callback would look like:

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index d603c4e..51f35b4 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -987,6 +987,12 @@ static int kona_peri_clk_enable(struct clk_hw *hw)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 	struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
+	int ret;
+
+	hw->prereq_bus_clk = clk_get(hw->ccu, hw->prereq);
+	ret = clk_enable(prereq_bus_clk);
+	if (ret)
+		return ret;
 
 	return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
 }
@@ -997,6 +1003,9 @@ static void kona_peri_clk_disable(struct clk_hw *hw)
 	struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
 
 	(void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
+
+	clk_disable(hw->prereq_bus_clk);
+	clk_put(hw->prereq_bus_clk);
 }
 
 static int kona_peri_clk_is_enabled(struct clk_hw *hw)


I guess it might take some trickery to get clk_get to work like that.
Let me know if I've completely lost the plot.

Regards,
Mike
