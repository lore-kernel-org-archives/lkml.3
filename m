Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaCPUsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 16:48:32 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62437 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaCPUsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 16:48:31 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] vfs: Don't let __fdget_pos() get FMODE_PATH files
Date: Sun, 16 Mar 2014 15:47:48 -0500
Message-Id: <1395002868-4642-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bd2a31d522344 ("get rid of fget_light()") introduced the
__fdget_pos() function, which returns the resulting file pointer and
fdput flags combined in an 'unsigned long'.  However, it also changed the
behavior to return files with FMODE_PATH set, which shouldn't happen
because read(), write(), lseek(), etc. aren't allowed on such files.
This commit restores the old behavior.

This regression actually had no effect on read() and write() since
FMODE_READ and FMODE_WRITE are not set on file descriptors opened with
O_PATH, but it did cause lseek() on a file descriptor opened with O_PATH
to fail with ESPIPE rather than EBADF.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/file.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 60a45e9..eb56a13 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -713,27 +713,16 @@ unsigned long __fdget_raw(unsigned int fd)
 
 unsigned long __fdget_pos(unsigned int fd)
 {
-	struct files_struct *files = current->files;
-	struct file *file;
-	unsigned long v;
-
-	if (atomic_read(&files->count) == 1) {
-		file = __fcheck_files(files, fd);
-		v = 0;
-	} else {
-		file = __fget(fd, 0);
-		v = FDPUT_FPUT;
-	}
-	if (!file)
-		return 0;
+	unsigned long v = __fdget(fd);
+	struct file *file = (struct file *)(v & ~3);
 
-	if (file->f_mode & FMODE_ATOMIC_POS) {
+	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
 		if (file_count(file) > 1) {
 			v |= FDPUT_POS_UNLOCK;
 			mutex_lock(&file->f_pos_lock);
 		}
 	}
-	return v | (unsigned long)file;
+	return v;
 }
 
 /*
-- 
1.9.0

