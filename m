Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3HMQAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:00:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab3HMP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:42 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-dSR_zMDwDUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=a3zGlQrJlCgA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=mHfI27u987tkQCTrSiYA:9 a=jeBq3FmKZ4MA:10 a=78435VTkClktVvTX:21 a=_5juxO-OqkDlbAYj:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155831.705200956@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [51/88] UBIFS: fix a horrid bug
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0051-UBIFS-fix-a-horrid-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 605c912bb843c024b1ed173dc427cd5c08e5d54d ]

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

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ubifs/dir.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 63799a7..1f61701 100644
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
1.7.10.4


