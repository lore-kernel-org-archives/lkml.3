Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaHTFrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:47:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaHTFrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:47:07 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ad-53f436590ea6
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4 1/3] usb: gadget: f_fs: fix the redundant ep files problem
Date: Wed, 20 Aug 2014 07:46:23 +0200
Message-id: <1408513585-28261-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
References: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd1Isy/BBne3C1vMetnOYnHwfr1F
	8+L1bBa3J05js7i8aw6bxaJlrcwWa4/cZbdYcLyF1eLB4Z3sDpwe++euYfdY9+cVk0ffllWM
	HsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugSvjT+tc1oLl2hWd9x+yNTA+VOpi5OCQEDCRODLf
	touRE8gUk7hwbz1bFyMXh5DAIkaJY5u/MkI47UwSJ28vZgWpYhPQkdjyfQIjiC0iICCx/sUl
	dpAiZoEHjBLtty6zgUwVFvCVWLtBH6SGRUBVYuqin8wgNq+Aq8SDa2sZIbbJSZw8NhlsJqeA
	m8TP7v1gNUJANW3HXjNOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4zJ5J7WBc
	2WBxiFGAg1GJh1ch+3OwEGtiWXFl7iFGCQ5mJRFeNo0vwUK8KYmVValF+fFFpTmpxYcYpTlY
	lMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYc+ZJHMqeFh3241b6iqs6nxac05g6+4jEvTXr
	2R+cjf4TmXvzQu/8w3O3bfkr5f6DoexQdhlb372a9TWGT4o+68+cnqH/vaquJ+5kzdeZJTOP
	OL7lv2DdnCcVtuXNU8d9lx7e/3OXwy1lTZP8+bmfTr8z3XfpT9rlCTwXZh7PjdnRucxW4etJ
	ti4lluKMREMt5qLiRACU88KjLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to now, when endpoint addresses in descriptors were non-consecutive,
there were created redundant files, which could cause problems in kernel,
when user tryed to read/write to them. It was result of fact that maximum
endpoint address was taken as total number of endpoints in funciton.

This patch adds endpoint descriptors counting and storing their addresses
in eps_addrmap to verify their cohesion in each speed.

Endpoint address map would be also useful for further features, just like
vitual endpoint address mapping.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/function/f_fs.c | 67 +++++++++++++++++++++++++++++++-------
 drivers/usb/gadget/function/u_fs.h |  2 ++
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index dc30adf..8096f22 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -155,6 +155,12 @@ struct ffs_io_data {
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
 
@@ -1830,7 +1836,8 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 				u8 *valuep, struct usb_descriptor_header *desc,
 				void *priv)
 {
-	struct ffs_data *ffs = priv;
+	struct ffs_desc_helper *helper = priv;
+	struct usb_endpoint_descriptor *d;
 
 	ENTER();
 
@@ -1844,8 +1851,8 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 		 * encountered interface "n" then there are at least
 		 * "n+1" interfaces.
 		 */
-		if (*valuep >= ffs->interfaces_count)
-			ffs->interfaces_count = *valuep + 1;
+		if (*valuep >= helper->interfaces_count)
+			helper->interfaces_count = *valuep + 1;
 		break;
 
 	case FFS_STRING:
@@ -1853,14 +1860,23 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
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
 
@@ -2053,6 +2069,7 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 	char *data = _data, *raw_descs;
 	unsigned os_descs_count = 0, counts[3], flags;
 	int ret = -EINVAL, i;
+	struct ffs_desc_helper helper;
 
 	ENTER();
 
@@ -2101,13 +2118,29 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 
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
@@ -2342,9 +2375,18 @@ static void ffs_event_add(struct ffs_data *ffs,
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
@@ -2378,7 +2420,10 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	if (!desc || desc->bDescriptorType != USB_DT_ENDPOINT)
 		return 0;
 
-	idx = (ds->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) - 1;
+	idx = ffs_ep_addr2idx(func->ffs, ds->bEndpointAddress) - 1;
+	if (idx < 0)
+		return idx;
+
 	ffs_ep = func->eps + idx;
 
 	if (unlikely(ffs_ep->descs[ep_desc_id])) {
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index 63d6e71..d48897e 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -224,6 +224,8 @@ struct ffs_data {
 	void				*ms_os_descs_ext_prop_name_avail;
 	void				*ms_os_descs_ext_prop_data_avail;
 
+	u8				eps_addrmap[15];
+
 	unsigned short			strings_count;
 	unsigned short			interfaces_count;
 	unsigned short			eps_count;
-- 
1.9.1

