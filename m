Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaCRQRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:17:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaCRQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:17:16 -0400
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/radeon: memory leak on bo reservation failure.
Date: Tue, 18 Mar 2014 17:16:52 +0100
Message-Id: <1395159412-12377-1-git-send-email-quentin.casasnovas@oracle.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On bo reservation failure, we end up leaking fpriv.

Fixes: 5e386b574cf7e1 ("drm/radeon: fix missing bo reservation")
Cc: stable@vger.kernel.org
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 66ed3ea..51cda80 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -546,8 +546,11 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
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
1.8.3.2

