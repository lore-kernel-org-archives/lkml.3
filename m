Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbaGCNMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:12:40 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40894 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaGCNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:05 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-72-53b5566854c6
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
Subject: [PATCH 07/12] drm/exynos/ipp: simplify memory check function
Date: Thu, 03 Jul 2014 15:10:32 +0200
Message-id: <1404393037-17299-8-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7oZYVuDDTa/ErG4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mr4uOELc8FRwYrVx90aGJ/zdTFyckgImEgsn/eKCcIWk7hwbz1b
	FyMXh5DAUkaJ142foZw+Jomdb56xgVSxCWhK/N18E8wWEVCWWLWvnR2kiFngI5PElaVvmEES
	wgKuEq/b+8DGsgioSsw79gMozsHBK+AssakpFWKbnMTJY5NZQWxOAReJQzOXMoLYQkAla5fM
	ZZvAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhQfd3BuPSY1SFGAQ5GJR7eF/qb
	goVYE8uKK3MPMUpwMCuJ8FYEbw0W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKh8Y/5/sx2vfie/
	Y7Cb2abxrvTyvpOrmmYxLn29++tKaVXO6G6bww8ybp7ZxWqxqObGM/Z5x00WnRA6x54pnXVn
	D0/lno0LxGLXvJ7r++IQ21fj/P8BexZ3tGSLdjetrY8W713+6domZUPVL9nLSxRu3BFx83F0
	jp7Z/tKx9Ybyy2j/sgk58nOVWIozEg21mIuKEwGtQF9YCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only thing function should check is if there are buffers in respective
queues.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 44 ++++++++-------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 89ff7e3..b7ce14e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -574,42 +574,18 @@ static void ipp_clean_cmd_node(struct ipp_context *ctx,
 	kfree(c_node);
 }
 
-static int ipp_check_mem_list(struct drm_exynos_ipp_cmd_node *c_node)
+static bool ipp_check_mem_list(struct drm_exynos_ipp_cmd_node *c_node)
 {
-	struct drm_exynos_ipp_property *property = &c_node->property;
-	struct drm_exynos_ipp_mem_node *m_node;
-	struct list_head *head;
-	int ret, i, count[EXYNOS_DRM_OPS_MAX] = { 0, };
-
-	for_each_ipp_ops(i) {
-		/* source/destination memory list */
-		head = &c_node->mem_list[i];
-
-		/* find memory node entry */
-		list_for_each_entry(m_node, head, list) {
-			DRM_DEBUG_KMS("%s,count[%d]m_node[0x%x]\n",
-				i ? "dst" : "src", count[i], (int)m_node);
-			count[i]++;
-		}
+	switch (c_node->property.cmd) {
+	case IPP_CMD_WB:
+		return !list_empty(&c_node->mem_list[EXYNOS_DRM_OPS_DST]);
+	case IPP_CMD_OUTPUT:
+		return !list_empty(&c_node->mem_list[EXYNOS_DRM_OPS_SRC]);
+	case IPP_CMD_M2M:
+	default:
+		return !list_empty(&c_node->mem_list[EXYNOS_DRM_OPS_SRC]) &&
+		       !list_empty(&c_node->mem_list[EXYNOS_DRM_OPS_DST]);
 	}
-
-	DRM_DEBUG_KMS("min[%d]max[%d]\n",
-		min(count[EXYNOS_DRM_OPS_SRC], count[EXYNOS_DRM_OPS_DST]),
-		max(count[EXYNOS_DRM_OPS_SRC], count[EXYNOS_DRM_OPS_DST]));
-
-	/*
-	 * M2M operations should be need paired memory address.
-	 * so, need to check minimum count about src, dst.
-	 * other case not use paired memory, so use maximum count
-	 */
-	if (ipp_is_m2m_cmd(property->cmd))
-		ret = min(count[EXYNOS_DRM_OPS_SRC],
-			count[EXYNOS_DRM_OPS_DST]);
-	else
-		ret = max(count[EXYNOS_DRM_OPS_SRC],
-			count[EXYNOS_DRM_OPS_DST]);
-
-	return ret;
 }
 
 static struct drm_exynos_ipp_mem_node
-- 
1.9.1

