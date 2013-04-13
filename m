Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3DMODW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:03:22 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:62907 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3DMODU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:03:20 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.8-stable] mnt: release locks on error path in do_loopback
Date: Sat, 13 Apr 2013 23:02:08 +0900
Message-Id: <1365861728-5557-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Andrey Vagin <avagin@openvz.org>"

commit e9c5d8a562f01b211926d70443378eb14b29a676 upstream

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
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5dd7709..4abc8c0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1713,7 +1713,7 @@ static int do_loopback(struct path *path, const char *old_name,
 
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
-		goto out;
+		goto out2;
 	}
 
 	err = graft_tree(mnt, path);
-- 
1.7.10.4

