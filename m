Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3FAIJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 04:09:53 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:59462 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3FAIJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 04:09:41 -0400
MIME-Version: 1.0
In-Reply-To: <1370046121-7835-4-git-send-email-rvaswani@codeaurora.org>
References: <1370046121-7835-1-git-send-email-rvaswani@codeaurora.org> <1370046121-7835-4-git-send-email-rvaswani@codeaurora.org>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 1 Jun 2013 09:09:19 +0100
X-Google-Sender-Auth: KdWFK4yehZznXGvYlStvG7OaaPA
Message-ID: <CACxGe6tD253nb-5sOSBQu0Kj1JwYOeas2-WpR2isFO+Q+8ty2A@mail.gmail.com>
Subject: Re: [PATCHv4 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 1:22 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
> This cleans up the gpio-msm-v2 driver of all the global define usage.
> The number of gpios are now defined in the device tree. This enables
> adding irqdomain support as well.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  .../devicetree/bindings/gpio/gpio-msm.txt          |   26 +++
>  arch/arm/boot/dts/msm8660-surf.dts                 |   11 +
>  arch/arm/boot/dts/msm8960-cdp.dts                  |   11 +
>  drivers/gpio/Kconfig                               |    2 +-
>  drivers/gpio/gpio-msm-v2.c                         |  194 ++++++++++++--------
>  5 files changed, 165 insertions(+), 79 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-msm.txt
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-msm.txt b/Documentation/devicetree/bindings/gpio/gpio-msm.txt
> new file mode 100644
> index 0000000..ac20e68
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-msm.txt
> @@ -0,0 +1,26 @@
> +MSM GPIO controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "qcom,msm-gpio" for MSM controllers
> +- #gpio-cells : Should be two.
> +  - first cell is the pin number
> +  - second cell is used to specify optional parameters (unused)
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- #interrupt-cells : Should be 2.
> +- interrupt-controller: Mark the device node as an interrupt controller
> +- interrupts : Specify the TLMM summary interrupt number
> +- ngpio : Specify the number of MSM GPIOs
> +
> +Example:
> +
> +       msmgpio: gpio@fd510000 {
> +               compatible = "qcom,msm-gpio";
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               interrupt-controller;
> +               #interrupt-cells = <2>;
> +               reg = <0xfd510000 0x4000>;
> +               interrupts = <0 208 0>;
> +               ngpio = <150>;
> +       };
> diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
> index 9bf49b3..8931906 100644
> --- a/arch/arm/boot/dts/msm8660-surf.dts
> +++ b/arch/arm/boot/dts/msm8660-surf.dts
> @@ -26,6 +26,17 @@
>                 cpu-offset = <0x40000>;
>         };
>
> +       msmgpio: gpio@800000 {
> +               compatible = "qcom,msm-gpio";
> +               reg = <0x00800000 0x1000>;
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               ngpio = <173>;
> +               interrupts = <0 32 0x4>;
> +               interrupt-controller;
> +               #interrupt-cells = <2>;
> +       };
> +
>         serial@19c400000 {
>                 compatible = "qcom,msm-hsuart", "qcom,msm-uart";
>                 reg = <0x19c40000 0x1000>,
> diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
> index 2e4d87a..52fe253 100644
> --- a/arch/arm/boot/dts/msm8960-cdp.dts
> +++ b/arch/arm/boot/dts/msm8960-cdp.dts
> @@ -26,6 +26,17 @@
>                 cpu-offset = <0x80000>;
>         };
>
> +       msmgpio: gpio@fd510000 {
> +               compatible = "qcom,msm-gpio";
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               ngpio = <150>;
> +               interrupts = <0 32 0x4>;
> +               interrupt-controller;
> +               #interrupt-cells = <2>;
> +               reg = <0xfd510000 0x4000>;
> +       };
> +
>         serial@19c400000 {
>                 compatible = "qcom,msm-hsuart", "qcom,msm-uart";
>                 reg = <0x16440000 0x1000>,
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 87d5670..6d61a12 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -165,7 +165,7 @@ config GPIO_MSM_V1
>
>  config GPIO_MSM_V2
>         tristate "Qualcomm MSM GPIO v2"
> -       depends on GPIOLIB && ARCH_MSM
> +       depends on GPIOLIB && OF && ARCH_MSM
>         help
>           Say yes here to support the GPIO interface on ARM v7 based
>           Qualcomm MSM chips.  Most of the pins on the MSM can be
> diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
> index 75cc821..5a824be 100644
> --- a/drivers/gpio/gpio-msm-v2.c
> +++ b/drivers/gpio/gpio-msm-v2.c
> @@ -19,17 +19,19 @@
>
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
> +#include <linux/err.h>
>  #include <linux/gpio.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/irqchip/chained_irq.h>
>  #include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/module.h>
> +#include <linux/of_address.h>
>  #include <linux/platform_device.h>
>  #include <linux/spinlock.h>
> -
> -#include <mach/msm_iomap.h>
> +#include <linux/slab.h>
>
>  /* Bits of interest in the GPIO_IN_OUT register.
>   */
> @@ -76,13 +78,6 @@ enum {
>         TARGET_PROC_NONE     = 7,
>  };
>
> -
> -#define GPIO_INTR_CFG_SU(gpio)    (MSM_TLMM_BASE + 0x0400 + (0x04 * (gpio)))
> -#define GPIO_CONFIG(gpio)         (MSM_TLMM_BASE + 0x1000 + (0x10 * (gpio)))
> -#define GPIO_IN_OUT(gpio)         (MSM_TLMM_BASE + 0x1004 + (0x10 * (gpio)))
> -#define GPIO_INTR_CFG(gpio)       (MSM_TLMM_BASE + 0x1008 + (0x10 * (gpio)))
> -#define GPIO_INTR_STATUS(gpio)    (MSM_TLMM_BASE + 0x100c + (0x10 * (gpio)))
> -
>  /**
>   * struct msm_gpio_dev: the MSM8660 SoC GPIO device structure
>   *
> @@ -101,11 +96,27 @@ enum {
>   */
>  struct msm_gpio_dev {
>         struct gpio_chip gpio_chip;
> -       DECLARE_BITMAP(enabled_irqs, NR_GPIO_IRQS);
> -       DECLARE_BITMAP(wake_irqs, NR_GPIO_IRQS);
> -       DECLARE_BITMAP(dual_edge_irqs, NR_GPIO_IRQS);
> +       unsigned long *enabled_irqs;
> +       unsigned long *wake_irqs;
> +       unsigned long *dual_edge_irqs;

Was there a reason you ignored the comment to leave these bitmaps as
statically allocated?

[...]

> +       msm_gpio.enabled_irqs = devm_kzalloc(&pdev->dev,
> +                                               sizeof(unsigned long) *
> +                                               BITS_TO_LONGS(ngpio) * 3,
> +                                               GFP_KERNEL);
> +       msm_gpio.wake_irqs = &msm_gpio.enabled_irqs[BITS_TO_LONGS(ngpio)];
> +       msm_gpio.dual_edge_irqs =
> +                       &msm_gpio.enabled_irqs[BITS_TO_LONGS(ngpio * 2)];

I should have just deleted my comment about doing it this way. I was
making the point that one allocation is better that three; but then I
also said that it was better to not allocate at all. Go back to the
statically allocated bitmap array. It is far better than this.

g.
