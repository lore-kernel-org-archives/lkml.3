Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbbAFT3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:29:30 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:42882 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbbAFT3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:29:25 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] update !CONFIG_BLK_CGROUP dummies in include/linux/blk-cgroup.h
Date: Tue,  6 Jan 2015 14:29:03 -0500
Message-Id: <1420572557-11572-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file will be used more widely with the pending cgroup
writeback support and the current set of dummy declarations aren't
enough to handle different config combinations.  Update as follows.

* Drop the struct cgroup declaration.  None of the dummy defs need it.

* Define blkcg as an empty struct instead of just declaring it.

* Wrap dummy function defs in CONFIG_BLOCK.  Some functions use block
  data types and none of them are to be used w/o block enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/blk-cgroup.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c567865..51f95b3 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -558,8 +558,8 @@ static inline void blkg_rwstat_merge(struct blkg_rwstat *to,
 
 #else	/* CONFIG_BLK_CGROUP */
 
-struct cgroup;
-struct blkcg;
+struct blkcg {
+};
 
 struct blkg_policy_data {
 };
@@ -570,6 +570,8 @@ struct blkcg_gq {
 struct blkcg_policy {
 };
 
+#ifdef CONFIG_BLOCK
+
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_drain_queue(struct request_queue *q) { }
@@ -599,5 +601,6 @@ static inline struct request_list *blk_rq_rl(struct request *rq) { return &rq->q
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
 
+#endif	/* CONFIG_BLOCK */
 #endif	/* CONFIG_BLK_CGROUP */
 #endif	/* _BLK_CGROUP_H */
-- 
2.1.0

