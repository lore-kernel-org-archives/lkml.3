Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaHDEWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:22:19 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:32932 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHDEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:22:18 -0400
MIME-Version: 1.0
In-Reply-To: <1406808468-12559-1-git-send-email-broonie@kernel.org>
References: <1406808468-12559-1-git-send-email-broonie@kernel.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 4 Aug 2014 13:21:57 +0900
Message-ID: <CAAVeFuKv_Qd2u60zSYYKicahDcH1wKs2BVQRGhNsF9civT_S2g@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Don't allow drivers to specify a base with DT
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 9:07 PM, Mark Brown <broonie@kernel.org> wrote:
> From: Mark Brown <broonie@linaro.org>
>
> DT based systems should have no reason to use fixed GPIO numbers but some
> drivers that work on both DT and non-DT platforms specify them anyway. In
> order to improve robustness in cases where drivers use gpio_is_valid() to
> check for a valid GPIO on data initialized to zero as a default and avoid
> bugs due to assuptions about fixed numbers creeping in ignore any specified
> base when DT is in use.

I agree that DT users should not use the base number at all - but the
fact is some of them are doing it. Aren't we going to break some
user-space users that will expect to find a GPIO under a given number?

Also, how is this going to help with gpio_is_valid() against
zero-initialized data?

>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/gpio/gpiolib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 768f0831db18..11d3cf1cbca7 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -234,7 +234,7 @@ int gpiochip_add(struct gpio_chip *chip)
>
>         spin_lock_irqsave(&gpio_lock, flags);
>
> -       if (base < 0) {
> +       if (base < 0 || of_have_populated_dt()) {
>                 base = gpiochip_find_base(chip->ngpio);
>                 if (base < 0) {
>                         status = base;
> --
> 2.0.1
>
