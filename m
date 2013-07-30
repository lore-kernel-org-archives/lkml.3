Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3G3Mna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:43:30 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44622 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3G3Mkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:37 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org, Tejun Heo <tj@kernel.org>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH 2/9] dm: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:21 -0400
Message-Id: <1375188028-11910-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375188028-11910-1-git-send-email-tj@kernel.org>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please route this through the subsystem tree.  As written in the
description, this shouldn't make any functional difference and just
prepares for the removal of WQ_NON_REENTRANT which is already noop.

Thanks.

------ 8< -------
dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-crypt.c  | 10 ++--------
 drivers/md/dm-kcopyd.c |  3 +--
 drivers/md/dm-raid1.c  |  3 +--
 drivers/md/dm.c        |  3 +--
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6d2d41a..0fce0bc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1645,20 +1645,14 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io",
-				       WQ_NON_REENTRANT|
-				       WQ_MEM_RECLAIM,
-				       1);
+	cc->io_queue = alloc_workqueue("kcryptd_io", WQ_MEM_RECLAIM, 1);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
 	cc->crypt_queue = alloc_workqueue("kcryptd",
-					  WQ_NON_REENTRANT|
-					  WQ_CPU_INTENSIVE|
-					  WQ_MEM_RECLAIM,
-					  1);
+					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index d581fe5..3a7cade 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -833,8 +833,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 		goto bad_slab;
 
 	INIT_WORK(&kc->kcopyd_work, do_work);
-	kc->kcopyd_wq = alloc_workqueue("kcopyd",
-					WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	kc->kcopyd_wq = alloc_workqueue("kcopyd", WQ_MEM_RECLAIM, 0);
 	if (!kc->kcopyd_wq)
 		goto bad_workqueue;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 699b5be..9584443 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1080,8 +1080,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->per_bio_data_size = sizeof(struct dm_raid1_bio_record);
 	ti->discard_zeroes_data_unsupported = true;
 
-	ms->kmirrord_wq = alloc_workqueue("kmirrord",
-					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	ms->kmirrord_wq = alloc_workqueue("kmirrord", WQ_MEM_RECLAIM, 0);
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		r = -ENOMEM;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e39d2b..ef095a9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1946,8 +1946,7 @@ static struct mapped_device *alloc_dev(int minor)
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
-	md->wq = alloc_workqueue("kdmflush",
-				 WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
 	if (!md->wq)
 		goto bad_thread;
 
-- 
1.8.3.1

