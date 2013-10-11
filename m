Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3JKIDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab3JKIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:01:34 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/6] [wip] drm/qxl: request regions
Date: Fri, 11 Oct 2013 10:01:12 +0200
Message-Id: <1381478473-18159-6-git-send-email-kraxel@redhat.com>
In-Reply-To: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
References: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So they show up in /proc/{iomem,ioports}.

No error checking (yet?).  Doesn't make things
worse than they are now, but still not nice.

Known issue: Doesn't work for qxl-vram (vesafb conflict?).

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/qxl/qxl_kms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index e5ca498..d430f3c 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -264,6 +264,11 @@ int qxl_device_init(struct qxl_device *qdev,
 	if (r)
 		return r;
 
+	r = pci_request_region(pdev, 0, "qxl-vram");
+	r = pci_request_region(pdev, 2, "qxl-rom");
+	r = pci_request_region(pdev, 3, "qxl-io");
+	r = pci_request_region(pdev, sb, "qxl-surface");
+
 	return 0;
 }
 
@@ -289,6 +294,7 @@ static void qxl_device_fini(struct qxl_device *qdev)
 	qdev->mode_info.modes = NULL;
 	qdev->mode_info.num_modes = 0;
 	qxl_debugfs_remove_files(qdev);
+	pci_release_regions(qdev->pdev);
 }
 
 int qxl_driver_unload(struct drm_device *dev)
-- 
1.8.3.1

