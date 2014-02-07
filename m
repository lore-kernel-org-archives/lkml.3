Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaBGLYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaBGLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 37/88] dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
Date: Fri,  7 Feb 2014 11:22:34 +0000
Message-Id: <1391772205-22239-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 16961b042db8cc5cf75d782b4255193ad56e1d4f upstream.

As additional members are added to the dm_thin_new_mapping structure
care should be taken to make sure they get initialized before use.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7ef83d9..a9bac03 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -964,13 +964,17 @@ static int ensure_next_mapping(struct pool *pool)
 
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
@@ -982,15 +986,10 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
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
 
 	if (!ds_add_work(&pool->shared_read_ds, &m->list))
 		m->quiesced = 1;
@@ -1052,15 +1051,12 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
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
@@ -1224,7 +1220,6 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			m->data_block = lookup_result.block;
 			m->cell = cell;
 			m->cell2 = cell2;
-			m->err = 0;
 			m->bio = bio;
 
 			if (!ds_add_work(&pool->all_io_ds, &m->list)) {
-- 
1.8.3.2

