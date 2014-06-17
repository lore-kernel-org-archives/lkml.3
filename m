Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967026AbaFQWOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:14:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966780AbaFQVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 185/212] drm/radeon: avoid crash if VM command submission isn't available
Date: Tue, 17 Jun 2014 14:44:39 -0700
Message-Id: <1403041506-13646-186-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 60a445405a1731bac2279eab354173c9c3156747 upstream.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 0b36616..8093a25 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -276,10 +276,17 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 			return -EINVAL;
 
 		/* we only support VM on some SI+ rings */
-		if ((p->rdev->asic->ring[p->ring]->cs_parse == NULL) &&
-		   ((p->cs_flags & RADEON_CS_USE_VM) == 0)) {
-			DRM_ERROR("Ring %d requires VM!\n", p->ring);
-			return -EINVAL;
+		if ((p->cs_flags & RADEON_CS_USE_VM) == 0) {
+			if (p->rdev->asic->ring[p->ring]->cs_parse == NULL) {
+				DRM_ERROR("Ring %d requires VM!\n", p->ring);
+				return -EINVAL;
+			}
+		} else {
+			if (p->rdev->asic->ring[p->ring]->ib_parse == NULL) {
+				DRM_ERROR("VM not supported on ring %d!\n",
+					  p->ring);
+				return -EINVAL;
+			}
 		}
 	}
 
-- 
1.9.1

