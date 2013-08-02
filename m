Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3HBEoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:44:39 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54271 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3HBEoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:44:37 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] fs: Allow unprivileged linkat(..., AT_EMPTY_PATH) aka flink
Date: Thu,  1 Aug 2013 21:44:31 -0700
Message-Id: <eb984f61d768986377aa407fc24dd403572da772.1375418617.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CALCETrUTyLO4BKX0SrmRd=nb2jvvZEhD9iTyFpSM23OUdQLhsA@mail.gmail.com>
References: <CALCETrUTyLO4BKX0SrmRd=nb2jvvZEhD9iTyFpSM23OUdQLhsA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every now and then someone proposes a new flink syscall, and this spawns
a long discussion of whether it would be a security problem.  I think
that this is missing the point: flink is *already* allowed without
privilege as long as /proc is mounted -- it's called AT_SYMLINK_FOLLOW.

Now that O_TMPFILE is here, the ability to create a file with O_TMPFILE,
write it, and link it in is very convenient.  The only problem is that
it requires that /proc be mounted so that you can do:

linkat(AT_FDCWD, "/proc/self/fd/<tmpfd>", dfd, path, AT_SYMLINK_NOFOLLOW)

This sucks -- it's much nicer to do:

linkat(tmpfd, "", dfd, path, AT_EMPTY_PATH)

Let's allow it.

If this turns out to be excessively scary, it we could instead require
that the inode in question be I_LINKABLE, but this seems pointless given
the /proc situation

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/namei.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8b61d10..89a612e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3671,15 +3671,11 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
 	/*
-	 * To use null names we require CAP_DAC_READ_SEARCH
-	 * This ensures that not everyone will be able to create
-	 * handlink using the passed filedescriptor.
+	 * Using empty names is equivalent to using AT_SYMLINK_FOLLOW
+	 * on /proc/self/fd/<fd>.
 	 */
-	if (flags & AT_EMPTY_PATH) {
-		if (!capable(CAP_DAC_READ_SEARCH))
-			return -ENOENT;
+	if (flags & AT_EMPTY_PATH)
 		how = LOOKUP_EMPTY;
-	}
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
-- 
1.8.3.1

