Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3KNQom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:44:42 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41193 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab3KNQoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:20 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitas_angelinas@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 13/26] staging/lustre/nrs: Fix a race condition in the ORR policy
Date: Fri, 15 Nov 2013 00:43:00 +0800
Message-Id: <1384447393-13838-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikitas Angelinas <nikitas_angelinas@xyratex.com>

Checking the atomic oo_ref in nrs_orr_hop_put_free() and then
taking the bucket lock leaves a race window open, by which a
second thread can attempt to free an already-freed
nrs_orr_object. Fix this, and change the hash bucket lock type
from an rwlock to a spinlock, as there are now as many calls on
the write path, as there are on the read path. Rehashing is not
used on the hashes, so libcfs_hash API usage can also be
simplified.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3430
Lustre-change: http://review.whamcloud.com/7623
Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Reviewed-by: Li Xi <pkuelelixi@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[pick up only client side of change -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_net.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 80227e9..8edf542 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -1569,7 +1569,7 @@ struct nrs_orr_data {
 	struct ptlrpc_nrs_resource	od_res;
 	cfs_binheap_t		       *od_binheap;
 	struct cfs_hash		       *od_obj_hash;
-	struct kmem_cache		       *od_cache;
+	struct kmem_cache	       *od_cache;
 	/**
 	 * Used when a new scheduling round commences, in order to synchronize
 	 * all object or OST batches with the new round number.
@@ -1626,7 +1626,7 @@ struct nrs_orr_object {
 	 * scheduling RPCs
 	 */
 	struct nrs_orr_key		oo_key;
-	atomic_t			oo_ref;
+	long				oo_ref;
 	/**
 	 * Round Robin quantum; the maximum number of RPCs that are allowed to
 	 * be scheduled for the object or OST in a single batch of each round.
-- 
1.7.9.5

