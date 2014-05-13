Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbaEMQAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:00:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31058 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaEMP7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:59:20 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-c4-53724154e700
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org,
        eparis@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hooanon05g@gmail.com, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/2] ima: re-introduce own integrity cache lock
Date: Tue, 13 May 2014 18:59:39 +0300
Message-id: <ea7c88c8831864280edc9c1892f8d5967571f815.1399996667.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1399996667.git.d.kasatkin@samsung.com>
References: <cover.1399996667.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1399996667.git.d.kasatkin@samsung.com>
References: <cover.1399996667.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xy7ohjkXBBte32Vjc+ruX2eLL0jqL
	idvbWCzO97WyWaxbv5jJ4uWMeewWl3fNYbP40POIzeL83+OsFp9WTGJ24PLYOesuu8eDQ5tZ
	PHYv+Mzk0fM92eP9vqtsHn1bVjF6fN4k57HpyVumAI4oLpuU1JzMstQifbsEroyzT/YwFmxx
	rOjo6GZpYFxm1sXIySEhYCJx5uJjFghbTOLCvfVsXYxcHEICSxklriw9zAzhdDJJHPn7CayK
	TUBPYkPzD3aQhIjALEaJzm39TCAOs8AERokH2xuZQKqEBewlrrb+Zuxi5OBgEVCV6F6iDxLm
	FYiT2LH+FhvEOjmJk8cms4LYnAJWEhufPAFrFRKwlNi79CsjLvEJjPwLGBlWMYqmliYXFCel
	5xrqFSfmFpfmpesl5+duYoQE8JcdjIuPWR1iFOBgVOLhDeAqCBZiTSwrrsw9xCjBwawkwvtZ
	ryhYiDclsbIqtSg/vqg0J7X4ECMTB6dUA6OazgRrrkeFV+Z2XmeKOZXcbrT0zUqzi9b3U1dN
	PXyqJuWwxzKH353XZj6Uq9Lk7/lyJ7VUkMsnS2fWqSud2p1H14pcWPB2vv2uxOtyHepxzY+W
	BR8oerx38/9fBntSOf6tS8tLPNZ+PTa/Tn3z3QvCWX3ml30/fJugpmqRtFyX1zr89nx1tm9K
	LMUZiYZazEXFiQD9Xl/rPgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before IMA appraisal was introduced, IMA was using own integrity cache
lock along with i_mutex. process_measurement and ima_file_free took
the iint->mutex first and then the i_mutex, while setxattr, chmod and
chown took the locks in reverse order. To resolve the potential deadlock,
i_mutex was moved to protect entire IMA functionality and the redundant
iint->mutex was eliminated.

Solution was based on the assumption that filesystem code does not take
i_mutex further. But when file is opened with O_DIRECT flag, direct-io
implementation takes i_mutex and produces deadlock. Furthermore, certain
other filesystem operations, such as llseek, also take i_mutex.

To resolve O_DIRECT related deadlock problem, this patch re-introduces
iint->mutex. But to eliminate the original chmod() related deadlock
problem, this patch eliminates the requirement for chmod hooks to take
the iint->mutex by introducing additional atomic iint->attr_flags to
indicate calling of the hooks. The allowed locking order is to take
the iint->mutex first and then the i_mutex.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/iint.c             | 10 ++++++++--
 security/integrity/ima/ima_appraise.c | 22 ++++++++--------------
 security/integrity/ima/ima_main.c     | 27 ++++++++++++++++-----------
 security/integrity/integrity.h        |  5 +++++
 4 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index a521edf..4c202b7 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -95,13 +95,15 @@ struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 	struct rb_node *node, *parent = NULL;
 	struct integrity_iint_cache *iint, *test_iint;
 
+	mutex_lock(&inode->i_mutex);
+
 	iint = integrity_iint_find(inode);
 	if (iint)
-		return iint;
+		goto out;
 
 	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
 	if (!iint)
-		return NULL;
+		goto out;
 
 	write_lock(&integrity_iint_lock);
 
@@ -123,6 +125,8 @@ struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 	rb_insert_color(node, &integrity_iint_tree);
 
 	write_unlock(&integrity_iint_lock);
+out:
+	mutex_unlock(&inode->i_mutex);
 	return iint;
 }
 
@@ -154,11 +158,13 @@ static void init_once(void *foo)
 	memset(iint, 0, sizeof(*iint));
 	iint->version = 0;
 	iint->flags = 0UL;
+	iint->attr_flags = 0;
 	iint->ima_file_status = INTEGRITY_UNKNOWN;
 	iint->ima_mmap_status = INTEGRITY_UNKNOWN;
 	iint->ima_bprm_status = INTEGRITY_UNKNOWN;
 	iint->ima_module_status = INTEGRITY_UNKNOWN;
 	iint->evm_status = INTEGRITY_UNKNOWN;
+	mutex_init(&iint->mutex);
 }
 
 static int __init integrity_iintcache_init(void)
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index d3113d4..0f8579e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -57,10 +57,12 @@ static int ima_fix_xattr(struct dentry *dentry,
 		iint->ima_hash->xattr.ng.type = IMA_XATTR_DIGEST_NG;
 		iint->ima_hash->xattr.ng.algo = algo;
 	}
+	mutex_lock(&dentry->d_inode->i_mutex);
 	rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
 				   &iint->ima_hash->xattr.data[offset],
 				   (sizeof(iint->ima_hash->xattr) - offset) +
 				   iint->ima_hash->length, 0);
+	mutex_unlock(&dentry->d_inode->i_mutex);
 	return rc;
 }
 
@@ -199,7 +201,9 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 		goto out;
 	}
 
+	mutex_lock(&inode->i_mutex);
 	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
+	mutex_unlock(&inode->i_mutex);
 	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
 		if ((status == INTEGRITY_NOLABEL)
 		    || (status == INTEGRITY_NOXATTRS))
@@ -313,13 +317,8 @@ void ima_inode_post_setattr(struct dentry *dentry)
 
 	must_appraise = ima_must_appraise(inode, MAY_ACCESS, POST_SETATTR);
 	iint = integrity_iint_find(inode);
-	if (iint) {
-		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
-				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK |
-				 IMA_ACTION_FLAGS);
-		if (must_appraise)
-			iint->flags |= IMA_APPRAISE;
-	}
+	if (iint)
+		set_bit(IMA_CHANGE_ATTR, &iint->attr_flags);
 	if (!must_appraise)
 		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
 	return;
@@ -349,13 +348,8 @@ static void ima_reset_appraise_flags(struct inode *inode, int digsig)
 		return;
 
 	iint = integrity_iint_find(inode);
-	if (!iint)
-		return;
-
-	iint->flags &= ~IMA_DONE_MASK;
-	if (digsig)
-		iint->flags |= IMA_DIGSIG;
-	return;
+	if (iint)
+		set_bit(IMA_CHANGE_XATTR, &iint->attr_flags);
 }
 
 int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index bd7b4cb..1e63c91 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -88,8 +88,6 @@ static void ima_rdwr_violation_check(struct file *file)
 	if (!S_ISREG(inode->i_mode) || !ima_initialized)
 		return;
 
-	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
-
 	if (mode & FMODE_WRITE) {
 		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
 			struct integrity_iint_cache *iint;
@@ -104,8 +102,6 @@ static void ima_rdwr_violation_check(struct file *file)
 			send_writers = true;
 	}
 
-	mutex_unlock(&inode->i_mutex);
-
 	if (!send_tomtou && !send_writers)
 		return;
 
@@ -127,14 +123,14 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
 	if (!(mode & FMODE_WRITE))
 		return;
 
-	mutex_lock(&inode->i_mutex);
+	mutex_lock(&iint->mutex);
 	if (atomic_read(&inode->i_writecount) == 1 &&
 	    iint->version != inode->i_version) {
 		iint->flags &= ~IMA_DONE_MASK;
 		if (iint->flags & IMA_APPRAISE)
 			ima_update_xattr(iint, file);
 	}
-	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&iint->mutex);
 }
 
 /**
@@ -186,11 +182,20 @@ static int process_measurement(struct file *file, const char *filename,
 	/*  Is the appraise rule hook specific?  */
 	_func = (action & IMA_FILE_APPRAISE) ? FILE_CHECK : function;
 
-	mutex_lock(&inode->i_mutex);
-
 	iint = integrity_inode_get(inode);
 	if (!iint)
-		goto out;
+		goto out_unlocked;
+
+	mutex_lock(&iint->mutex);
+
+	if (test_and_clear_bit(IMA_CHANGE_ATTR, &iint->attr_flags))
+		/* reset appraisal flags if ima_inode_post_setattr was called */
+		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
+				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK);
+
+	if (test_and_clear_bit(IMA_CHANGE_XATTR, &iint->attr_flags))
+		/* reset all flags if ima_inode_setxattr was called */
+		iint->flags &= ~IMA_DONE_MASK;
 
 	/* Determine if already appraised/measured based on bitmask
 	 * (IMA_MEASURE, IMA_MEASURED, IMA_XXXX_APPRAISE, IMA_XXXX_APPRAISED,
@@ -234,9 +239,9 @@ static int process_measurement(struct file *file, const char *filename,
 out_digsig:
 	if ((mask & MAY_WRITE) && (iint->flags & IMA_DIGSIG))
 		rc = -EACCES;
-out:
-	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&iint->mutex);
 	kfree(xattr_value);
+out_unlocked:
 	if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
 		return -EACCES;
 	return 0;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 2fb5e53..f73cd06 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -50,6 +50,9 @@
 #define IMA_APPRAISED_SUBMASK	(IMA_FILE_APPRAISED | IMA_MMAP_APPRAISED | \
 				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED)
 
+#define IMA_CHANGE_XATTR	0
+#define IMA_CHANGE_ATTR		1
+
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
 	EVM_XATTR_HMAC,
@@ -96,9 +99,11 @@ struct signature_v2_hdr {
 /* integrity data associated with an inode */
 struct integrity_iint_cache {
 	struct rb_node rb_node;	/* rooted in integrity_iint_tree */
+	struct mutex mutex;	/* protects: version, flags, digest */
 	struct inode *inode;	/* back pointer to inode in question */
 	u64 version;		/* track inode changes */
 	unsigned long flags;
+	unsigned long attr_flags;
 	enum integrity_status ima_file_status:4;
 	enum integrity_status ima_mmap_status:4;
 	enum integrity_status ima_bprm_status:4;
-- 
1.9.1

