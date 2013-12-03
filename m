Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3LCOxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:53:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab3LCOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:53:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH5/5] security: shmem: implement kernel private shmem inodes
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: keyrings@linux-nfs.org, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org
Date: Tue, 03 Dec 2013 14:53:28 +0000
Message-ID: <20131203145328.30689.3782.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
References: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

We have a problem where the big_key key storage implementation uses a
shmem backed inode to hold the key contents.  Because of this detail of
implementation LSM checks are being done between processes trying to
read the keys and the tmpfs backed inode.  The LSM checks are already
being handled on the key interface level and should not be enforced at
the inode level (since the inode is an implementation detail, not a
part of the security model)

This patch implements a new function shmem_kernel_file_setup() which
returns the equivalent to shmem_file_setup() only the underlying inode
has S_PRIVATE set.  This means that all LSM checks for the inode in
question are skipped.  It should only be used for kernel internal
operations where the inode is not exposed to userspace without proper
LSM checking.  It is possible that some other users of
shmem_file_setup() should use the new interface, but this has not been
explored.

Reproducing this bug is a little bit difficult.  The steps I used on
Fedora are:

 (1) Turn off selinux enforcing:

	setenforce 0

 (2) Create a huge key

	k=`dd if=/dev/zero bs=8192 count=1 | keyctl padd big_key test-key @s`

 (3) Access the key in another context:

	runcon system_u:system_r:httpd_t:s0-s0:c0.c1023 keyctl print $k >/dev/null

 (4) Examine the audit logs:

	ausearch -m AVC -i --subject httpd_t | audit2allow

If the last command's output includes a line that looks like:

	allow httpd_t user_tmpfs_t:file { open read };

There was an inode check between httpd and the tmpfs filesystem.  With
this patch no such denial will be seen.  (NOTE! you should clear your
audit log if you have tested for this previously)

(Please return you box to enforcing)

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hugh Dickins <hughd@google.com>
cc: linux-mm@kvack.org
---

 include/linux/shmem_fs.h |    2 ++
 mm/shmem.c               |   36 +++++++++++++++++++++++++++++-------
 security/keys/big_key.c  |    2 +-
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 30aa0dc60d75..9d55438bc4ad 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -47,6 +47,8 @@ extern int shmem_init(void);
 extern int shmem_fill_super(struct super_block *sb, void *data, int silent);
 extern struct file *shmem_file_setup(const char *name,
 					loff_t size, unsigned long flags);
+extern struct file *shmem_kernel_file_setup(const char *name, loff_t size,
+					    unsigned long flags);
 extern int shmem_zero_setup(struct vm_area_struct *);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 extern void shmem_unlock_mapping(struct address_space *mapping);
diff --git a/mm/shmem.c b/mm/shmem.c
index 8297623fcaed..902a14842b74 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2918,13 +2918,8 @@ static struct dentry_operations anon_ops = {
 	.d_dname = simple_dname
 };
 
-/**
- * shmem_file_setup - get an unlinked file living in tmpfs
- * @name: name for dentry (to be seen in /proc/<pid>/maps
- * @size: size to be set for the file
- * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
- */
-struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
+static struct file *__shmem_file_setup(const char *name, loff_t size,
+				       unsigned long flags, unsigned int i_flags)
 {
 	struct file *res;
 	struct inode *inode;
@@ -2957,6 +2952,7 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
 	if (!inode)
 		goto put_dentry;
 
+	inode->i_flags |= i_flags;
 	d_instantiate(path.dentry, inode);
 	inode->i_size = size;
 	clear_nlink(inode);	/* It is unlinked */
@@ -2977,6 +2973,32 @@ put_memory:
 	shmem_unacct_size(flags, size);
 	return res;
 }
+
+/**
+ * shmem_kernel_file_setup - get an unlinked file living in tmpfs which must be
+ * 	kernel internal.  There will be NO LSM permission checks against the
+ * 	underlying inode.  So users of this interface must do LSM checks at a
+ * 	higher layer.  The one user is the big_key implementation.  LSM checks
+ * 	are provided at the key level rather than the inode level.
+ * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @size: size to be set for the file
+ * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
+ */
+struct file *shmem_kernel_file_setup(const char *name, loff_t size, unsigned long flags)
+{
+	return __shmem_file_setup(name, size, flags, S_PRIVATE);
+}
+
+/**
+ * shmem_file_setup - get an unlinked file living in tmpfs
+ * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @size: size to be set for the file
+ * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
+ */
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
+{
+	return __shmem_file_setup(name, size, flags, 0);
+}
 EXPORT_SYMBOL_GPL(shmem_file_setup);
 
 /**
diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 7f44c3207a9b..8137b27d641d 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -70,7 +70,7 @@ int big_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 		 *
 		 * TODO: Encrypt the stored data with a temporary key.
 		 */
-		file = shmem_file_setup("", datalen, 0);
+		file = shmem_kernel_file_setup("", datalen, 0);
 		if (IS_ERR(file)) {
 			ret = PTR_ERR(file);
 			goto err_quota;

