Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaBJT5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:57:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaBJTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 032/124] dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
Date: Mon, 10 Feb 2014 11:39:32 -0800
Message-Id: <1392061264-28124-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 16961b042db8cc5cf75d782b4255193ad56e1d4f upstream.

As additional members are added to the dm_thin_new_mapping structure
care should be taken to make sure they get initialized before use.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 44a715f..b6fdaf7 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -678,13 +678,17 @@ static int ensure_next_mapping(struct pool *pool)
 
 static struct dm_thin_new_mapping *get_next_mapping(struct pool *pool)
 {
-	struct dm_thin_new_mapping *r = pool->next_mapping;
+	struct dm_thin_new_mapping *m = pool->next_mapping;
 
 	BUG_ON(!pool->next_mapping);
 
+	memset(m, 0, sizeof(struct dm_thin_new_mapping));
+	INIT_LIST_HEAD(&m->list);
+	m->bio = NULL;
+
 	pool->next_mapping = NULL;
 
-	return r;
+	return m;
 }
 
 static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
@@ -696,15 +700,10 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	INIT_LIST_HEAD(&m->list);
-	m->quiesced = 0;
-	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_dest;
 	m->cell = cell;
-	m->err = 0;
-	m->bio = NULL;
 
 	if (!dm_deferred_set_add_work(pool->shared_read_ds, &m->list))
 		m->quiesced = 1;
@@ -767,15 +766,12 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	struct pool *pool = tc->pool;
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	INIT_LIST_HEAD(&m->list);
 	m->quiesced = 1;
 	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
 	m->data_block = data_block;
 	m->cell = cell;
-	m->err = 0;
-	m->bio = NULL;
 
 	/*
 	 * If the whole block of data is being overwritten or we are not
@@ -966,7 +962,6 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			m->data_block = lookup_result.block;
 			m->cell = cell;
 			m->cell2 = cell2;
-			m->err = 0;
 			m->bio = bio;
 
 			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list)) {
-- 
1.8.3.2

