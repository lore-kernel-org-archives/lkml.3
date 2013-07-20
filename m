Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3GTRNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:13:34 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49124 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3GTRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:13:33 -0400
From: Jerry Zhou <uulinux@gmail.com>
To: akpm@linux-foundation.org
Cc: zhuwei.lu@archermind.com, tianfu.huang@archermind.com,
        chunhua.zhou@archermind.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jerry Zhou <uulinux@gmail.com>
Subject: [PATCH] mm: negative left shift count when PAGE_SHIFT > 20
Date: Sun, 21 Jul 2013 01:12:54 +0800
Message-Id: <1374340374-4819-1-git-send-email-uulinux@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
previous calculating here will generate an unexpected result. In
addition, if PAGE_SIZE >= 1MB, The memory size of "numentries" was
already integral multiple of 1MB.

Signed-off-by: Jerry Zhou <uulinux@gmail.com>
---
 mm/page_alloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..7c469c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5745,9 +5745,10 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
-		numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
-		numentries >>= 20 - PAGE_SHIFT;
-		numentries <<= 20 - PAGE_SHIFT;
+
+		/* It isn't necessary when PAGE_SIZE >= 1MB */
+		if (PAGE_SHIFT < 20)
+			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
 		/* limit to 1 bucket per 2^scale bytes of low memory */
 		if (scale > PAGE_SHIFT)
-- 
1.8.1.5

