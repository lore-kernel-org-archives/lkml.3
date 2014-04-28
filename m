Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaD1Bax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbaD1B3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Brian Norris" <computersforpeace@gmail.com>,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        "Li Zefan" <lizefan@huawei.com>,
        "David Woodhouse" <dwmw2@infradead.org>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.618076091@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 42/94] jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jffs2/nodemgmt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -159,19 +159,24 @@ int jffs2_reserve_space(struct jffs2_sb_
 int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
 			   uint32_t *len, uint32_t sumsize)
 {
-	int ret = -EAGAIN;
+	int ret;
 	minsize = PAD(minsize);
 
 	D1(printk(KERN_DEBUG "jffs2_reserve_space_gc(): Requested 0x%x bytes\n", minsize));
 
-	spin_lock(&c->erase_completion_lock);
-	while(ret == -EAGAIN) {
+	while (true) {
+		spin_lock(&c->erase_completion_lock);
 		ret = jffs2_do_reserve_space(c, minsize, len, sumsize);
 		if (ret) {
 			D1(printk(KERN_DEBUG "jffs2_reserve_space_gc: looping, ret is %d\n", ret));
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
 

