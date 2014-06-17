Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbaFQQSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:18:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50439 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbaFQQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 019/121] drm/radeon: memory leak on bo reservation failure. v2
Date: Tue, 17 Jun 2014 09:13:32 -0700
Message-Id: <1403021714-16320-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

commit 74073c9dd29905645feb6dee03c144657a9844cd upstream.

On bo reservation failure, we end up leaking fpriv.

v2 (chk): rebased and added missing free on vm failure as well

Fixes: 5e386b574cf7e1 ("drm/radeon: fix missing bo reservation")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
[ kamal: backport to 3.13-stable: omit radeon_vm_init() return check ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 89c85e0..32a5dae 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -460,8 +460,11 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 		radeon_vm_init(rdev, &fpriv->vm);
 
 		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
-		if (r)
+		if (r) {
+			radeon_vm_fini(rdev, &fpriv->vm);
+			kfree(fpriv);
 			return r;
+		}
 
 		/* map the ib pool buffer read only into
 		 * virtual address space */
-- 
1.9.1

