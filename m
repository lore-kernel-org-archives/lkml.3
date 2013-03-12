Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3CLWdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3CLWd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Yasi <joe.yasi@gmail.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 072/100] efivarfs: return accurate error code in efivarfs_fill_super()
Date: Tue, 12 Mar 2013 15:31:57 -0700
Message-Id: <20130312223130.679686857@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit feff5dc4f98330d8152b521acc2e18c16712e6c8 upstream.

Joseph was hitting a failure case when mounting efivarfs which
resulted in an incorrect error message,

  $ sudo mount -v /sys/firmware/efi/efivars mount: Cannot allocate memory

triggered when efivarfs_valid_name() returned -EINVAL.

Make sure we pass accurate return values up the stack if
efivarfs_fill_super() fails to build inodes for EFI variables.

Reported-by: Joseph Yasi <joe.yasi@gmail.com>
Reported-by: Lingzhu Xiang <lxiang@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1110,15 +1110,22 @@ static struct dentry_operations efivarfs
 
 static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
 {
+	struct dentry *d;
 	struct qstr q;
+	int err;
 
 	q.name = name;
 	q.len = strlen(name);
 
-	if (efivarfs_d_hash(NULL, NULL, &q))
-		return NULL;
+	err = efivarfs_d_hash(NULL, NULL, &q);
+	if (err)
+		return ERR_PTR(err);
+
+	d = d_alloc(parent, &q);
+	if (d)
+		return d;
 
-	return d_alloc(parent, &q);
+	return ERR_PTR(-ENOMEM);
 }
 
 static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
@@ -1128,6 +1135,7 @@ static int efivarfs_fill_super(struct su
 	struct efivar_entry *entry, *n;
 	struct efivars *efivars = &__efivars;
 	char *name;
+	int err = -ENOMEM;
 
 	efivarfs_sb = sb;
 
@@ -1178,8 +1186,10 @@ static int efivarfs_fill_super(struct su
 			goto fail_name;
 
 		dentry = efivarfs_alloc_dentry(root, name);
-		if (!dentry)
+		if (IS_ERR(dentry)) {
+			err = PTR_ERR(dentry);
 			goto fail_inode;
+		}
 
 		/* copied by the above to local storage in the dentry. */
 		kfree(name);
@@ -1206,7 +1216,7 @@ fail_inode:
 fail_name:
 	kfree(name);
 fail:
-	return -ENOMEM;
+	return err;
 }
 
 static struct dentry *efivarfs_mount(struct file_system_type *fs_type,


