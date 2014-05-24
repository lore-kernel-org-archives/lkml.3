Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaEXAd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:33:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37020 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEXAdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:33:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <elder@linaro.org>, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1400590362-11177-2-git-send-email-elder@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1400590362-11177-1-git-send-email-elder@linaro.org>
 <1400590362-11177-2-git-send-email-elder@linaro.org>
Message-ID: <20140524003344.23136.68999@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 1/5] clk: bcm281xx: add an initialized flag
Date: Fri, 23 May 2014 17:33:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2014-05-20 05:52:38)
> Add a flag that tracks whether a clock has already been initialized.
> This will be used by the next patch to avoid initializing a clock
> more than once when it's listed as a prerequisite.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/clk/bcm/clk-kona.c | 17 +++++++++++++++--
>  drivers/clk/bcm/clk-kona.h |  7 +++++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> index d603c4e..d8a7f38 100644
> --- a/drivers/clk/bcm/clk-kona.c
> +++ b/drivers/clk/bcm/clk-kona.c
> @@ -27,6 +27,9 @@
>  #define CCU_ACCESS_PASSWORD      0xA5A500
>  #define CLK_GATE_DELAY_LOOP      2000
>  
> +#define clk_is_initialized(_clk)       FLAG_TEST((_clk), KONA, INITIALIZED)
> +#define clk_set_initialized(_clk)      FLAG_SET((_clk), KONA, INITIALIZED)
> +
>  /* Bitfield operations */
>  
>  /* Produces a mask of set bits covering a range of a 32-bit value */
> @@ -1194,13 +1197,23 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
>  
>  static bool __kona_clk_init(struct kona_clk *bcm_clk)
>  {
> +       bool ret;
> +
> +       if (clk_is_initialized(bcm_clk))
> +               return true;
> +
>         switch (bcm_clk->type) {
>         case bcm_clk_peri:
> -               return __peri_clk_init(bcm_clk);
> +               ret = __peri_clk_init(bcm_clk);

Hi Alex,

Going through this code, it's a bit hard to keep up ;-)

Does the call to __peri_clk_init enable the prereq clocks? If so, is
their clk->prepare_count and clk->enable_count properly incremented?

Thanks,
Mike

> +               break;
>         default:
> +               ret = false;
>                 BUG();
>         }
> -       return -EINVAL;
> +       if (ret)
> +               clk_set_initialized(bcm_clk);
> +
> +       return ret;
>  }
>  
>  /* Set a CCU and all its clocks into their desired initial state */
> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
> index 2537b30..10e238d 100644
> --- a/drivers/clk/bcm/clk-kona.h
> +++ b/drivers/clk/bcm/clk-kona.h
> @@ -406,6 +406,7 @@ struct kona_clk {
>         struct clk_init_data init_data; /* includes name of this clock */
>         struct ccu_data *ccu;   /* ccu this clock is associated with */
>         enum bcm_clk_type type;
> +       u32 flags;              /* BCM_CLK_KONA_FLAGS_* below */
>         union {
>                 void *data;
>                 struct peri_clk_data *peri;
> @@ -414,6 +415,12 @@ struct kona_clk {
>  #define to_kona_clk(_hw) \
>         container_of(_hw, struct kona_clk, hw)
>  
> +/*
> + * Kona clock flags:
> + *   INITIALIZED       clock has been initialized already
> + */
> +#define BCM_CLK_KONA_FLAGS_INITIALIZED ((u32)1 << 0)   /* Clock initialized */
> +
>  /* Initialization macro for an entry in a CCU's kona_clks[] array. */
>  #define KONA_CLK(_ccu_name, _clk_name, _type)                          \
>         {                                                               \
> -- 
> 1.9.1
> 
