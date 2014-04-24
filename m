Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaDXIiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:38:55 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42743 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaDXIiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <1397847510-17199-1-git-send-email-tim.kryger@linaro.org>
References: <1397847510-17199-1-git-send-email-tim.kryger@linaro.org>
Date: Thu, 24 Apr 2014 10:38:50 +0200
Message-ID: <CAPDyKFp12-g0EXvnp0z2pQfiFxTRZMK4nK8y0XMUhUeDSOwNEA@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Try other signal levels during power up
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Chris Ball <chris@printf.net>, Linux MMC <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2014 20:58, Tim Kryger <tim.kryger@linaro.org> wrote:
> The eMMC signalling voltage is determined by VCCQ which is provided to
> the card by the host.  Signalling is not required to begin at 3.3v and,
> if the host and card both support a particular VCC/VCCQ combination, it
> can be used immediately.
>
> In contrast, SD Cards must begin with 3.3v signalling and may switch to
> a lower voltage signalling if instructed to do so in CMD11.  A message
> is required to coordinate this operation because the card only receives
> a 3.3v VDD and must know when to use the 1.8v produced by its internal
> regulator.
>
> It makes sense for the core to begin with 3.3v signalling but when that
> can't be set, 1.8v and 1.2v signalling also should be attempted.  This
> is especially important when an external regulator with a limited range
> is used to supply VCCQ to an eMMC part.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  drivers/mmc/core/core.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index acbc3f2..ecdbeae 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1517,6 +1517,8 @@ void mmc_set_driver_type(struct mmc_host *host, unsigned int drv_type)
>   */
>  void mmc_power_up(struct mmc_host *host, u32 ocr)
>  {
> +       int err;
> +

The variable err is not needed, since we don't plan on printing it nor
returning it. Please remove and handle the return code directly in the
if statements.

Kind regards
Ulf Hansson

>         if (host->ios.power_mode == MMC_POWER_ON)
>                 return;
>
> @@ -1534,7 +1536,13 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
>         mmc_set_ios(host);
>
>         /* Set signal voltage to 3.3V */
> -       __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330);
> +       err = __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330);
> +
> +       /* Since eMMC parts can start at 1.8v or 1.2v try those too */
> +       if (err)
> +               err = __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_180);
> +       if (err)
> +               __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_120);
>
>         /*
>          * This delay should be sufficient to allow the power supply
> --
> 1.7.9.5
>
