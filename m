Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaALC4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 21:56:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:45178 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaALC4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 21:56:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] fs/ramfs: don't use module_init for non-modular core code
Date: Sat, 11 Jan 2014 21:56:20 -0500
Message-ID: <1389495380-17231-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ramfs is always built in.  It will never be modular, so
using module_init as an alias for __initcall is rather
misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of fs_initcall (which
makes sense for fs code) will thus change this registration
from level 6-device to level 5-fs (i.e. slightly earlier).
However no observable impact of that small difference has
been observed during testing, or is expected.

Also note that this change uncovers a missing semicolon bug in
the registration of the initcall.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 03b8016e5bbc..d365b1c4eb3c 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -282,4 +282,4 @@ int __init init_ramfs_fs(void)
 
 	return err;
 }
-module_init(init_ramfs_fs)
+fs_initcall(init_ramfs_fs);
-- 
1.8.5.2

