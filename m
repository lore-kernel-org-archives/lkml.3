Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaJWQWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:22:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35743 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbaJWQV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:21:29 -0400
Message-ID: <54492ADA.4000309@ti.com>
Date: Thu, 23 Oct 2014 19:20:42 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>
CC: Andrzej Hajda <a.hajda@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC 1/2] PM / Domains: Power on domain early during system resume
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com> <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 10/23/2014 04:48 PM, Krzysztof Kozlowski wrote:
> When resuming the system the power domain has to be powered on early so
> any runtime PM aware devices could resume.
> 
> This fixes following scenario reproduced on Exynos DRM:
> 1. Power domain is off before suspending the system.
> 2. System is suspended to RAM.
> 3. Resuming starts. The Exynos DRM driver resume callback is called.
> 4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
>     the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
> 5. The Exynos DSI driver calls pm_runtime_get. The driver runtime
>     resumes and this should turn LCD power domain on.
> 6. Unfortunately the domain cannot be turned on because system resume is
>     in progress and genpd->prepared_count is positive.

Just interesting, what value will be returned by pm_runtime_enabled()
from any of your .resume() callback (for any device which belongs to
some Generic PM domain)?

I'm asking, because as I can see Runtime PM can be disabled from pm_genpd_prepare().

Thank you.

Oh. I've just found that you might get this issue if you will try to do
suspend when PM domain is ON ;)

Any way, In my opinion, It might be better to fix pm_genpd_prepare() so
it will not increment prepared_count when initial state of the GPD is
GPD_STATE_POWER_OFF. Seems it's needed only in opposite case -
when state of GPD has to be restored from pm_genpd_resume_noirq().

> 
> Steps to reproduce:
> 1. Add runtime PM to Exynos DSI driver.
> 2. Build Exynos DRM/FB without FRAMEBUFFER_CONSOLE.
> 3. Enable the connector and screen (e.g. with modeset-vsync application).
> 4. echo 3 > /sys/devices/platform/exynos-drm/graphics/fb0/blank
> 5. echo mem > /sys/power/state
> 6. Resume.
> [   77.712469] PM: early resume of devices complete after 3.854 msecs
> [   77.712739] exynos-dsi 11c80000.dsi: pm_genpd_resume()
> [   77.712758] exynos4-fimc 11800000.fimc: pm_genpd_resume()
> [   77.712774] exynos4-fimc 11810000.fimc: pm_genpd_resume()
> [   77.712787] exynos-drm-fimc 11820000.fimc: pm_genpd_resume()
> [   77.712802] exynos-drm-fimc 11830000.fimc: pm_genpd_resume()
> [   77.712815] s5p-mipi-csis 11880000.csis: pm_genpd_resume()
> [   77.712829] s5p-mipi-csis 11890000.csis: pm_genpd_resume()
> [   77.712843] exynos-fimc-lite 12390000.fimc-lite: pm_genpd_resume()
> [   77.712856] exynos-fimc-lite 123a0000.fimc-lite: pm_genpd_resume()
> [   77.713788] exynos4-fb 11c00000.fimd: pm_genpd_resume()
> [   77.713912] wake disabled for irq 184
> [   77.713923] wake disabled for irq 185
> [   77.714082] wake disabled for irq 173
> [   77.715676] wake disabled for irq 176
> [   77.718540] exynos4-fb 11c00000.fimd: pm_genpd_runtime_resume()
> [   77.718567] exynos4-fb 11c00000.fimd: state restore latency exceeded, new value 1708 ns
> [   77.718636] exynos-dsi 11c80000.dsi: pm_genpd_runtime_resume()
> [   77.892366] exynos-dsi 11c80000.dsi: PLL failed to stabilize
> [   77.892377] exynos-dsi 11c80000.dsi: failed to configure DSI PLL
> [   78.192168] exynos-dsi 11c80000.dsi: timeout waiting for reset
> [   78.211578] exynos-dsi 11c80000.dsi: waiting for bus lanes timed out
> [   78.307173] exynos-dsi 11c80000.dsi: xfer timed out: d1 00 (null)
> [   78.307190] panel_s6e8aa0 11c80000.dsi.0: error -110 reading dcs seq(0xd1)
> [   78.307199] panel_s6e8aa0 11c80000.dsi.0: read id failed
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>   drivers/base/power/domain.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 40bc2f4072cc..4fdfe404a04c 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -179,8 +179,7 @@ static int __pm_genpd_poweron(struct generic_pm_domain *genpd)
>   	}
>   	finish_wait(&genpd->status_wait_queue, &wait);
>   
> -	if (genpd->status == GPD_STATE_ACTIVE
> -	    || (genpd->prepared_count > 0 && genpd->suspend_power_off))
> +	if (genpd->status == GPD_STATE_ACTIVE)
>   		return 0;
>   
>   	if (genpd->status != GPD_STATE_POWER_OFF) {
> 

regards,
-grygorii
