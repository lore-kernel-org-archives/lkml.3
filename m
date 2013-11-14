Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3KNQu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:50:56 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37696 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3KNQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 02/26] staging/lustre/build: fix race issues thanks to oap_lock
Date: Fri, 15 Nov 2013 00:42:49 +0800
Message-Id: <1384447393-13838-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'data race condition' defects found by Coverity version
6.5.0:
Data race condition (MISSING_LOCK)
Accessing variable without holding lock. Elsewhere,
this variable is accessed with lock held.

This patch is dedicated to code fragments involving oap_lock.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2744
Lustre-change: http://review.whamcloud.com/6572
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_cache.c |    6 ++++++
 drivers/staging/lustre/lustre/osc/osc_io.c    |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index abb4604..ff36e77 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -1071,7 +1071,9 @@ static int osc_extent_make_ready(const struct lu_env *env,
 		last->oap_count = osc_refresh_count(env, last, OBD_BRW_WRITE);
 		LASSERT(last->oap_count > 0);
 		LASSERT(last->oap_page_off + last->oap_count <= PAGE_CACHE_SIZE);
+		spin_lock(&last->oap_lock);
 		last->oap_async_flags |= ASYNC_COUNT_STABLE;
+		spin_unlock(&last->oap_lock);
 	}
 
 	/* for the rest of pages, we don't need to call osf_refresh_count()
@@ -1079,7 +1081,9 @@ static int osc_extent_make_ready(const struct lu_env *env,
 	list_for_each_entry(oap, &ext->oe_pages, oap_pending_item) {
 		if (!(oap->oap_async_flags & ASYNC_COUNT_STABLE)) {
 			oap->oap_count = PAGE_CACHE_SIZE - oap->oap_page_off;
+			spin_lock(&oap->oap_lock);
 			oap->oap_async_flags |= ASYNC_COUNT_STABLE;
+			spin_unlock(&oap->oap_lock);
 		}
 	}
 
@@ -2238,6 +2242,8 @@ int osc_queue_async_io(const struct lu_env *env, struct cl_io *io,
 	oap->oap_cmd = cmd;
 	oap->oap_page_off = ops->ops_from;
 	oap->oap_count = ops->ops_to - ops->ops_from;
+	/* No need to hold a lock here,
+	 * since this page is not in any list yet. */
 	oap->oap_async_flags = 0;
 	oap->oap_brw_flags = brw_flags;
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index e567f2f..d464243 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -164,8 +164,10 @@ static int osc_io_submit(const struct lu_env *env,
 		}
 
 		cl_page_list_move(qout, qin, page);
+		spin_lock(&oap->oap_lock);
 		oap->oap_async_flags = ASYNC_URGENT|ASYNC_READY;
 		oap->oap_async_flags |= ASYNC_COUNT_STABLE;
+		spin_unlock(&oap->oap_lock);
 
 		osc_page_submit(env, opg, crt, brw_flags);
 		list_add_tail(&oap->oap_pending_item, &list);
-- 
1.7.9.5

