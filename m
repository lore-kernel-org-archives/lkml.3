Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaDYIQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:16:58 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:63575 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaDYIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <1398375866-8898-1-git-send-email-tim.kryger@linaro.org>
References: <1398375866-8898-1-git-send-email-tim.kryger@linaro.org>
Date: Fri, 25 Apr 2014 10:16:40 +0200
Message-ID: <CAPDyKFqUs+tq1+5xPLAjZrmTb1DjkLdVKzXs+-o1NH=b4HH-jQ@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: core: Try other signal levels during power up
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Chris Ball <chris@printf.net>, Linux MMC <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 23:44, Tim Kryger <tim.kryger@linaro.org> wrote:
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

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>
> Changes since v1:
>   - Eliminated temporary err variable and added debug output
>
>  drivers/mmc/core/core.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index acbc3f2..72926a9 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1533,8 +1533,13 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
>         host->ios.timing = MMC_TIMING_LEGACY;
>         mmc_set_ios(host);
>
> -       /* Set signal voltage to 3.3V */
> -       __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330);
> +       /* Try to set signal voltage to 3.3V but fall back to 1.8v or 1.2v */
> +       if (__mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_330) == 0)
> +               dev_dbg(mmc_dev(host), "Initial signal voltage of 3.3v\n");
> +       else if (__mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_180) == 0)
> +               dev_dbg(mmc_dev(host), "Initial signal voltage of 1.8v\n");
> +       else if (__mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_120) == 0)
> +               dev_dbg(mmc_dev(host), "Initial signal voltage of 1.2v\n");
>
>         /*
>          * This delay should be sufficient to allow the power supply
> --
> 1.7.9.5
>
