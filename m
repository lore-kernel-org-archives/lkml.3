Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaBHCOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 21:14:50 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:40993 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaBHCOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 21:14:49 -0500
Message-ID: <52F592F2.6010008@huawei.com>
Date: Sat, 8 Feb 2014 10:14:10 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: [PATCH 1/3] jffs2: fix unbalanced locking
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was found by our internal debugging feature on runtime, but this
bug won't lead to deadlock, as the structure that this lock is embedded
in is freed on error.

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/jffs2/readinode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 386303d..8261021 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -1143,6 +1143,7 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 		JFFS2_ERROR("cannot read nodes for ino %u, returned error is %d\n", f->inocache->ino, ret);
 		if (f->inocache->state == INO_STATE_READING)
 			jffs2_set_inocache_state(c, f->inocache, INO_STATE_CHECKEDABSENT);
+		mutex_unlock(&f->sem);
 		return ret;
 	}
 
@@ -1159,6 +1160,7 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 			jffs2_free_tmp_dnode_info(rii.mdata_tn);
 			rii.mdata_tn = NULL;
 		}
+		mutex_unlock(&f->sem);
 		return ret;
 	}
 
@@ -1183,6 +1185,7 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 			if (!rii.fds) {
 				if (f->inocache->state == INO_STATE_READING)
 					jffs2_set_inocache_state(c, f->inocache, INO_STATE_CHECKEDABSENT);
+				mutex_unlock(&f->sem);
 				return -EIO;
 			}
 			JFFS2_NOTICE("but it has children so we fake some modes for it\n");
-- 
1.8.0.2

