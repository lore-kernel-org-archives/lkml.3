Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaFEHtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:49:23 -0400
Received: from mail-wg0-f73.google.com ([74.125.82.73]:65292 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaFEHtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:49:22 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 03:49:21 EDT
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/2] tools: ffs-test: convert to new descriptor format fixing compilation error
Date: Thu,  5 Jun 2014 09:43:26 +0200
Message-Id: <1401954206-8491-2-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1401954206-8491-1-git-send-email-mina86@mina86.com>
References: <1401954206-8491-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit [ac8dde11: “usb: gadget: f_fs: Add flags to descriptors block”]
which introduced a new descriptor format for FunctionFS removed the
usb_functionfs_descs_head structure, which is still used by ffs-test.
tool.

Convert ffs-test by converting it to use the new header format.  For
testing kernels prior to 3.14 (when the new format was introduced) and
parsing of the legacy headers in the new kernels, provide a compilation
flag to make the tool use the old format.

Finally, include information as to when the legacy FunctionFS headers
format has been deprecated (which is also when the new one has been
introduced).

Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Reported-by: Krzysztof Opasiak <k.opasiak@samsung.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/uapi/linux/usb/functionfs.h |  2 +-
 tools/usb/Makefile                  |  6 +++++-
 tools/usb/ffs-test.c                | 20 ++++++++++++++++++--
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 92c94e8..d54ba5d 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -60,7 +60,7 @@ struct usb_functionfs_descs_head {
  * structure.  Any flags that are not recognised cause the whole block to be
  * rejected with -ENOSYS.
  *
- * Legacy descriptors format:
+ * Legacy descriptors format (deprecated as of 3.14):
  *
  * | off | name      | type         | description                          |
  * |-----+-----------+--------------+--------------------------------------|
diff --git a/tools/usb/Makefile b/tools/usb/Makefile
index acf2165..d576b3b 100644
--- a/tools/usb/Makefile
+++ b/tools/usb/Makefile
@@ -6,7 +6,11 @@ WARNINGS = -Wall -Wextra
 CFLAGS = $(WARNINGS) -g -I../include
 LDFLAGS = $(PTHREAD_LIBS)
 
-all: testusb ffs-test
+all: testusb ffs-test ffs-test-legacy
+
+ffs-test-legacy: ffs-test.c
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) -DUSE_LEGACY_DESC_HEAD
+
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
 
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index fe1e66b..74b353d 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -1,5 +1,5 @@
 /*
- * ffs-test.c.c -- user mode filesystem api for usb composite function
+ * ffs-test.c -- user mode filesystem api for usb composite function
  *
  * Copyright (C) 2010 Samsung Electronics
  *                    Author: Michal Nazarewicz <mina86@mina86.com>
@@ -21,6 +21,8 @@
 
 /* $(CROSS_COMPILE)cc -Wall -Wextra -g -o ffs-test ffs-test.c -lpthread */
 
+/* Uncomment to make the tool use legacy FFS descriptor headers. */
+/* #define USE_LEGACY_DESC_HEAD */
 
 #define _BSD_SOURCE /* for endian.h */
 
@@ -106,7 +108,15 @@ static void _msg(unsigned level, const char *fmt, ...)
 /******************** Descriptors and Strings *******************************/
 
 static const struct {
-	struct usb_functionfs_descs_head header;
+	struct {
+		__le32 magic;
+		__le32 length;
+#ifndef USE_LEGACY_DESC_HEAD
+		__le32 flags;
+#endif
+		__le32 fs_count;
+		__le32 hs_count;
+	} __attribute__((packed)) header;
 	struct {
 		struct usb_interface_descriptor intf;
 		struct usb_endpoint_descriptor_no_audio sink;
@@ -114,7 +124,13 @@ static const struct {
 	} __attribute__((packed)) fs_descs, hs_descs;
 } __attribute__((packed)) descriptors = {
 	.header = {
+#ifdef USE_LEGACY_DESC_HEAD
 		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
+#else
+		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
+		.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
+				     FUNCTIONFS_HAS_HS_DESC),
+#endif
 		.length = cpu_to_le32(sizeof descriptors),
 		.fs_count = 3,
 		.hs_count = 3,
-- 
2.0.0.526.g5318336

