Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3AMRph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35014 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926Ab3AMRpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:33 -0500
Message-Id: <20130113174306.052418287@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:44 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ed Cashin <ecashin@coraid.com>, Josh Boyer <jwboyer@redhat.com>
Subject: [ 49/49] aoe: do not call bdi_init after blk_alloc_queue
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Cashin <ecashin@coraid.com>

commit 0a41409c518083133e79015092585d68915865be upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    5 -----
 2 files changed, 1 insertions(+), 6 deletions(-)

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


