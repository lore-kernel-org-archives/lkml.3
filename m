Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbbALSl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:41:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbbALSal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 183/216] dm thin: fix missing out-of-data-space to write mode transition if blocks are released
Date: Mon, 12 Jan 2015 18:29:21 +0000
Message-Id: <1421087394-2712-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 2c43fd26e46734430122b8d2ad3024bb532df3ef upstream.

Discard bios and thin device deletion have the potential to release data
blocks.  If the thin-pool is in out-of-data-space mode, and blocks were
released, transition the thin-pool back to full write mode.

The correct time to do this is just after the thin-pool metadata commit.
It cannot be done before the commit because the space maps will not
allow immediate reuse of the data blocks in case there's a rollback
following power failure.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c13efb1020d9..408ffba7ec63 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -936,6 +936,24 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	}
 }
 
+static void set_pool_mode(struct pool *pool, enum pool_mode new_mode);
+
+static void check_for_space(struct pool *pool)
+{
+	int r;
+	dm_block_t nr_free;
+
+	if (get_pool_mode(pool) != PM_OUT_OF_DATA_SPACE)
+		return;
+
+	r = dm_pool_get_free_block_count(pool->pmd, &nr_free);
+	if (r)
+		return;
+
+	if (nr_free)
+		set_pool_mode(pool, PM_WRITE);
+}
+
 /*
  * A non-zero return indicates read_only or fail_io mode.
  * Many callers don't care about the return value.
@@ -950,6 +968,8 @@ static int commit(struct pool *pool)
 	r = dm_pool_commit_metadata(pool->pmd);
 	if (r)
 		metadata_operation_failed(pool, "dm_pool_commit_metadata", r);
+	else
+		check_for_space(pool);
 
 	return r;
 }
@@ -968,8 +988,6 @@ static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 	}
 }
 
-static void set_pool_mode(struct pool *pool, enum pool_mode new_mode);
-
 static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 {
 	int r;
-- 
2.1.4

