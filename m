Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3JUWeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:34:05 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57672 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3JUWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:34:01 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 6/6] drm: zap mmaps for dead devices
Date: Tue, 22 Oct 2013 00:33:28 +0200
Message-Id: <1382394808-20611-7-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
References: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once a DRM device is unregistered, user-space must not access any existing
mmaps, anymore. As we cannot rely on this, we now zap all of them in
drm_dev_unregister().

Any driver which wants to support that needs to protect their fault()
and mmap() handlers via drm_dev_get_active(), otherwise users can create
new mmaps after/during drm_dev_unregister().

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/drm_stub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index e363b72..274a005 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -602,6 +602,10 @@ void drm_dev_unregister(struct drm_device *dev)
 
 	drm_dev_shutdown(dev);
 
+	/* zap all memory mappings (drm_global_mutex must not be locked) */
+	if (dev->dev_mapping)
+		unmap_mapping_range(dev->dev_mapping, 0, LLONG_MAX, 1);
+
 	/* We cannot hold drm_global_mutex during drm_dev_shutdown() as it might
 	 * dead-lock. Hence, there's a small race between drm_dev_shutdown() and
 	 * us locking drm_global_mutex which drm_release() might trigger. To fix
-- 
1.8.4.1

