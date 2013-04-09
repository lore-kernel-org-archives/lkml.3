Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935808Ab3DINfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:35:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22363 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760402Ab3DINfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:35:17 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] mnt: release locks on error path in do_loopback
Date: Tue,  9 Apr 2013 17:33:29 +0400
Message-Id: <1365514409-12448-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_loopback calls lock_mount(path) and forget to unlock_mount
if clone_mnt or copy_mnt fails.

[   77.661566] ================================================
[   77.662939] [ BUG: lock held when returning to user space! ]
[   77.664104] 3.9.0-rc5+ #17 Not tainted
[   77.664982] ------------------------------------------------
[   77.666488] mount/514 is leaving the kernel with locks still held!
[   77.668027] 2 locks held by mount/514:
[   77.668817]  #0:  (&sb->s_type->i_mutex_key#7){+.+.+.}, at: [<ffffffff811cca22>] lock_mount+0x32/0xe0
[   77.671755]  #1:  (&namespace_sem){+++++.}, at: [<ffffffff811cca3a>] lock_mount+0x4a/0xe0

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f4fa671e..a81343e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1704,7 +1704,7 @@ static int do_loopback(struct path *path, const char *old_name,
 
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
-		goto out;
+		goto out2;
 	}
 
 	err = graft_tree(mnt, path);
-- 
1.8.1.4

