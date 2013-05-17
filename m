Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3EQIP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:15:26 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:33996 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3EQIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <1368619413-24647-4-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
	<1368619413-24647-4-git-send-email-fabio.baltieri@linaro.org>
Date: Fri, 17 May 2013 10:15:22 +0200
Message-ID: <CAPDyKFqAZuebgu8CCfTniFCxuu5CjCT82h+w=ZF7m2wPzaejeQ@mail.gmail.com>
Subject: Re: [PATCH 03/10] usb: phy: ab8500-usb: add transceiver clock control
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2013 14:03, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
>
> Add common clock support code for the ab8500-usb phy driver.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/usb/phy/phy-ab8500-usb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
> index b043faa..cc0d7e5 100644
> --- a/drivers/usb/phy/phy-ab8500-usb.c
> +++ b/drivers/usb/phy/phy-ab8500-usb.c
> @@ -29,6 +29,8 @@
>  #include <linux/notifier.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
>  #include <linux/mfd/abx500.h>
>  #include <linux/mfd/abx500/ab8500.h>
>  #include <linux/usb/musb-ux500.h>
> @@ -126,6 +128,7 @@ struct ab8500_usb {
>         unsigned vbus_draw;
>         struct work_struct phy_dis_work;
>         enum ab8500_usb_mode mode;
> +       struct clk *sysclk;
>         struct regulator *v_ape;
>         struct regulator *v_musb;
>         struct regulator *v_ulpi;
> @@ -252,6 +255,9 @@ static void ab8500_usb_phy_enable(struct ab8500_usb *ab, bool sel_host)
>         if (IS_ERR(ab->pinctrl))
>                 dev_err(ab->dev, "could not get/set default pinstate\n");
>
> +       if (clk_prepare_enable(ab->sysclk))
> +               dev_err(ab->dev, "can't prepare/enable clock\n");
> +
>         ab8500_usb_regulator_enable(ab);
>
>         abx500_mask_and_set_register_interruptible(ab->dev,
> @@ -274,6 +280,8 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
>         /* Needed to disable the phy.*/
>         ab8500_usb_wd_workaround(ab);
>
> +       clk_disable_unprepare(ab->sysclk);
> +
>         ab8500_usb_regulator_disable(ab);
>
>         if (!IS_ERR(ab->pinctrl)) {
> @@ -784,6 +792,12 @@ static int ab8500_usb_probe(struct platform_device *pdev)
>         if (err)
>                 return err;
>
> +       ab->sysclk = devm_clk_get(ab->dev, "sysclk");
> +       if (IS_ERR(ab->sysclk)) {
> +               dev_err(ab->dev, "Could not get sysclk.\n");
> +               return PTR_ERR(ab->sysclk);
> +       }
> +
>         err = ab8500_usb_irq_setup(pdev, ab);
>         if (err < 0)
>                 return err;
> --
> 1.8.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
