Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab3GSIWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:22:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab3GSIWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:22:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947719"
Message-ID: <51E8F65F.9040007@cn.fujitsu.com>
Date: Fri, 19 Jul 2013 16:18:39 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs: add the missing delection of orphan inode entry in
 write_orphan_inodes()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 16:20:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 16:20:18,
	Serialize complete at 2013/07/19 16:20:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After writing orphan inode entry in jornal block, we need to delete each
entry from the orphan entry list, and release them.


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 66a6b85..290db04 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -337,6 +337,10 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 		memset(orphan_blk, 0, sizeof(*orphan_blk));
 page_exist:
 		orphan_blk->ino[nentries++] = cpu_to_le32(orphan->ino);
+
+		list_del(&orphan->list);
+		kmem_cache_free(orphan_entry_slab, orphan);
+		sbi->n_orphans--;
 	}
 	if (!page)
 		goto end;
-- 
1.7.7

