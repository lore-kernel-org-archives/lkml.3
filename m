Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3JNM0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:26:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12925 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3JNM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:26:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Oct 2013 05:26:12 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCHv2 3/4] drm/tegra: Deliver syncpoint base to user space
Date: Mon, 14 Oct 2013 15:21:54 +0300
Message-ID: <1381753315-21778-4-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
References: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a separate ioctl for delivering syncpoint base number
to user space. If the syncpoint does not have an associated base, the
function returns -ENXIO.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/drm.c | 25 +++++++++++++++++++++++++
 include/uapi/drm/tegra_drm.h | 26 +++++++++++++++++---------
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 8c61cee..c11cbf5 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -472,6 +472,30 @@ static int tegra_get_syncpt(struct drm_device *drm, void *data,
 	return 0;
 }
 
+static int tegra_get_syncpt_base(struct drm_device *drm, void *data,
+				 struct drm_file *file)
+{
+	struct drm_tegra_get_syncpt_base *args = data;
+	struct host1x_drm_file *fpriv = file->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+	struct host1x_syncpt_base *base;
+
+	if (!host1x_drm_file_owns_context(fpriv, context))
+		return -ENODEV;
+
+	if (args->index >= context->client->num_syncpts)
+		return -EINVAL;
+
+	base = context->client->syncpts[args->index]->base;
+	if (!base)
+		return -ENXIO;
+
+	args->base_id = base->id;
+
+	return 0;
+}
+
 static int tegra_submit(struct drm_device *drm, void *data,
 			struct drm_file *file)
 {
@@ -498,6 +522,7 @@ static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(TEGRA_CLOSE_CHANNEL, tegra_close_channel, DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT, tegra_get_syncpt, DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(TEGRA_SUBMIT, tegra_submit, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT_BASE, tegra_get_syncpt_base, DRM_UNLOCKED),
 #endif
 };
 
diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index 73bde4e..8b8094c 100644
--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -65,6 +65,12 @@ struct drm_tegra_get_syncpt {
 	__u32 id;
 };
 
+struct drm_tegra_get_syncpt_base {
+	__u64 context;
+	__u32 index;
+	__u32 base_id;
+};
+
 struct drm_tegra_syncpt {
 	__u32 id;
 	__u32 incrs;
@@ -115,15 +121,16 @@ struct drm_tegra_submit {
 	__u32 reserved[5];	/* future expansion */
 };
 
-#define DRM_TEGRA_GEM_CREATE	0x00
-#define DRM_TEGRA_GEM_MMAP	0x01
-#define DRM_TEGRA_SYNCPT_READ	0x02
-#define DRM_TEGRA_SYNCPT_INCR	0x03
-#define DRM_TEGRA_SYNCPT_WAIT	0x04
-#define DRM_TEGRA_OPEN_CHANNEL	0x05
-#define DRM_TEGRA_CLOSE_CHANNEL	0x06
-#define DRM_TEGRA_GET_SYNCPT	0x07
-#define DRM_TEGRA_SUBMIT	0x08
+#define DRM_TEGRA_GEM_CREATE		0x00
+#define DRM_TEGRA_GEM_MMAP		0x01
+#define DRM_TEGRA_SYNCPT_READ		0x02
+#define DRM_TEGRA_SYNCPT_INCR		0x03
+#define DRM_TEGRA_SYNCPT_WAIT		0x04
+#define DRM_TEGRA_OPEN_CHANNEL		0x05
+#define DRM_TEGRA_CLOSE_CHANNEL		0x06
+#define DRM_TEGRA_GET_SYNCPT		0x07
+#define DRM_TEGRA_SUBMIT		0x08
+#define DRM_TEGRA_GET_SYNCPT_BASE	0x09
 
 #define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_CREATE, struct drm_tegra_gem_create)
 #define DRM_IOCTL_TEGRA_GEM_MMAP DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_MMAP, struct drm_tegra_gem_mmap)
@@ -134,5 +141,6 @@ struct drm_tegra_submit {
 #define DRM_IOCTL_TEGRA_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_CLOSE_CHANNEL, struct drm_tegra_open_channel)
 #define DRM_IOCTL_TEGRA_GET_SYNCPT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT, struct drm_tegra_get_syncpt)
 #define DRM_IOCTL_TEGRA_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_SUBMIT, struct drm_tegra_submit)
+#define DRM_IOCTL_TEGRA_GET_SYNCPT_BASE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT_BASE, struct drm_tegra_get_syncpt_base)
 
 #endif
-- 
1.8.1.5

