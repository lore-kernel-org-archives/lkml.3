Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbbAGCnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:43:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970AbbAGCHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 20/52] dm thin: fix missing out-of-data-space to write mode transition if blocks are released
Date: Tue,  6 Jan 2015 18:06:48 -0800
Message-Id: <20150107020558.426173824@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -916,6 +916,24 @@ static void schedule_zero(struct thin_c
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
@@ -930,6 +948,8 @@ static int commit(struct pool *pool)
 	r = dm_pool_commit_metadata(pool->pmd);
 	if (r)
 		metadata_operation_failed(pool, "dm_pool_commit_metadata", r);
+	else
+		check_for_space(pool);
 
 	return r;
 }
@@ -948,8 +968,6 @@ static void check_low_water_mark(struct
 	}
 }
 
-static void set_pool_mode(struct pool *pool, enum pool_mode new_mode);
-
 static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 {
 	int r;


