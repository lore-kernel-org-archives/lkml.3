Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3KYN64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:58:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59019 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab3KYNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.958344770@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 64/87] vfs: allow O_PATH file descriptors for fstatfs()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use fget_raw() not fdget_raw()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/statfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -86,7 +86,7 @@ int user_statfs(const char __user *pathn
 
 int fd_statfs(int fd, struct kstatfs *st)
 {
-	struct file *file = fget(fd);
+	struct file *file = fget_raw(fd);
 	int error = -EBADF;
 	if (file) {
 		error = vfs_statfs(&file->f_path, st);

