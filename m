Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaEBQap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:30:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43626 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>, Tim Gardner <tim.gardner@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/151] drm/nouveau: don't suspend/resume display on runtime s/r
Date: Fri,  2 May 2014 08:36:30 -0700
Message-Id: <1399045139-4531-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 05c63c2ff23a80b654d6c088ac3ba21628db0173 upstream.

This should ensure we don't hit a locking problem when someone
wakes us up via a connector, we should never go into suspend
while the display is on anyways.

Signed-off-by: Dave Airlie <airlied@redhat.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1313986
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 7431033..a5a2e72 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -486,13 +486,13 @@ nouveau_drm_remove(struct pci_dev *pdev)
 }
 
 static int
-nouveau_do_suspend(struct drm_device *dev)
+nouveau_do_suspend(struct drm_device *dev, bool runtime)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_cli *cli;
 	int ret;
 
-	if (dev->mode_config.num_crtc) {
+	if (dev->mode_config.num_crtc && !runtime) {
 		NV_INFO(drm, "suspending display...\n");
 		ret = nouveau_display_suspend(dev);
 		if (ret)
@@ -560,7 +560,7 @@ int nouveau_pmops_suspend(struct device *dev)
 	if (drm_dev->mode_config.num_crtc)
 		nouveau_fbcon_set_suspend(drm_dev, 1);
 
-	ret = nouveau_do_suspend(drm_dev);
+	ret = nouveau_do_suspend(drm_dev, false);
 	if (ret)
 		return ret;
 
@@ -640,7 +640,7 @@ static int nouveau_pmops_freeze(struct device *dev)
 	if (drm_dev->mode_config.num_crtc)
 		nouveau_fbcon_set_suspend(drm_dev, 1);
 
-	ret = nouveau_do_suspend(drm_dev);
+	ret = nouveau_do_suspend(drm_dev, false);
 	return ret;
 }
 
@@ -871,7 +871,7 @@ static int nouveau_pmops_runtime_suspend(struct device *dev)
 	drm_kms_helper_poll_disable(drm_dev);
 	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
 	nouveau_switcheroo_optimus_dsm();
-	ret = nouveau_do_suspend(drm_dev);
+	ret = nouveau_do_suspend(drm_dev, true);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3cold);
@@ -897,8 +897,6 @@ static int nouveau_pmops_runtime_resume(struct device *dev)
 	pci_set_master(pdev);
 
 	ret = nouveau_do_resume(drm_dev);
-	if (drm_dev->mode_config.num_crtc)
-		nouveau_display_resume(drm_dev);
 	drm_kms_helper_poll_enable(drm_dev);
 	/* do magic */
 	nv_mask(device, 0x88488, (1 << 25), (1 << 25));
-- 
1.9.1

