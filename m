Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaJGH7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:59:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36341 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaJGH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:59:14 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-b2-54339d506a36
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        k.opasiak@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] usb: gadget: f_fs: add "zombie" mode
Date: Tue, 07 Oct 2014 09:59:02 +0200
Message-id: <1412668742-14831-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xoG7AXOMQg6O7lC1mvWxnsTh4v96i
	efF6NovbE6exWVzeNYfNYtGyVmaLBcdbWC0eHN7J7sDhsX/uGnaPdX9eMXn0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgy+hpWshXc0K+40r2LsYFxsVoXIyeHhICJxOb3F1khbDGJ
	C/fWs3UxcnEICUxnlHg+/yCU084kcejADEaQKjYBHYkt3yeA2SICAhLrX1xiByliFjjCKPFx
	3hJmkISwgIXEmq77TF2MHBwsAqoSLz5zg4R5BVwlpi/bzQ6xTU7i5LHJrBMYuRcwMqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECA6XZ9I7GFc1WBxiFOBgVOLhXaFlHCLEmlhWXJl7iFGC
	g1lJhHdLBVCINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QD
	Y+b0zzsjj67p2PaFz0W+dp+UNkfTiUVOYUwvn+YzLNTdd2lpgdKze6Ex+wTETuyY3fXgd/Mi
	6ae3dqVOesXNxbKT54P4W2bDk4ebzm669Fqia838lTLftzzueXjv1OOTwqKW/KnJ86actvgx
	40PzPrfNRSs0Uh84vxebcr2DqzknXjfkrVN+bY0SS3FGoqEWc1FxIgDtC33PEwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we can compose gadgets from many functions, there is the problem
related to gadget breakage while FunctionFS daemon being closed. In some
cases it's strongly desired to keep gadget alive for a while, despite
FunctionFS files are closed, to allow another functions to complete
some presumably critical operations.

For this purpose this patch introduces "zombie" mode. It can be enabled
by setting mount option "zombie=1", and results with defering function
closure to the moment of reopening ep0 file or filesystem umount.

When ffs->state == FFS_ZOMBIE:
- function is still binded and visible to host,
- setup requests are automatically stalled,
- all another transfers are refused,
- epfiles, excepting ep0, are deleted from filesystem,
- opening ep0 causes function close, and then FunctionFS is ready for
  descriptors and string write,
- umount of functionfs cause function close.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Changelog:

v2:
- delete epfiles, excepting ep0, when FFS is in "zombie" mode,
- add description of FFS_ZOMBIE state,
- minor cleanups.

v1: https://lkml.org/lkml/2014/10/6/128

 drivers/usb/gadget/function/f_fs.c | 38 ++++++++++++++++++++++++++++++++++----
 drivers/usb/gadget/function/u_fs.h | 22 ++++++++++++++++++++++
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 7c6771d..b368b0a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -162,6 +162,7 @@ struct ffs_desc_helper {
 };
 
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
+static void ffs_epfiles_delete(struct ffs_epfile *epfiles, unsigned count);
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
 
 static struct dentry *
@@ -606,6 +607,8 @@ static unsigned int ffs_ep0_poll(struct file *file, poll_table *wait)
 		}
 	case FFS_CLOSING:
 		break;
+	case FFS_ZOMBIE:
+		break;
 	}
 
 	mutex_unlock(&ffs->mutex);
@@ -1152,6 +1155,7 @@ struct ffs_sb_fill_data {
 	struct ffs_file_perms perms;
 	umode_t root_mode;
 	const char *dev_name;
+	bool zombie_mode;
 	struct ffs_data *ffs_data;
 };
 
@@ -1222,6 +1226,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 
 		/* Interpret option */
 		switch (eq - opts) {
+		case 6:
+			if (!memcmp(opts, "zombie", 6))
+				data->zombie_mode = !!value;
+			else
+				goto invalid;
+			break;
 		case 5:
 			if (!memcmp(opts, "rmode", 5))
 				data->root_mode  = (value & 0555) | S_IFDIR;
@@ -1286,6 +1296,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 			.gid = GLOBAL_ROOT_GID,
 		},
 		.root_mode = S_IFDIR | 0500,
+		.zombie_mode = false,
 	};
 	struct dentry *rv;
 	int ret;
@@ -1302,6 +1313,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	if (unlikely(!ffs))
 		return ERR_PTR(-ENOMEM);
 	ffs->file_perms = data.perms;
+	ffs->zombie_mode = data.zombie_mode;
 
 	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
 	if (unlikely(!ffs->dev_name)) {
@@ -1389,7 +1401,9 @@ static void ffs_data_opened(struct ffs_data *ffs)
 	ENTER();
 
 	atomic_inc(&ffs->ref);
-	atomic_inc(&ffs->opened);
+	if (atomic_add_return(1, &ffs->opened) == 1)
+		if (ffs->state == FFS_ZOMBIE)
+			ffs_data_reset(ffs);
 }
 
 static void ffs_data_put(struct ffs_data *ffs)
@@ -1411,8 +1425,17 @@ static void ffs_data_closed(struct ffs_data *ffs)
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
+		if (ffs->zombie_mode) {
+			ffs->state = FFS_ZOMBIE;
+			if (ffs->epfiles)
+				ffs_epfiles_delete(ffs->epfiles,
+						   ffs->eps_count);
+			if (ffs->setup_state == FFS_SETUP_PENDING)
+				__ffs_ep0_stall(ffs);
+		} else {
+			ffs->state = FFS_CLOSING;
+			ffs_data_reset(ffs);
+		}
 	}
 
 	ffs_data_put(ffs);
@@ -1569,7 +1592,7 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
+static void ffs_epfiles_delete(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
 
@@ -1584,6 +1607,13 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 			epfile->dentry = NULL;
 		}
 	}
+}
+
+static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
+{
+	ENTER();
+
+	ffs_epfiles_delete(epfiles, count);
 
 	kfree(epfiles);
 }
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index cd128e3..bc16a02 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -93,6 +93,26 @@ enum ffs_state {
 	FFS_ACTIVE,
 
 	/*
+	 * Function is visible to host, but it's not functional. All
+	 * setup requests are stalled and another transfers are refused.
+	 * All epfiles, excepting ep0, are deleted so there is no way
+	 * to perform any operations on them.
+	 *
+	 * This state is set after closing all functionfs files, when
+	 * mount parameter "zombie=1" has been set. Function will remain
+	 * in zombie state until filesystem will be umounted or ep0 will
+	 * be opened again. In the second case functionfs state will be
+	 * reseted, and it will be ready for descriptors and strings
+	 * writing.
+	 *
+	 * This is useful only when functionfs is composed to gadget
+	 * with another function which can perform some critical
+	 * operations, and it's strongly desired to have this operations
+	 * completed, even after functionfs files closure.
+	 */
+	FFS_ZOMBIE,
+
+	/*
 	 * All endpoints have been closed.  This state is also set if
 	 * we encounter an unrecoverable error.  The only
 	 * unrecoverable error is situation when after reading strings
@@ -251,6 +271,8 @@ struct ffs_data {
 		kgid_t				gid;
 	}				file_perms;
 
+	bool zombie_mode;
+
 	/*
 	 * The endpoint files, filled by ffs_epfiles_create(),
 	 * destroyed by ffs_epfiles_destroy().
-- 
1.9.1

