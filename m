Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3LCWPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:15:48 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:35230 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3LCWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:15:47 -0500
Date: Tue, 3 Dec 2013 17:15:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: sysfs: use a separate locking class for open files depending on
 mmap
Message-ID: <20131203221543.GP8277@htj.dyndns.org>
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
 <20131203211515.GA17951@redhat.com>
 <20131203213649.GO8277@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203213649.GO8277@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can you please test whether this patch makes the lockdep warning go
away?

Thanks a lot!

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b94f936..fccb645 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -470,6 +470,9 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	int rc;
 
+	if (!(of->sd->s_flags & SYSFS_FLAG_HAS_MMAP))
+		return -ENODEV;
+
 	mutex_lock(&of->mutex);
 
 	/* need of->sd for battr, its parent for kobj */
@@ -477,9 +480,6 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!sysfs_get_active(of->sd))
 		goto out_unlock;
 
-	if (!battr->mmap)
-		goto out_put;
-
 	rc = battr->mmap(file, kobj, battr, vma);
 	if (rc)
 		goto out_put;
@@ -851,6 +851,14 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	sd->s_attr.attr = (void *)attr;
 	sysfs_dirent_init_lockdep(sd);
 
+	if (type == SYSFS_KOBJ_BIN_ATTR) {
+		const struct bin_attribute *battr =
+			container_of(attr, struct bin_attribute, attr);
+
+		if (battr->mmap)
+			sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
+	}
+
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, sd, dir_sd);
 	sysfs_addrm_finish(&acxt);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 0af09fb..27c1f7e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -96,6 +96,7 @@ struct sysfs_dirent {
 
 #define SYSFS_FLAG_MASK			~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
 #define SYSFS_FLAG_REMOVED		0x02000
+#define SYSFS_FLAG_HAS_MMAP		0x04000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {

-- 
tejun
