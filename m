Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaJFLZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:25:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54545 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJFLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:25:29 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-f4-54327c265634
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        k.opasiak@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: f_fs: add "zombie" mode
Date: Mon, 06 Oct 2014 13:25:14 +0200
Message-id: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAV21GqMQg2m3eS1mvWxnsTh4v96i
	efF6NovbE6exWVzeNYfNYtGyVmaLBcdbWC0eHN7J7sDhsX/uGnaPdX9eMXn0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgyVhzNLDgmV3HtYidbA+N+iS5GTg4JAROJL/vXsEDYYhIX
	7q1n62Lk4hASWMQo8frdFiYIp51JYs6nc4wgVWwCOhJbvk8As0UEBCTWv7jEDlLELHCEUeLj
	vCXMXYwcHMICphIL/vmA1LAIqEr83bOPGcTmFXCW6Lz0G2qbnMTJY5NZJzByL2BkWMUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRHCzPpHcwrmqwOMQowMGoxMMbscMwRIg1say4MvcQowQH
	s5II76UqoxAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFIN
	jCETlThyXreu8dLucl++6+jF2TNFt1TycMyLvta8xcpxTWWokuG7t33lG9+2bapaMunBaf2D
	3tcVopmztzGpX9imvDFaPYXL2lrNLrUqtLD3Ls/7yRUi6d43/9vMSmu8mBkRsXfJlYd5vi93
	LHqhejpJQrNILzyhVNf+gVPa0oD/7Puu/Na5pcRSnJFoqMVcVJwIAHisjqESAgAA
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
- opening ep0 causes function close, and then FunctionFS is ready for
  descriptors and string write,
- umount of functionfs cause function close.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/function/f_fs.c | 25 ++++++++++++++++++++++---
 drivers/usb/gadget/function/u_fs.h |  4 ++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 7c6771d..5581bec 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -606,6 +606,8 @@ static unsigned int ffs_ep0_poll(struct file *file, poll_table *wait)
 		}
 	case FFS_CLOSING:
 		break;
+	case FFS_ZOMBIE:
+		break;
 	}
 
 	mutex_unlock(&ffs->mutex);
@@ -1152,6 +1154,7 @@ struct ffs_sb_fill_data {
 	struct ffs_file_perms perms;
 	umode_t root_mode;
 	const char *dev_name;
+	bool zombie_mode;
 	struct ffs_data *ffs_data;
 };
 
@@ -1222,6 +1225,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 
 		/* Interpret option */
 		switch (eq - opts) {
+		case 6:
+			if (!memcmp(opts, "zombie", 6))
+				data->zombie_mode  = !!value;
+			else
+				goto invalid;
+			break;
 		case 5:
 			if (!memcmp(opts, "rmode", 5))
 				data->root_mode  = (value & 0555) | S_IFDIR;
@@ -1286,6 +1295,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 			.gid = GLOBAL_ROOT_GID,
 		},
 		.root_mode = S_IFDIR | 0500,
+		.zombie_mode = false,
 	};
 	struct dentry *rv;
 	int ret;
@@ -1302,6 +1312,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	if (unlikely(!ffs))
 		return ERR_PTR(-ENOMEM);
 	ffs->file_perms = data.perms;
+	ffs->zombie_mode = data.zombie_mode;
 
 	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
 	if (unlikely(!ffs->dev_name)) {
@@ -1389,7 +1400,9 @@ static void ffs_data_opened(struct ffs_data *ffs)
 	ENTER();
 
 	atomic_inc(&ffs->ref);
-	atomic_inc(&ffs->opened);
+	if (atomic_add_return(1, &ffs->opened) == 1)
+		if (ffs->state == FFS_ZOMBIE)
+			ffs_data_reset(ffs);
 }
 
 static void ffs_data_put(struct ffs_data *ffs)
@@ -1411,8 +1424,14 @@ static void ffs_data_closed(struct ffs_data *ffs)
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
+		if (ffs->zombie_mode) {
+			ffs->state = FFS_ZOMBIE;
+			if (ffs->setup_state == FFS_SETUP_PENDING)
+				__ffs_ep0_stall(ffs);
+		} else {
+			ffs->state = FFS_CLOSING;
+			ffs_data_reset(ffs);
+		}
 	}
 
 	ffs_data_put(ffs);
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index cd128e3..7a4abbe 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -92,6 +92,8 @@ enum ffs_state {
 	 */
 	FFS_ACTIVE,
 
+	FFS_ZOMBIE,
+
 	/*
 	 * All endpoints have been closed.  This state is also set if
 	 * we encounter an unrecoverable error.  The only
@@ -251,6 +253,8 @@ struct ffs_data {
 		kgid_t				gid;
 	}				file_perms;
 
+	bool zombie_mode;
+
 	/*
 	 * The endpoint files, filled by ffs_epfiles_create(),
 	 * destroyed by ffs_epfiles_destroy().
-- 
1.9.1

