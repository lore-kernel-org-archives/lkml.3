Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbbALSyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:54:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbALSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 152/216] dm thin: fix a race in thin_dtr
Date: Mon, 12 Jan 2015 18:28:50 +0000
Message-Id: <1421087394-2712-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 17181fb7a0c3a279196c0eeb2caba65a1519614b upstream.

As long as struct thin_c is in the list, anyone can grab a reference of
it.  Consequently, we must wait for the reference count to drop to zero
*after* we remove the structure from the list, not before.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index df898e0db419..6f75083a81cc 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3183,14 +3183,14 @@ static void thin_dtr(struct dm_target *ti)
 	struct thin_c *tc = ti->private;
 	unsigned long flags;
 
-	thin_put(tc);
-	wait_for_completion(&tc->can_destroy);
-
 	spin_lock_irqsave(&tc->pool->lock, flags);
 	list_del_rcu(&tc->list);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 	synchronize_rcu();
 
+	thin_put(tc);
+	wait_for_completion(&tc->can_destroy);
+
 	mutex_lock(&dm_thin_pool_table.mutex);
 
 	__pool_dec(tc->pool);
-- 
2.1.4

