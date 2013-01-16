Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3APQC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab3APQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 085/222] drm/radeon: stop page faults from hanging the system (v2)
Date: Wed, 16 Jan 2013 13:54:45 -0200
Message-Id: <1358351822-7675-86-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>

commit ae133a1129790ec288b429b5f08ab4701633844a upstream.

Redirect invalid memory accesses to the default page
instead of locking up the memory controller. Also
enable the invalid memory access interrupts and
start spamming system log with it.

v2 (agd5f): fix up against 2 level PT changes

Signed-off-by: Christian König <deathsimple@vodafone.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c  |   10 ++++++++++
 drivers/gpu/drm/radeon/evergreend.h |    3 +++
 drivers/gpu/drm/radeon/ni.c         |   16 +++++++++++++---
 drivers/gpu/drm/radeon/nid.h        |   11 +++++++++++
 drivers/gpu/drm/radeon/si.c         |   25 +++++++++++++++++++++++--
 drivers/gpu/drm/radeon/sid.h        |   14 ++++++++++++++
 6 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 9c61b96..fb868675 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2913,6 +2913,16 @@ restart_ih:
 				break;
 			}
 			break;
+		case 146:
+		case 147:
+			dev_err(rdev->dev, "GPU fault detected: %d 0x%08x\n", src_id, src_data);
+			dev_err(rdev->dev, "  VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x%08X\n",
+				RREG32(VM_CONTEXT1_PROTECTION_FAULT_ADDR));
+			dev_err(rdev->dev, "  VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x%08X\n",
+				RREG32(VM_CONTEXT1_PROTECTION_FAULT_STATUS));
+			/* reset addr and status */
+			WREG32_P(VM_CONTEXT1_CNTL2, 1, ~1);
+			break;
 		case 176: /* CP_INT in ring buffer */
 		case 177: /* CP_INT in IB1 */
 		case 178: /* CP_INT in IB2 */
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index bfdbafe..d2f0528 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -647,6 +647,7 @@
 #define		PAGE_TABLE_DEPTH(x)				(((x) & 3) << 1)
 #define		RANGE_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 4)
 #define VM_CONTEXT1_CNTL				0x1414
+#define VM_CONTEXT1_CNTL2				0x1434
 #define	VM_CONTEXT0_PAGE_TABLE_BASE_ADDR		0x153C
 #define	VM_CONTEXT0_PAGE_TABLE_END_ADDR			0x157C
 #define	VM_CONTEXT0_PAGE_TABLE_START_ADDR		0x155C
@@ -668,6 +669,8 @@
 #define		CACHE_UPDATE_MODE(x)				((x) << 6)
 #define	VM_L2_STATUS					0x140C
 #define		L2_BUSY						(1 << 0)
+#define	VM_CONTEXT1_PROTECTION_FAULT_ADDR		0x14FC
+#define	VM_CONTEXT1_PROTECTION_FAULT_STATUS		0x14DC
 
 #define	WAIT_UNTIL					0x8040
 
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 2732a70..6a0664d 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -780,10 +780,20 @@ int cayman_pcie_gart_enable(struct radeon_device *rdev)
 	/* enable context1-7 */
 	WREG32(VM_CONTEXT1_PROTECTION_FAULT_DEFAULT_ADDR,
 	       (u32)(rdev->dummy_page.addr >> 12));
-	WREG32(VM_CONTEXT1_CNTL2, 0);
-	WREG32(VM_CONTEXT1_CNTL, 0);
+	WREG32(VM_CONTEXT1_CNTL2, 4);
 	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
-				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
+				RANGE_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT |
+				DUMMY_PAGE_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				DUMMY_PAGE_PROTECTION_FAULT_ENABLE_DEFAULT |
+				PDE0_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				PDE0_PROTECTION_FAULT_ENABLE_DEFAULT |
+				VALID_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				VALID_PROTECTION_FAULT_ENABLE_DEFAULT |
+				READ_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				READ_PROTECTION_FAULT_ENABLE_DEFAULT |
+				WRITE_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				WRITE_PROTECTION_FAULT_ENABLE_DEFAULT);
 
 	cayman_pcie_gart_tlb_flush(rdev);
 	DRM_INFO("PCIE GART of %uM enabled (table at 0x%016llX).\n",
diff --git a/drivers/gpu/drm/radeon/nid.h b/drivers/gpu/drm/radeon/nid.h
index a0b9806..5e76c2f5 100644
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -80,7 +80,18 @@
 #define VM_CONTEXT0_CNTL				0x1410
 #define		ENABLE_CONTEXT					(1 << 0)
 #define		PAGE_TABLE_DEPTH(x)				(((x) & 3) << 1)
+#define		RANGE_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 3)
 #define		RANGE_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 4)
+#define		DUMMY_PAGE_PROTECTION_FAULT_ENABLE_INTERRUPT	(1 << 6)
+#define		DUMMY_PAGE_PROTECTION_FAULT_ENABLE_DEFAULT	(1 << 7)
+#define		PDE0_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 9)
+#define		PDE0_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 10)
+#define		VALID_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 12)
+#define		VALID_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 13)
+#define		READ_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 15)
+#define		READ_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 16)
+#define		WRITE_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 18)
+#define		WRITE_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 19)
 #define VM_CONTEXT1_CNTL				0x1414
 #define VM_CONTEXT0_CNTL2				0x1430
 #define VM_CONTEXT1_CNTL2				0x1434
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index ec8abab..29e42de 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2391,9 +2391,20 @@ int si_pcie_gart_enable(struct radeon_device *rdev)
 	/* enable context1-15 */
 	WREG32(VM_CONTEXT1_PROTECTION_FAULT_DEFAULT_ADDR,
 	       (u32)(rdev->dummy_page.addr >> 12));
-	WREG32(VM_CONTEXT1_CNTL2, 0);
+	WREG32(VM_CONTEXT1_CNTL2, 4);
 	WREG32(VM_CONTEXT1_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
-				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
+				RANGE_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT |
+				DUMMY_PAGE_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				DUMMY_PAGE_PROTECTION_FAULT_ENABLE_DEFAULT |
+				PDE0_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				PDE0_PROTECTION_FAULT_ENABLE_DEFAULT |
+				VALID_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				VALID_PROTECTION_FAULT_ENABLE_DEFAULT |
+				READ_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				READ_PROTECTION_FAULT_ENABLE_DEFAULT |
+				WRITE_PROTECTION_FAULT_ENABLE_INTERRUPT |
+				WRITE_PROTECTION_FAULT_ENABLE_DEFAULT);
 
 	si_pcie_gart_tlb_flush(rdev);
 	DRM_INFO("PCIE GART of %uM enabled (table at 0x%016llX).\n",
@@ -3604,6 +3615,16 @@ restart_ih:
 				break;
 			}
 			break;
+		case 146:
+		case 147:
+			dev_err(rdev->dev, "GPU fault detected: %d 0x%08x\n", src_id, src_data);
+			dev_err(rdev->dev, "  VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x%08X\n",
+				RREG32(VM_CONTEXT1_PROTECTION_FAULT_ADDR));
+			dev_err(rdev->dev, "  VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x%08X\n",
+				RREG32(VM_CONTEXT1_PROTECTION_FAULT_STATUS));
+			/* reset addr and status */
+			WREG32_P(VM_CONTEXT1_CNTL2, 1, ~1);
+			break;
 		case 176: /* RINGID0 CP_INT */
 			radeon_fence_process(rdev, RADEON_RING_TYPE_GFX_INDEX);
 			break;
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 810a83e..06b17e6 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -91,7 +91,18 @@
 #define VM_CONTEXT0_CNTL				0x1410
 #define		ENABLE_CONTEXT					(1 << 0)
 #define		PAGE_TABLE_DEPTH(x)				(((x) & 3) << 1)
+#define		RANGE_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 3)
 #define		RANGE_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 4)
+#define		DUMMY_PAGE_PROTECTION_FAULT_ENABLE_INTERRUPT	(1 << 6)
+#define		DUMMY_PAGE_PROTECTION_FAULT_ENABLE_DEFAULT	(1 << 7)
+#define		PDE0_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 9)
+#define		PDE0_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 10)
+#define		VALID_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 12)
+#define		VALID_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 13)
+#define		READ_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 15)
+#define		READ_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 16)
+#define		WRITE_PROTECTION_FAULT_ENABLE_INTERRUPT		(1 << 18)
+#define		WRITE_PROTECTION_FAULT_ENABLE_DEFAULT		(1 << 19)
 #define VM_CONTEXT1_CNTL				0x1414
 #define VM_CONTEXT0_CNTL2				0x1430
 #define VM_CONTEXT1_CNTL2				0x1434
@@ -104,6 +115,9 @@
 #define	VM_CONTEXT14_PAGE_TABLE_BASE_ADDR		0x1450
 #define	VM_CONTEXT15_PAGE_TABLE_BASE_ADDR		0x1454
 
+#define	VM_CONTEXT1_PROTECTION_FAULT_ADDR		0x14FC
+#define	VM_CONTEXT1_PROTECTION_FAULT_STATUS		0x14DC
+
 #define VM_INVALIDATE_REQUEST				0x1478
 #define VM_INVALIDATE_RESPONSE				0x147c
 
-- 
1.7.9.5

