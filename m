Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaIINRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:17:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16655 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaIINRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:02 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f2-540efdcb5f1d
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 2/9] drm/exynos: fix drm driver de-initialization order
Date: Tue, 09 Sep 2014 15:16:06 +0200
Message-id: <1410268573-2297-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7qn//KFGDzsF7C4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mo4uqSTtWApZ8WD3puMDYxNHF2MnBwSAiYS2+6+YYSwxSQu3FvP
	1sXIxSEksJRRou/eQ1YIp49J4s+t0+wgVWwCmhJ/N99kA7FFBJQlVu1rZwcpYhb4yCRxZekb
	ZpCEsIC7xNGZT8GKWARUJZ7P3sYKYvMKOElMub0Gap2cxMljk4HiHBycAs4Sb/8FgISFgEoW
	vP3GPoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkLD6uoNx6TGrQ4wCHIxKPLwT
	y/hChFgTy4orcw8xSnAwK4nwWr8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamDUmuz8ZIui3023
	Pfs3vTXgWWZtqhP1a615bdGiXaWqTya4/DxhwNC+4Oaiv/V+V8tOd9TpToh9kvv6y4Y/kktO
	WnzK3bFp9Tfu2DOXHZe3LFXbLpvXuSrpm+rrjnJn8XOVazwixc5mBk6zKO64eH3ujPgLqw9u
	3CykeOmnQt9/Vu4whecJt39xKrEUZyQaajEXFScCAPMiNWEJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since components have their own cleanup routines calling
drm_mode_config_cleanup before component_unbind_all causes errors
due to double free of KMS objects. The patch fixes it by changing
de-initialization order. Now it is exactly opposite to init order.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index e11c4d6..b2c710a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -136,14 +136,14 @@ static int exynos_drm_unload(struct drm_device *dev)
 	exynos_drm_device_subdrv_remove(dev);
 
 	exynos_drm_fbdev_fini(dev);
-	drm_vblank_cleanup(dev);
 	drm_kms_helper_poll_fini(dev);
-	drm_mode_config_cleanup(dev);
 
+	component_unbind_all(dev->dev, dev);
+	drm_vblank_cleanup(dev);
+	drm_mode_config_cleanup(dev);
 	drm_release_iommu_mapping(dev);
-	kfree(dev->dev_private);
 
-	component_unbind_all(dev->dev, dev);
+	kfree(dev->dev_private);
 	dev->dev_private = NULL;
 
 	return 0;
-- 
1.9.1

