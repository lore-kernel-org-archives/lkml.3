Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaEMQtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:49:22 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:28575 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbaEMQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:49:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVALNKclNbtADP/2dsb2JhbABZgwasdwQBAQEBAQEFAZoZAgKBIhd0glMTHCMYgQIkE4hFAccvhVSIeoRHAQOPKYomAYsLiAWDODuBMyQ
Date: Tue, 13 May 2014 18:49:09 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/3] FS/CODA: replace printk by pr_foo()
Message-Id: <20140513184909.e5ccec32a70c2722c43c1d1e@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No level printk converted to pr_warn or pr_info

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/coda/cnode.c      |  4 ++--
 fs/coda/coda_linux.h |  2 +-
 fs/coda/dir.c        | 12 ++++++------
 fs/coda/inode.c      | 29 +++++++++++++++--------------
 fs/coda/psdev.c      | 34 +++++++++++++++++-----------------
 fs/coda/upcall.c     | 14 +++++++-------
 6 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/fs/coda/cnode.c b/fs/coda/cnode.c
index 911cf30..4bb74b3 100644
--- a/fs/coda/cnode.c
+++ b/fs/coda/cnode.c
@@ -101,7 +101,7 @@ struct inode *coda_cnode_make(struct CodaFid *fid, struct super_block *sb)
 
 	inode = coda_iget(sb, fid, &attr);
 	if (IS_ERR(inode))
-		printk("coda_cnode_make: coda_iget failed\n");
+		pr_warn("coda_cnode_make: coda_iget failed\n");
 	return inode;
 }
 
@@ -137,7 +137,7 @@ struct inode *coda_fid_to_inode(struct CodaFid *fid, struct super_block *sb)
 	unsigned long hash = coda_f2i(fid);
 
 	if ( !sb ) {
-		printk("coda_fid_to_inode: no sb!\n");
+		pr_warn("coda_fid_to_inode: no sb!\n");
 		return NULL;
 	}
 
diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
index e7550cb..a3bf7a8 100644
--- a/fs/coda/coda_linux.h
+++ b/fs/coda/coda_linux.h
@@ -63,7 +63,7 @@ void coda_sysctl_clean(void);
     else \
         ptr = (cast)vzalloc((unsigned long) size); \
     if (!ptr) \
-        printk("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
+	pr_warn("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
 } while (0)
 
 
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 5efbb5e..bdd34df 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -102,7 +102,7 @@ static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, unsig
 	int type = 0;
 
 	if (length > CODA_MAXNAMLEN) {
-		printk(KERN_ERR "name too long: lookup, %s (%*s)\n",
+		pr_err("name too long: lookup, %s (%*s)\n",
 		       coda_i2s(dir), (int)length, name);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
@@ -453,7 +453,7 @@ static int coda_venus_readdir(struct file *coda_file, struct dir_context *ctx)
 		ret = kernel_read(host_file, ctx->pos - 2, (char *)vdir,
 				  sizeof(*vdir));
 		if (ret < 0) {
-			printk(KERN_ERR "coda readdir: read dir %s failed %d\n",
+			pr_err("coda readdir: read dir %s failed %d\n",
 			       coda_f2s(&cii->c_fid), ret);
 			break;
 		}
@@ -461,14 +461,14 @@ static int coda_venus_readdir(struct file *coda_file, struct dir_context *ctx)
 
 		/* catch truncated reads */
 		if (ret < vdir_size || ret < vdir_size + vdir->d_namlen) {
-			printk(KERN_ERR "coda readdir: short read on %s\n",
+			pr_err("coda readdir: short read on %s\n",
 			       coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
 		}
 		/* validate whether the directory file actually makes sense */
 		if (vdir->d_reclen < vdir_size + vdir->d_namlen) {
-			printk(KERN_ERR "coda readdir: invalid dir %s\n",
+			pr_err("coda readdir: invalid dir %s\n",
 			       coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
@@ -589,8 +589,8 @@ int coda_revalidate_inode(struct inode *inode)
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			printk("Coda: inode %ld, fid %s changed type!\n",
-			       inode->i_ino, coda_f2s(&(cii->c_fid)));
+			pr_warn("Coda: inode %ld, fid %s changed type!\n",
+				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
 		/* the following can happen when a local fid is replaced 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index d9c7751..b87d49f 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -119,12 +119,12 @@ static int get_device_index(struct coda_mount_data *data)
 	int idx;
 
 	if (data == NULL) {
-		printk("coda_read_super: Bad mount data\n");
+		pr_warn("coda_read_super: Bad mount data\n");
 		return -1;
 	}
 
 	if (data->version != CODA_MOUNT_VERSION) {
-		printk("coda_read_super: Bad mount version\n");
+		pr_warn("coda_read_super: Bad mount version\n");
 		return -1;
 	}
 
@@ -141,13 +141,13 @@ static int get_device_index(struct coda_mount_data *data)
 	fdput(f);
 
 	if (idx < 0 || idx >= MAX_CODADEVS) {
-		printk("coda_read_super: Bad minor number\n");
+		pr_warn("coda_read_super: Bad minor number\n");
 		return -1;
 	}
 
 	return idx;
 Ebadf:
-	printk("coda_read_super: Bad file\n");
+	pr_warn("coda_read_super: Bad file\n");
 	return -1;
 }
 
@@ -168,19 +168,19 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	if(idx == -1)
 		idx = 0;
 	
-	printk(KERN_INFO "coda_read_super: device index: %i\n", idx);
+	pr_info("coda_read_super: device index: %i\n", idx);
 
 	vc = &coda_comms[idx];
 	mutex_lock(&vc->vc_mutex);
 
 	if (!vc->vc_inuse) {
-		printk("coda_read_super: No pseudo device\n");
+		pr_warn("coda_read_super: No pseudo device\n");
 		error = -EINVAL;
 		goto unlock_out;
 	}
 
 	if (vc->vc_sb) {
-		printk("coda_read_super: Device already mounted\n");
+		pr_warn("coda_read_super: Device already mounted\n");
 		error = -EBUSY;
 		goto unlock_out;
 	}
@@ -204,22 +204,23 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	/* get root fid from Venus: this needs the root inode */
 	error = venus_rootfid(sb, &fid);
 	if ( error ) {
-	        printk("coda_read_super: coda_get_rootfid failed with %d\n",
-		       error);
+		pr_warn("coda_read_super: coda_get_rootfid failed with %d\n",
+			error);
 		goto error;
 	}
-	printk("coda_read_super: rootfid is %s\n", coda_f2s(&fid));
+	pr_info("coda_read_super: rootfid is %s\n", coda_f2s(&fid));
 	
 	/* make root inode */
         root = coda_cnode_make(&fid, sb);
         if (IS_ERR(root)) {
 		error = PTR_ERR(root);
-		printk("Failure of coda_cnode_make for root: error %d\n", error);
+		pr_warn("Failure of coda_cnode_make for root: error %d\n",
+			error);
 		goto error;
 	} 
 
-	printk("coda_read_super: rootinode is %ld dev %s\n", 
-	       root->i_ino, root->i_sb->s_id);
+	pr_info("coda_read_super: rootinode is %ld dev %s\n",
+		root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		error = -EINVAL;
@@ -246,7 +247,7 @@ static void coda_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 	mutex_unlock(&vcp->vc_mutex);
 
-	printk("Coda: Bye bye.\n");
+	pr_info("Coda: Bye bye.\n");
 }
 
 static void coda_evict_inode(struct inode *inode)
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index ebc2bae..accddf6 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -114,14 +114,14 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 		int size = sizeof(*dcbuf);
 
 		if  ( nbytes < sizeof(struct coda_out_hdr) ) {
-		        printk("coda_downcall opc %d uniq %d, not enough!\n",
-			       hdr.opcode, hdr.unique);
+			pr_warn("coda_downcall opc %d uniq %d, not enough!\n",
+				hdr.opcode, hdr.unique);
 			count = nbytes;
 			goto out;
 		}
 		if ( nbytes > size ) {
-		        printk("Coda: downcall opc %d, uniq %d, too much!",
-			       hdr.opcode, hdr.unique);
+			pr_warn("Coda: downcall opc %d, uniq %d, too much!",
+				hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
 		CODA_ALLOC(dcbuf, union outputArgs *, nbytes);
@@ -136,7 +136,8 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 
 		CODA_FREE(dcbuf, nbytes);
 		if (error) {
-		        printk("psdev_write: coda_downcall error: %d\n", error);
+			pr_warn("psdev_write: coda_downcall error: %d\n",
+				error);
 			retval = error;
 			goto out;
 		}
@@ -157,7 +158,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 	mutex_unlock(&vcp->vc_mutex);
 
 	if (!req) {
-		printk("psdev_write: msg (%d, %d) not found\n", 
+		pr_warn("psdev_write: msg (%d, %d) not found\n",
 			hdr.opcode, hdr.unique);
 		retval = -ESRCH;
 		goto out;
@@ -165,8 +166,8 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 
         /* move data into response buffer. */
 	if (req->uc_outSize < nbytes) {
-                printk("psdev_write: too much cnt: %d, cnt: %ld, opc: %d, uniq: %d.\n",
-		       req->uc_outSize, (long)nbytes, hdr.opcode, hdr.unique);
+		pr_warn("psdev_write: too much cnt: %d, cnt: %ld, opc: %d, uniq: %d.\n",
+			req->uc_outSize, (long)nbytes, hdr.opcode, hdr.unique);
 		nbytes = req->uc_outSize; /* don't have more space! */
 	}
         if (copy_from_user(req->uc_data, buf, nbytes)) {
@@ -240,7 +241,7 @@ static ssize_t coda_psdev_read(struct file * file, char __user * buf,
 	/* Move the input args into userspace */
 	count = req->uc_inSize;
 	if (nbytes < req->uc_inSize) {
-                printk ("psdev_read: Venus read %ld bytes of %d in message\n",
+		pr_warn("psdev_read: Venus read %ld bytes of %d in message\n",
 			(long)nbytes, req->uc_inSize);
 		count = nbytes;
         }
@@ -305,7 +306,7 @@ static int coda_psdev_release(struct inode * inode, struct file * file)
 	struct upc_req *req, *tmp;
 
 	if (!vcp || !vcp->vc_inuse ) {
-		printk("psdev_release: Not open.\n");
+		pr_warn("psdev_release: Not open.\n");
 		return -1;
 	}
 
@@ -354,8 +355,8 @@ static int init_coda_psdev(void)
 {
 	int i, err = 0;
 	if (register_chrdev(CODA_PSDEV_MAJOR, "coda", &coda_psdev_fops)) {
-              printk(KERN_ERR "coda_psdev: unable to get major %d\n", 
-		     CODA_PSDEV_MAJOR);
+		pr_err("coda_psdev: unable to get major %d\n",
+		       CODA_PSDEV_MAJOR);
               return -EIO;
 	}
 	coda_psdev_class = class_create(THIS_MODULE, "coda");
@@ -393,13 +394,13 @@ static int __init init_coda(void)
 		goto out2;
 	status = init_coda_psdev();
 	if ( status ) {
-		printk("Problem (%d) in init_coda_psdev\n", status);
+		pr_warn("Problem (%d) in init_coda_psdev\n", status);
 		goto out1;
 	}
 	
 	status = register_filesystem(&coda_fs_type);
 	if (status) {
-		printk("coda: failed to register filesystem!\n");
+		pr_warn("coda: failed to register filesystem!\n");
 		goto out;
 	}
 	return 0;
@@ -420,9 +421,8 @@ static void __exit exit_coda(void)
         int err, i;
 
 	err = unregister_filesystem(&coda_fs_type);
-        if ( err != 0 ) {
-                printk("coda: failed to unregister filesystem\n");
-        }
+	if (err != 0)
+		pr_warn("coda: failed to unregister filesystem\n");
 	for (i = 0; i < MAX_CODADEVS; i++)
 		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 3a73197..5f3b217 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -508,8 +508,8 @@ int venus_pioctl(struct super_block *sb, struct CodaFid *fid,
         inp->coda_ioctl.data = (char *)(INSIZE(ioctl));
      
         /* get the data out of user space */
-        if ( copy_from_user((char*)inp + (long)inp->coda_ioctl.data,
-			    data->vi.in, data->vi.in_size) ) {
+	if (copy_from_user((char *)inp + (long)inp->coda_ioctl.data,
+			   data->vi.in, data->vi.in_size)) {
 		error = -EINVAL;
 	        goto exit;
 	}
@@ -518,8 +518,8 @@ int venus_pioctl(struct super_block *sb, struct CodaFid *fid,
 			    &outsize, inp);
 
         if (error) {
-	        printk("coda_pioctl: Venus returns: %d for %s\n", 
-		       error, coda_f2s(fid));
+		pr_warn("coda_pioctl: Venus returns: %d for %s\n",
+			error, coda_f2s(fid));
 		goto exit; 
 	}
 
@@ -675,7 +675,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	mutex_lock(&vcp->vc_mutex);
 
 	if (!vcp->vc_inuse) {
-		printk(KERN_NOTICE "coda: Venus dead, not sending upcall\n");
+		pr_notice("coda: Venus dead, not sending upcall\n");
 		error = -ENXIO;
 		goto exit;
 	}
@@ -725,7 +725,7 @@ static int coda_upcall(struct venus_comm *vcp,
 
 	error = -EINTR;
 	if ((req->uc_flags & CODA_REQ_ABORT) || !signal_pending(current)) {
-		printk(KERN_WARNING "coda: Unexpected interruption.\n");
+		pr_warn("coda: Unexpected interruption.\n");
 		goto exit;
 	}
 
@@ -735,7 +735,7 @@ static int coda_upcall(struct venus_comm *vcp,
 
 	/* Venus saw the upcall, make sure we can send interrupt signal */
 	if (!vcp->vc_inuse) {
-		printk(KERN_INFO "coda: Venus dead, not sending signal.\n");
+		pr_info("coda: Venus dead, not sending signal.\n");
 		goto exit;
 	}
 
-- 
1.8.4.5

