Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab3GVTeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:34:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36153 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3GVTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:34:24 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Dave Hansen <dave@sr71.net>,
        Bob Liu <lliubbo@gmail.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: zswap: add runtime enable/disable
Date: Mon, 22 Jul 2013 14:34:02 -0500
Message-Id: <1374521642-25478-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072219-2398-0000-0000-000000A1E9B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, zswap can only be enabled at boot time.  This patch
modifies zswap so that it can be dynamically enabled or disabled
at runtime.

In order to allow this ability, zswap unconditionally registers as a
frontswap backend regardless of whether or not zswap.enabled=1 is passed
in the boot parameters or not.  This introduces a very small overhead
for systems that have zswap disabled as calls to frontswap_store() will
call zswap_frontswap_store(), but there is a fast path to immediately
return if zswap is disabled.

Disabling zswap does not unregister zswap from frontswap.  It simply
blocks all future stores.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 Documentation/vm/zswap.txt | 18 ++++++++++++++++--
 mm/zswap.c                 |  9 +++------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/vm/zswap.txt b/Documentation/vm/zswap.txt
index 7e492d8..d588477 100644
--- a/Documentation/vm/zswap.txt
+++ b/Documentation/vm/zswap.txt
@@ -26,8 +26,22 @@ Zswap evicts pages from compressed cache on an LRU basis to the backing swap
 device when the compressed pool reaches it size limit.  This requirement had
 been identified in prior community discussions.
 
-To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
-zswap.enabled=1
+Zswap is disabled by default but can be enabled at boot time by setting
+the "enabled" attribute to 1 at boot time. e.g. zswap.enabled=1.  Zswap
+can also be enabled and disabled at runtime using the sysfs interface.
+An exmaple command to enable zswap at runtime, assuming sysfs is mounted
+at /sys, is:
+
+echo 1 > /sys/modules/zswap/parameters/enabled
+
+When zswap is disabled at runtime, it will stop storing pages that are
+being swapped out.  However, it will _not_ immediately write out or
+fault back into memory all of the pages stored in the compressed pool.
+The pages stored in zswap will continue to remain in the compressed pool
+until they are either invalidated or faulted back into memory.  In order
+to force all pages out of the compressed pool, a swapoff on the swap
+device(s) will fault all swapped out pages, included those in the
+compressed pool, back into memory.
 
 Design:
 
diff --git a/mm/zswap.c b/mm/zswap.c
index deda2b6..199b1b0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -75,9 +75,9 @@ static u64 zswap_duplicate_entry;
 /*********************************
 * tunables
 **********************************/
-/* Enable/disable zswap (disabled by default, fixed at boot for now) */
+/* Enable/disable zswap (disabled by default) */
 static bool zswap_enabled __read_mostly;
-module_param_named(enabled, zswap_enabled, bool, 0);
+module_param_named(enabled, zswap_enabled, bool, 0644);
 
 /* Compressor to be used by zswap (fixed at boot for now) */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
@@ -612,7 +612,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	u8 *src, *dst;
 	struct zswap_header *zhdr;
 
-	if (!tree) {
+	if (!zswap_enabled || !tree) {
 		ret = -ENODEV;
 		goto reject;
 	}
@@ -908,9 +908,6 @@ static void __exit zswap_debugfs_exit(void) { }
 **********************************/
 static int __init init_zswap(void)
 {
-	if (!zswap_enabled)
-		return 0;
-
 	pr_info("loading zswap\n");
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
-- 
1.8.1.2

