Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaEEMoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:44:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41125 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932364AbaEEMnh (ORCPT
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
Subject: [PATCH 3.12 45/50] jffs2: remove from wait queue after schedule()
Date: Mon,  5 May 2014 14:43:27 +0200
Message-Id: <7b87da3a8a0491eed7eb8800ccd198a077c9601b.1399292849.git.jslaby@suse.cz>
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

commit 3ead9578443b66ddb3d50ed4f53af8a0c0298ec5 upstream.

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/jffs2/nodemgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 41789e6fa6fe..b6bd4affd9ad 100644
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
1.9.2

