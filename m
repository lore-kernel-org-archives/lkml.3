Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaJ2MzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:55:06 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14392 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbaJ2MqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:13 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/35] UBI: Fastmap: Fix races in ubi_wl_get_peb()
Date: Wed, 29 Oct 2014 13:45:30 +0100
Message-Id: <1414586758-9972-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubi_wl_get_peb() has two problems, it reads the pool
size and usage counters without any protection.
While reading one value would be perfectly fine it reads multiple
values and compares them. This is racy and can lead to incorrect
pool handling.
Furthermore ubi_update_fastmap() is called without wl_lock held,
before incrementing the used counter it needs to be checked again.
It could happen that another thread consumed all PEBs from the
pool and the counter goes beyond ->size.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index a06e31e..5f8d2ff 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -626,24 +626,34 @@ void ubi_refill_pools(struct ubi_device *ubi)
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
 {
-	int ret;
+	int ret, retried = 0;
 	struct ubi_fm_pool *pool = &ubi->fm_pool;
 	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
-	if (!pool->size || !wl_pool->size || pool->used == pool->size ||
-	    wl_pool->used == wl_pool->size)
+again:
+	spin_lock(&ubi->wl_lock);
+	if (!pool->size || !wl_pool->size || pool->used >= pool->size ||
+	    wl_pool->used >= wl_pool->size) {
+		spin_unlock(&ubi->wl_lock);
 		ubi_update_fastmap(ubi);
-
-	/* we got not a single free PEB */
-	if (!pool->size)
-		ret = -ENOSPC;
-	else {
 		spin_lock(&ubi->wl_lock);
-		ret = pool->pebs[pool->used++];
-		prot_queue_add(ubi, ubi->lookuptbl[ret]);
+	}
+
+	if (pool->used >= pool->size || !pool->size) {
 		spin_unlock(&ubi->wl_lock);
+		if (retried) {
+			ubi_err("Unable to get a free PEB from user WL pool");
+			ret = -ENOSPC;
+			goto out;
+		}
+		retried = 1;
+		goto again;
 	}
 
+	ret = pool->pebs[pool->used++];
+	prot_queue_add(ubi, ubi->lookuptbl[ret]);
+	spin_unlock(&ubi->wl_lock);
+out:
 	return ret;
 }
 
-- 
1.8.4.5

