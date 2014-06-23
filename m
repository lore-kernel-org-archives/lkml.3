Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaFWJBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55481 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 036/111] drm/radeon: avoid crash if VM command submission isn't available
Date: Mon, 23 Jun 2014 10:31:11 +0200
Message-Id: <9292af256fbd70a11c469af030050d80b4ebad9e.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 60a445405a1731bac2279eab354173c9c3156747 upstream.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_cs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 80285e35bc65..b2b8b38f0319 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -271,10 +271,17 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
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
2.0.0

