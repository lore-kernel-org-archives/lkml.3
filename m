Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab3APQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3APQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ed Cashin <ecashin@coraid.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 192/222] aoe: do not call bdi_init after blk_alloc_queue
Date: Wed, 16 Jan 2013 13:56:32 -0200
Message-Id: <1358351822-7675-193-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Cashin <ecashin@coraid.com>

[ this is part of commit 0a41409c518083133e79015092585d68915865be upstream,
  kernels <= 3.6 requires this different patch ]

blk_alloc_queue has already done a bdi_init, so do not bdi_init
again in aoeblk_gdalloc.  The extra call causes list corruption
in the per-CPU backing dev info stats lists.

Affected users see console WARNINGs about list_del corruption on
percpu_counter_destroy when doing "rmmod aoe" or "aoeflush -a"
when AoE targets have been detected and initialized by the
system.

The patch below applies to v3.6.11, with its v47 aoe driver.  It
is expected to apply to all currently maintained stable kernels
except 3.7.y.  A related but different fix has been posted for
3.7.y.

References:

  RedHat bugzilla ticket with original report
  https://bugzilla.redhat.com/show_bug.cgi?id=853064

  LKML discussion of bug and fix
  http://thread.gmane.org/gmane.linux.kernel/1416336/focus=1416497

Reported-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index db195ab..e49ddd0 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "47"
+#define VERSION "47q"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 321de7b..7eca463 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -276,8 +276,6 @@ aoeblk_gdalloc(void *vp)
 		goto err_mempool;
 	blk_queue_make_request(d->blkq, aoeblk_make_request);
 	d->blkq->backing_dev_info.name = "aoe";
-	if (bdi_init(&d->blkq->backing_dev_info))
-		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
@@ -298,9 +296,6 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
-err_blkq:
-	blk_cleanup_queue(d->blkq);
-	d->blkq = NULL;
 err_mempool:
 	mempool_destroy(d->bufpool);
 err_disk:
-- 
1.7.9.5

