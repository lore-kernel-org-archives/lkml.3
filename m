Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908Ab3JPSXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:23:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab3JPRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 06/69] vfs: allow O_PATH file descriptors for fstatfs()
Date: Wed, 16 Oct 2013 10:44:15 -0700
Message-Id: <20131016174313.631364854@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -94,7 +94,7 @@ retry:
 
 int fd_statfs(int fd, struct kstatfs *st)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_raw(fd);
 	int error = -EBADF;
 	if (f.file) {
 		error = vfs_statfs(&f.file->f_path, st);


