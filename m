Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3CNK7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:59:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3CNKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 25/88] block: fix synchronization and limit check in blk_alloc_devt()
Date: Thu, 14 Mar 2013 10:35:18 +0000
Message-Id: <1363257381-15900-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ce23bba842aee98092225d9576dba47c82352521 upstream.

idr allocation in blk_alloc_devt() wasn't synchronized against lookup
and removal, and its limit check was off by one - 1 << MINORBITS is
the number of minors allowed, not the maximum allowed minor.

Add locking and rename MAX_EXT_DEVT to NR_EXT_DEVT and fix limit
checking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/genhd.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9433636..60108d9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -25,7 +25,7 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 
 /* for extended dynamic devt allocation, currently only one major is used */
-#define MAX_EXT_DEVT		(1 << MINORBITS)
+#define NR_EXT_DEVT		(1 << MINORBITS)
 
 /* For extended devt allocation.  ext_devt_mutex prevents look up
  * results from going away underneath its user.
@@ -422,19 +422,16 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 			return -ENOMEM;
 		mutex_lock(&ext_devt_mutex);
 		rc = idr_get_new(&ext_devt_idr, part, &idx);
+		if (!rc && idx >= NR_EXT_DEVT) {
+			idr_remove(&ext_devt_idr, idx);
+			rc = -EBUSY;
+		}
 		mutex_unlock(&ext_devt_mutex);
 	} while (rc == -EAGAIN);
 
 	if (rc)
 		return rc;
 
-	if (idx > MAX_EXT_DEVT) {
-		mutex_lock(&ext_devt_mutex);
-		idr_remove(&ext_devt_idr, idx);
-		mutex_unlock(&ext_devt_mutex);
-		return -EBUSY;
-	}
-
 	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
 }
-- 
1.8.1.2

