Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaEVUoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:44:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51963 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaEVUoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:44:24 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: ntfs: file.c:  Fix for possible null pointer dereference
Date: Thu, 22 May 2014 22:45:14 +0200
Message-Id: <1400791514-12014-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ntfs/file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index db9bd8a..99394b4 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -308,10 +308,11 @@ do_non_resident_extend:
 	BUG_ON(!a->non_resident);
 	a->data.non_resident.initialized_size = cpu_to_sle64(new_init_size);
 done:
-	flush_dcache_mft_record_page(ctx->ntfs_ino);
-	mark_mft_record_dirty(ctx->ntfs_ino);
-	if (ctx)
+	if (ctx) {
+		flush_dcache_mft_record_page(ctx->ntfs_ino);
+		mark_mft_record_dirty(ctx->ntfs_ino);
 		ntfs_attr_put_search_ctx(ctx);
+	}
 	if (m)
 		unmap_mft_record(base_ni);
 	ntfs_debug("Done, initialized_size 0x%llx, i_size 0x%llx.",
-- 
1.7.10.4

