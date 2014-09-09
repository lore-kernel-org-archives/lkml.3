Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaIIGXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:23:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45827 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaIIGXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:23:33 -0400
X-AuditID: cbfee61a-f79e46d00000134f-76-540e9ce34f0f
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v8 1/3] usb: gadget: f_fs: fix the redundant ep files problem
Date: Tue, 09 Sep 2014 08:23:15 +0200
Message-id: <1410243797-9719-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
References: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xgO7jOXwhBgfvCFscvF9v0bx4PZvF
	5V1z2CwWLWtltnhweCe7A6vH/rlr2D36tqxi9Dh+YzuTx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	M55vYSt4pl3x9/UhxgbG2cpdjJwcEgImEm/urmOEsMUkLtxbz9bFyMUhJLCIUeLWxW5GCKed
	SeJ7UydYFZuAjsSW7xPAbBEBAYn1Ly6xgxQxCzQySvz4PYMVJCEs4Ctxovkm0CgODhYBVYmO
	Z2D1vAIuEl8v74baJidx8thksHJOAVeJb2c2sIHYQkA1zzdMZ57AyLuAkWEVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnDYPJPawbiyweIQowAHoxIPb0YwX4gQa2JZcWXuIUYJDmYlEV7v
	GUAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjOIMQRYb
	O28n5Qm0uj84Jfxuk+Td4kbxuy4z3d988MqdnLPv95b23x2VS96lJoiXce/tb5J6tH3R6m22
	XzUyK/W7+fTOffRUj+rO7prwyF3/V8L7E2cPexXb2itNVO1qkrY89+jTlcUvHm1fz/RYu/pl
	4pIX9tuWv3784cOPQs3Gtcy5aWE8IkosxRmJhlrMRcWJAMS5PZ4XAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to now, when endpoint addresses in descriptors were non-consecutive,
there were created redundant files, which could cause problems in kernel,
when user tried to read/write to them. It was result of fact that maximum
endpoint address was taken as total number of endpoints in funciton.

This patch adds endpoint descriptors counting and storing their addresses
in eps_addrmap to verify their cohesion in each speed.

Endpoint address map would be also useful for further features, just like
vitual endpoint address mapping.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/function/f_fs.c | 66 +++++++++++++++++++++++++++++++-------
 drivers/usb/gadget/function/u_fs.h |  2 ++
 2 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index dc30adf..0dc3552d 100644
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
@@ -1853,14 +1860,22 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
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
+		/* Check if descriptors for any speed were already parsed */
+		if (!helper->ffs->eps_count && !helper->ffs->interfaces_count)
+			helper->ffs->eps_addrmap[helper->eps_count] =
+				d->bEndpointAddress;
+		else if (helper->ffs->eps_addrmap[helper->eps_count] !=
+				d->bEndpointAddress)
+			return -EINVAL;
 		break;
 	}
 
@@ -2053,6 +2068,7 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 	char *data = _data, *raw_descs;
 	unsigned os_descs_count = 0, counts[3], flags;
 	int ret = -EINVAL, i;
+	struct ffs_desc_helper helper;
 
 	ENTER();
 
@@ -2101,13 +2117,29 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 
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
@@ -2342,9 +2374,18 @@ static void ffs_event_add(struct ffs_data *ffs,
 	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
 }
 
-
 /* Bind/unbind USB function hooks *******************************************/
 
+static int ffs_ep_addr2idx(struct ffs_data *ffs, u8 endpoint_address)
+{
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(ffs->eps_addrmap); ++i)
+		if (ffs->eps_addrmap[i] == endpoint_address)
+			return i;
+	return -ENOENT;
+}
+
 static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 				    struct usb_descriptor_header *desc,
 				    void *priv)
@@ -2378,7 +2419,10 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
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

