Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaCYRuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:50:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55759 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbaCYRU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:20:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 77/81] drm/radeon: fix missing bo reservation
Date: Tue, 25 Mar 2014 10:16:30 -0700
Message-Id: <1395767794-5012-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 5e386b574cf7e1593e1296e5b0feea4108ed6ad8 upstream.

Otherwise we might get a crash here.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 2e9209c..89c85e0 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -459,6 +459,10 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 
 		radeon_vm_init(rdev, &fpriv->vm);
 
+		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
+		if (r)
+			return r;
+
 		/* map the ib pool buffer read only into
 		 * virtual address space */
 		bo_va = radeon_vm_bo_add(rdev, &fpriv->vm,
@@ -466,6 +470,8 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 		r = radeon_vm_bo_set_addr(rdev, bo_va, RADEON_VA_IB_OFFSET,
 					  RADEON_VM_PAGE_READABLE |
 					  RADEON_VM_PAGE_SNOOPED);
+
+		radeon_bo_unreserve(rdev->ring_tmp_bo.bo);
 		if (r) {
 			radeon_vm_fini(rdev, &fpriv->vm);
 			kfree(fpriv);
-- 
1.8.3.2

