Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3KVGqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:46:48 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:55025 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3KVGqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:46:46 -0500
MIME-Version: 1.0
In-Reply-To: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
References: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
Date: Fri, 22 Nov 2013 12:16:44 +0530
Message-ID: <CA+NduCDdAV1R4RRJ4e=cYZiMA1imVjRZRL+fe0XA2-v=ziVDQg@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
From: Yuvaraj Cd <yuvaraj.lkml@gmail.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>, hs@denx.de,
        khali@linux-fr.org, ben-linux@fluff.org,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:42 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds new compatible to support HSI2C module on Exynos5260
> HSI2C module on Exynos5260 needs to be reset during during initialization.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  .../devicetree/bindings/i2c/i2c-exynos5.txt        |    6 +++-
>  drivers/i2c/busses/i2c-exynos5.c                   |   31 ++++++++++++++++++--
>  2 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> index 056732c..704ab92 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> @@ -5,7 +5,11 @@ at various speeds ranging from 100khz to 3.4Mhz.
>
>  Required properties:
>    - compatible: value should be.
> -      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
> +       -> "samsung,exynos5-hsi2c", for i2c compatible with HSI2C available on
> +                               Exynos5250/5420 SoCs.
> +       -> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
> +                               on Exynos5260 SoCs.
> +
>    - reg: physical base address of the controller and length of memory mapped
>      region.
>    - interrupts: interrupt number to the cpu.
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
> index aca3991..cbb49e2 100644
> --- a/drivers/i2c/busses/i2c-exynos5.c
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -184,14 +184,35 @@ struct exynos5_i2c {
>          * 2. Fast speed upto 1Mbps
>          */
>         int                     speed_mode;
> +
> +       /* Version of HS-I2C Hardware */
> +       unsigned int            version;
> +};
> +
> +enum hsi2c_version {
> +       EXYNOS_5,
> +       EXYNOS_5260
>  };
>
>  static const struct of_device_id exynos5_i2c_match[] = {
> -       { .compatible = "samsung,exynos5-hsi2c" },
> +       {
> +               .compatible = "samsung,exynos5-hsi2c",
> +               .data = (void *)EXYNOS_5 },
> +       {
> +               .compatible = "samsung,exynos5260-hsi2c",
> +               .data = (void *)EXYNOS_5260 },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
>
> +static inline unsigned int exynos5_i2c_get_version(struct platform_device *pdev)
> +{
> +       const struct of_device_id *match;
> +
> +       match = of_match_node(exynos5_i2c_match, pdev->dev.of_node);
> +       return (unsigned int)match->data;
> +}
> +
>  static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
>  {
>         writel(readl(i2c->regs + HSI2C_INT_STATUS),
> @@ -692,7 +713,13 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
>         if (ret)
>                 goto err_clk;
>
> -       exynos5_i2c_init(i2c);
> +       i2c->version = exynos5_i2c_get_version(pdev);
> +
> +       /* The HS-I2C core on Exynos5260 needs a reset to start with */
> +       if (i2c->version == EXYNOS_5260)

Is there is any change in the HSI2C IP for EXYNOS5260?
Can you let me know whats the change w.r.t IP and
why it needs reset to start,which was not needed in earlier SOC?

> +               exynos5_i2c_reset(i2c);
> +       else
> +               exynos5_i2c_init(i2c);
>
>         ret = i2c_add_adapter(&i2c->adap);
>         if (ret < 0) {
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
