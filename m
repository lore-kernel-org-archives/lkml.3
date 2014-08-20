Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaHTFrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:47:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22837 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaHTFrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:47:46 -0400
X-AuditID: cbfee61b-f79f86d00000144c-e9-53f4367d45e9
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4 3/3] usb: gadget: f_fs: virtual endpoint address mapping
Date: Wed, 20 Aug 2014 07:46:25 +0200
Message-id: <1408513585-28261-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
References: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd1asy/BBuenc1nMetnOYnHwfr1F
	8+L1bBa3J05js7i8aw6bxaJlrcwWa4/cZbdYcLyF1eLB4Z3sDpwe++euYfdY9+cVk0ffllWM
	HsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugSvj9+MOloJN6hUPf7cwNzAuVehi5OSQEDCROHTs
	HiuELSZx4d56ti5GLg4hgUWMEue3djJBOO1MEmdWfAWrYhPQkdjyfQIjiC0iICCx/sUldpAi
	ZoEHjBLtty6zgSSEBbwlPv6bzARiswioSnxf2AfWzCvgKtHdtZsFYp2cxMljk8HinAJuEj+7
	9zOD2EJANW3HXjNOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM41J5J72Bc1WBx
	iFGAg1GJh9eh/XOwEGtiWXFl7iFGCQ5mJRFeNo0vwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYQz9nsp7eXPS47Znh/L/3hc/dNWTmiOT0fqbYqHmg
	xm3zmv1Wr84I/w5xvH7OZHWUBvMTxr/Xbq1h+3fHMOjdIQ7D8G/71y5lb6tbdJh/xt+0B4Ib
	U/sOyKZNctgYvVpIc9PtBXyeLzkEWeZpxe3Sqe3Nf/fHUVrkl71K4Tn3jq72C+LO+xWilFiK
	MxINtZiLihMBeaIIIzECAAA=
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
 drivers/usb/gadget/function/f_fs.c  | 23 +++++++++++++++++++++--
 drivers/usb/gadget/function/u_fs.h  |  2 ++
 include/uapi/linux/usb/functionfs.h |  1 +
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index ac7b16d..a20ac8d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1555,7 +1555,10 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
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
@@ -2105,10 +2108,12 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 		break;
 	case FUNCTIONFS_DESCRIPTORS_MAGIC_V2:
 		flags = get_unaligned_le32(data + 8);
+		ffs->user_flags = flags;
 		if (flags & ~(FUNCTIONFS_HAS_FS_DESC |
 			      FUNCTIONFS_HAS_HS_DESC |
 			      FUNCTIONFS_HAS_SS_DESC |
-			      FUNCTIONFS_HAS_MS_OS_DESC)) {
+			      FUNCTIONFS_HAS_MS_OS_DESC |
+			      FUNCTIONFS_VIRTUAL_ADDR)) {
 			ret = -ENOSYS;
 			goto error;
 		}
@@ -2463,7 +2468,13 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
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
@@ -2478,6 +2489,12 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
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
 
@@ -2922,6 +2939,8 @@ static int ffs_func_setup(struct usb_function *f,
 		ret = ffs_func_revmap_ep(func, le16_to_cpu(creq->wIndex));
 		if (unlikely(ret < 0))
 			return ret;
+		if (func->ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
+			ret = func->ffs->eps_addrmap[ret];
 		break;
 
 	default:
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index d48897e..cd128e3 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -224,6 +224,8 @@ struct ffs_data {
 	void				*ms_os_descs_ext_prop_name_avail;
 	void				*ms_os_descs_ext_prop_data_avail;
 
+	unsigned			user_flags;
+
 	u8				eps_addrmap[15];
 
 	unsigned short			strings_count;
diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 900896e..81d2da6 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -19,6 +19,7 @@ enum functionfs_flags {
 	FUNCTIONFS_HAS_HS_DESC = 2,
 	FUNCTIONFS_HAS_SS_DESC = 4,
 	FUNCTIONFS_HAS_MS_OS_DESC = 8,
+	FUNCTIONFS_VIRTUAL_ADDR = 16,
 };
 
 /* Descriptor of an non-audio endpoint */
-- 
1.9.1

