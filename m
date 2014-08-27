Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbaH0VHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:07:33 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:51097 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257AbaH0VEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:04:15 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 17:04:15 EDT
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/5] tools: ffs-test: convert to new descriptor format
Date: Wed, 27 Aug 2014 22:58:46 +0200
Message-Id: <1409173129-19603-3-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409173129-19603-1-git-send-email-mina86@mina86.com>
References: <1409173129-19603-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [ac8dde11: “Add flags to descriptors block”] functionfs
supports a new, more powerful and extensible, descriptor format.
Since ffs-test is probably the first thing users of the functionfs
interface see when they start writing functionfs user space daemons,
convert it to use the new format thus promoting it.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/uapi/linux/usb/functionfs.h |  2 +-
 tools/usb/ffs-test.c                | 14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 3ca03de..6d2a16b 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -102,7 +102,7 @@ struct usb_ext_prop_desc {
  * structure.  Any flags that are not recognised cause the whole block to be
  * rejected with -ENOSYS.
  *
- * Legacy descriptors format:
+ * Legacy descriptors format (deprecated as of 3.14):
  *
  * | off | name      | type         | description                          |
  * |-----+-----------+--------------+--------------------------------------|
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index a87e99f..708d317 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -1,5 +1,5 @@
 /*
- * ffs-test.c.c -- user mode filesystem api for usb composite function
+ * ffs-test.c -- user mode filesystem api for usb composite function
  *
  * Copyright (C) 2010 Samsung Electronics
  *                    Author: Michal Nazarewicz <mina86@mina86.com>
@@ -106,7 +106,9 @@ static void _msg(unsigned level, const char *fmt, ...)
 /******************** Descriptors and Strings *******************************/
 
 static const struct {
-	struct usb_functionfs_descs_head header;
+	struct usb_functionfs_descs_head_v2 header;
+	__le32 fs_count;
+	__le32 hs_count;
 	struct {
 		struct usb_interface_descriptor intf;
 		struct usb_endpoint_descriptor_no_audio sink;
@@ -114,11 +116,12 @@ static const struct {
 	} __attribute__((packed)) fs_descs, hs_descs;
 } __attribute__((packed)) descriptors = {
 	.header = {
-		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
+		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
+		.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
+				     FUNCTIONFS_HAS_HS_DESC),
 		.length = cpu_to_le32(sizeof descriptors),
-		.fs_count = cpu_to_le32(3),
-		.hs_count = cpu_to_le32(3),
 	},
+	.fs_count = cpu_to_le32(3),
 	.fs_descs = {
 		.intf = {
 			.bLength = sizeof descriptors.fs_descs.intf,
@@ -142,6 +145,7 @@ static const struct {
 			/* .wMaxPacketSize = autoconfiguration (kernel) */
 		},
 	},
+	.hs_count = cpu_to_le32(3),
 	.hs_descs = {
 		.intf = {
 			.bLength = sizeof descriptors.fs_descs.intf,
-- 
2.1.0.rc2.206.gedb03e5

