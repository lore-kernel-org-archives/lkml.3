Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaBKUok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:44:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaBKTFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.13 051/120] dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
Date: Tue, 11 Feb 2014 11:04:52 -0800
Message-Id: <20140211184825.077211377@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 16961b042db8cc5cf75d782b4255193ad56e1d4f upstream.

As additional members are added to the dm_thin_new_mapping structure
care should be taken to make sure they get initialized before use.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -760,13 +760,17 @@ static int ensure_next_mapping(struct po
 
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
@@ -778,15 +782,10 @@ static void schedule_copy(struct thin_c
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
@@ -849,15 +848,12 @@ static void schedule_zero(struct thin_c
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
@@ -1055,7 +1051,6 @@ static void process_discard(struct thin_
 			m->data_block = lookup_result.block;
 			m->cell = cell;
 			m->cell2 = cell2;
-			m->err = 0;
 			m->bio = bio;
 
 			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list)) {


