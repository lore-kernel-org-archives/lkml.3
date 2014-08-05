Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaHEK4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:56:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44595 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaHEKtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:01 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-94-53e0b69b2d7d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 12/29] DRM: Exynos: fix window clear code
Date: Tue, 05 Aug 2014 12:47:40 +0200
Message-id: <1407235677-26324-13-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7qztz0INjjXLmnxd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgylg0eQVzwW6BimM7brM1MK7h7WLk5JAQMJG4
	2fuFHcIWk7hwbz1bFyMXh5DAUkaJ/Ze2MEI4fUwSM6f2MYJUsQkYSnS97QKrEhHoZZTob/rB
	BOIwC6xjldjfe50FpEpYwFLiZvN0JhCbRUBV4tucfWDdvAKeEt9frGaC2Ccn8f/lCjCbEyh+
	+OYBVhBbSMBD4ueGNewTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJna87GJce
	szrEKMDBqMTDq7D3brAQa2JZcWXuIUYJDmYlEV6JNQ+ChXhTEiurUovy44tKc1KLDzEycXBK
	NTDu/HBc9X2A9nfTmwnli26+LXPp1LA88OfZ4o86mafc5uxq3Ma+aNWqQMmcf28FT034fK+Z
	a++DFb2818za2z6v2yfH9EOD7f7fjL0xU/9q7WTnOvNMwE14XnmCx8b35/Zf+7y0Rnq16vE7
	Mz7s7Tx1oTbuu2Xahu0qGbF7n3a7/FLjK/t/7+iRZ0osxRmJhlrMRcWJAL2Rb+57AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To correctly disable hardware window during driver init, both enable bits
(WINCONx_ENWIN in WINCON and SHADOWCON_CHx_ENABLE in SHADOWCON) must be
cleared, otherwise hardware fails to re-enable such window later.

While touching this function, also temporarily disable ctx->suspended flag
to let fimd_wait_for_vblank function really to do its job.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 41904df..7a363d2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -165,27 +165,38 @@ static void fimd_wait_for_vblank(struct exynos_drm_manager *mgr)
 		DRM_DEBUG_KMS("vblank wait timed out.\n");
 }
 
-
 static void fimd_clear_channel(struct exynos_drm_manager *mgr)
 {
 	struct fimd_context *ctx = mgr->ctx;
-	int win, ch_enabled = 0;
+	int state, win, ch_enabled = 0;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
 	/* Check if any channel is enabled. */
 	for (win = 0; win < WINDOWS_NR; win++) {
-		u32 val = readl(ctx->regs + SHADOWCON);
-		if (val & SHADOWCON_CHx_ENABLE(win)) {
-			val &= ~SHADOWCON_CHx_ENABLE(win);
-			writel(val, ctx->regs + SHADOWCON);
+		u32 val = readl(ctx->regs + WINCON(win));
+		if (val & WINCONx_ENWIN) {
+			/* wincon */
+			val &= ~WINCONx_ENWIN;
+			writel(val, ctx->regs + WINCON(win));
+
+			/* unprotect windows */
+			if (ctx->driver_data->has_shadowcon) {
+				val = readl(ctx->regs + SHADOWCON);
+				val &= ~SHADOWCON_CHx_ENABLE(win);
+				writel(val, ctx->regs + SHADOWCON);
+			}
 			ch_enabled = 1;
 		}
 	}
 
 	/* Wait for vsync, as disable channel takes effect at next vsync */
-	if (ch_enabled)
+	if (ch_enabled) {
+		state = ctx->suspended;
+		ctx->suspended = 0;
 		fimd_wait_for_vblank(mgr);
+		ctx->suspended = state;
+	}
 }
 
 static int fimd_mgr_initialize(struct exynos_drm_manager *mgr,
-- 
1.9.2

