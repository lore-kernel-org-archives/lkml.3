Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3CDDni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32803 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756325Ab3CDDne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:34 -0500
Message-Id: <20130304033718.509647354@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 111/153] block: fix synchronization and limit check in blk_alloc_devt()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/genhd.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -26,7 +26,7 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 
 /* for extended dynamic devt allocation, currently only one major is used */
-#define MAX_EXT_DEVT		(1 << MINORBITS)
+#define NR_EXT_DEVT		(1 << MINORBITS)
 
 /* For extended devt allocation.  ext_devt_mutex prevents look up
  * results from going away underneath its user.
@@ -423,19 +423,16 @@ int blk_alloc_devt(struct hd_struct *par
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


