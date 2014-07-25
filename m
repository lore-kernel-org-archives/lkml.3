Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbaGYNg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:36:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58618 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760406AbaGYNgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:36:24 -0400
X-AuditID: cbfee61a-f79e46d00000134f-33-53d25d561cba
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 3/3] usb: gadget: f_fs: make numbers in ep file names the
 same as ep addresses
Date: Fri, 25 Jul 2014 15:36:03 +0200
Message-id: <1406295363-26998-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQd2w2EvBBmc/6VjMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWC463sFo8OLyT3YHDY//cNewe6/68YvLo27KK0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBlfOmawV7wQ6xiV/s9lgbGK0JdjJwcEgImEl2r/jBC2GIS
	F+6tZ+ti5OIQEpjOKDF990dmkISQQDuTxKNDhiA2m4COxJbvE8AaRAQEJNa/uMQO0sAscJxR
	YuanL0wgCWGBZInr7QfBmlkEVCUu73vMBmLzCrhKHNx6mwlim5zEyWOTWUFsTgE3iYZ1u4Hi
	HEDLXCW6TttNYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4uJ5J7WBc2WBxiFGA
	g1GJh7ej/mKwEGtiWXFl7iFGCQ5mJRHe2qhLwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7Ra
	BwoJpCeWpGanphakFsFkmTg4pRoYz+5bd35jrOHik7a3zd88z2/M03/5cPYPaW+fcq4Lzq3J
	9zczu7JNeLU1rOXZ6d4/h6wXVNSY2BXXL67k2HHYx0nqyMGZHL0Vd/QXxHqpf1mzbsGWZ19+
	X7uYFugXvnj5tK3ri1/aPIpMzt22T6KsID3/4b7HdfpLry/YE3nwW8ltho7ZfdNkHimxFGck
	GmoxFxUnAgAmdDEZKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds FUNCTIONFS_ADDR_NAMES flag to user flags set in
descriptors, which makes numbers in endpoint file names the same as
value of bEndpointAddress in endpoint descriptor. It simplifies endpoint
handling, because now it can be refered using one unique number.

Numbers are in hexadecimal format to have each name of the same lenght,
and to simplify debugging. The first digit can be 0 or 8 which means
OUT or IN endpoint direction, and the second digit is simply hexadecimal
value of endpoint number (which is between 1 and 15).

It needed to store user flags to the moment of endpoint files creation,
and for this reason there is new field in struct ffs_data named user_flags.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/f_fs.c           | 11 ++++++++---
 drivers/usb/gadget/u_fs.h           |  2 ++
 include/uapi/linux/usb/functionfs.h |  1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index a2e18cc..0b8040b 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1550,8 +1550,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 		epfile->ffs = ffs;
 		mutex_init(&epfile->mutex);
 		init_waitqueue_head(&epfile->wait);
-		sprintf(epfiles->name, "ep%u",
-			ffs->eps_addrmap[i] & USB_ENDPOINT_NUMBER_MASK);
+		if (ffs->user_flags & FUNCTIONFS_ADDR_NAMES)
+			sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
+		else
+			sprintf(epfiles->name, "ep%u",
+				ffs->eps_addrmap[i] & USB_ENDPOINT_NUMBER_MASK);
 		if (!unlikely(ffs_sb_create_file(ffs->sb, epfiles->name, epfile,
 						 &ffs_epfile_operations,
 						 &epfile->dentry))) {
@@ -1912,9 +1915,11 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 		break;
 	case FUNCTIONFS_DESCRIPTORS_MAGIC_V2:
 		flags = get_unaligned_le32(data + 8);
+		ffs->user_flags = flags;
 		if (flags & ~(FUNCTIONFS_HAS_FS_DESC |
 			      FUNCTIONFS_HAS_HS_DESC |
-			      FUNCTIONFS_HAS_SS_DESC)) {
+			      FUNCTIONFS_HAS_SS_DESC |
+			      FUNCTIONFS_ADDR_NAMES)) {
 			ret = -ENOSYS;
 			goto error;
 		}
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
index 1ab6f06..a29d910 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -18,6 +18,7 @@ enum functionfs_flags {
 	FUNCTIONFS_HAS_FS_DESC = 1,
 	FUNCTIONFS_HAS_HS_DESC = 2,
 	FUNCTIONFS_HAS_SS_DESC = 4,
+	FUNCTIONFS_ADDR_NAMES = 8,
 };
 
 #ifndef __KERNEL__
-- 
1.9.1

