Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3IWIwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:52:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51316 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3IWIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:52:47 -0400
Message-ID: <5240014E.1080804@huawei.com>
Date: Mon, 23 Sep 2013 16:52:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Woodhouse <David.Woodhouse@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: [PATCH] jffs2: fix unbalanced locking
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the failure path in jffs2_do_crccheck_inode() the lock isn't released
before returning.

This probably won't cause real bug, because the structure that contains
the lock is freed in this case.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/jffs2/readinode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index ae81b01..55cf63d 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -1425,7 +1425,8 @@ int jffs2_do_crccheck_inode(struct jffs2_sb_info *c, struct jffs2_inode_cache *i
 		jffs2_do_clear_inode(c, f);
 	}
 	jffs2_xattr_do_crccheck_inode(c, ic);
-	kfree (f);
+	mutex_unlock(&f->sem);
+	kfree(f);
 	return ret;
 }
 
-- 
1.8.0.2
