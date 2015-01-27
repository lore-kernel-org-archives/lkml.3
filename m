Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbbA0VGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:06:16 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34725 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbbA0VGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:06:13 -0500
MIME-Version: 1.0
In-Reply-To: <1422358221-13199-2-git-send-email-k.kozlowski@samsung.com>
References: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
	<1422358221-13199-2-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 27 Jan 2015 22:06:12 +0100
Message-ID: <CAAfyv34YoUG8dyq10mFZRQ-uf6-oT_KAbwZ1UQQ0FvFrs10BrQ@mail.gmail.com>
Subject: Re: [RFT PATCH 1/4] power_supply: twl4030_madc: Check return value of power_supply_register
From: Belisko Marek <marek.belisko@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzystof,

On Tue, Jan 27, 2015 at 12:30 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> The return value of power_supply_register() call was not checked and
> even on error probe() function returned 0. If registering failed then
> during unbind the driver tried to unregister power supply which was not
> actually registered.
>
> This could lead to memory corruption because power_supply_unregister()
> unconditionally cleans up given power supply.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: da0a00ebc239 ("power: Add twl4030_madc battery driver.")
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/power/twl4030_madc_battery.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
> index 7ef445a6cfa6..cf907609ec49 100644
> --- a/drivers/power/twl4030_madc_battery.c
> +++ b/drivers/power/twl4030_madc_battery.c
> @@ -192,6 +192,7 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
>  {
>         struct twl4030_madc_battery *twl4030_madc_bat;
>         struct twl4030_madc_bat_platform_data *pdata = pdev->dev.platform_data;
> +       int ret = 0;
>
>         twl4030_madc_bat = kzalloc(sizeof(*twl4030_madc_bat), GFP_KERNEL);
>         if (!twl4030_madc_bat)
> @@ -216,9 +217,11 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
>
>         twl4030_madc_bat->pdata = pdata;
>         platform_set_drvdata(pdev, twl4030_madc_bat);
> -       power_supply_register(&pdev->dev, &twl4030_madc_bat->psy);
> +       ret = power_supply_register(&pdev->dev, &twl4030_madc_bat->psy);
> +       if (ret < 0)
> +               kfree(twl4030_madc_bat);
I post update twl4030_madc to iio some time ago [1] where this change
was incorporated.
I plan to respin in next week so we can drop this one (or take and
I'll rebase on top).
>
> -       return 0;
> +       return ret;
>  }
>
>  static int twl4030_madc_battery_remove(struct platform_device *pdev)
> --
> 1.9.1
>

[1] - https://lkml.org/lkml/2014/3/5/284

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
