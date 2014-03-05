Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbaCEO3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:29:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbaCEO12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 127/131] drm/radeon: fix missing bo reservation
Date: Wed,  5 Mar 2014 14:24:11 +0000
Message-Id: <1394029455-23128-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 5e386b574cf7e1593e1296e5b0feea4108ed6ad8 upstream.

Otherwise we might get a crash here.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index cc2ca38..42ff84b 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -504,6 +504,10 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 
 		radeon_vm_init(rdev, &fpriv->vm);
 
+		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
+		if (r)
+			return r;
+
 		/* map the ib pool buffer read only into
 		 * virtual address space */
 		bo_va = radeon_vm_bo_add(rdev, &fpriv->vm,
@@ -511,6 +515,8 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 		r = radeon_vm_bo_set_addr(rdev, bo_va, RADEON_VA_IB_OFFSET,
 					  RADEON_VM_PAGE_READABLE |
 					  RADEON_VM_PAGE_SNOOPED);
+
+		radeon_bo_unreserve(rdev->ring_tmp_bo.bo);
 		if (r) {
 			radeon_vm_fini(rdev, &fpriv->vm);
 			kfree(fpriv);
-- 
1.9.0

