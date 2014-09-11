Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaIKU4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:56:00 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:42337 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaIKUzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:55:15 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 10/10] zsmalloc: implement zs_zpool_shrink() with zs_shrink()
Date: Thu, 11 Sep 2014 16:54:01 -0400
Message-Id: <1410468841-320-11-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the zs_zpool_shrink() function, which previously just returned
EINVAL, by calling the zs_shrink() function to shrink the zs_pool by one
zspage.  The zs_shrink() function is called in a loop until the requested
number of pages have been reclaimed, or an error occurs.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f769c21..4937b2b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -292,7 +292,20 @@ static void zs_zpool_free(void *pool, unsigned long handle)
 static int zs_zpool_shrink(void *pool, unsigned int pages,
 			unsigned int *reclaimed)
 {
-	return -EINVAL;
+	int total = 0, ret = 0;
+
+	while (total < pages) {
+		ret = zs_shrink(pool);
+		WARN_ON(!ret);
+		if (ret <= 0)
+			break;
+		total += ret;
+		ret = 0;
+	}
+
+	if (reclaimed)
+		*reclaimed = total;
+	return ret;
 }
 
 static void *zs_zpool_map(void *pool, unsigned long handle,
-- 
1.8.3.1

