Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbaDVUwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:52:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaDVUXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:23:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 054/133] jffs2: remove from wait queue after schedule()
Date: Tue, 22 Apr 2014 13:13:12 -0700
Message-Id: <1398197671-12786-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3ead9578443b66ddb3d50ed4f53af8a0c0298ec5 upstream.

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/jffs2/nodemgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 0331072..bbae5b1 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -179,6 +179,7 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 					spin_unlock(&c->erase_completion_lock);
 
 					schedule();
+					remove_wait_queue(&c->erase_wait, &wait);
 				} else
 					spin_unlock(&c->erase_completion_lock);
 			} else if (ret)
-- 
1.9.1

