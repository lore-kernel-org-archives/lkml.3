Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3KFLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:16:57 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35005 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab3KFLQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:16:55 -0500
From: Hong Zhiguo <honkiko@gmail.com>
To: tj@kernel.org
Cc: vgoyal@redhat.com, cgroups@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Subject: [PATCH] blkcg: have bh disable for 32bit UP system reading 64bit stats
Date: Wed,  6 Nov 2013 19:14:44 +0800
Message-Id: <1383736484-393-1-git-send-email-zhiguohong@tencent.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Zhiguo <zhiguohong@tencent.com>

Update of blkg_stat and blkg_rwstat may happen in bh context.
While u64_stats_fetch_retry is only preempt_disable on 32bit
UP system. This is not enough to avoid preemption by bh and
may read strange 64 bit value.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
---
 block/blk-cgroup.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ae6969a..2e34c38 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -430,9 +430,9 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 	uint64_t v;
 
 	do {
-		start = u64_stats_fetch_begin(&stat->syncp);
+		start = u64_stats_fetch_begin_bh(&stat->syncp);
 		v = stat->cnt;
-	} while (u64_stats_fetch_retry(&stat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&stat->syncp, start));
 
 	return v;
 }
@@ -498,9 +498,9 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
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
1.8.1.2

