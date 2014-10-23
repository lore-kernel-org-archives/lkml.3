Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaJWNsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:48:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56271 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaJWNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:48:41 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-df-54490735a064
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 1/2] PM / Domains: Power on domain early during system resume
Date: Thu, 23 Oct 2014 15:48:09 +0200
Message-id: <1414072090-11293-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
References: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xa7pm7J4hBrMcLG6tO8dq0XvuJJPF
	xhnrWS2ufH3PZtG8eD2bxaT7E1gsXty7yGLx+oWhRe+Cq2wWZ5vesFvMmrKXyWLT42usFpd3
	zWGz+Nx7hNFixvl9TBZrj9xlt7h76iibxZnTl1gtZkx+yeYg7LF4z0smj+3fHrB67J+7ht3j
	fvdxJo/NS+o9tlxtZ/Ho27KK0WPF6u/sHp83yQVwRnHZpKTmZJalFunbJXBlzHqyhLXgn2TF
	iW9/mBoYn4h2MXJySAiYSHzYuoIVwhaTuHBvPVsXIxeHkMBSRomWnw1MEE4fk8SvXfvZQarY
	BIwlNi9fwgZiiwisZ5G4dNALpIhZYD+jxK+7K8FGCQt4S3yZthrMZhFQlXi2axmYzSvgLvH2
	93E2iHVyEiePTQaLcwp4SDyd85i5i5EDaJu7xLItFhMYeRcwMqxiFE0tTS4oTkrPNdIrTswt
	Ls1L10vOz93ECAn4rzsYlx6zOsQowMGoxMNbkewRIsSaWFZcmXuIUYKDWUmEN57VM0SINyWx
	siq1KD++qDQntfgQIxMHp1QDI/vFFFYNvS0LZqyMymSKkTr0cHfHotlhbcKF9Ysrv4Xt1tDe
	wCntzHE3U/ido9acifK1hXyzP3UorhBXeiNjuPrAny9sIVO9665e/LxwX3swU/qXZ41cES8W
	VTusM4mYoNnlvOrmG71vR+yCBNamdP5dqLbe89zxewej16z8Mk29NoLzVVwTqxJLcUaioRZz
	UXEiADxAs3tWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When resuming the system the power domain has to be powered on early so
any runtime PM aware devices could resume.

This fixes following scenario reproduced on Exynos DRM:
1. Power domain is off before suspending the system.
2. System is suspended to RAM.
3. Resuming starts. The Exynos DRM driver resume callback is called.
4. The Exynos DRM driver calls drm_helper_resume_force_mode which turns
   the screen on by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
5. The Exynos DSI driver calls pm_runtime_get. The driver runtime
   resumes and this should turn LCD power domain on.
6. Unfortunately the domain cannot be turned on because system resume is
   in progress and genpd->prepared_count is positive.

Steps to reproduce:
1. Add runtime PM to Exynos DSI driver.
2. Build Exynos DRM/FB without FRAMEBUFFER_CONSOLE.
3. Enable the connector and screen (e.g. with modeset-vsync application).
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
 drivers/base/power/domain.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 40bc2f4072cc..4fdfe404a04c 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -179,8 +179,7 @@ static int __pm_genpd_poweron(struct generic_pm_domain *genpd)
 	}
 	finish_wait(&genpd->status_wait_queue, &wait);
 
-	if (genpd->status == GPD_STATE_ACTIVE
-	    || (genpd->prepared_count > 0 && genpd->suspend_power_off))
+	if (genpd->status == GPD_STATE_ACTIVE)
 		return 0;
 
 	if (genpd->status != GPD_STATE_POWER_OFF) {
-- 
1.9.1

