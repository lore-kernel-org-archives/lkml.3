Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725AbaDJHEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:04:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55979 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241AbaDJHEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:04:23 -0400
MIME-Version: 1.0
In-Reply-To: <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org> <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 10 Apr 2014 16:04:02 +0900
Message-ID: <CAAVeFuJY67zdoHiZufxDbkaw=xt8YwxyDAwHW_T7UZeSOt35NA@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] mfd: palmas: support IRQ inversion at the board level
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, any news about this patch? I'm waiting for it to be merged in
order to resend some Tegra DTs, but still cannot see it in -next.

Thanks,
Alex.

On Tue, Mar 4, 2014 at 4:51 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> Implement the new DT property ti,irq-externally-inverted, and add an
> equivalent platform data field to match. This allows the driver to
> correctly automatically configure the IRQ output polarity when the board
> or SoC contains an inverter between the Palmas IRQ output and IRQ
> controller input.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v3:
> * Use an IRQD flag to represent the data, rather than a custom DT property.
> v2:
> * Split V1's patch 1/2 into separate patches 1/3 and 2/3.
> ---
>  drivers/mfd/palmas.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index d280d789e55a..3281d4103e9d 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -292,7 +292,8 @@ static int palmas_set_pdata_irq_flag(struct i2c_client *i2c,
>                 return -EINVAL;
>         }
>
> -       pdata->irq_flags = irqd_get_trigger_type(irq_data);
> +       pdata->irq_flags = irqd_get_trigger_type(irq_data) |
> +                          irqd_get_src_dst_inverted(irq_data);
>         dev_info(&i2c->dev, "Irq flag is 0x%08x\n", pdata->irq_flags);
>         return 0;
>  }
> @@ -447,6 +448,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>                 reg = PALMAS_POLARITY_CTRL_INT_POLARITY;
>         else
>                 reg = 0;
> +       if (pdata->irq_flags & IRQ_SRC_DST_INVERTED)
> +               reg ^= PALMAS_POLARITY_CTRL_INT_POLARITY;
>         ret = palmas_update_bits(palmas, PALMAS_PU_PD_OD_BASE,
>                         PALMAS_POLARITY_CTRL, PALMAS_POLARITY_CTRL_INT_POLARITY,
>                         reg);
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
