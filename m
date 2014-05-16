Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaEPVpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:45:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:20987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaEPVnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="512987836"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        alexander.deucher@amd.com, dri-devel@lists.freedesktop.org
Subject: [PATCH 7/8] radeon: Out of line radeon_get_ib_value
Date: Fri, 16 May 2014 14:43:14 -0700
Message-Id: <1400276595-6965-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Saves about 5k of text

   text	   data	    bss	    dec	    hex	filename
14080360	2008168	1507328	17595856	10c7dd0	vmlinux-before-radeon
14074978	2008168	1507328	17590474	10c68ca	vmlinux-radeon

Cc: alexander.deucher@amd.com
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/radeon.h        | 10 +---------
 drivers/gpu/drm/radeon/radeon_device.c |  9 +++++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 6852861..8cae409 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1032,15 +1032,7 @@ struct radeon_cs_parser {
 	struct ww_acquire_ctx	ticket;
 };
 
-static inline u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
-{
-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
-
-	if (ibc->kdata)
-		return ibc->kdata[idx];
-	return p->ib.ptr[idx];
-}
-
+u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx);
 
 struct radeon_cs_packet {
 	unsigned	idx;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 0e770bb..1cbd171 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -112,6 +112,15 @@ bool radeon_is_px(struct drm_device *dev)
 	return false;
 }
 
+u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
+{
+	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
+
+	if (ibc->kdata)
+		return ibc->kdata[idx];
+	return p->ib.ptr[idx];
+}
+
 /**
  * radeon_program_register_sequence - program an array of registers.
  *
-- 
1.9.0

