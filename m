Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaKGNyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:54:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17574 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaKGNyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:54:17 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-b7-545ccf051afe
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/2] drm/exynos: Fix DSI resuming fail because power domain
 being off
Date: Fri, 07 Nov 2014 14:53:58 +0100
Message-id: <1415368439-23642-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
References: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7qs52NCDLZ81LC4te4cq0XvuZNM
	FhtnrGe1uPL1PZvFyiksFpPuT2CxeHHvIovF6xeGFr0LrrJZPN38mMnibNMbdotNj6+xWlze
	NYfNYsb5fUwWa4/cZbeYMfklm4OAx6ZVnWwe2789YPW4332cyWPzknqPvi2rGD2O39jO5PF5
	k1wAexSXTUpqTmZZapG+XQJXxsrWK4wF76Uq9l6cy9zAeFCsi5GTQ0LAROL3wb9MELaYxIV7
	69m6GLk4hASWMkr8e3YKyuljktjz6DVYFZuAscTm5UvAEiIC35kkpjxZzw6SYBaYwiQx9UxF
	FyMHh7BAlMTFzwogYRYBVYml638zg9i8Au4SXz59YobYJidx8thkVhCbU8BDorfjPZgtBFTz
	6vh01gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITvlx2Mi49ZHWIU4GBU4uHt
	FIoJEWJNLCuuzD3EKMHBrCTCe+M4UIg3JbGyKrUoP76oNCe1+BAjEwenVAPjrJJ5W9iOr+Za
	xtFa53Bt8v/Cxv9GrPNX6Kj8Yw6zae7rvZhVvOzaqR1Ozx5s2+0V5+7qZ5Hazf+hfnXoQpa9
	nyQ+Oc84rHOeb06Jy+u50b2PPycs78npOW/o8ERop32T6rKlq4oczf9dNDrJw9tjV2rwoTbq
	SP+EGzuVfL85ePy/eSmd9Vy8EktxRqKhFnNRcSIAHrpiZz0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During system resume from suspend to RAM the Exynos DRM driver forced
CRTC mode thus turning display on (DPMS_ON). This lead to runtime resuming
of DSI which failed because whole LCD power domain was off and it was
not allowed to turn on because of system resume in progress.

Forcing mode should not be needed and removing it solves this particular
problem.

This necessary fix for following scenario reproduced on Exynos DRM:
1. Power domain is off before suspending the system.
2. System is suspended to RAM.
3. Resuming starts. The Exynos DRM driver resume callback is called.
4. The Exynos DRM driver calls drm_helper_resume_force_mode() which turns
   on the screen by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
5. The Exynos DSI driver calls pm_runtime_get. The driver runtime
   resumes and this should turn LCD power domain on.
6. Unfortunately the domain cannot be turned on because system resume is
   in progress and genpd->prepared_count is positive.

Steps to reproduce:
1. Add runtime PM to Exynos DSI driver.
2. Build Exynos DRM/FB without FRAMEBUFFER_CONSOLE.
3. Enable the connector and screen (e.g. with modeset-vsync).
4. echo 3 > /sys/devices/platform/exynos-drm/graphics/fb0/blank
5. echo mem > /sys/power/state
6. Resume.
[   77.712469] PM: early resume of devices complete after 3.854 msecs
[   77.712739] exynos-dsi 11c80000.dsi: pm_genpd_resume()
[   77.712758] exynos4-fimc 11800000.fimc: pm_genpd_resume()
[   77.712774] exynos4-fimc 11810000.fimc: pm_genpd_resume()
[   77.712787] exynos-drm-fimc 11820000.fimc: pm_genpd_resume()
[   77.712802] exynos-drm-fimc 11830000.fimc: pm_genpd_resume()
[   77.712815] s5p-mipi-csis 11880000.csis: pm_genpd_resume()
[   77.712829] s5p-mipi-csis 11890000.csis: pm_genpd_resume()
[   77.712843] exynos-fimc-lite 12390000.fimc-lite: pm_genpd_resume()
[   77.712856] exynos-fimc-lite 123a0000.fimc-lite: pm_genpd_resume()
[   77.713788] exynos4-fb 11c00000.fimd: pm_genpd_resume()
[   77.713912] wake disabled for irq 184
[   77.713923] wake disabled for irq 185
[   77.714082] wake disabled for irq 173
[   77.715676] wake disabled for irq 176
[   77.718540] exynos4-fb 11c00000.fimd: pm_genpd_runtime_resume()
[   77.718567] exynos4-fb 11c00000.fimd: state restore latency exceeded, new value 1708 ns
[   77.718636] exynos-dsi 11c80000.dsi: pm_genpd_runtime_resume()
[   77.892366] exynos-dsi 11c80000.dsi: PLL failed to stabilize
[   77.892377] exynos-dsi 11c80000.dsi: failed to configure DSI PLL
[   78.192168] exynos-dsi 11c80000.dsi: timeout waiting for reset
[   78.211578] exynos-dsi 11c80000.dsi: waiting for bus lanes timed out
[   78.307173] exynos-dsi 11c80000.dsi: xfer timed out: d1 00 (null)
[   78.307190] panel_s6e8aa0 11c80000.dsi.0: error -110 reading dcs seq(0xd1)
[   78.307199] panel_s6e8aa0 11c80000.dsi.0: read id failed

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index d32165a7f862..8f7110c9d21f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -200,8 +200,6 @@ static int exynos_drm_resume(struct drm_device *dev)
 	}
 	drm_modeset_unlock_all(dev);
 
-	drm_helper_resume_force_mode(dev);
-
 	return 0;
 }
 
-- 
1.9.1

