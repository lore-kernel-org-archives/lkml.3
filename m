Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3GOO2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:28:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44562 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3GOO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:28 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 14/17] staging/lustre: fix for invalidatepage() API change
Date: Mon, 15 Jul 2013 22:27:17 +0800
Message-Id: <1373898440-14208-15-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

somehow this got dropped during merge window...

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/lustre_patchless_compat.h |    2 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
index a8e9c0c..a260e99 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
@@ -53,7 +53,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 		return;
 
 	if (PagePrivate(page))
-		page->mapping->a_ops->invalidatepage(page, 0);
+		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
 
 	cancel_dirty_page(page, PAGE_SIZE);
 	ClearPageMappedToDisk(page);
diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 27e4e64..f1a1c5f 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -72,7 +72,8 @@
  * aligned truncate). Lustre leaves partially truncated page in the cache,
  * relying on struct inode::i_size to limit further accesses.
  */
-static void ll_invalidatepage(struct page *vmpage, unsigned long offset)
+static void ll_invalidatepage(struct page *vmpage, unsigned int offset,
+			      unsigned int length)
 {
 	struct inode     *inode;
 	struct lu_env    *env;
@@ -89,7 +90,7 @@ static void ll_invalidatepage(struct page *vmpage, unsigned long offset)
 	 * below because they are run with page locked and all our io is
 	 * happening with locked page too
 	 */
-	if (offset == 0) {
+	if (offset == 0 && length == PAGE_CACHE_SIZE) {
 		env = cl_env_get(&refcheck);
 		if (!IS_ERR(env)) {
 			inode = vmpage->mapping->host;
-- 
1.7.9.5

