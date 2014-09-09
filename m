Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaIINRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:17:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20764 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbaIINRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:09 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-23-540efdd4d0c9
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
Subject: [PATCH 6/9] drm/exynos/dsi: unregister connector on removal
Date: Tue, 09 Sep 2014 15:16:10 +0200
Message-id: <1410268573-2297-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xK7pX/vKFGMz/I2Nxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXx7vQ7loJ1XBU9726wNDA2cnYxcnBICJhIfLxS28XICWSKSVy4
	t56ti5GLQ0hgKaPEheaDTBBOH5NE89/LzCBVbAKaEn8332QDsUUElCVW7WtnByliFvjIJHFl
	6RtmkKnCAi4SX3bkg9SwCKhKrJ94AyzMK+Ak0fiwFGKZnMTJY5NZQcKcAs4Sb/8FgISFgCoW
	vP3GPoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkID6uoNx6TGrQ4wCHIxKPLwT
	y/hChFgTy4orcw8xSnAwK4nwWr8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamDU+XtopivXm+ht
	IvFTnXh1mzflGWZO8dob9veW+E/uPcfCtN/Vt2lE7+rtXhNXeO6DTuKan4ly4kFaD2zdX3SE
	eT96vyDZ2y16upizgobLEpXGj4kZqb6736mc1mi+cZ4jYNOzVYZCduvW92hxnlF9yqS+I2td
	kEmF46ZVf5wE76afk+W9f06JpTgj0VCLuag4EQD+481TBgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During component unbind connector should be unregistered.
Also DSI host should be unregistered after KMS cleanup.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 0065a5a..24741d8 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1441,6 +1441,9 @@ exynos_dsi_detect(struct drm_connector *connector, bool force)
 
 static void exynos_dsi_connector_destroy(struct drm_connector *connector)
 {
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
+	connector->dev = NULL;
 }
 
 static struct drm_connector_funcs exynos_dsi_connector_funcs = {
@@ -1661,10 +1664,10 @@ static void exynos_dsi_unbind(struct device *dev, struct device *master,
 
 	exynos_dsi_dpms(&exynos_dsi_display, DRM_MODE_DPMS_OFF);
 
-	mipi_dsi_host_unregister(&dsi->dsi_host);
-
+	exynos_dsi_connector_destroy(&dsi->connector);
 	encoder->funcs->destroy(encoder);
-	drm_connector_cleanup(&dsi->connector);
+
+	mipi_dsi_host_unregister(&dsi->dsi_host);
 }
 
 static const struct component_ops exynos_dsi_component_ops = {
-- 
1.9.1

