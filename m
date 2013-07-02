Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3GBLKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:10:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3GBLIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/50] UBIFS: fix a horrid bug
Date: Tue,  2 Jul 2013 12:07:36 +0100
Message-Id: <1372763258-20664-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 605c912bb843c024b1ed173dc427cd5c08e5d54d upstream.

Al Viro pointed me to the fact that '->readdir()' and '->llseek()' have no
mutual exclusion, which means the 'ubifs_dir_llseek()' can be run while we are
in the middle of 'ubifs_readdir()'.

This means that 'file->private_data' can be freed while 'ubifs_readdir()' uses
it, and this is a very bad bug: not only 'ubifs_readdir()' can return garbage,
but this may corrupt memory and lead to all kinds of problems like crashes an
security holes.

This patch fixes the problem by using the 'file->f_version' field, which
'->llseek()' always unconditionally sets to zero. We set it to 1 in
'ubifs_readdir()' and whenever we detect that it became 0, we know there was a
seek and it is time to clear the state saved in 'file->private_data'.

I tested this patch by writing a user-space program which runds readdir and
seek in parallell. I could easily crash the kernel without these patches, but
could not crash it with these patches.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/dir.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 918ce52..1ce4953 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -365,6 +365,24 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		 */
 		return 0;
 
+	if (file->f_version == 0) {
+		/*
+		 * The file was seek'ed, which means that @file->private_data
+		 * is now invalid. This may also be just the first
+		 * 'ubifs_readdir()' invocation, in which case
+		 * @file->private_data is NULL, and the below code is
+		 * basically a no-op.
+		 */
+		kfree(file->private_data);
+		file->private_data = NULL;
+	}
+
+	/*
+	 * 'generic_file_llseek()' unconditionally sets @file->f_version to
+	 * zero, and we use this for detecting whether the file was seek'ed.
+	 */
+	file->f_version = 1;
+
 	/* File positions 0 and 1 correspond to "." and ".." */
 	if (pos == 0) {
 		ubifs_assert(!file->private_data);
@@ -438,6 +456,14 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 		cond_resched();
+
+		if (file->f_version == 0)
+			/*
+			 * The file was seek'ed meanwhile, lets return and start
+			 * reading direntries from the new position on the next
+			 * invocation.
+			 */
+			return 0;
 	}
 
 out:
@@ -448,15 +474,13 @@ out:
 
 	kfree(file->private_data);
 	file->private_data = NULL;
+	/* 2 is a special value indicating that there are no more direntries */
 	file->f_pos = 2;
 	return 0;
 }
 
-/* If a directory is seeked, we have to free saved readdir() state */
 static loff_t ubifs_dir_llseek(struct file *file, loff_t offset, int origin)
 {
-	kfree(file->private_data);
-	file->private_data = NULL;
 	return generic_file_llseek(file, offset, origin);
 }
 
-- 
1.8.1.2

