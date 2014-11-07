Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaKGNyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:54:33 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15872 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaKGNyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:54:17 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-be-545ccf0640ce
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
Subject: [PATCH v2 2/2] drm/exynos/dsi: Add runtime PM so LCD power domain
 could be turned off
Date: Fri, 07 Nov 2014 14:53:59 +0100
Message-id: <1415368439-23642-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
References: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xy7ps52NCDBa+V7S4te4cq0XvuZNM
	FhtnrGe1uPL1PZvFyiksFpPuT2CxeHHvIovF6xeGFr0LrrJZPN38mMnibNMbdotNj6+xWlze
	NYfNYsb5fUwWa4/cZbeYMfklm4OAx6ZVnWwe2789YPW4332cyWPzknqPvi2rGD2O39jO5PF5
	k1wAexSXTUpqTmZZapG+XQJXxsX7F9gLGoUqHsw6ztTAOIGvi5GDQ0LAROLFd+cuRk4gU0zi
	wr31bF2MXBxCAksZJT50XmKGcPqYJI5fm8sKUsUmYCyxefkSsCoRge9MElOerGcHSTALTGGS
	mHqmAsQWFkiQ+NexhAVkA4uAqsSao9kgYV4Bd4lLW6eyQGyTkzh5bDLYTE4BD4nejvdgthBQ
	zavj01knMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESvF92MC4+ZnWIUYCDUYmH
	t1MoJkSINbGsuDL3EKMEB7OSCO+N40Ah3pTEyqrUovz4otKc1OJDjEwcnFINjNM53/1S3mY/
	W5f/XnCM2C3TVr5FHleqFK/8zBPZX6PMPfc5u37lzP5Vz9/vcDQJn/w+ii1Ac8PE1F0tKyac
	divtL8r69H9i7yw9Ltate1In7HqW99iOocl49vKfdxaG6q2NE5rZk1sTGs124pZ/TuuLtpUf
	jL4cujdJeV3wvXwZ0b/b2nrjDyuxFGckGmoxFxUnAgC0zb7bPAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime Power Management to the Exynos DSI driver so the LCD power
domain could be turned off.

This slightly reduces the energy consumption when screen is completely
turned off. On Trats2 board when the system was idle the energy
consumption dropped by 1% (from 92.2 mA to 91.1 mA).

Before the patch:
$ cat cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
lcd0-power-domain               on
    /devices/11c00000.fimd                              suspended
    /devices/11c80000.dsi                               unsupported

After applying the patch:
lcd0-power-domain               off
    /devices/11c00000.fimd                              suspended
    /devices/11c80000.dsi                               suspended

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 24741d8758e8..19ed36d2d557 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -21,6 +21,7 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/phy/phy.h>
+#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/component.h>
 
@@ -1356,6 +1357,8 @@ static int exynos_dsi_enable(struct exynos_dsi *dsi)
 	if (dsi->state & DSIM_STATE_ENABLED)
 		return 0;
 
+	pm_runtime_get_sync(dsi->dev);
+
 	ret = exynos_dsi_poweron(dsi);
 	if (ret < 0)
 		return ret;
@@ -1392,6 +1395,8 @@ static void exynos_dsi_disable(struct exynos_dsi *dsi)
 	drm_panel_unprepare(dsi->panel);
 	exynos_dsi_poweroff(dsi);
 
+	pm_runtime_put_sync(dsi->dev);
+
 	dsi->state &= ~DSIM_STATE_ENABLED;
 }
 
@@ -1772,6 +1777,8 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_del_component;
 
+	pm_runtime_enable(&pdev->dev);
+
 	return ret;
 
 err_del_component:
@@ -1781,6 +1788,8 @@ err_del_component:
 
 static int exynos_dsi_remove(struct platform_device *pdev)
 {
+	pm_runtime_disable(&pdev->dev);
+
 	component_del(&pdev->dev, &exynos_dsi_component_ops);
 	exynos_drm_component_del(&pdev->dev, EXYNOS_DEVICE_TYPE_CONNECTOR);
 
-- 
1.9.1

