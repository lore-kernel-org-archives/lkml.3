Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaLRIzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:55:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39554 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaLRIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:55:37 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-10-54929684824f
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, k.opasiak@samsung.com,
        stern@rowland.harvard.edu, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v5] usb: gadget: f_fs: add "no_disconnect" mode
Date: Thu, 18 Dec 2014 09:55:10 +0100
Message-id: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e+xgG7LtEkhBpuv81kcvF9v0bx4PZvF
	7YnT2Cwu75rDZrFoWSuzxdojd9ktFhxvYbV4cHgnu8WE3xfYHDg99s9dw+6x7s8rJo/Zd38w
	evRtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDJm3vrIXvDBueLv4XusDYyXzLoYOTkk
	BEwkTr3sZIWwxSQu3FvP1sXIxSEksIhRonHCBEYIp51J4szMu4wgVWwCOhJbvk8As0UEBCTW
	v7jEDlLELPCEUWLP51lgCWEBe4ml134xg9gsAqoScx/eBFvBK+AqcX3eEXaIdXISJ49NZp3A
	yL2AkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAQPZPewbiqweIQowAHoxIPr4TepBAh
	1sSy4srcQ4wSHMxKIrzROUAh3pTEyqrUovz4otKc1OJDjNIcLErivEr2bSFCAumJJanZqakF
	qUUwWSYOTqkGRs+g1rmSHedPlu68vmfLspUGevFX+SveFsx/vKF4ndbHKtVVM+fkrDjwdX5V
	3eReL+/Fsk3M705N5onw+Cq+9UGZ0zL30n16K9YJdTjqiy62V5x8JKeZ1/LL3/rNuRbrji5m
	7jr37MeCbV9Tbf9P/Tc3opHP7MG9sI02u65tOdBtrKnXVC53nlmJpTgj0VCLuag4EQDlgtwp
	HgIAAA==
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
- opening ep0 causes the function to be closed, and then FunctionFS
  is ready for descriptors and string write,
- altsetting change causes the function to be closed - we want to keep
  function alive until another functions are potentialy used, altsetting
  change means that another configuration is being selected or USB cable
  was unplugged, which indicates that we don't need to stay longer in
  FFS_DEACTIVATED state
- unmounting of the FunctionFS instance causes the function to be closed.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Changelog:

v5:
- close function on altsetting change

v4: https://lkml.org/lkml/2014/10/9/224
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

---
 drivers/usb/gadget/function/f_fs.c | 56 ++++++++++++++++++++++++++++++++++----
 drivers/usb/gadget/function/u_fs.h | 24 ++++++++++++++++
 2 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 63314ed..d49af15 100644
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
@@ -1180,6 +1182,7 @@ struct ffs_sb_fill_data {
 	struct ffs_file_perms perms;
 	umode_t root_mode;
 	const char *dev_name;
+	bool no_disconnect;
 	struct ffs_data *ffs_data;
 };
 
@@ -1250,6 +1253,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 
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
@@ -1314,6 +1323,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 			.gid = GLOBAL_ROOT_GID,
 		},
 		.root_mode = S_IFDIR | 0500,
+		.no_disconnect = false,
 	};
 	struct dentry *rv;
 	int ret;
@@ -1330,6 +1340,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	if (unlikely(!ffs))
 		return ERR_PTR(-ENOMEM);
 	ffs->file_perms = data.perms;
+	ffs->no_disconnect = data.no_disconnect;
 
 	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
 	if (unlikely(!ffs->dev_name)) {
@@ -1361,6 +1372,7 @@ ffs_fs_kill_sb(struct super_block *sb)
 	kill_litter_super(sb);
 	if (sb->s_fs_info) {
 		ffs_release_dev(sb->s_fs_info);
+		ffs_data_closed(sb->s_fs_info);
 		ffs_data_put(sb->s_fs_info);
 	}
 }
@@ -1417,7 +1429,11 @@ static void ffs_data_opened(struct ffs_data *ffs)
 	ENTER();
 
 	atomic_inc(&ffs->ref);
-	atomic_inc(&ffs->opened);
+	if (atomic_add_return(1, &ffs->opened) == 1)
+		if (ffs->state == FFS_DEACTIVATED) {
+			ffs->state = FFS_CLOSING;
+			ffs_data_reset(ffs);
+	}
 }
 
 static void ffs_data_put(struct ffs_data *ffs)
@@ -1439,6 +1455,21 @@ static void ffs_data_closed(struct ffs_data *ffs)
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
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
+	}
+	if (atomic_read(&ffs->opened) < 0) {
 		ffs->state = FFS_CLOSING;
 		ffs_data_reset(ffs);
 	}
@@ -1616,7 +1647,6 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	kfree(epfiles);
 }
 
-
 static void ffs_func_eps_disable(struct ffs_function *func)
 {
 	struct ffs_ep *ep         = func->eps;
@@ -1629,10 +1659,12 @@ static void ffs_func_eps_disable(struct ffs_function *func)
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
@@ -2888,6 +2920,13 @@ static int ffs_func_bind(struct usb_configuration *c,
 
 /* Other USB function hooks *************************************************/
 
+static void ffs_reset_work(struct work_struct *work)
+{
+	struct ffs_data *ffs = container_of(work,
+		struct ffs_data, reset_work);
+	ffs_data_reset(ffs);
+}
+
 static int ffs_func_set_alt(struct usb_function *f,
 			    unsigned interface, unsigned alt)
 {
@@ -2904,6 +2943,13 @@ static int ffs_func_set_alt(struct usb_function *f,
 	if (ffs->func)
 		ffs_func_eps_disable(ffs->func);
 
+	if (ffs->state == FFS_DEACTIVATED) {
+		ffs->state = FFS_CLOSING;
+		INIT_WORK(&ffs->reset_work, ffs_reset_work);
+		schedule_work(&ffs->reset_work);
+		return -ENODEV;
+	}
+
 	if (ffs->state != FFS_ACTIVE)
 		return -ENODEV;
 
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index cd128e3..284a1f0 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -19,6 +19,7 @@
 #include <linux/usb/composite.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 
 #ifdef VERBOSE_DEBUG
 #ifndef pr_vdebug
@@ -93,6 +94,26 @@ enum ffs_state {
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
@@ -251,6 +272,9 @@ struct ffs_data {
 		kgid_t				gid;
 	}				file_perms;
 
+	bool no_disconnect;
+	struct work_struct reset_work;
+
 	/*
 	 * The endpoint files, filled by ffs_epfiles_create(),
 	 * destroyed by ffs_epfiles_destroy().
-- 
1.9.1

