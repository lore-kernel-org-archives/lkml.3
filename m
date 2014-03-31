Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaCaGcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 02:32:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:22032 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaCaGcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 02:32:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,763,1389772800"; 
   d="scan'208";a="483776022"
Date: Mon, 31 Mar 2014 14:32:00 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-next@vger.kernel.org,
        Zhang Yanmin <yanmin.zhang@intel.com>, fengguang.wu@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v2 3/3] pstore: support current records dump in ramoops
Message-ID: <20140331063200.GC2395@lskakaxi-intel>
References: <20140331110756.c4f9b2e9f9f4874e0d90da11@canb.auug.org.au>
 <20140331062708.GA2395@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140331062708.GA2395@lskakaxi-intel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

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
  include/linux/pstore_ram.h | 15 +++++++++++++++
  7 files changed, 103 insertions(+), 16 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index a9c9782..64adfb8 100644
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
  
@@ -358,7 +371,7 @@ int pstore_is_mounted(void)
   */
  int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
  		  char *data, bool compressed, size_t size,
-		  struct timespec time, struct pstore_info *psi)
+		  struct timespec time, struct pstore_info *psi, bool curr)
  {
  	struct dentry		*root = pstore_sb->s_root;
  	struct dentry		*dentry;
@@ -374,14 +387,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
@@ -389,13 +403,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
@@ -434,13 +450,15 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
@@ -465,6 +483,7 @@ fail_alloc:
  	iput(inode);
  
  fail:
+	kfree(data);
  	return rc;
  }
  
@@ -497,6 +516,7 @@ static int pstore_fill_super(struct super_block *sb, void *data, int silent)
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
index 46d269e..6a3cbbb 100644
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
index e1f2adc..67c9ced 100644
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
@@ -309,6 +326,7 @@ static struct ramoops_context oops_cxt = {
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
index d7d0b7a..9134bda 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -72,4 +72,19 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz);
  ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
  	char *str, size_t len);
  
+#ifdef CONFIG_PSTORE_RAM
+void *persistent_ram_buffer(struct persistent_ram_zone *prz);
+size_t persistent_ram_size(struct persistent_ram_zone *prz);
+#else
+static inline void *persistent_ram_buffer(struct persistent_ram_zone *prz)
+{
+	return NULL;
+}
+
+static inline size_t persistent_ram_size(struct persistent_ram_zone *prz)
+{
+	return 0;
+}
+#endif
+
  #endif
-- 
1.8.3.2

