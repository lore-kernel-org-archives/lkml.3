Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaFYEpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:45:55 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63374 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaFYEpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:45:53 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] vfs: fix check for fallocate on active swapfile
Date: Tue, 24 Jun 2014 23:45:08 -0500
Message-Id: <1403671508-371-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the broken check for calling sys_fallocate() on an active swapfile,
introduced by commit 0790b31b69374ddadefe ("fs: disallow all fallocate
operation on active swapfile").

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/open.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 36662d0..d6fd3ac 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -263,11 +263,10 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EPERM;
 
 	/*
-	 * We can not allow to do any fallocate operation on an active
-	 * swapfile
+	 * We cannot allow any fallocate operation on an active swapfile
 	 */
 	if (IS_SWAPFILE(inode))
-		ret = -ETXTBSY;
+		return -ETXTBSY;
 
 	/*
 	 * Revalidate the write permissions, in case security policy has
-- 
2.0.0

