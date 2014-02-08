Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaBHCP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 21:15:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:5886 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaBHCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 21:15:57 -0500
Message-ID: <52F5934B.4000101@huawei.com>
Date: Sat, 8 Feb 2014 10:15:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: [PATCH 2/3] jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
References: <52F592F2.6010008@huawei.com>
In-Reply-To: <52F592F2.6010008@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We triggered soft-lockup under stress test on 2.6.34 kernel.

BUG: soft lockup - CPU#1 stuck for 60009ms! [lockf2.test:14488]
...
[<bf09a4d4>] (jffs2_do_reserve_space+0x420/0x440 [jffs2])
[<bf09a528>] (jffs2_reserve_space_gc+0x34/0x78 [jffs2])
[<bf0a1350>] (jffs2_garbage_collect_dnode.isra.3+0x264/0x478 [jffs2])
[<bf0a2078>] (jffs2_garbage_collect_pass+0x9c0/0xe4c [jffs2])
[<bf09a670>] (jffs2_reserve_space+0x104/0x2a8 [jffs2])
[<bf09dc48>] (jffs2_write_inode_range+0x5c/0x4d4 [jffs2])
[<bf097d8c>] (jffs2_write_end+0x198/0x2c0 [jffs2])
[<c00e00a4>] (generic_file_buffered_write+0x158/0x200)
[<c00e14f4>] (__generic_file_aio_write+0x3a4/0x414)
[<c00e15c0>] (generic_file_aio_write+0x5c/0xbc)
[<c012334c>] (do_sync_write+0x98/0xd4)
[<c0123a84>] (vfs_write+0xa8/0x150)
[<c0123d74>] (sys_write+0x3c/0xc0)]

Fix this by adding a cond_resched() in the while loop.

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/jffs2/nodemgmt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 0331072..fb30161 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -216,15 +216,20 @@ int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
 
 	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
 
-	spin_lock(&c->erase_completion_lock);
-	while(ret == -EAGAIN) {
+	while (true) {
+		spin_lock(&c->erase_completion_lock);
 		ret = jffs2_do_reserve_space(c, minsize, len, sumsize);
 		if (ret) {
 			jffs2_dbg(1, "%s(): looping, ret is %d\n",
 				  __func__, ret);
 		}
+		spin_unlock(&c->erase_completion_lock);
+
+		if (ret == -EAGAIN)
+			cond_resched();
+		else
+			break;
 	}
-	spin_unlock(&c->erase_completion_lock);
 	if (!ret)
 		ret = jffs2_prealloc_raw_node_refs(c, c->nextblock, 1);
 
-- 
1.8.0.2

