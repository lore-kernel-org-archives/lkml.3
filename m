Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965762AbaH1JJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:09:18 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56444 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965689AbaH1JIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:37 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-05-53fef1940405
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
Subject: [PATCH v2 17/17] drm/exynos/ipp: add file checks for ioctls
Date: Thu, 28 Aug 2014 11:07:41 +0200
Message-id: <1409216861-12452-18-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7pTPv4LNlgwj8Pi1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugStj2pfCgpcCFUfXrGJtYJzE18XIySEhYCLxvO8DC4QtJnHh3nq2
	LkYuDiGBpYwSKzpmMEI4fUwSyxbsYAOpYhPQlPi7+SaYLSKgLLFqXzs7SBGzwEcmiStL3zCD
	JIQFXCTunJ7ADmKzCKhKLJ2xACzOCxRf0rKaCWKdnMTJY5NZQWxOoPjG42/A6oUEnCV2n//M
	NIGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkLD6uoNx6TGrQ4wCHIxKPLwKp/8E
	C7EmlhVX5h5ilOBgVhLhPXr8X7AQb0piZVVqUX58UWlOavEhRiYOTqkGxosll7o+sj3ubHFY
	YNiWHnR7r9zf7AiFrfseVS1Q8PVTn2llcs6pSW6/c57UHE7XUrnN1mcfHuO9uPmX1JYEifcZ
	9Sz/Z11YZr0n5aq7+ufDwlmcJXfkffjqPLgyuaor9sZKx6zOtnoc0aMguoJB4/Dc+4wqCsrL
	s4tqJi2Of9cRpvN6daedEktxRqKhFnNRcSIAuirp+gkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Process should not have access to ipp nodes created by another
process. The patch adds necessary checks.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index fc8bb67..d233cfc 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -318,7 +318,8 @@ static void ipp_print_property(struct drm_exynos_ipp_property *property,
 		sz->hsize, sz->vsize, config->flip, config->degree);
 }
 
-static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property)
+static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property,
+		struct drm_file *file)
 {
 	struct exynos_drm_ippdrv *ippdrv;
 	struct drm_exynos_ipp_cmd_node *c_node;
@@ -339,8 +340,12 @@ static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property)
 	 */
 	mutex_lock(&ippdrv->cmd_lock);
 	list_for_each_entry(c_node, &ippdrv->cmd_list, list) {
-		if ((c_node->property.prop_id == prop_id) &&
-		    (c_node->state == IPP_STATE_STOP)) {
+		if (c_node->property.prop_id == prop_id) {
+			if (c_node->filp != file)
+				break;
+			if (c_node->state != IPP_STATE_STOP)
+				break;
+
 			mutex_unlock(&ippdrv->cmd_lock);
 			DRM_DEBUG_KMS("found cmd[%d]ippdrv[0x%x]\n",
 				property->cmd, (int)ippdrv);
@@ -418,7 +423,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 	 */
 	if (property->prop_id) {
 		DRM_DEBUG_KMS("prop_id[%d]\n", property->prop_id);
-		return ipp_find_and_set_property(property);
+		return ipp_find_and_set_property(property, file);
 	}
 
 	/* find ipp driver using ipp id */
@@ -1032,7 +1037,7 @@ int exynos_drm_ipp_cmd_ctrl(struct drm_device *drm_dev, void *data,
 
 	c_node = ipp_find_obj(&ctx->prop_idr, &ctx->prop_lock,
 		cmd_ctrl->prop_id);
-	if (!c_node) {
+	if (!c_node || c_node->filp != file) {
 		DRM_ERROR("invalid command node list.\n");
 		return -ENODEV;
 	}
-- 
1.9.1

