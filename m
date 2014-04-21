Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaDUEhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:37:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaDUEfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:35:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.13 26/32] jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
Date: Sun, 20 Apr 2014 19:13:43 -0700
Message-Id: <20140421021137.429999427@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/nodemgmt.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

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
 


