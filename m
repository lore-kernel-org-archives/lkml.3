Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab3JRTyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:54:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3JRTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/11] vfs: allow O_PATH file descriptors for fstatfs()
Date: Fri, 18 Oct 2013 12:53:33 -0700
Message-Id: <20131018195049.370263767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9d05746e7b16d8565dddbe3200faa1e669d23bbf upstream.

Olga reported that file descriptors opened with O_PATH do not work with
fstatfs(), found during further development of ksh93's thread support.

There is no reason to not allow O_PATH file descriptors here (fstatfs is
very much a path operation), so use "fdget_raw()".  See commit
55815f70147d ("vfs: make O_PATH file descriptors usable for 'fstat()'")
for a very similar issue reported for fstat() by the same team.

Reported-and-tested-by: ольга крыжановская <olga.kryzhanovska@gmail.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/statfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -87,7 +87,7 @@ int user_statfs(const char __user *pathn
 
 int fd_statfs(int fd, struct kstatfs *st)
 {
-	struct file *file = fget(fd);
+	struct file *file = fget_raw(fd);
 	int error = -EBADF;
 	if (file) {
 		error = vfs_statfs(&file->f_path, st);


