Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaIXLQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:16:17 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:42323 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaIXLQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:16:14 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: rdunlap@infradead.org, viro@zeniv.linux.org.uk
Cc: linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        akpm@linux-foundation.org, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp, rob.jones@codethink.co.uk
Subject: [PATCH RESUBMIT 2/2] Documentation/filesystem/seq_file: document seq_open_init()
Date: Wed, 24 Sep 2014 12:15:56 +0100
Message-Id: <1411557356-10673-3-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for new function and restructure existing text
in the same area.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 Documentation/filesystems/seq_file.txt |   58 +++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 420fc0d..10a3be6 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -221,15 +221,37 @@ Here, the call to seq_open() takes the seq_operations structure we created
 before, and gets set up to iterate through the virtual file.
 
 On a successful open, seq_open() stores the struct seq_file pointer in
-file->private_data. If you have an application where the same iterator can
-be used for more than one file, you can store an arbitrary pointer in the
-private field of the seq_file structure; that value can then be retrieved
-by the iterator functions.
+file->private_data.
 
-There is also a wrapper function to seq_open() called seq_open_private(). It
-kmallocs a zero filled block of memory and stores a pointer to it in the
-private field of the seq_file structure, returning 0 on success. The
-block size is specified in a third parameter to the function, e.g.:
+Many applications can use the same iterator for more than one file. You can
+store an arbitrary pointer in the private field of the seq_file structure;
+that value can then be retrieved by the iterator functions.
+
+To facilitate this, a number of wrapper functions to seq_open() are
+provided:
+
++----------------------+---------------------------------------------------------+
+|      Function        | Use case                                                |
++----------------------+---------------------------------------------------------+
+| seq_open()           | Iterator needs no pre-initialised data                  |
+| seq_open_init()      | Iterator needs a pointer to data but no kmalloc needed  |
+| seq_open_private()   | Iterator needs data but kzalloc() suffices              |
+| __seq_open_private() | Iterator needs data with initialisation after kzalloc() |
++----------------------+---------------------------------------------------------+
+
+seq_open_init() is similiar to seq_open() except that it accepts a third
+parameter of type (void *) which it stores in the private field of the
+seq_file structure, e.g.:
+
+	static int ct_open(struct inode *inode, struct file *file)
+	{
+		return seq_open_init(file, &ct_seq_ops, &mystruct);
+	}
+
+seq_open_private() is similar to seq_open_init() except that the third
+parameter is a size. The function kmallocs a zero filled block of memory
+of the supplied size and stores a pointer to this block in the private
+field of the seq_file structure, returning 0 on success, e.g.:
 
 	static int ct_open(struct inode *inode, struct file *file)
 	{
@@ -237,15 +259,14 @@ block size is specified in a third parameter to the function, e.g.:
 					sizeof(struct mystruct));
 	}
 
-There is also a variant function, __seq_open_private(), which is functionally
-identical except that, if successful, it returns the pointer to the allocated
-memory block, allowing further initialisation e.g.:
+__seq_open_private()is a variant of seq_open_private(), functionally
+identical except that, if successful, it returns the pointer to the
+allocated memory block, allowing further initialisation, e.g.:
 
 	static int ct_open(struct inode *inode, struct file *file)
 	{
-		struct mystruct *p =
-			__seq_open_private(file, &ct_seq_ops, sizeof(*p));
-
+		struct mystruct *p;
+		p = __seq_open_private(file, &ct_seq_ops, sizeof(*p));
 		if (!p)
 			return -ENOMEM;
 
@@ -256,9 +277,6 @@ memory block, allowing further initialisation e.g.:
 		return 0;
 	}
 
-A corresponding close function, seq_release_private() is available which
-frees the memory allocated in the corresponding open.
-
 The other operations of interest - read(), llseek(), and release() - are
 all implemented by the seq_file code itself. So a virtual file's
 file_operations structure will look like:
@@ -271,8 +289,10 @@ file_operations structure will look like:
 	        .release = seq_release
 	};
 
-There is also a seq_release_private() which passes the contents of the
-seq_file private field to kfree() before releasing the structure.
+There is also wrapper function, seq_release_private(), which can be used
+instead of seq_release(). It is identical except that it passes the contents
+of the seq_file private field to kfree() before releasing the seq_file
+structure itself.
 
 The final step is the creation of the /proc file itself. In the example
 code, that is done in the initialization code in the usual way:
-- 
1.7.10.4

