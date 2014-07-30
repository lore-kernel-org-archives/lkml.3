Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaG3JoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:44:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaG3JoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:44:00 -0400
X-AuditID: cbfee61b-f79f86d00000144c-1f-53d8be5e83ab
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 1/3] usb: gadget: f_fs: fix the redundant ep files problem
Date: Wed, 30 Jul 2014 11:43:41 +0200
Message-id: <1406713423-32472-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
References: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd24fTeCDZZ8lLSY9bKdxeLg/XqL
	5sXr2SxuT5zGZnF51xw2i0XLWpkt1h65y26x4HgLq8WDwzvZHTg99s9dw+6x7s8rJo++LasY
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGub7frAVLtCouTZjK1MD4WLGLkZNDQsBE4szV
	icwQtpjEhXvr2boYuTiEBKYzSuxYspwJwmlnklj28g8jSBWbgI7Elu8TwGwRAQGJ9S8usYMU
	MQs8YJRov3WZDSQhLOArce/cOzCbRUBV4t31W2AreAVcJf5OvssGsU5O4uSxyawgNqeAm8TJ
	TQ+AhnIAbXOV+P7EawIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYH2THoH46oG
	i0OMAhyMSjy8M/5fDxZiTSwrrsw9xCjBwawkwtu39kawEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsb43VzHf88S/yf3Zreov5X5wyXl217+3nBit9f6
	KBnGradPW+UbhWqeFBB/pfhp08L4i7pOAfpfngRGMDDMm3xpSoRRo+XBeqEnuyN4Vh3Snrz8
	36W+udreEeYXP6uFr4sxTH/OHmtSe6ppUfdLTe2+6zmK2Vpf++Z1G2/ichW6/1Zl/g3RzJVK
	LMUZiYZazEXFiQCI3GQoMAIAAA==
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
 drivers/usb/gadget/f_fs.c | 67 +++++++++++++++++++++++++++++++++++++++--------
 drivers/usb/gadget/u_fs.h |  2 ++
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 165c2dd..6b806be 100644
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
 
@@ -1820,7 +1826,8 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 				u8 *valuep, struct usb_descriptor_header *desc,
 				void *priv)
 {
-	struct ffs_data *ffs = priv;
+	struct ffs_desc_helper *helper = priv;
+	struct usb_endpoint_descriptor *d;
 
 	ENTER();
 
@@ -1834,8 +1841,8 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
 		 * encountered interface "n" then there are at least
 		 * "n+1" interfaces.
 		 */
-		if (*valuep >= ffs->interfaces_count)
-			ffs->interfaces_count = *valuep + 1;
+		if (*valuep >= helper->interfaces_count)
+			helper->interfaces_count = *valuep + 1;
 		break;
 
 	case FFS_STRING:
@@ -1843,14 +1850,23 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
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
 
@@ -1863,6 +1879,7 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 	char *data = _data, *raw_descs;
 	unsigned counts[3], flags;
 	int ret = -EINVAL, i;
+	struct ffs_desc_helper helper;
 
 	ENTER();
 
@@ -1905,13 +1922,29 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 
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
@@ -2137,9 +2170,18 @@ static void ffs_event_add(struct ffs_data *ffs,
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
@@ -2173,7 +2215,10 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 	if (!desc || desc->bDescriptorType != USB_DT_ENDPOINT)
 		return 0;
 
-	idx = (ds->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) - 1;
+	idx = ffs_ep_addr2idx(func->ffs, ds->bEndpointAddress) - 1;
+	if (idx < 0)
+		return idx;
+
 	ffs_ep = func->eps + idx;
 
 	if (unlikely(ffs_ep->descs[ep_desc_id])) {
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

