Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3B1Aar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:30:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34948 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3B1Aaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:30:46 -0500
Date: Wed, 27 Feb 2013 16:30:42 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH] eCryptfs: allow userspace messaging to be disabled
Message-ID: <20130228003042.GA8472@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the userspace messaging (for the less common case of userspace key
wrap/unwrap via ecryptfsd) is not needed, allow eCryptfs to build with
it removed. This saves on kernel code size and reduces potential attack
surface by removing the /dev/ecryptfs node.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Tyler Hicks <tyhicks@canonical.com>
---
 fs/ecryptfs/Kconfig           |    8 ++++++++
 fs/ecryptfs/Makefile          |    7 +++++--
 fs/ecryptfs/ecryptfs_kernel.h |   27 +++++++++++++++++++++++++--
 fs/ecryptfs/keystore.c        |    4 ++--
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index e15ef38..434aa31 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -12,3 +12,11 @@ config ECRYPT_FS
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ecryptfs.
+
+config ECRYPT_FS_MESSAGING
+	bool "Enable notifications for userspace key wrap/unwrap"
+	depends on ECRYPT_FS
+	help
+	  Enables the /dev/ecryptfs entry for use by ecryptfsd. This allows
+	  for userspace to wrap/unwrap file encryption keys by other
+	  backends, like OpenSSL.
diff --git a/fs/ecryptfs/Makefile b/fs/ecryptfs/Makefile
index 2cc9ee4..49678a6 100644
--- a/fs/ecryptfs/Makefile
+++ b/fs/ecryptfs/Makefile
@@ -1,7 +1,10 @@
 #
-# Makefile for the Linux 2.6 eCryptfs
+# Makefile for the Linux eCryptfs
 #
 
 obj-$(CONFIG_ECRYPT_FS) += ecryptfs.o
 
-ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o miscdev.o kthread.o debug.o
+ecryptfs-y := dentry.o file.o inode.o main.o super.o mmap.o read_write.o \
+	      crypto.o keystore.o kthread.o debug.o
+
+ecryptfs-$(CONFIG_ECRYPT_FS_MESSAGING) += messaging.o miscdev.o
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index cfb4b9f..b33722c 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -399,7 +399,9 @@ struct ecryptfs_daemon {
 	struct hlist_node euid_chain;
 };
 
+#ifdef CONFIG_ECRYPT_FS_MESSAGING
 extern struct mutex ecryptfs_daemon_hash_mux;
+#endif
 
 static inline size_t
 ecryptfs_lower_header_size(struct ecryptfs_crypt_stat *crypt_stat)
@@ -604,6 +606,7 @@ int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
 int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
+#ifdef CONFIG_ECRYPT_FS_MESSAGING
 int ecryptfs_process_response(struct ecryptfs_daemon *daemon,
 			      struct ecryptfs_message *msg, u32 seq);
 int ecryptfs_send_message(char *data, int data_len,
@@ -612,6 +615,24 @@ int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
 			       struct ecryptfs_message **emsg);
 int ecryptfs_init_messaging(void);
 void ecryptfs_release_messaging(void);
+#else
+static inline int ecryptfs_init_messaging(void)
+{
+	return 0;
+}
+static inline void ecryptfs_release_messaging(void)
+{ }
+static inline int ecryptfs_send_message(char *data, int data_len,
+					struct ecryptfs_msg_ctx **msg_ctx)
+{
+	return -ENOTCONN;
+}
+static inline int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
+					     struct ecryptfs_message **emsg)
+{
+	return -ENOMSG;
+}
+#endif
 
 void
 ecryptfs_write_header_metadata(char *virt,
@@ -649,12 +670,11 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 				     size_t offset_in_page, size_t size,
 				     struct inode *ecryptfs_inode);
 struct page *ecryptfs_get_locked_page(struct inode *inode, loff_t index);
-int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon);
-int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon);
 int ecryptfs_parse_packet_length(unsigned char *data, size_t *size,
 				 size_t *length_size);
 int ecryptfs_write_packet_length(char *dest, size_t size,
 				 size_t *packet_size_length);
+#ifdef CONFIG_ECRYPT_FS_MESSAGING
 int ecryptfs_init_ecryptfs_miscdev(void);
 void ecryptfs_destroy_ecryptfs_miscdev(void);
 int ecryptfs_send_miscdev(char *data, size_t data_size,
@@ -663,6 +683,9 @@ int ecryptfs_send_miscdev(char *data, size_t data_size,
 void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
 int
 ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, struct file *file);
+int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon);
+int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon);
+#endif
 int ecryptfs_init_kthread(void);
 void ecryptfs_destroy_kthread(void);
 int ecryptfs_privileged_open(struct file **lower_file,
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 2333203..32bd806 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1168,7 +1168,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	rc = ecryptfs_send_message(payload, payload_len, &msg_ctx);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error sending message to "
-				"ecryptfsd\n");
+				"ecryptfsd: %d\n", rc);
 		goto out;
 	}
 	rc = ecryptfs_wait_for_response(msg_ctx, &msg);
@@ -1989,7 +1989,7 @@ pki_encrypt_session_key(struct key *auth_tok_key,
 	rc = ecryptfs_send_message(payload, payload_len, &msg_ctx);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error sending message to "
-				"ecryptfsd\n");
+				"ecryptfsd: %d\n", rc);
 		goto out;
 	}
 	rc = ecryptfs_wait_for_response(msg_ctx, &msg);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
