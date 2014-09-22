Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaIVQu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:50:58 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:65204 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaIVQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <1411329923-15912-4-git-send-email-heiko@sntech.de>
References: <1411329923-15912-1-git-send-email-heiko@sntech.de>
	<1411329923-15912-4-git-send-email-heiko@sntech.de>
Date: Mon, 22 Sep 2014 09:50:55 -0700
X-Google-Sender-Auth: qUUevzj2fL7leyJ3UR78gcjKoPE
Message-ID: <CAD=FV=Vkz1e-AEQv30YS-hFos59RES_4qNbH6Wu1UQvfAWLW8A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] power: gpio-charger: do not use gpio value directly
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: sre@kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Heiko Stuebner <heiko.stuebner@bq.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Sun, Sep 21, 2014 at 1:05 PM, Heiko Stuebner <heiko@sntech.de> wrote:
> From: Heiko Stuebner <heiko.stuebner@bq.com>
>
> Some gpio implementations return interesting values for gpio_get_value when
> the value is not 0 - as seen on a imx6sl board. Therefore do not use the
> value returned from gpio_get_value directly but simply check for 0 or not 0.
>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
> ---
>  drivers/power/gpio-charger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 5fe6879..ce99a29 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -57,7 +57,7 @@ static int gpio_charger_get_property(struct power_supply *psy,
>
>         switch (psp) {
>         case POWER_SUPPLY_PROP_ONLINE:
> -               val->intval = gpio_get_value_cansleep(pdata->gpio);
> +               val->intval = gpio_get_value_cansleep(pdata->gpio) ? 1 : 0;

There is a common practice about using "!!" for this.  AKA:
"val->intval = !!gpio_get_value_cansleep(pdata->gpio);".

>                 val->intval ^= pdata->gpio_active_low;

It seems like while you're at it you could also fix
"pdata->gpio_active_low" to have the "!!", just to be safe.

...if you don't fix this, perhaps you should fix your last patch to
add a "!!", like:

  pdata->gpio_active_low = !!(flags & OF_GPIO_ACTIVE_LOW);

...technically OF_GPIO_ACTIVE_LOW is 0x1 so it's not a bug, but...
