Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaBEUPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:15:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:55618 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaBEUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 197/213] vfs: missed source of ->f_pos races
Date: Wed, 5 Feb 2014 15:02:32 -0500
Message-ID: <1391630568-49251-198-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0e665d5d1125f9f4ccff56a75e814f10f88861a2 upstream.

compat_sys_{read,write}v() need the same "pass a copy of file->f_pos" thing
as sys_{read,write}{,v}().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/compat.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 633e63c32aa7..388555d404bf 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1231,11 +1231,14 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
+	loff_t pos;
 
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
-	ret = compat_readv(file, vec, vlen, &file->f_pos);
+	pos = file->f_pos;
+	ret = compat_readv(file, vec, vlen, &pos);
+	file->f_pos = pos;
 	fput_light(file, fput_needed);
 	return ret;
 }
@@ -1288,11 +1291,14 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
+	loff_t pos;
 
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
-	ret = compat_writev(file, vec, vlen, &file->f_pos);
+	pos = file->f_pos;
+	ret = compat_writev(file, vec, vlen, &pos);
+	file->f_pos = pos;
 	fput_light(file, fput_needed);
 	return ret;
 }
-- 
1.8.5.2

