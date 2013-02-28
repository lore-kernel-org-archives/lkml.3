Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3B1Ijq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:39:46 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37366 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab3B1Ijn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:39:43 -0500
Date: Thu, 28 Feb 2013 00:39:37 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        Kees Cook <keescook@chromium.org>, ecryptfs@vger.kernel.org
Subject: [PATCH v2] eCryptfs: allow userspace messaging to be disabled
Message-ID: <20130228083937.GA27475@www.outflux.net>
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

v2:
 - update version mask to reflect messaging feature presence.

---
 fs/ecryptfs/Kconfig           |    8 ++++++++
 fs/ecryptfs/Makefile          |    7 +++++--
 fs/ecryptfs/ecryptfs_kernel.h |   40 ++++++++++++++++++++++++++++++++++++++--
 fs/ecryptfs/keystore.c        |    4 ++--
 include/linux/ecryptfs.h      |   12 ++----------
 5 files changed, 55 insertions(+), 16 deletions(-)

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
index cfb4b9f..a9df69e 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -172,6 +172,19 @@ ecryptfs_get_key_payload_data(struct key *key)
 #define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE 24
 #define ECRYPTFS_ENCRYPTED_DENTRY_NAME_LEN (18 + 1 + 4 + 1 + 32)
 
+#ifdef CONFIG_ECRYPT_FS_MESSAGING
+# define ECRYPTFS_VERSIONING_MASK_MESSAGING (ECRYPTFS_VERSIONING_DEVMISC \
+					     | ECRYPTFS_VERSIONING_PUBKEY)
+#else
+# define ECRYPTFS_VERSIONING_MASK_MESSAGING 0
+#endif
+
+#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
+				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
+				  | ECRYPTFS_VERSIONING_XATTR \
+				  | ECRYPTFS_VERSIONING_MULTKEY \
+				  | ECRYPTFS_VERSIONING_MASK_MESSAGING \
+				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
 struct ecryptfs_key_sig {
 	struct list_head crypt_stat_list;
 	char keysig[ECRYPTFS_SIG_SIZE_HEX + 1];
@@ -399,7 +412,9 @@ struct ecryptfs_daemon {
 	struct hlist_node euid_chain;
 };
 
+#ifdef CONFIG_ECRYPT_FS_MESSAGING
 extern struct mutex ecryptfs_daemon_hash_mux;
+#endif
 
 static inline size_t
 ecryptfs_lower_header_size(struct ecryptfs_crypt_stat *crypt_stat)
@@ -604,6 +619,7 @@ int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
 int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
+#ifdef CONFIG_ECRYPT_FS_MESSAGING
 int ecryptfs_process_response(struct ecryptfs_daemon *daemon,
 			      struct ecryptfs_message *msg, u32 seq);
 int ecryptfs_send_message(char *data, int data_len,
@@ -612,6 +628,24 @@ int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
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
@@ -649,12 +683,11 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
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
@@ -663,6 +696,9 @@ int ecryptfs_send_miscdev(char *data, size_t data_size,
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
diff --git a/include/linux/ecryptfs.h b/include/linux/ecryptfs.h
index 2224a8c..8d5ab99 100644
--- a/include/linux/ecryptfs.h
+++ b/include/linux/ecryptfs.h
@@ -6,9 +6,8 @@
 #define ECRYPTFS_VERSION_MINOR 0x04
 #define ECRYPTFS_SUPPORTED_FILE_VERSION 0x03
 /* These flags indicate which features are supported by the kernel
- * module; userspace tools such as the mount helper read
- * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
- * how to behave. */
+ * module; userspace tools such as the mount helper read the feature
+ * bits from a sysfs handle in order to determine how to behave. */
 #define ECRYPTFS_VERSIONING_PASSPHRASE            0x00000001
 #define ECRYPTFS_VERSIONING_PUBKEY                0x00000002
 #define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
@@ -19,13 +18,6 @@
 #define ECRYPTFS_VERSIONING_HMAC                  0x00000080
 #define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
 #define ECRYPTFS_VERSIONING_GCM                   0x00000200
-#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
-				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
-				  | ECRYPTFS_VERSIONING_PUBKEY \
-				  | ECRYPTFS_VERSIONING_XATTR \
-				  | ECRYPTFS_VERSIONING_MULTKEY \
-				  | ECRYPTFS_VERSIONING_DEVMISC \
-				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
 #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
 #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
 #define ECRYPTFS_SALT_SIZE 8
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
