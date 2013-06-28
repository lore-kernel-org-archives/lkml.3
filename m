Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3F1S4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3F1S4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 045/105] drm/radeon: do not try to uselessly update virtual memory pagetable
Date: Fri, 28 Jun 2013 11:51:07 -0700
Message-Id: <1372445527-24414-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 3813f5ca9ab7a00e80a17aab34f155453c66c78a upstream.

If a buffer is never bound to a virtual memory pagetable than don't try
to unbind it. Only drawback is that we don't update the pagetable when
unbinding the ib pool buffer which is fine because it only happens at
suspend or module unload/shutdown.

Fixes spurious messages about buffers without VM mappings. E.g.:
radeon 0000:01:00.0: bo ffff88020afac400 don't has a mapping in vm ffff88021ca2b900

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_gart.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 6e24f84..daf9710 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -1209,11 +1209,13 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 int radeon_vm_bo_rmv(struct radeon_device *rdev,
 		     struct radeon_bo_va *bo_va)
 {
-	int r;
+	int r = 0;
 
 	mutex_lock(&rdev->vm_manager.lock);
 	mutex_lock(&bo_va->vm->mutex);
-	r = radeon_vm_bo_update_pte(rdev, bo_va->vm, bo_va->bo, NULL);
+	if (bo_va->soffset) {
+		r = radeon_vm_bo_update_pte(rdev, bo_va->vm, bo_va->bo, NULL);
+	}
 	mutex_unlock(&rdev->vm_manager.lock);
 	list_del(&bo_va->vm_list);
 	mutex_unlock(&bo_va->vm->mutex);
-- 
1.8.1.2

