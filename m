Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3LQSjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:39:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60829 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3LQSOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hong Zhiguo <zhiguohong@tencent.com>, Jens Axboe <axboe@kernel.dk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 028/103] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
Date: Tue, 17 Dec 2013 18:12:17 +0000
Message-Id: <1387304012-23805-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <zhiguohong@tencent.com>

commit 2c575026fae6e63771bd2a4c1d407214a8096a89 upstream.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-cgroup.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 8ac457c..b8521f4 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -261,9 +261,9 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 	uint64_t v;
 
 	do {
-		start = u64_stats_fetch_begin(&stat->syncp);
+		start = u64_stats_fetch_begin_bh(&stat->syncp);
 		v = stat->cnt;
-	} while (u64_stats_fetch_retry(&stat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&stat->syncp, start));
 
 	return v;
 }
@@ -317,9 +317,9 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
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

