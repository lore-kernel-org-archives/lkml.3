Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3HFJg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:36:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46410 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3HFJgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:36:55 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-e9-5200c3b5a63b
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: bob.liu@oracle.com
Cc: b.zolnierkie@samsung.com, p.sarna@partner.samsung.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] mm: zcache: zcache_cleancache_flush_fs fix
Date: Tue, 06 Aug 2013 11:36:02 +0200
Message-id: <1375781762-15344-1-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jQd2thxmCDPr+GFtsnLGe1aLr1FQW
	i7NNb9gtLu+aw2Zxb81/VotVi6Ic2Dw2fZrE7vHx6S0Wj4Pv9jB59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aSiwdYC35yV8y5cIW5gfEbZxcjJ4eEgIlE+8L3LBC2mMSFe+vZuhi5OIQE
	pjNKHNu+GMppZ5I4cGM5WBWbgL7El+trwGwRoI6Vb9eCFTELzGCUODL7LDNIQljAWuLA/Yds
	IDaLgKrE7Pb9TCA2r4C3xOttJ4DiHEDrFCTmTLKZwMi9gJFhFaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZwaDyT3sG4qsHiEKMAB6MSD2/C1f+BQqyJZcWVuYcYJTiYlUR4VXYyBAnxpiRW
	VqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgbH+3ik1tLedxu5J5
	J6Zz/ShMvMF6l3e97za5yYbMR6JmCLEoqDtqzjB7LMXAPU8ut2qhKk+xy6+lFXavj/c0lIhH
	7feL0jDN+yGe+c/bpP2jRkzikrQ/k+MFX16qazp+I/nfejcGX169l7FXJBoT2opdszOWSeyM
	rmM+1HlN7OiSFx5pC7WUWIozEg21mIuKEwH4DlE+CQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "mm: zcache: core functions added" patch,
available at https://lkml.org/lkml/2013/7/20/90.
It regards incorrect implementation of zcache_cleancache_flush_fs().

Function above should be effective only if cleancache pool referred
by pool_id is valid. This issue is checked by testing whether zpool
points to NULL.

Unfortunately, if filesystem mount fails, such pool is never created
and fs/super.c calls cleancache_invalidate_fs() function with pool_id
parameter set to -1. This results in assigning zpool with pools[-1],
which causes zpool to be not NULL and thus whole function hangs on
uninitialized read-write lock.

To prevent that behaviour, pool_id should be checked for being positive
before assigning zpool variable with pools[pool_id].

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 mm/zcache.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/zcache.c b/mm/zcache.c
index a2408e8..7e6d2e7 100644
--- a/mm/zcache.c
+++ b/mm/zcache.c
@@ -600,8 +600,12 @@ static void zcache_cleancache_flush_fs(int pool_id)
 	struct zcache_rb_entry *entry = NULL;
 	struct rb_node *node;
 	unsigned long flags1, flags2;
-	struct zcache_pool *zpool = zcache.pools[pool_id];
+	struct zcache_pool *zpool;
+
+	if (pool_id < 0)
+		return;
 
+	zpool = zcache.pools[pool_id];
 	if (!zpool)
 		return;
 
-- 
1.7.9.5

