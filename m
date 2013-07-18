Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab3GRQ4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:56:50 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53365 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3GRQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:56:49 -0400
From: Jerry <uulinux@gmail.com>
To: akpm@linux-foundation.org
Cc: zhuwei.lu@archermind.com, tianfu.huang@archermind.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jerry <uulinux@gmail.com>
Subject: [PATCH] mm: negative left shift count when PAGE_SHIFT > 20
Date: Fri, 19 Jul 2013 00:56:12 +0800
Message-Id: <1374166572-7988-1-git-send-email-uulinux@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
calculating here will generate an unexpected result. In addition, if
PAGE_SHIFT > 20, The memory size represented by numentries was already
integral multiple of 1MB.

Signed-off-by: Jerry <uulinux@gmail.com>
---
 mm/page_alloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..cd41797 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5745,9 +5745,11 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
-		numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
-		numentries >>= 20 - PAGE_SHIFT;
-		numentries <<= 20 - PAGE_SHIFT;
+		if (20 > PAGE_SHIFT) {
+			numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
+			numentries >>= 20 - PAGE_SHIFT;
+			numentries <<= 20 - PAGE_SHIFT;
+		}
 
 		/* limit to 1 bucket per 2^scale bytes of low memory */
 		if (scale > PAGE_SHIFT)
-- 
1.8.1.5

