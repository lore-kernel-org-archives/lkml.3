Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaCPTZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:25:37 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46451 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbaCPTZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:25:36 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] vfs: atomic f_pos access in llseek()
Date: Sun, 16 Mar 2014 14:24:08 -0500
Message-Id: <1394997848-11360-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9c225f2655e36a4 ("vfs: atomic f_pos accesses as per POSIX") changed
several system calls to use fdget_pos() instead of fdget(), but missed
sys_llseek().  Fix it.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/read_write.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 54e19b9..28cc9c8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -307,7 +307,7 @@ SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
 		unsigned int, whence)
 {
 	int retval;
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	loff_t offset;
 
 	if (!f.file)
@@ -327,7 +327,7 @@ SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
 			retval = 0;
 	}
 out_putf:
-	fdput(f);
+	fdput_pos(f);
 	return retval;
 }
 #endif
-- 
1.9.0

