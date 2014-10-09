Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaJIVIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbaJIVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 109/163] drm/nouveau/runpm: fix module unload
Date: Thu,  9 Oct 2014 14:02:14 -0700
Message-Id: <1412888588-26755-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 53beaa01e0fe8e4202f43485a03b32fcf5dfea74 upstream.

Use the new vga_switcheroo_fini_domain_pm_ops function
to unregister the pm ops.

Based on a patch from:
Pali Rohár <pali.rohar@gmail.com>

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=84431

Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_vga.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_vga.c b/drivers/gpu/drm/nouveau/nouveau_vga.c
index 81638d7..13790ea 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vga.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vga.c
@@ -98,7 +98,16 @@ void
 nouveau_vga_fini(struct nouveau_drm *drm)
 {
 	struct drm_device *dev = drm->dev;
+	bool runtime = false;
+
+	if (nouveau_runtime_pm == 1)
+		runtime = true;
+	if ((nouveau_runtime_pm == -1) && (nouveau_is_optimus() || nouveau_is_v1_dsm()))
+		runtime = true;
+
 	vga_switcheroo_unregister_client(dev->pdev);
+	if (runtime && nouveau_is_v1_dsm() && !nouveau_is_optimus())
+		vga_switcheroo_fini_domain_pm_ops(drm->dev->dev);
 	vga_client_register(dev->pdev, NULL, NULL, NULL);
 }
 
-- 
1.9.1

