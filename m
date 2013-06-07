Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3FGCRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:17:24 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:47415 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3FGCRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:17:23 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 10:17:22 +0800
Message-ID: <CAPgLHd_=Y=YwCWSFjcacJ14yKUidmmJTHnKKibU6haoBUeNacA@mail.gmail.com>
Subject: [PATCH] UBIFS: fix error return code in ubifs_remount_rw() and ubifs_fill_super()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dedekind1@gmail.com, adrian.hunter@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the kmalloc() and d_make_root() error handling
case instead of 0, as done elsewhere in those functions.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ubifs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index f21acf0..673b4bc 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1629,8 +1629,10 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	}
 
 	c->write_reserve_buf = kmalloc(COMPRESSED_DATA_NODE_BUF_SZ, GFP_KERNEL);
-	if (!c->write_reserve_buf)
+	if (!c->write_reserve_buf) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	err = ubifs_lpt_init(c, 0, 1);
 	if (err)
@@ -2063,8 +2065,10 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sb->s_root = d_make_root(root);
-	if (!sb->s_root)
+	if (!sb->s_root) {
+		err = -ENOMEM;
 		goto out_umount;
+	}
 
 	mutex_unlock(&c->umount_mutex);
 	return 0;

