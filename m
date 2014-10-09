Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaJINWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:22:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62138 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaJINWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:22:16 -0400
X-AuditID: cbfee61a-f79c06d000004e71-cd-54368c06b6b9
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com, andrzej.p@samsung.com,
        m.szyprowski@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
Date: Thu, 09 Oct 2014 15:21:51 +0200
Message-id: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xgC5bj1mIQfNxUYtZL9tZLA7er7do
	XryezeL2xGlsFpd3zWGzWLSsldli7ZG77BYLjrewWjw4vJPdgdNj/9w17B7r/rxi8ujbsorR
	4/iN7UwenzfJBbBGcdmkpOZklqUW6dslcGU8OSBf8NqiYuapWawNjOd1uxg5OSQETCRuHb7I
	CmGLSVy4t54NxBYSWMQocf07TxcjF5DdziTRv2UHC0iCTUBHYsv3CYwgtoiAgMT6F5fYQYqY
	BR4wStzadQZoEgeHsIC9xJJnfCA1LAKqEi19z8AW8Aq4Smz5eoANYpmcxMljk1knMHIvYGRY
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcNM+kdjCubLA4xCjAwajEw/vgn2mIEGtiWXFl
	7iFGCQ5mJRHeN1lmIUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFk
	mTg4pRoYDQ02s6w2+uzDGlkrqNi5J+D05Lzth4yMP85U09Ffeu1ul/1pkYfSKZZCPBYxD/8m
	8j5fcWpPN8PkdN0L7x4/v+G2xYAxrFnkNJNLhXdf8ZRlyj9i3R/fqAx7d/hT4A/hN/OPCiSs
	1P930URXXCffdm9XVv+ZLdf0F8cI+5mankhrjDh8uHuyEktxRqKhFnNRcSIAbHt31xYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we can compose gadgets from many functions, there is the problem
related to gadget breakage while FunctionFS daemon being closed. FFS
function is userspace code so there is no way to know when it will close
files (it doesn't matter what is the reason of this situation, it can
be daemon logic, program breakage, process kill or any other). So when
we have another function in gadget which, for example, sends some amount
of data, does some software update or implements some real-time functionality,
we may want to keep the gadget connected despite FFS function is no longer
functional.

We can't just remove one of functions from gadget since it has been
enumerated, so the only way to keep entire gadget working is to make
broken FFS function deactivated but still visible to host. For this
purpose this patch introduces "no_disconnect" mode. It can be enabled
by setting mount option "no_disconnect=1", and results with defering
function disconnect to the moment of reopen ep0 file or filesystem
unmount. After closing all endpoint files, FunctionFS is set to state
FFS_DEACTIVATED.

When ffs->state == FFS_DEACTIVATED:
- function is still bound and visible to host,
- setup requests are automatically stalled,
- transfers on other endpoints are refused,
- epfiles, except ep0, are deleted from the filesystem,
- opening ep0 causes the function to be closes, and then FunctionFS
  is ready for descriptors and string write,
- unmounting of the FunctionFS instance causes the function to be closed.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Changelog:

v4:
- use ffs_data_reset() instead of ffs_data_clear() to reset ffs data
  properly after ffs->ref refcount reach 0 (or under in no_disconnect
  mode) in ffs_data_put() function

v3: https://lkml.org/lkml/2014/10/9/170
- change option name to more descriptive and less scary,
- fix cleaning up on unmount (call ffs_data_closed() in ffs_fs_kill_sb(),
  and ffs_data_clear() in ffs_data_closed() if ffs->opened is negative).

v2: https://lkml.org/lkml/2014/10/7/109
- delete epfiles, excepting ep0, when FFS is in "zombie" mode,
- add description of FFS_ZOMBIE state,
- minor cleanups.

v1: https://lkml.org/lkml/2014/10/6/128

 drivers/usb/gadget/function/f_fs.c | 42 +++++++++++++++++++++++++++++++-------
 drivers/usb/gadget/function/u_fs.h | 22 ++++++++++++++++++++
 2 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 12dbdaf..2d47d4a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -606,6 +606,8 @@ static unsigned int ffs_ep0_poll(struct file *file, poll_table *wait)
 		}
 	case FFS_CLOSING:
 		break;
+	case FFS_DEACTIVATED:
+		break;
 	}
 
 	mutex_unlock(&ffs->mutex);
@@ -1152,6 +1154,7 @@ struct ffs_sb_fill_data {
 	struct ffs_file_perms perms;
 	umode_t root_mode;
 	const char *dev_name;
+	bool no_disconnect;
 	struct ffs_data *ffs_data;
 };
 
@@ -1222,6 +1225,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 
 		/* Interpret option */
 		switch (eq - opts) {
+		case 13:
+			if (!memcmp(opts, "no_disconnect", 13))
+				data->no_disconnect = !!value;
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
+		.no_disconnect = false,
 	};
 	struct dentry *rv;
 	int ret;
@@ -1302,6 +1312,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	if (unlikely(!ffs))
 		return ERR_PTR(-ENOMEM);
 	ffs->file_perms = data.perms;
+	ffs->no_disconnect = data.no_disconnect;
 
 	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
 	if (unlikely(!ffs->dev_name)) {
@@ -1333,6 +1344,7 @@ ffs_fs_kill_sb(struct super_block *sb)
 	kill_litter_super(sb);
 	if (sb->s_fs_info) {
 		ffs_release_dev(sb->s_fs_info);
+		ffs_data_closed(sb->s_fs_info);
 		ffs_data_put(sb->s_fs_info);
 	}
 }
@@ -1389,7 +1401,9 @@ static void ffs_data_opened(struct ffs_data *ffs)
 	ENTER();
 
 	atomic_inc(&ffs->ref);
-	atomic_inc(&ffs->opened);
+	if (atomic_add_return(1, &ffs->opened) == 1)
+		if (ffs->state == FFS_DEACTIVATED)
+			ffs_data_reset(ffs);
 }
 
 static void ffs_data_put(struct ffs_data *ffs)
@@ -1411,9 +1425,22 @@ static void ffs_data_closed(struct ffs_data *ffs)
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
+		if (ffs->no_disconnect) {
+			ffs->state = FFS_DEACTIVATED;
+			if (ffs->epfiles) {
+				ffs_epfiles_destroy(ffs->epfiles,
+						   ffs->eps_count);
+				ffs->epfiles = NULL;
+			}
+			if (ffs->setup_state == FFS_SETUP_PENDING)
+				__ffs_ep0_stall(ffs);
+		} else {
+			ffs->state = FFS_CLOSING;
+			ffs_data_reset(ffs);
+		}
 	}
+	if (atomic_read(&ffs->opened) < 0)
+		ffs_data_reset(ffs);
 
 	ffs_data_put(ffs);
 }
@@ -1588,7 +1615,6 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	kfree(epfiles);
 }
 
-
 static void ffs_func_eps_disable(struct ffs_function *func)
 {
 	struct ffs_ep *ep         = func->eps;
@@ -1601,10 +1627,12 @@ static void ffs_func_eps_disable(struct ffs_function *func)
 		/* pending requests get nuked */
 		if (likely(ep->ep))
 			usb_ep_disable(ep->ep);
-		epfile->ep = NULL;
-
 		++ep;
-		++epfile;
+
+		if (epfile) {
+			epfile->ep = NULL;
+			++epfile;
+		}
 	} while (--count);
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 }
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index cd128e3..7bc0ca2 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -93,6 +93,26 @@ enum ffs_state {
 	FFS_ACTIVE,
 
 	/*
+	 * Function is visible to host, but it's not functional. All
+	 * setup requests are stalled and transfers on another endpoints
+	 * are refused. All epfiles, except ep0, are deleted so there
+	 * is no way to perform any operations on them.
+	 *
+	 * This state is set after closing all functionfs files, when
+	 * mount parameter "no_disconnect=1" has been set. Function will
+	 * remain in deactivated state until filesystem is umounted or
+	 * ep0 is opened again. In the second case functionfs state will
+	 * be reset, and it will be ready for descriptors and strings
+	 * writing.
+	 *
+	 * This is useful only when functionfs is composed to gadget
+	 * with another function which can perform some critical
+	 * operations, and it's strongly desired to have this operations
+	 * completed, even after functionfs files closure.
+	 */
+	FFS_DEACTIVATED,
+
+	/*
 	 * All endpoints have been closed.  This state is also set if
 	 * we encounter an unrecoverable error.  The only
 	 * unrecoverable error is situation when after reading strings
@@ -251,6 +271,8 @@ struct ffs_data {
 		kgid_t				gid;
 	}				file_perms;
 
+	bool no_disconnect;
+
 	/*
 	 * The endpoint files, filled by ffs_epfiles_create(),
 	 * destroyed by ffs_epfiles_destroy().
-- 
1.9.1

