Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaJTQ0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:26:15 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36996 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaJTQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:26:09 -0400
MIME-Version: 1.0
In-Reply-To: <1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 20 Oct 2014 09:26:08 -0700
X-Google-Sender-Auth: 4nzFc2olIhFrcKL6Z9SEi07jBJE
Message-ID: <CAD=FV=UtwNjyx56QtRrEo=jbX_PeMRAYZJVXzxqeS-vs4JyGRg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Thu, Oct 16, 2014 at 3:13 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The regulator framework has a set of helpers functions to be used when
> the system is entering and leaving from suspend but these are not called
> on Exynos platforms. This means that the .set_suspend_* function handlers
> defined by regulator drivers are not called when the system is suspended.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/mach-exynos/suspend.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
> index cc8d237..ee9a8e0 100644
> --- a/arch/arm/mach-exynos/suspend.c
> +++ b/arch/arm/mach-exynos/suspend.c
> @@ -20,6 +20,7 @@
>  #include <linux/io.h>
>  #include <linux/irqchip/arm-gic.h>
>  #include <linux/err.h>
> +#include <linux/regulator/machine.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/hardware/cache-l2x0.h>
> @@ -443,6 +444,22 @@ static int exynos_suspend_enter(suspend_state_t state)
>
>  static int exynos_suspend_prepare(void)
>  {
> +       int ret;
> +
> +       /*
> +        * REVISIT: It would be better if struct platform_suspend_ops
> +        * .prepare handler get the suspend_state_t as a parameter to
> +        * avoid hard-coding the suspend to mem state. It's safe to do
> +        * it now only because the suspend_valid_only_mem function is
> +        * used as the .valid callback used to check if a given state
> +        * is supported by the platform anyways.
> +        */
> +       ret = regulator_suspend_prepare(PM_SUSPEND_MEM);
> +       if (ret) {
> +               pr_err("Failed to prepare regulators for system suspend\n");
> +               return ret;
> +       }
> +
>         s3c_pm_check_prepare();
>
>         return 0;
> @@ -451,6 +468,7 @@ static int exynos_suspend_prepare(void)
>  static void exynos_suspend_finish(void)
>  {
>         s3c_pm_check_cleanup();
> +       regulator_suspend_finish();

It turns out that regulator_suspend_finish() actually returns an error
code.  Could you print a warning if you see it?

Other than that, feel free to add my Reviewed-by.  Thanks!

-Doug
