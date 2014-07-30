Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaG3JoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:44:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31028 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaG3JoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:44:07 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a1-53d8be65ef5b
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 3/3] usb: gadget: f_fs: virtual endpoint address mapping
Date: Wed, 30 Jul 2014 11:43:43 +0200
Message-id: <1406713423-32472-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
References: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jQd3UfTeCDTZdU7aY9bKdxeLg/XqL
	5sXr2SxuT5zGZnF51xw2i0XLWpkt1h65y26x4HgLq8WDwzvZHTg99s9dw+6x7s8rJo++LasY
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGmnlzmAva1CoOLpvO1MD4W66LkZNDQsBE4sT2
	44wQtpjEhXvr2boYuTiEBKYzSnQdP80O4bQzSRyefResik1AR2LL9wlgtoiAgMT6F5fAipgF
	HjBKtN+6zAaSEBbwlng46wiQzcHBIqAq0bonDsTkFXCVeLSpFmKZnMTJY5NZQWxOATeJk5se
	MIKUCAGVfH/iNYGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4CB7JrWDcWWDxSFG
	AQ5GJR7eGf+vBwuxJpYVV+YeYpTgYFYS4e1beyNYiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+B
	VutAIYH0xJLU7NTUgtQimCwTB6dUA+OyH2Fn7QrdjhpvTJ4bM5vjvaXsy0m6j43332xdZZ1l
	PekfryTnWp1TNZKsdWKJU3eta7JvsMiayrR84x6d9SoXQ66Jb5r9Pl5v66xtakc3GzYtDVK2
	DBWuPr/9v4/VFOeH9o279wX8chcWu/H6o17f7/9HeA8ndjCIppgfvDz10k85U6ZdgUuVWIoz
	Eg21mIuKEwHFObUHLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces virtual endpoint address mapping. It separates
function logic form physical endpoint addresses making it more hardware
independent.

Following modifications changes user space API, so to enable them user
have to switch on the FUNCTIONFS_VIRTUAL_ADDR flag in descriptors.

Endpoints are now refered using virtual endpoint addresses chosen by
user in endpoint descpriptors. This applies to each context when endpoint
address can be used:
- when accessing endpoint files in FunctionFS filesystemi (in file name),
- in setup requests directed to specific endpoint (in wIndex field),
- in descriptors returned by FUNCTIONFS_ENDPOINT_DESC ioctl.

In endpoint file names the endpoint address number is formatted as
double-digit hexadecimal value ("ep%02x") which has few advantages -
it is easy to parse, allows to easly recognize endpoint direction basing
on its name (IN endpoint number starts with digit 8, and OUT with 0)
which can be useful for debugging purpose, and it makes easier to introduce
further features allowing to use each endpoint number in both directions
to have more endpoints available for function if hardware supports this
(for example we could have ep01 which is endpoint 1 with OUT direction,
and ep81 which is endpoint 1 with IN direction).

Physical endpoint address can be still obtained using ioctl named
FUNCTIONFS_ENDPOINT_REVMAP, but now it's not neccesary to handle
USB transactions properly.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/f_fs.c           | 23 +++++++++++++++++++++--
 drivers/usb/gadget/u_fs.h           |  2 ++
 include/uapi/linux/usb/functionfs.h |  1 +
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 7f16c5a..9f31692 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1550,7 +1550,10 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 		epfile->ffs = ffs;
 		mutex_init(&epfile->mutex);
 		init_waitqueue_head(&epfile->wait);
-		sprintf(epfiles->name, "ep%u",  i);
+		if (ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
+			sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
+		else
+			sprintf(epfiles->name, "ep%u", i);
 		if (!unlikely(ffs_sb_create_file(ffs->sb, epfiles->name, epfile,
 						 &ffs_epfile_operations,
 						 &epfile->dentry))) {
@@ -1911,9 +1914,11 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 		break;
 	case FUNCTIONFS_DESCRIPTORS_MAGIC_V2:
 		flags = get_unaligned_le32(data + 8);
+		ffs->user_flags = flags;
 		if (flags & ~(FUNCTIONFS_HAS_FS_DESC |
 			      FUNCTIONFS_HAS_HS_DESC |
-			      FUNCTIONFS_HAS_SS_DESC)) {
+			      FUNCTIONFS_HAS_SS_DESC |
+			      FUNCTIONFS_VIRTUAL_ADDR)) {
 			ret = -ENOSYS;
 			goto error;
 		}
@@ -2254,7 +2259,13 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	} else {
 		struct usb_request *req;
 		struct usb_ep *ep;
+		u8 bEndpointAddress;
 
+		/*
+		 * We back up bEndpointAddress because autoconfig overwrites
+		 * it with physical endpoint address.
+		 */
+		bEndpointAddress = ds->bEndpointAddress;
 		pr_vdebug("autoconfig\n");
 		ep = usb_ep_autoconfig(func->gadget, ds);
 		if (unlikely(!ep))
@@ -2269,6 +2280,12 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 		ffs_ep->req = req;
 		func->eps_revmap[ds->bEndpointAddress &
 				 USB_ENDPOINT_NUMBER_MASK] = idx + 1;
+		/*
+		 * If we use virtual address mapping, we restore
+		 * original bEndpointAddress value.
+		 */
+		if (func->ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
+			ds->bEndpointAddress = bEndpointAddress;
 	}
 	ffs_dump_mem(": Rewritten ep desc", ds, ds->bLength);
 
@@ -2592,6 +2609,8 @@ static int ffs_func_setup(struct usb_function *f,
 		ret = ffs_func_revmap_ep(func, le16_to_cpu(creq->wIndex));
 		if (unlikely(ret < 0))
 			return ret;
+		if (func->ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
+			ret = func->ffs->eps_addrmap[ret];
 		break;
 
 	default:
diff --git a/drivers/usb/gadget/u_fs.h b/drivers/usb/gadget/u_fs.h
index fe31eba..adc6568 100644
--- a/drivers/usb/gadget/u_fs.h
+++ b/drivers/usb/gadget/u_fs.h
@@ -217,6 +217,8 @@ struct ffs_data {
 	unsigned			hs_descs_count;
 	unsigned			ss_descs_count;
 
+	unsigned			user_flags;
+
 	u8				eps_addrmap[15];
 
 	unsigned short			strings_count;
diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 1ab6f06..af4f61c 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -18,6 +18,7 @@ enum functionfs_flags {
 	FUNCTIONFS_HAS_FS_DESC = 1,
 	FUNCTIONFS_HAS_HS_DESC = 2,
 	FUNCTIONFS_HAS_SS_DESC = 4,
+	FUNCTIONFS_VIRTUAL_ADDR = 8,
 };
 
 #ifndef __KERNEL__
-- 
1.9.1

