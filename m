Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaKKLV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:21:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaKKLLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 142/170] drm/radeon: Use drm_malloc_ab instead of kmalloc_array
Date: Tue, 11 Nov 2014 11:08:21 +0000
Message-Id: <1415704129-12709-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit e5a5fd4df21b9c4acb67e815ec949cce594860f8 upstream.

Should avoid kmalloc failures due to large number of array entries.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=81991
Reviewed-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c   | 2 +-
 drivers/gpu/drm/radeon/radeon_ring.c | 4 ++--
 drivers/gpu/drm/radeon/radeon_vm.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 8f7d56f342f1..c50a1da6c12a 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -418,7 +418,7 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error, bo
 	kfree(parser->track);
 	kfree(parser->relocs);
 	kfree(parser->relocs_ptr);
-	kfree(parser->vm_bos);
+	drm_free_large(parser->vm_bos);
 	for (i = 0; i < parser->nchunks; i++)
 		drm_free_large(parser->chunks[i].kdata);
 	kfree(parser->chunks);
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index f8050f5429e2..2d763910fe5d 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -571,7 +571,7 @@ unsigned radeon_ring_backup(struct radeon_device *rdev, struct radeon_ring *ring
 	}
 
 	/* and then save the content of the ring */
-	*data = kmalloc_array(size, sizeof(uint32_t), GFP_KERNEL);
+	*data = drm_malloc_ab(size, sizeof(uint32_t));
 	if (!*data) {
 		mutex_unlock(&rdev->ring_lock);
 		return 0;
@@ -613,7 +613,7 @@ int radeon_ring_restore(struct radeon_device *rdev, struct radeon_ring *ring,
 	}
 
 	radeon_ring_unlock_commit(rdev, ring);
-	kfree(data);
+	drm_free_large(data);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_vm.c b/drivers/gpu/drm/radeon/radeon_vm.c
index 725d3669014f..abf8e2c876ac 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -132,8 +132,8 @@ struct radeon_cs_reloc *radeon_vm_get_bos(struct radeon_device *rdev,
 	struct radeon_cs_reloc *list;
 	unsigned i, idx;
 
-	list = kmalloc_array(vm->max_pde_used + 2,
-			     sizeof(struct radeon_cs_reloc), GFP_KERNEL);
+	list = drm_malloc_ab(vm->max_pde_used + 2,
+			     sizeof(struct radeon_cs_reloc));
 	if (!list)
 		return NULL;
 
-- 
2.1.0

