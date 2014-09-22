Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaIVQGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:06:18 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49771 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIVQGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:06:16 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>, Wolfram Sang <wsa@the-dreams.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-rk3x: move setup to the earlier subsys initcall
Date: Mon, 22 Sep 2014 18:05:43 +0200
Message-ID: <7192455.FveG5nGWsJ@xq-nb>
User-Agent: KMail/4.13.3 (Linux/3.17.0-031700rc4-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1411370675-27866-1-git-send-email-zyw@rock-chips.com>
References: <1411370675-27866-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bt83T/m9e1ccGshWiBxR3uGxvmFjuRGl2EluFokEwLM
 XLTR52pwlwHVidcSPnlPKgMH1LlJVLHltHUMkWAP0I9dat68WT
 UwpPZy6Rl0CDfLe+fJMcPXjNuCAzVVn/jXy+RKUwGXcihDfLGI
 Zplax9mLYuVbAzET3eSLMAXAyr7SvUWQkFtZf1cwhYM/rxPysT
 GrAXFsRdcLTE52++zKbCa20gTxjOUtobXV4RjCXscYTUgQg2V0
 b18pvPwNcLXeka3mBhedfB7FqUbt4c0lNkCr3IeWeK+taxPo90
 zLhW6Xjqxc3Cqw+8NKdyABnT1At+sf6Qulg5C0PMyj8ASYsMUb
 m8lLvvkhpdTJuuBbyENM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Montag, 22. September 2014, 15:24:35 schrieb Chris Zhong:
> Some device using this bus, such as regulators, they should register
> as early as possible, so the I2C bus master needs to be loaded early.
> Therefore initialize via subsys_initcall() is better.

You could also use probe deferral in the regulator driver to wait until the 
bus is ready. I don't know if you're already doing it, just wanted to point 
that out.

That said, this change will make the boot faster in any case by avoiding 
unnecessary deferrals, so I'm for it if you fix the minor issue below.

> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> ---
> 
>  drivers/i2c/busses/i2c-rk3x.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index e637c32..5b91901 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -760,7 +760,18 @@ static struct platform_driver rk3x_i2c_driver = {
>  	},
>  };
> 
> -module_platform_driver(rk3x_i2c_driver);
> +static int __init rk3x_i2c_init_driver(void)
> +{
> +	return platform_driver_register(&rk3x_i2c_driver);
> +}
> +
> +static void __exit rk3x_i2c_exit_driver(void)
> +{
> +	platform_driver_unregister(&rk3x_i2c_driver);
> +}
> +
> +subsys_initcall(rk3x_i2c_init_driver);
> +module_exit(rk3x_i2c_exit_driver);

This means that the driver cannot be used as a loadable module any more, 
right?

In that case, you should probably turn the tristate option in Kconfig into a 
bool.

Cheers,
  Max

