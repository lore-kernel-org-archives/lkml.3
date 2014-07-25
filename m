Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbaGYNgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:36:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58608 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353AbaGYNgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:36:17 -0400
X-AuditID: cbfee61b-f79f86d00000144c-92-53d25d4fdf79
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 1/3] usb: gadget: f_fs: virtual address mapping
Date: Fri, 25 Jul 2014 15:36:01 +0200
Message-id: <1406295363-26998-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3/2EvBBidm21jMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWC463sFo8OLyT3YHDY//cNewe6/68YvLo27KK0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBlXH72jaVgjk3F0dvv2RsY1xl0MXJySAiYSBza8YEZwhaT
	uHBvPVsXIxeHkMB0RolXm1YwQzjtTBIzpzWxglSxCehIbPk+gRHEFhEQkFj/4hI7SBGzwHFG
	iZmfvjCBJIQFnCQOnt3JDmKzCKhK3HlxCyzOK+AqcenMEyaIdXISJ49NBhvKKeAm0bBuN1Cc
	A2ibq0TXabsJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH1zPpHYyrGiwOMQpw
	MCrx8HbUXwwWYk0sK67MPcQowcGsJMJbG3UpWIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbr
	QCGB9MSS1OzU1ILUIpgsEwenVANjwporq6J+mIv2LN/GpR8npORyJW1K2QRVPq2CXuNNIj/X
	/8lRtwnY/2RDq5fp1P93jlWoiLTNa2Uw3Lwz4u+qBeuOXW3I+xfN9vnOM95/Ln5VnwWWfVlp
	0NT4hKlHdrpg7h/T/GnWu1tfLBXTcv7olpF/YEHSmv5r8W1hOeuL9q+SfZnwM4tTiaU4I9FQ
	i7moOBEADQWqgisCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds virtual endpoint address mapping to functionfs.

So far endpoint addresses given by user through endpoint descriptors
were ignored, and replaced by physical endpoint addresses. Endpoint
address in wIndex field of setup requesti, addressed to endpoint, was
the physical endpoint address, and names of files in functionfs
directory was numered in order, and were the same as indexes of
ffs_epfile in epfile array. In result user has no way to indicate
which file in functionfs is associated with which particular
requested endpoint. He also didn't know which endpoint is recipient
of setup request.

There was also one more problem - if endpoint addresses in descriptors
were non-consecutive, there were created redundant files, which could
cause problems in kernel, when user tryed to read/write to them.
It was result of fact that maximum endpoint address was taken as
total number of endpoints in funciton.

This patch solves this problems by introducing virtual endpoint address
mapping. Now each function has separate endpoint address space. Numbers
of endpoint files in functionfs and addresses in setup requests are
mapped to addresses choosen by user in endpoint descriptors.

It also introduces additional testing if desctiptors given by user are
consistent - if number of endpoints and their addresses in each speed
are the same.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/f_fs.c | 78 +++++++++++++++++++++++++++++++++++++++--------
 drivers/usb/gadget/u_fs.h |  2 ++
 2 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 165c2dd..490b30f 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -154,6 +154,12 @@ struct ffs_io_data {
 	struct usb_request *req;
 };
 
+struct ffs_desc_helper {
+	struct ffs_data *ffs;
+	unsigned interfaces_count;
+	unsigned eps_count;
+};
+
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
 
@@ -1527,7 +1533,8 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 		epfile->ffs = ffs;
 		mutex_init(&epfile->mutex);
 		init_waitqueue_head(&epfile->wait);
-		sprintf(epfiles->name, "ep%u",  i);
+		sprintf(epfiles->name, "ep%u",
+			ffs->eps_addrmap[i] & USB_ENDPOINT_NUMBER_MASK);
 		if (!unlikely(ffs_sb_create_file(ffs->sb, epfiles->name, epfile,
 						 &ffs_epfile_operations,
 						 &epfile->dentry))) {
@@ -1820,7 +1827,8 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 				u8 *valuep, struct usb_descriptor_header *desc,
 				void *priv)
 {
-	struct ffs_data *ffs = priv;
+	struct ffs_desc_helper *helper = priv;
+	struct usb_endpoint_descriptor *d;
 
 	ENTER();
 
@@ -1834,8 +1842,8 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 		 * encountered interface "n" then there are at least
 		 * "n+1" interfaces.
 		 */
-		if (*valuep >= ffs->interfaces_count)
-			ffs->interfaces_count = *valuep + 1;
+		if (*valuep >= helper->interfaces_count)
+			helper->interfaces_count = *valuep + 1;
 		break;
 
 	case FFS_STRING:
@@ -1843,14 +1851,23 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 		 * Strings are indexed from 1 (0 is magic ;) reserved
 		 * for languages list or some such)
 		 */
-		if (*valuep > ffs->strings_count)
-			ffs->strings_count = *valuep;
+		if (*valuep > helper->ffs->strings_count)
+			helper->ffs->strings_count = *valuep;
 		break;
 
 	case FFS_ENDPOINT:
-		/* Endpoints are indexed from 1 as well. */
-		if ((*valuep & USB_ENDPOINT_NUMBER_MASK) > ffs->eps_count)
-			ffs->eps_count = (*valuep & USB_ENDPOINT_NUMBER_MASK);
+		d = (void *)desc;
+		helper->eps_count++;
+		if (helper->eps_count >= 15)
+			return -EINVAL;
+		if (!helper->ffs->eps_count && !helper->ffs->interfaces_count)
+			helper->ffs->eps_addrmap[helper->eps_count] =
+				d->bEndpointAddress;
+		else if (helper->ffs->eps_count < helper->eps_count)
+			return -EINVAL;
+		else if (helper->ffs->eps_addrmap[helper->eps_count] !=
+				d->bEndpointAddress)
+			return -EINVAL;
 		break;
 	}
 
@@ -1863,6 +1880,7 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 	char *data = _data, *raw_descs;
 	unsigned counts[3], flags;
 	int ret = -EINVAL, i;
+	struct ffs_desc_helper helper;
 
 	ENTER();
 
@@ -1905,13 +1923,29 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 
 	/* Read descriptors */
 	raw_descs = data;
+	helper.ffs = ffs;
 	for (i = 0; i < 3; ++i) {
 		if (!counts[i])
 			continue;
+		helper.interfaces_count = 0;
+		helper.eps_count = 0;
 		ret = ffs_do_descs(counts[i], data, len,
-				   __ffs_data_do_entity, ffs);
+				   __ffs_data_do_entity, &helper);
 		if (ret < 0)
 			goto error;
+		if (!ffs->eps_count && !ffs->interfaces_count) {
+			ffs->eps_count = helper.eps_count;
+			ffs->interfaces_count = helper.interfaces_count;
+		} else {
+			if (ffs->eps_count != helper.eps_count) {
+				ret = -EINVAL;
+				goto error;
+			}
+			if (ffs->interfaces_count != helper.interfaces_count) {
+				ret = -EINVAL;
+				goto error;
+			}
+		}
 		data += ret;
 		len  -= ret;
 	}
@@ -2137,9 +2171,18 @@ static void ffs_event_add(struct ffs_data *ffs,
 	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
 }
 
-
 /* Bind/unbind USB function hooks *******************************************/
 
+static int ffs_ep_addr2idx(struct ffs_data *ffs, u8 endpoint_address)
+{
+	int i;
+
+	for (i = 1; i < 15; ++i)
+		if (ffs->eps_addrmap[i] == endpoint_address)
+			return i;
+	return -ENOENT;
+}
+
 static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 				    struct usb_descriptor_header *desc,
 				    void *priv)
@@ -2173,7 +2216,10 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	if (!desc || desc->bDescriptorType != USB_DT_ENDPOINT)
 		return 0;
 
-	idx = (ds->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) - 1;
+	idx = ffs_ep_addr2idx(func->ffs, ds->bEndpointAddress) - 1;
+	if (idx < 0)
+		return idx;
+
 	ffs_ep = func->eps + idx;
 
 	if (unlikely(ffs_ep->descs[ep_desc_id])) {
@@ -2192,7 +2238,13 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
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
@@ -2207,6 +2259,7 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 		ffs_ep->req = req;
 		func->eps_revmap[ds->bEndpointAddress &
 				 USB_ENDPOINT_NUMBER_MASK] = idx + 1;
+		ds->bEndpointAddress = bEndpointAddress;
 	}
 	ffs_dump_mem(": Rewritten ep desc", ds, ds->bLength);
 
@@ -2530,6 +2583,7 @@ static int ffs_func_setup(struct usb_function *f,
 		ret = ffs_func_revmap_ep(func, le16_to_cpu(creq->wIndex));
 		if (unlikely(ret < 0))
 			return ret;
+		ret = func->ffs->eps_addrmap[ret];
 		break;
 
 	default:
diff --git a/drivers/usb/gadget/u_fs.h b/drivers/usb/gadget/u_fs.h
index bf0ba37..fe31eba 100644
--- a/drivers/usb/gadget/u_fs.h
+++ b/drivers/usb/gadget/u_fs.h
@@ -217,6 +217,8 @@ struct ffs_data {
 	unsigned			hs_descs_count;
 	unsigned			ss_descs_count;
 
+	u8				eps_addrmap[15];
+
 	unsigned short			strings_count;
 	unsigned short			interfaces_count;
 	unsigned short			eps_count;
-- 
1.9.1

