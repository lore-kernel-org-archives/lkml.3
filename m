Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaKKSoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:44:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:15362 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaKKSoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:44:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414941173"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: [PATCH 6/6] x86: Use clwb in drm_clflush_virt_range
Date: Tue, 11 Nov 2014 11:43:16 -0700
Message-Id: <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clwb is available on the system, use it in drm_clflush_virt_range.
If clwb is not available, fall back to clflushopt if you can.
If clflushopt is not supported, fall all the way back to clflush.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: x86@kernel.org
---
 drivers/gpu/drm/drm_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index aad9d82..84e9a04 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -138,8 +138,8 @@ drm_clflush_virt_range(void *addr, unsigned long length)
 		void *end = addr + length;
 		mb();
 		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
-			clflushopt(addr);
-		clflushopt(end - 1);
+			clwb(addr);
+		clwb(end - 1);
 		mb();
 		return;
 	}
-- 
1.9.3

