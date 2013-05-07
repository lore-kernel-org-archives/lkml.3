Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3EGMGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:06:22 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47319 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab3EGMGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:06:19 -0400
MIME-Version: 1.0
In-Reply-To: <1367895031-23744-1-git-send-email-naveenkrishna.ch@gmail.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
	<1367895031-23744-1-git-send-email-naveenkrishna.ch@gmail.com>
Date: Tue, 7 May 2013 17:36:18 +0530
Message-ID: <CAK9yfHyojW0pFiEbt87yGHtsH-u7FzS0AjJ9qYUWpS3LVi51wQ@mail.gmail.com>
Subject: Re: [PATCH v8] i2c: exynos5: add High Speed I2C controller driver
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Naveen Krishna Chatradhi <naveenkrishna.ch@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sjg@chromium.org, broonie@opensource.wolfsonmicro.com,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2013 08:20, Naveen Krishna Chatradhi
<naveenkrishna.ch@gmail.com> wrote:
> From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> Adds support for High Speed I2C driver found in Exynos5 and
> later SoCs from Samsung.
>
> Driver only supports Device Tree method.
>
> Changes since v1:
> 1. Added FIFO functionality
> 2. Added High speed mode functionality
> 3. Remove SMBUS_QUICK
> 4. Remove the debugfs functionality
> 5. Use devm_* functions where ever possible
> 6. Driver is free from GPIO configs
> 7. Use OF data string "clock-frequency" to get the bus operating frequencies
> 8. Split the clock divisor calculation function
> 9. Add resets for the failed transacton cases
> 10. few other bug fixes and cosmetic changes
>
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Simon Glass <sjg@google.com>
> Tested-by: Andrew Bresticker <abrestic@google.com>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@google.com>
> ---
> Changes since v7:
> 1. used devm_ioremap_resource for register base address
> 2. merged FIFO fix from Yuvaraj
>    https://patchwork.kernel.org/patch/2420351/
> 3. merged hsi2c clock config patch from Yuvaraj
>    https://patchwork.kernel.org/patch/2464681/
>
>  .../devicetree/bindings/i2c/i2c-exynos5.txt        |   41 +
>  drivers/i2c/busses/Kconfig                         |    7 +
>  drivers/i2c/busses/Makefile                        |    1 +
>  drivers/i2c/busses/i2c-exynos5.c                   |  888 ++++++++++++++++++++
>  4 files changed, 937 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
>  create mode 100644 drivers/i2c/busses/i2c-exynos5.c
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> new file mode 100644
> index 0000000..6e613b6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> @@ -0,0 +1,41 @@
> +* Samsung's High Speed I2C controller
> +
> +The Samsung's High Speed I2C controller is used to interface with I2C devices
> +at various speeds ranging from 100khz to 3.4Mhz.
> +
> +Required properties:
> +  - compatible: value should be.
> +      (a) "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.

Since this is the only string supported as of now, "(a)" could be dropped.

> +  - reg: physical base address of the controller and length of memory mapped
> +    region.
> +  - interrupts: interrupt number to the cpu.
> +
> +  - Pinctrl variant (preferred, if available):

Is the non-pinctrl variant still supported?

> +    - pinctrl-0: Pin control group to be used for this controller.
> +    - pinctrl-names: Should contain only one value - "default".

What about address-cells and size-cells property?

> +
> +Optional properties:
> +  - samsung,hs-mode: Mode of operation, High speed or Fast speed mode. If not
> +    specified, default value is 0.
> +  - clock-frequency: Desired operating frequency in Hz of the bus.
> +    If not specified, the default value in Hz is 100000.
> +
> +Example:
> +
> +       hsi2c@12ca0000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12ca0000 0x100>;
> +               interrupts = <56>;
> +               clock-frequency = <100000>;
> +               /* Pinctrl variant begins here */
> +               pinctrl-0 = <&i2c4_bus>;
> +               pinctrl-names = "default";
> +               /* Pinctrl variant ends here */
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               s2mps11_pmic@66 {
> +                       compatible = "samsung,s2mps11-pmic";
> +                       reg = <0x66>;
> +               };
> +       };

[snip]

> +static int exynos5_i2c_probe(struct platform_device *pdev)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct exynos5_i2c *i2c;
> +       struct resource *mem;
> +       int ret;
> +
> +       if (!np) {
> +               dev_err(&pdev->dev, "no device node\n");
> +               return -ENOENT;
> +       }
> +
> +       i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
> +       if (!i2c) {
> +               dev_err(&pdev->dev, "no memory for state\n");
> +               return -ENOMEM;
> +       }
> +
> +       /* Mode of operation High/Fast Speed mode */
> +       if (of_get_property(np, "samsung,hs-mode", NULL)) {
> +               i2c->speed_mode = HSI2C_HIGH_SPD;
> +               i2c->fs_clock = HSI2C_FS_TX_CLOCK;
> +               if (of_property_read_u32(np, "clock-frequency", &i2c->hs_clock))
> +                       i2c->hs_clock = HSI2C_HS_TX_CLOCK;
> +       } else {
> +               i2c->speed_mode = HSI2C_FAST_SPD;
> +               if (of_property_read_u32(np, "clock-frequency", &i2c->fs_clock))
> +                       i2c->fs_clock = HSI2C_FS_TX_CLOCK;
> +       }
> +
> +       strlcpy(i2c->adap.name, "exynos5-i2c", sizeof(i2c->adap.name));
> +       i2c->adap.owner   = THIS_MODULE;
> +       i2c->adap.algo    = &exynos5_i2c_algorithm;
> +       i2c->adap.retries = 2;
> +       i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD;
> +
> +       i2c->dev = &pdev->dev;
> +       i2c->clk = devm_clk_get(&pdev->dev, "hsi2c");
> +       if (IS_ERR(i2c->clk)) {
> +               dev_err(&pdev->dev, "cannot get clock\n");
> +               return -ENOENT;
> +       }
> +
> +       clk_prepare_enable(i2c->clk);
> +
> +       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       i2c->regs = devm_ioremap_resource(&pdev->dev, mem);
> +       if (!i2c->regs) {

Should be "if (IS_ERR(i2c->regs)) {"

> +               dev_err(&pdev->dev, "cannot map HS-I2C IO\n");
> +               ret = PTR_ERR(i2c->regs);
> +               goto err_clk;
> +       }




-- 
With warm regards,
Sachin
