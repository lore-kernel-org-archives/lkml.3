Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaF3MC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:02:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52056 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/181] drm/radeon: memory leak on bo reservation failure. v2
Date: Mon, 30 Jun 2014 13:51:47 +0200
Message-Id: <19142a08acf5fae289672ae075d707631fc479ad.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 74073c9dd29905645feb6dee03c144657a9844cd upstream.

On bo reservation failure, we end up leaking fpriv.

v2 (chk): rebased and added missing free on vm failure as well

Fixes: 5e386b574cf7e1 ("drm/radeon: fix missing bo reservation")
Cc: stable@vger.kernel.org
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Conflicts:
	drivers/gpu/drm/radeon/radeon_kms.c
---
 drivers/gpu/drm/radeon/radeon_kms.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 7456ce186f29..a134e8bf53f5 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -501,8 +501,11 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
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
2.0.0

