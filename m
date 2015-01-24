Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbbAXNuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 08:50:17 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61386 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbAXNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 08:50:15 -0500
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zsmalloc: avoid unnecessary iteration when freeing
 size_class
Date: Sat, 24 Jan 2015 21:50:03 +0800
Message-Id: <1422107403-10071-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pool->size_class[i] is assigned with the i from (zs_size_classes - 1) to 0.
So if we failed in zs_create_pool(), we only need to iterate from (zs_size_classes - 1)
to i, instead of from 0 to (zs_size_classes - 1)

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 16617e9..e6fa3da 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1433,12 +1433,12 @@ void zs_destroy_pool(struct zs_pool *pool)
 
 	zs_pool_stat_destroy(pool);
 
-	for (i = 0; i < zs_size_classes; i++) {
+	for (i = zs_size_classes - 1; i >= 0; i--) {
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
 		if (!class)
-			continue;
+			break;
 
 		if (class->index != i)
 			continue;
-- 
1.7.9.5

