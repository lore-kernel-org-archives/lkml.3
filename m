Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaCMLvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:51:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:46958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbaCMLv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,646,1389772800"; 
   d="scan'208";a="497688311"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Liu ShuoX <shuox.liu@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH] pstore: support current records dump in ramoops
Date: Thu, 13 Mar 2014 19:47:40 +0800
Message-Id: <1394711263-11042-3-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394711263-11042-1-git-send-email-shuox.liu@intel.com>
References: <1394711263-11042-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump the records in runtime is useful sometime. We could check the
records and understand driver's and device's status.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/inode.c          | 32 ++++++++++++++++++++++++++------
 fs/pstore/internal.h       |  3 ++-
 fs/pstore/platform.c       | 39 ++++++++++++++++++++++++++++++---------
 fs/pstore/ram.c            | 18 ++++++++++++++++++
 fs/pstore/ram_core.c       | 10 ++++++++++
 include/linux/pstore.h     |  2 ++
 include/linux/pstore_ram.h |  2 ++
 7 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 6e53e3d..47d7fcf 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -48,10 +48,11 @@ struct pstore_private {
 	struct list_head list;
 	struct pstore_info *psi;
 	enum pstore_type_id type;
+	int	curr;
 	u64	id;
 	int	count;
 	ssize_t	size;
-	char	data[];
+	char	*data;
 };
 
 struct pstore_seq_data {
@@ -220,6 +221,14 @@ static int pstore_file_open(struct inode *inode, struct file *file)
 			sops = zones[ps->id].seq_ops;
 		else
 			sops = &pstore_seq_ops;
+		if (ps->curr) {
+			/*
+			 * Update size again as current buffer
+			 * size might be changed.
+			 */
+			inode->i_size = ps->size =
+				persistent_ram_size(cxt->norm_przs[ps->id]);
+		}
 	}
 
 	err = seq_open(file, sops);
@@ -256,12 +265,16 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct pstore_private *p = dentry->d_inode->i_private;
 
+	if (p->curr)
+		goto unlink;
 	if (p->psi->erase)
 		p->psi->erase(p->type, p->id, p->count,
 			      dentry->d_inode->i_ctime, p->psi);
 	else
 		return -EPERM;
 
+	kfree(p->data);
+unlink:
 	return simple_unlink(dir, dentry);
 }
 
@@ -357,7 +370,7 @@ int pstore_is_mounted(void)
  */
 int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		  char *data, bool compressed, size_t size,
-		  struct timespec time, struct pstore_info *psi)
+		  struct timespec time, struct pstore_info *psi, bool curr)
 {
 	struct dentry		*root = pstore_sb->s_root;
 	struct dentry		*dentry;
@@ -373,14 +386,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	list_for_each_entry(pos, &allpstore, list) {
 		if (pos->type == type &&
 		    pos->id == id &&
-		    pos->psi == psi) {
+		    pos->psi == psi &&
+		    pos->curr == curr) {
 			rc = -EEXIST;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&allpstore_lock, flags);
 	if (rc)
-		return rc;
+		goto fail;
 
 	rc = -ENOMEM;
 	inode = pstore_get_inode(pstore_sb);
@@ -388,13 +402,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		goto fail;
 	inode->i_mode = S_IFREG | 0444;
 	inode->i_fop = &pstore_file_operations;
-	private = kmalloc(sizeof *private + size, GFP_KERNEL);
+	private = kmalloc(sizeof(*private), GFP_KERNEL);
 	if (!private)
 		goto fail_alloc;
 	private->type = type;
 	private->id = id;
 	private->count = count;
 	private->psi = psi;
+	private->curr = curr;
+	private->data = data;
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
@@ -430,13 +446,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		break;
 	}
 
+	if (curr)
+		strcat(name, "_cur");
+
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_alloc_name(root, name);
 	if (!dentry)
 		goto fail_lockedalloc;
 
-	memcpy(private->data, data, size);
 	inode->i_size = private->size = size;
 
 	inode->i_private = private;
@@ -461,6 +479,7 @@ fail_alloc:
 	iput(inode);
 
 fail:
+	kfree(data);
 	return rc;
 }
 
@@ -493,6 +512,7 @@ static int pstore_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	pstore_get_records(0);
+	pstore_get_cur_records();
 
 	return 0;
 }
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 86623ee..ccc0f35 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -50,10 +50,11 @@ extern struct pstore_info *psinfo;
 
 extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(int);
+extern void	pstore_get_cur_records(void);
 extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
 			      int count, char *data, bool compressed,
 			      size_t size, struct timespec time,
-			      struct pstore_info *psi);
+			      struct pstore_info *psi, bool curr);
 extern int	pstore_is_mounted(void);
 
 #endif
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 46d269e..8c63051 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -439,8 +439,10 @@ int pstore_register(struct pstore_info *psi)
 
 	allocate_buf_for_compression();
 
-	if (pstore_is_mounted())
+	if (pstore_is_mounted()) {
 		pstore_get_records(0);
+		pstore_get_cur_records();
+	}
 
 	kmsg_dump_register(&pstore_dumper);
 
@@ -498,7 +500,13 @@ void pstore_get_records(int quiet)
 
 			if (unzipped_len > 0) {
 				kfree(buf);
-				buf = big_oops_buf;
+				buf = kmalloc(unzipped_len, GFP_KERNEL);
+				if (!buf) {
+					if (!quiet)
+						failed++;
+					continue;
+				}
+				memcpy(buf, big_oops_buf, unzipped_len);
 				size = unzipped_len;
 				compressed = false;
 			} else {
@@ -508,15 +516,10 @@ void pstore_get_records(int quiet)
 			}
 		}
 		rc = pstore_mkfile(type, psi->name, id, count, buf,
-				  compressed, (size_t)size, time, psi);
-		if (unzipped_len < 0) {
-			/* Free buffer other than big oops */
-			kfree(buf);
-			buf = NULL;
-		} else
-			unzipped_len = -1;
+				  compressed, (size_t)size, time, psi, false);
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
+		unzipped_len = -1;
 	}
 	if (psi->close)
 		psi->close(psi);
@@ -528,6 +531,24 @@ out:
 		       failed, psi->name);
 }
 
+void pstore_get_cur_records(void)
+{
+	struct pstore_info *psi = psinfo;
+	ssize_t		size;
+	char		*buf = NULL;
+	struct timespec time = {0};
+	u64		id = 0;
+	int		rc;
+
+	if (!psi)
+		return;
+
+	while (size = psi->read_curr(&id, PSTORE_TYPE_NORM, &buf, psi), buf) {
+		rc = pstore_mkfile(PSTORE_TYPE_NORM, psi->name, id - 1, 0, buf,
+				0, (size_t)size, time, psi, true);
+	}
+}
+
 static void pstore_dowork(struct work_struct *work)
 {
 	pstore_get_records(1);
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index b8118b8c5..d20bc31 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -141,6 +141,23 @@ static void ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
 	}
 }
 
+/* only support PSTORE_TYPE_NORM type ram zone */
+static ssize_t ramoops_pstore_read_current(u64 *id, enum pstore_type_id type,
+		char **buf, struct pstore_info *psi)
+{
+	struct ramoops_context *cxt = psi->data;
+	struct persistent_ram_zone *prz;
+
+	if (type != PSTORE_TYPE_NORM || (*id >= cxt->norm_num)) {
+		*buf = NULL;
+		return 0;
+	}
+	prz = cxt->norm_przs[(*id)++];
+	*buf = persistent_ram_buffer(prz);
+
+	return persistent_ram_size(prz);
+}
+
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   int *count, struct timespec *time,
 				   char **buf, bool *compressed,
@@ -306,6 +323,7 @@ static struct ramoops_context oops_cxt = {
 		.name	= "ramoops",
 		.open	= ramoops_pstore_open,
 		.read	= ramoops_pstore_read,
+		.read_curr	= ramoops_pstore_read_current,
 		.write_buf	= ramoops_pstore_write_buf,
 		.erase	= ramoops_pstore_erase,
 	},
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 9c25a0f..72a34b5 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -46,6 +46,11 @@ static inline size_t buffer_start(struct persistent_ram_zone *prz)
 	return atomic_read(&prz->buffer->start);
 }
 
+void *persistent_ram_buffer(struct persistent_ram_zone *prz)
+{
+	return prz->buffer->data;
+}
+
 /* increase and wrap the start pointer, returning the old value */
 static size_t buffer_start_add_atomic(struct persistent_ram_zone *prz, size_t a)
 {
@@ -370,6 +375,11 @@ notrace void *persistent_ram_new_record(struct persistent_ram_zone *prz)
 			buffer_start_add(prz, record_size));
 }
 
+size_t persistent_ram_size(struct persistent_ram_zone *prz)
+{
+	return buffer_size(prz);
+}
+
 size_t persistent_ram_old_size(struct persistent_ram_zone *prz)
 {
 	return prz->old_log_size;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 9936859..31a6ec1 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -59,6 +59,8 @@ struct pstore_info {
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			int *count, struct timespec *time, char **buf,
 			bool *compressed, struct pstore_info *psi);
+	ssize_t		(*read_curr)(u64 *id, enum pstore_type_id type,
+			char **buf, struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, int count, bool compressed,
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index d7d0b7a..6feda77 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -57,6 +57,7 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 			u32 sig, struct persistent_ram_ecc_info *ecc_info);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
+void *persistent_ram_buffer(struct persistent_ram_zone *prz);
 
 int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
 	unsigned int count);
@@ -67,6 +68,7 @@ void *persistent_ram_new_record(struct persistent_ram_zone *prz);
 
 void persistent_ram_save_old(struct persistent_ram_zone *prz);
 size_t persistent_ram_old_size(struct persistent_ram_zone *prz);
+size_t persistent_ram_size(struct persistent_ram_zone *prz);
 void *persistent_ram_old(struct persistent_ram_zone *prz);
 void persistent_ram_free_old(struct persistent_ram_zone *prz);
 ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
-- 
1.8.3.2

