Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaEEMo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:44:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41127 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363AbaEEMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 44/50] jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
Date: Mon,  5 May 2014 14:43:26 +0200
Message-Id: <ff308965e7189645ad5f8343c145388002ac49fe.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 13b546d96207c131eeae15dc7b26c6e7d0f1cad7 upstream.

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

[akpm@linux-foundation.org: don't initialize `ret']
Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/jffs2/nodemgmt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 03310721712f..41789e6fa6fe 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -211,20 +211,25 @@ out:
 int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
 			   uint32_t *len, uint32_t sumsize)
 {
-	int ret = -EAGAIN;
+	int ret;
 	minsize = PAD(minsize);
 
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
1.9.2

