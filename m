Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaKYBe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:34:56 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55195 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaKYBez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:34:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        "Tomasz Figa" <tomasz.figa@gmail.com>, "Kukjin Kim" <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
        "Vivek Gautam" <gautam.vivek@samsung.com>,
        "Kevin Hilman" <khilman@kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1416842312-4405-2-git-send-email-k.kozlowski@samsung.com>
Cc: "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
 <1416842312-4405-2-git-send-email-k.kozlowski@samsung.com>
Message-ID: <20141125013450.12298.96117@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC 1/2] clk: Allow overriding generic ops for clocks
Date: Mon, 24 Nov 2014 17:34:50 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Krzysztof Kozlowski (2014-11-24 07:18:31)
> For clocks depending on some other clock domain one may want to perform
> specific ops before actual enable/disable of gate clock. Allow such case
> by accepting supplied ops in new exported function:
> clk_register_gate_ops().

If you are not going to use the gate_ops, why use the gate clock at all?
You can create a platform-specific clock type which uses the ops you
specify.

Regards,
Mike

> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/clk/clk-gate.c       | 16 +++++++++++++---
>  include/linux/clk-provider.h |  5 +++++
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> index 51fd87fb7ba6..51802af2d9e7 100644
> --- a/drivers/clk/clk-gate.c
> +++ b/drivers/clk/clk-gate.c
> @@ -117,11 +117,12 @@ EXPORT_SYMBOL_GPL(clk_gate_ops);
>   * @bit_idx: which bit in the register controls gating of this clock
>   * @clk_gate_flags: gate-specific flags for this clock
>   * @lock: shared register lock for this clock
> + * @ops: clk_ops to use for this clock
>   */
> -struct clk *clk_register_gate(struct device *dev, const char *name,
> +struct clk *clk_register_gate_ops(struct device *dev, const char *name,
>                 const char *parent_name, unsigned long flags,
>                 void __iomem *reg, u8 bit_idx,
> -               u8 clk_gate_flags, spinlock_t *lock)
> +               u8 clk_gate_flags, spinlock_t *lock, const struct clk_ops *ops)
>  {
>         struct clk_gate *gate;
>         struct clk *clk;
> @@ -142,7 +143,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
>         }
>  
>         init.name = name;
> -       init.ops = &clk_gate_ops;
> +       init.ops = ops;
>         init.flags = flags | CLK_IS_BASIC;
>         init.parent_names = (parent_name ? &parent_name: NULL);
>         init.num_parents = (parent_name ? 1 : 0);
> @@ -161,4 +162,13 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
>  
>         return clk;
>  }
> +EXPORT_SYMBOL_GPL(clk_register_gate_ops);
> +
> +struct clk *clk_register_gate(struct device *dev, const char *name,
> +               const char *parent_name, unsigned long flags,
> +               void __iomem *reg, u8 bit_idx,
> +               u8 clk_gate_flags, spinlock_t *lock)
> +{
> +       return clk_register_gate_ops(dev, name, parent_name, flags, reg, bit_idx, clk_gate_flags, lock, &clk_gate_ops);
> +}
>  EXPORT_SYMBOL_GPL(clk_register_gate);
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index be21af149f11..6cfc77a9f339 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -290,11 +290,16 @@ struct clk_gate {
>  #define CLK_GATE_HIWORD_MASK           BIT(1)
>  
>  extern const struct clk_ops clk_gate_ops;
> +struct clk *clk_register_gate_ops(struct device *dev, const char *name,
> +               const char *parent_name, unsigned long flags,
> +               void __iomem *reg, u8 bit_idx,
> +               u8 clk_gate_flags, spinlock_t *lock, const struct clk_ops *ops);
>  struct clk *clk_register_gate(struct device *dev, const char *name,
>                 const char *parent_name, unsigned long flags,
>                 void __iomem *reg, u8 bit_idx,
>                 u8 clk_gate_flags, spinlock_t *lock);
>  
> +
>  struct clk_div_table {
>         unsigned int    val;
>         unsigned int    div;
> -- 
> 1.9.1
> 
