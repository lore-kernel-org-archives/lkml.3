Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab3AOXHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:07:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:48256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934281Ab3AOW4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Boyer <jwboyer@redhat.com>, Ed Cashin <ecashin@coraid.com>
Subject: [ 37/71] aoe: do not call bdi_init after blk_alloc_queue
Date: Tue, 15 Jan 2013 14:54:34 -0800
Message-Id: <20130115225343.104552739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Cashin <ecashin@coraid.com>

commit 0a41409c518083133e79015092585d68915865be upstream, but doesn't
apply, so this version is different for older kernels than 3.7.x

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "47"
+#define VERSION "47q"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -277,8 +277,6 @@ aoeblk_gdalloc(void *vp)
 		goto err_mempool;
 	blk_queue_make_request(d->blkq, aoeblk_make_request);
 	d->blkq->backing_dev_info.name = "aoe";
-	if (bdi_init(&d->blkq->backing_dev_info))
-		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
@@ -299,9 +297,6 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
-err_blkq:
-	blk_cleanup_queue(d->blkq);
-	d->blkq = NULL;
 err_mempool:
 	mempool_destroy(d->bufpool);
 err_disk:


