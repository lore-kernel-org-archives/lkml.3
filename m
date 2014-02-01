Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaBAD20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:28:26 -0500
Received: from gnurou.org ([207.192.72.5]:51772 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaBAD2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:23 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 22:28:23 EST
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 03/16] drm/nouveau: add platform device probing function
Date: Sat,  1 Feb 2014 12:16:45 +0900
Message-Id: <1391224618-3794-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a nouveau_drm_platform_probe() function that probes a Nouveau
platform device and registers it using drm_platform_init().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/base.c  | 34 ++++++++++++++++++++++
 .../gpu/drm/nouveau/core/include/engine/device.h   | 10 +++++++
 drivers/gpu/drm/nouveau/nouveau_drm.c              | 19 ++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
index a6abb51..ba6c2f2 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/base.c
@@ -543,3 +543,37 @@ done:
 	mutex_unlock(&nv_devices_mutex);
 	return ret;
 }
+
+int
+nouveau_device_platform_create_(struct platform_device *pdev, u64 name,
+				const char *sname, const char *cfg,
+				const char *dbg, int length, void **pobject)
+{
+	struct nouveau_device *device;
+	int ret = -EEXIST;
+
+	mutex_lock(&nv_devices_mutex);
+	list_for_each_entry(device, &nv_devices, head) {
+		if (device->handle == name)
+			goto done;
+	}
+
+	ret = nouveau_engine_create_(NULL, NULL, &nouveau_device_oclass, true,
+				     "DEVICE", "device", length, pobject);
+	device = *pobject;
+	if (ret)
+		goto done;
+
+	device->platformdev = pdev;
+	device->handle = name;
+	device->cfgopt = cfg;
+	device->dbgopt = dbg;
+	device->name = sname;
+
+	nv_subdev(device)->debug = nouveau_dbgopt(device->dbgopt, "DEVICE");
+	nv_engine(device)->sclass = nouveau_device_sclass;
+	list_add(&device->head, &nv_devices);
+done:
+	mutex_unlock(&nv_devices_mutex);
+	return ret;
+}
diff --git a/drivers/gpu/drm/nouveau/core/include/engine/device.h b/drivers/gpu/drm/nouveau/core/include/engine/device.h
index b3dd2c4..90056190 100644
--- a/drivers/gpu/drm/nouveau/core/include/engine/device.h
+++ b/drivers/gpu/drm/nouveau/core/include/engine/device.h
@@ -3,12 +3,22 @@
 
 #include <core/device.h>
 
+struct platform_device;
+
 #define nouveau_device_create(p,n,s,c,d,u)                                     \
 	nouveau_device_create_((p), (n), (s), (c), (d), sizeof(**u), (void **)u)
 
 int  nouveau_device_create_(struct pci_dev *, u64 name, const char *sname,
 			    const char *cfg, const char *dbg, int, void **);
 
+#define nouveau_device_platform_create(p,n,s,c,d,u)                            \
+	nouveau_device_platform_create_((p), (n), (s), (c), (d), sizeof(**u),  \
+					(void **)u)
+
+int nouveau_device_platform_create_(struct platform_device *pdev, u64 name,
+			       const char *sname, const char *cfg,
+			       const char *dbg, int, void **);
+
 int nv04_identify(struct nouveau_device *);
 int nv10_identify(struct nouveau_device *);
 int nv20_identify(struct nouveau_device *);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 4cba4d8..8d55a50 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -986,6 +986,25 @@ nouveau_drm_pci_driver = {
 	.driver.pm = &nouveau_pm_ops,
 };
 
+
+int nouveau_drm_platform_probe(struct platform_device *pdev)
+{
+	struct nouveau_device *device;
+	int ret;
+
+	ret = nouveau_device_platform_create(pdev, nouveau_platform_name(pdev),
+					   dev_name(&pdev->dev), nouveau_config,
+					   nouveau_debug, &device);
+
+	ret = drm_platform_init(&driver, pdev);
+	if (ret) {
+		nouveau_object_ref(NULL, (struct nouveau_object **)&device);
+		return ret;
+	}
+
+	return ret;
+}
+
 static int __init
 nouveau_drm_init(void)
 {
-- 
1.8.5.3

