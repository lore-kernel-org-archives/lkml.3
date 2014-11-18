Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaKRB6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:58:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:54321 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaKRB6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:58:04 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: put the inode page when error was occurred
Date: Mon, 17 Nov 2014 17:57:54 -0800
Message-Id: <1416275874-74186-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
References: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should put the inode page when error was occurred.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8f16443..12dd58a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -963,22 +963,22 @@ repeat:
 		} else if (page->index == 0) {
 			err = f2fs_convert_inline_page(&dn, page);
 			if (err)
-				goto unlock_fail;
+				goto put_fail;
 		} else {
 			struct page *p = grab_cache_page(inode->i_mapping, 0);
 			if (!p) {
 				err = -ENOMEM;
-				goto unlock_fail;
+				goto put_fail;
 			}
 			err = f2fs_convert_inline_page(&dn, p);
 			f2fs_put_page(p, 1);
 			if (err)
-				goto unlock_fail;
+				goto put_fail;
 		}
 	}
 	err = f2fs_reserve_block(&dn, index);
 	if (err)
-		goto unlock_fail;
+		goto put_fail;
 put_next:
 	f2fs_put_dnode(&dn);
 	f2fs_unlock_op(sbi);
@@ -1021,6 +1021,8 @@ out:
 	clear_cold_data(page);
 	return 0;
 
+put_fail:
+	f2fs_put_dnode(&dn);
 unlock_fail:
 	f2fs_unlock_op(sbi);
 	f2fs_put_page(page, 1);
-- 
2.1.1

