Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3GZH5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:57:38 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:33594 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3GZH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:57:36 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, sparclinux@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] dm cache: Avoid conflicting remove_mapping() in mq policy
Date: Fri, 26 Jul 2013 09:57:31 +0200
Message-Id: <1374825451-30463-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sparc32, which includes <linux/swap.h> from <asm/pgtable_32.h>:

drivers/md/dm-cache-policy-mq.c:962:13: error: conflicting types for 'remove_mapping'
include/linux/swap.h:285:12: note: previous declaration of 'remove_mapping' was here

As mq_remove_mapping() already exists, and the local remove_mapping() is
used only once, inline it manually to avoid the conflict.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I think this is also needed on hexagon, which includes <linux/swap.h> from
<asm/pgtable.h>.

 drivers/md/dm-cache-policy-mq.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index dc112a7..4296155 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -959,23 +959,21 @@ out:
 	return r;
 }
 
-static void remove_mapping(struct mq_policy *mq, dm_oblock_t oblock)
+static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	struct entry *e = hash_lookup(mq, oblock);
+	struct mq_policy *mq = to_mq_policy(p);
+	struct entry *e;
+
+	mutex_lock(&mq->lock);
+
+	e = hash_lookup(mq, oblock);
 
 	BUG_ON(!e || !e->in_cache);
 
 	del(mq, e);
 	e->in_cache = false;
 	push(mq, e);
-}
 
-static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
-{
-	struct mq_policy *mq = to_mq_policy(p);
-
-	mutex_lock(&mq->lock);
-	remove_mapping(mq, oblock);
 	mutex_unlock(&mq->lock);
 }
 
-- 
1.7.9.5

