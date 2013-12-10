Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3LJIbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:31:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3LJIA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3.10 31/52] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
Date: Tue, 10 Dec 2013 00:01:04 -0800
Message-Id: <20131210075956.404684981@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <zhiguohong@tencent.com>

commit 2c575026fae6e63771bd2a4c1d407214a8096a89 upstream.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-cgroup.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -399,9 +399,9 @@ static inline uint64_t blkg_stat_read(st
 	uint64_t v;
 
 	do {
-		start = u64_stats_fetch_begin(&stat->syncp);
+		start = u64_stats_fetch_begin_bh(&stat->syncp);
 		v = stat->cnt;
-	} while (u64_stats_fetch_retry(&stat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&stat->syncp, start));
 
 	return v;
 }
@@ -467,9 +467,9 @@ static inline struct blkg_rwstat blkg_rw
 	struct blkg_rwstat tmp;
 
 	do {
-		start = u64_stats_fetch_begin(&rwstat->syncp);
+		start = u64_stats_fetch_begin_bh(&rwstat->syncp);
 		tmp = *rwstat;
-	} while (u64_stats_fetch_retry(&rwstat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&rwstat->syncp, start));
 
 	return tmp;
 }


