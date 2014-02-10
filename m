Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBJLxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:53:02 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:36207 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752214AbaBJLxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:53:00 -0500
Date: Mon, 10 Feb 2014 13:52:56 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <viro@zeniv.linux.org.uk>, <bcrl@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
        <linux-kernel@vger.kernel.org>, <rakesh@tuxera.com>
Subject: [PATCH] aio: add aio_migratepage_helper to get rid of duplicate code
Message-ID: <20140210115255.GA3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 fs/aio.c | 55 +++++++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index d3d55dc..20d690a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -278,32 +278,46 @@ static int aio_set_page_dirty(struct page *page)
 }
 
 #if IS_ENABLED(CONFIG_MIGRATION)
-static int aio_migratepage(struct address_space *mapping, struct page *new,
-			struct page *old, enum migrate_mode mode)
+static int aio_migratepage_helper(struct address_space *mapping,
+			struct page *new, struct page *old, bool move)
 {
 	struct kioctx *ctx;
 	unsigned long flags;
-	int rc;
-
-	rc = 0;
+	int rc = 0;
 
-	/* Make sure the old page hasn't already been changed */
+	/* We can potentially race against kioctx teardown here.  Use the
+	 * address_space's private data lock to protect the mapping's
+	 * private_data.
+	 */
 	spin_lock(&mapping->private_lock);
 	ctx = mapping->private_data;
 	if (ctx) {
 		pgoff_t idx;
 		spin_lock_irqsave(&ctx->completion_lock, flags);
+		if (move)
+			migrate_page_copy(new, old);
 		idx = old->index;
 		if (idx < (pgoff_t)ctx->nr_pages) {
 			if (ctx->ring_pages[idx] != old)
 				rc = -EAGAIN;
+			else if (move)
+				ctx->ring_pages[idx] = new;
 		} else
 			rc = -EINVAL;
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	} else
-		rc = -EINVAL;
+		rc = move ? -EBUSY : -EINVAL;
 	spin_unlock(&mapping->private_lock);
+	return rc;
+}
 
+static int aio_migratepage(struct address_space *mapping, struct page *new,
+			struct page *old, enum migrate_mode mode)
+{
+	int rc = 0;
+
+	/* Make sure the old page hasn't already been changed */
+	rc = aio_migratepage_helper(mapping, new, old, false);
 	if (rc != 0)
 		return rc;
 
@@ -317,31 +331,8 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 		return rc;
 	}
 
-	/* We can potentially race against kioctx teardown here.  Use the
-	 * address_space's private data lock to protect the mapping's
-	 * private_data.
-	 */
-	spin_lock(&mapping->private_lock);
-	ctx = mapping->private_data;
-	if (ctx) {
-		pgoff_t idx;
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		migrate_page_copy(new, old);
-		idx = old->index;
-		if (idx < (pgoff_t)ctx->nr_pages) {
-			/* And only do the move if things haven't changed */
-			if (ctx->ring_pages[idx] == old)
-				ctx->ring_pages[idx] = new;
-			else
-				rc = -EAGAIN;
-		} else
-			rc = -EINVAL;
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else
-		rc = -EBUSY;
-	spin_unlock(&mapping->private_lock);
-
-	if (rc == MIGRATEPAGE_SUCCESS)
+	rc = aio_migratepage_helper(mapping, new, old, true);
+	if (rc == 0)
 		put_page(old);
 	else
 		put_page(new);
-- 
1.8.3.1

