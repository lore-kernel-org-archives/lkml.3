Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3GAUPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:15:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3GAUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 10/13] UBIFS: fix a horrid bug
Date: Mon,  1 Jul 2013 13:10:29 -0700
Message-Id: <20130701200524.298718013@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200523.096669485@linuxfoundation.org>
References: <20130701200523.096669485@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/dir.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -373,6 +373,24 @@ static int ubifs_readdir(struct file *fi
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
@@ -446,6 +464,14 @@ static int ubifs_readdir(struct file *fi
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
@@ -456,15 +482,13 @@ out:
 
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
 


