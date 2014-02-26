Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaBZTMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:12:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:20204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaBZTJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="490301633"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4] x86: Use clflushopt in drm_clflush_page
Date: Wed, 26 Feb 2014 12:06:51 -0700
Message-Id: <1393441612-19729-4-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clflushopt is available on the system, use it instead of clflush in
drm_clflush_page.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpu/drm/drm_cache.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index bb8f580..c518fb6 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -32,6 +32,12 @@
 #include <drm/drmP.h>
 
 #if defined(CONFIG_X86)
+
+/*
+ * clflushopt is an unordered instruction which needs fencing with mfence or
+ * sfence to avoid ordering issues.  For drm_clflush_page this fencing happens
+ * in the caller.
+ */
 static void
 drm_clflush_page(struct page *page)
 {
@@ -44,7 +50,7 @@ drm_clflush_page(struct page *page)
 
 	page_virtual = kmap_atomic(page);
 	for (i = 0; i < PAGE_SIZE; i += size)
-		clflush(page_virtual + i);
+		clflushopt(page_virtual + i);
 	kunmap_atomic(page_virtual);
 }
 
-- 
1.7.10.4

