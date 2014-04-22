Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbaDVUTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:19:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbaDVUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:19:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 103/133] dm thin: fix dangling bio in process_deferred_bios error path
Date: Tue, 22 Apr 2014 13:14:01 -0700
Message-Id: <1398197671-12786-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit fe76cd88e654124d1431bb662a0fc6e99ca811a5 upstream.

If unable to ensure_next_mapping() we must add the current bio, which
was removed from the @bios list via bio_list_pop, back to the
deferred_bios list before all the remaining @bios.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 4d9659b..ca954b1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1245,9 +1245,9 @@ static void process_deferred_bios(struct pool *pool)
 		 */
 		if (ensure_next_mapping(pool)) {
 			spin_lock_irqsave(&pool->lock, flags);
+			bio_list_add(&pool->deferred_bios, bio);
 			bio_list_merge(&pool->deferred_bios, &bios);
 			spin_unlock_irqrestore(&pool->lock, flags);
-
 			break;
 		}
 
-- 
1.9.1

