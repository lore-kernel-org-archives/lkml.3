Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158AbaKNEb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:31:28 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65063 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbaKNEbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:31:11 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, akpm@linux-foundation.org, jkosina@suse.cz,
        horia.geanta@freescale.com, computersforpeace@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 2/2] dma-debug: prevent early callers from crashing
Date: Thu, 13 Nov 2014 20:31:02 -0800
Message-Id: <1415939462-28174-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415939462-28174-1-git-send-email-f.fainelli@gmail.com>
References: <1415939462-28174-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_debug_init() is called by architecture specific code at different
levels, but typically as a fs_initcall due to the debugfs
initialization. Some platforms may have early callers of the DMA-API,
running prior to the fs_initcall() level, which is not much of an issue
unless CONFIG_DMA_API_DEBUG is set. Whe the DMA-API debugging facilities
are turned on a caller will go through:

debug_dma_map_{single,page}
	-> dma_mapping_error (inline function usually)
		-> debug_dma_mapping_error
			-> get_hash_bucket

Calling get_hash_bucket() returns a valid hash value since we hash on
high bits of the dma_addr cookie, but we will grab an unitialized
spinlock, which typically won't crash but produce a warning, the real
crash will however happen during the bucket list traversal because the
list has not been initialized yet.

An obvious solution is of course to move some of the offenders to run
after the fs_initcall level, but since this might not always be an
option, we add a flag "dma_debug_initialized" which is set to false by
default, and set to true once dma_debug_init() has had a chance to run.

The dma_debug_disabled() helper function previously introduced just
needs to check for dma_debug_initialized to allow the caller to proceed
or not.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 lib/dma-debug.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 1ac35dbaf8e0..9722bd2dbc9b 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -102,9 +102,12 @@ static DEFINE_SPINLOCK(free_entries_lock);
 /* Global disable flag - will be set in case of an error */
 static u32 global_disable __read_mostly;
 
+/* Early initialization disable flag, set at the end of dma_debug_init */
+static bool dma_debug_initialized __read_mostly;
+
 static inline bool dma_debug_disabled(void)
 {
-	return global_disable;
+	return global_disable || !dma_debug_initialized;
 }
 
 /* Global error count */
@@ -999,7 +1002,10 @@ void dma_debug_init(u32 num_entries)
 {
 	int i;
 
-	if (dma_debug_disabled())
+	/* Do not use dma_debug_initialized here, since we really want to be
+	 * called to set dma_debug_initialized
+	 */
+	if (global_disable)
 		return;
 
 	for (i = 0; i < HASH_SIZE; ++i) {
@@ -1026,6 +1032,8 @@ void dma_debug_init(u32 num_entries)
 
 	nr_total_entries = num_free_entries;
 
+	dma_debug_initialized = true;
+
 	pr_info("DMA-API: debugging enabled by kernel config\n");
 }
 
-- 
1.9.1

