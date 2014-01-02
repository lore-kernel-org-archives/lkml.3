Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaABRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:07:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaABRHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hong Zhiguo <zhiguohong@tencent.com>, Jens Axboe <axboe@kernel.dk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 60/91] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
Date: Thu,  2 Jan 2014 09:04:35 -0800
Message-Id: <1388682306-30859-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <zhiguohong@tencent.com>

commit 2c575026fae6e63771bd2a4c1d407214a8096a89 upstream.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/blk-cgroup.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2459730..6f33c3f 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -370,9 +370,9 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 	uint64_t v;
 
 	do {
-		start = u64_stats_fetch_begin(&stat->syncp);
+		start = u64_stats_fetch_begin_bh(&stat->syncp);
 		v = stat->cnt;
-	} while (u64_stats_fetch_retry(&stat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&stat->syncp, start));
 
 	return v;
 }
@@ -426,9 +426,9 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
 	struct blkg_rwstat tmp;
 
 	do {
-		start = u64_stats_fetch_begin(&rwstat->syncp);
+		start = u64_stats_fetch_begin_bh(&rwstat->syncp);
 		tmp = *rwstat;
-	} while (u64_stats_fetch_retry(&rwstat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&rwstat->syncp, start));
 
 	return tmp;
 }
-- 
1.8.3.2

