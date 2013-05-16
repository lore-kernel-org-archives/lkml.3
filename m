Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3EPIm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:42:27 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18862 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416Ab3EPImX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:42:23 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Oskar Andero <oskar.andero@sonymobile.com>,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] mm: vmscan: handle any negative return value from scan_objects
Date: Thu, 16 May 2013 10:42:16 +0200
Message-ID: <1368693736-15486-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shrinkers must return -1 to indicate that it is busy. Instead, treat
any negative value as busy.
This fixes a potential bug if scan_objects returns a negative other than -1.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 include/linux/shrinker.h | 7 ++++---
 mm/vmscan.c              | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 3b08869..ced0e91 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -38,9 +38,10 @@ struct shrink_control {
  * @scan_objects will only be called if @count_objects returned a positive
  * value for the number of freeable objects. The callout should scan the cache
  * and attempt to free items from the cache. It should then return the number of
- * objects freed during the scan, or -1 if progress cannot be made due to
- * potential deadlocks. If -1 is returned, then no further attempts to call the
- * @scan_objects will be made from the current reclaim context.
+ * objects freed during the scan, or a negative value if progress cannot be made
+ * due to potential deadlocks. If a negative value is returned, then no further
+ * attempts to call the @scan_objects will be made from the current reclaim
+ * context.
  */
 struct shrinker {
 	long (*count_objects)(struct shrinker *, struct shrink_control *sc);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6bac41e..acb4aef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -291,7 +291,7 @@ shrink_slab_one(struct shrinker *shrinker, struct shrink_control *shrinkctl,
 
 		shrinkctl->nr_to_scan = nr_to_scan;
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
-		if (ret == -1)
+		if (ret < 0)
 			break;
 		freed += ret;
 
-- 
1.8.1.5

