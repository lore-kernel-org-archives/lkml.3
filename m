Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaJOQTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:19:55 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58296 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaJOQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <1413374496-27866-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413374496-27866-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Wed, 15 Oct 2014 09:19:52 -0700
X-Google-Sender-Auth: DoLwkjrZKY85oZzayVDnI7DfDvc
Message-ID: <CAD=FV=VT9RBitk5NoMKBRm=RVoNC4roLFEBLpd_L7Fuvxvs9SQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: EXYNOS: Call regulator core suspend prepare and
 finish functions
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
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

On Wed, Oct 15, 2014 at 5:01 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The regulator framework has a set of helpers functions to be used when
> the system is entering and leaving from suspend but these are not called
> on Exynos platforms. This means that the .set_suspend_* function handlers
> defined in regulator drivers are never called when the system is suspended.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Could you also add a patch to your series ripping out the call in
"drivers/mfd/sec-core.c" since it doesn't belong there.  If you don't
rip that out then it will be called twice on systems with that
regulator.


> ---
>  arch/arm/mach-exynos/suspend.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
> index f5d9773..5b9c551 100644
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
> @@ -270,14 +271,29 @@ static int exynos_suspend_enter(suspend_state_t state)
>
>  static int exynos_suspend_prepare(void)
>  {
> +       int ret;
> +
>         s3c_pm_check_prepare();
>
> +       /*
> +        * REVISIT: It would be better if struct platform_suspend_ops
> +        * .prepare handler get the suspend_state_t as a parameter to
> +        * avoid hard-coding the suspend to mem state. It's safe to do
> +        * it only because the suspend_valid_only_mem function is the
> +        * .valid callback used to check if a given state is supported
> +        * by the platform.
> +        */
> +       ret = regulator_suspend_prepare(PM_SUSPEND_MEM);
> +       if (ret)
> +               pr_info("Failed to prepare regulators for system suspend\n");
> +

nit: can you put this before s3c_pm_check_prepare().  pm_check is
pretty darn broken and I have a feeling that it will eventually be
ripped out (or in the very least ported to not be Samsung-specific and
include all of the "suspend volatile" crud that we have in the
chromeos-3.8 kernel), but might as well try not to break it further.

Changing the order also has the advantage of making prepare / finish
opposite orders (good!) and handling the fact that you would call
s3c_pm_check_prepare() but not s3c_pm_check_cleanup() if
regulator_suspend_prepare() fails.


>         return 0;
>  }
>
>  static void exynos_suspend_finish(void)
>  {
>         s3c_pm_check_cleanup();
> +       regulator_suspend_finish();
>  }
>
>  static const struct platform_suspend_ops exynos_suspend_ops = {
> --
> 2.1.0
>
