Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaKYLvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:51:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58219 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaKYKkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 051/254] drm/nouveau/bar: behave better if ioremap failed
Date: Tue, 25 Nov 2014 10:36:41 +0000
Message-Id: <1416912004-5928-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit e7d96929a7cd93e146af0d1fd251fa1ec2e3ebf8 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
index 73b1ed20c8d5..8bcbdf39cfb2 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
@@ -99,8 +99,13 @@ nouveau_bar_alloc(struct nouveau_bar *bar, struct nouveau_object *parent,
 		  struct nouveau_mem *mem, struct nouveau_object **pobject)
 {
 	struct nouveau_object *engine = nv_object(bar);
-	return nouveau_object_ctor(parent, engine, &nouveau_barobj_oclass,
-				   mem, 0, pobject);
+	int ret = -ENOMEM;
+	if (bar->iomem) {
+		ret = nouveau_object_ctor(parent, engine,
+					  &nouveau_barobj_oclass,
+					  mem, 0, pobject);
+	}
+	return ret;
 }
 
 int
@@ -118,9 +123,12 @@ nouveau_bar_create_(struct nouveau_object *parent,
 	if (ret)
 		return ret;
 
-	if (nv_device_resource_len(device, 3) != 0)
+	if (nv_device_resource_len(device, 3) != 0) {
 		bar->iomem = ioremap(nv_device_resource_start(device, 3),
 				     nv_device_resource_len(device, 3));
+		if (!bar->iomem)
+			nv_warn(bar, "PRAMIN ioremap failed\n");
+	}
 
 	return 0;
 }
-- 
2.1.0

