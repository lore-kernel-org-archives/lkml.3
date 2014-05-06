Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbaEFFFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:05:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:51251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbaEFFFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,994,1389772800"; 
   d="scan'208";a="428051668"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Liu ShuoX <shuox.liu@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 3/3] pstore: support current records dump in ramoops
Date: Tue,  6 May 2014 13:03:46 +0800
Message-Id: <1399352628-13308-4-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
References: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump the records in runtime is useful sometime. We could check the
records and understand driver's and device's status.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/inode.c          | 39 +++++++++++++++++++++++++++++++--------
 fs/pstore/internal.h       |  3 ++-
 fs/pstore/platform.c       | 39 ++++++++++++++++++++++++++++++---------
 fs/pstore/ram.c            | 18 ++++++++++++++++++
 fs/pstore/ram_core.c       | 10 ++++++++++
 include/linux/pstore.h     |  2 ++
 include/linux/pstore_ram.h |  2 ++
 7 files changed, 95 insertions(+), 18 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index a9c9782..a3b817c15df 100644
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
@@ -210,16 +211,27 @@ static int pstore_file_open(struct inode *inode, struct file *file)
 	struct ramoops_context *cxt = ps->psi->data;
 	struct ramoops_zone    *zones = cxt ? cxt->zones : NULL;
 	struct seq_file *sf;
+	char *buf = NULL;
 	int err;
+	u64 id = ps->id;
 	const struct seq_operations *sops = NULL;
 
 	if (ps->type == PSTORE_TYPE_FTRACE)
 		sops = &pstore_ftrace_seq_ops;
 	if (ps->type == PSTORE_TYPE_NORM && zones) {
-		if (zones[ps->id].seq_ops)
-			sops = zones[ps->id].seq_ops;
+		if (zones[id].seq_ops)
+			sops = zones[id].seq_ops;
 		else
 			sops = &pstore_seq_ops;
+		if (ps->curr) {
+			/*
+			 * Update size again as current buffer
+			 * size might be changed.
+			 */
+			inode->i_size = ps->size =
+				ps->psi->read_curr(&id, PSTORE_TYPE_NORM,
+						&buf, ps->psi);
+		}
 	}
 
 	err = seq_open(file, sops);
@@ -256,12 +268,16 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
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
 
@@ -358,7 +374,7 @@ int pstore_is_mounted(void)
  */
 int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		  char *data, bool compressed, size_t size,
-		  struct timespec time, struct pstore_info *psi)
+		  struct timespec time, struct pstore_info *psi, bool curr)
 {
 	struct dentry		*root = pstore_sb->s_root;
 	struct dentry		*dentry;
@@ -374,14 +390,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
@@ -389,13 +406,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
@@ -434,13 +453,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
@@ -465,6 +486,7 @@ fail_alloc:
 	iput(inode);
 
 fail:
+	kfree(data);
 	return rc;
 }
 
@@ -497,6 +519,7 @@ static int pstore_fill_super(struct super_block *sb, void *data, int silent)
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
index f208c2b..1f4ec47 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -477,8 +477,10 @@ int pstore_register(struct pstore_info *psi)
 
 	allocate_buf_for_compression();
 
-	if (pstore_is_mounted())
+	if (pstore_is_mounted()) {
 		pstore_get_records(0);
+		pstore_get_cur_records();
+	}
 
 	kmsg_dump_register(&pstore_dumper);
 
@@ -536,7 +538,13 @@ void pstore_get_records(int quiet)
 
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
@@ -546,15 +554,10 @@ void pstore_get_records(int quiet)
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
@@ -566,6 +569,24 @@ out:
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
+	if (!psi || !psi->read_curr)
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
index eb10ce5..8fadca3 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -180,6 +180,23 @@ void pstore_dump_records(struct ramoops_zone *zone)
 }
 EXPORT_SYMBOL_GPL(pstore_dump_records);
 
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
@@ -350,6 +367,7 @@ static struct ramoops_context oops_cxt = {
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
index d7d0b7a..9e383eb 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -71,5 +71,7 @@ void *persistent_ram_old(struct persistent_ram_zone *prz);
 void persistent_ram_free_old(struct persistent_ram_zone *prz);
 ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 	char *str, size_t len);
+void *persistent_ram_buffer(struct persistent_ram_zone *prz);
+size_t persistent_ram_size(struct persistent_ram_zone *prz);
 
 #endif
-- 
1.8.3.2

