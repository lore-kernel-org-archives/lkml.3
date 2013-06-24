Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3FXMuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:50:00 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2050 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3FXMt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:49:58 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/2] metag: panic if cache aliasing possible
Date: Mon, 24 Jun 2013 13:49:47 +0100
Message-ID: <1372078188-26602-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372078188-26602-1-git-send-email-james.hogan@imgtec.com>
References: <1372078188-26602-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_24_13_49_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the cache and page size configuration allows for cache aliasing to
occur we warn on boot, but the log messages are easy to miss and will
result is random crashes occuring in userland. Let's panic too in this
case so that the user immediately knows they need to fix the cache
configuration or configured page size.

Also fix the warning messages which display the cache and page sizes to
include newlines, and add the word "Potential" since an actual cache
alias hasn't been detected.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/cachepart.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
index 954548b..0a2385f 100644
--- a/arch/metag/kernel/cachepart.c
+++ b/arch/metag/kernel/cachepart.c
@@ -100,22 +100,23 @@ void check_for_cache_aliasing(int thread_id)
 		thread_cache_size =
 				get_thread_cache_size(cache_type, thread_id);
 		if (thread_cache_size < 0)
-			pr_emerg("Can't read %s cache size", \
+			pr_emerg("Can't read %s cache size\n",
 				 cache_type ? "DCACHE" : "ICACHE");
 		else if (thread_cache_size == 0)
 			/* Cache is off. No need to check for aliasing */
 			continue;
 		if (thread_cache_size / CACHE_ASSOCIATIVITY > PAGE_SIZE) {
-			pr_emerg("Cache aliasing detected in %s on Thread %d",
+			pr_emerg("Potential cache aliasing detected in %s on Thread %d\n",
 				 cache_type ? "DCACHE" : "ICACHE", thread_id);
-			pr_warn("Total %s size: %u bytes",
-				cache_type ? "DCACHE" : "ICACHE ",
+			pr_warn("Total %s size: %u bytes\n",
+				cache_type ? "DCACHE" : "ICACHE",
 				cache_type ? get_dcache_size()
 				: get_icache_size());
-			pr_warn("Thread %s size: %d bytes",
+			pr_warn("Thread %s size: %d bytes\n",
 				cache_type ? "CACHE" : "ICACHE",
 				thread_cache_size);
-			pr_warn("Page Size: %lu bytes", PAGE_SIZE);
+			pr_warn("Page Size: %lu bytes\n", PAGE_SIZE);
+			panic("Potential cache aliasing detected");
 		}
 	}
 }
-- 
1.8.1.2


