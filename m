Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbbATTPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:15:53 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34378 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbbATTNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:14 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 01/11] initramfs: separate reading cpio method from header
Date: Tue, 20 Jan 2015 14:12:50 -0500
Message-Id: <1421781180-24425-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0037-0000-0000-000000671585
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding xattr support, read the CPIO method
separately from the rest of the header.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 init/initramfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index ad1bd77..bb51b5b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -187,6 +187,7 @@ static void __init parse_header(char *s)
 
 static __initdata enum state {
 	Start,
+	GotFormat,
 	Collect,
 	GotHeader,
 	SkipIt,
@@ -230,7 +231,7 @@ static __initdata char *header_buf, *symlink_buf, *name_buf;
 
 static int __init do_start(void)
 {
-	read_into(header_buf, 110, GotHeader);
+	read_into(header_buf, 6, GotFormat);
 	return 0;
 }
 
@@ -248,7 +249,7 @@ static int __init do_collect(void)
 	return 0;
 }
 
-static int __init do_header(void)
+static int __init do_format(void)
 {
 	if (memcmp(collected, "070707", 6)==0) {
 		error("incorrect cpio method used: use -H newc option");
@@ -258,6 +259,12 @@ static int __init do_header(void)
 		error("no cpio magic");
 		return 1;
 	}
+	read_into(header_buf, 104, GotHeader);
+	return 0;
+}
+
+static int __init do_header(void)
+{
 	parse_header(collected);
 	next_header = this_header + N_ALIGN(name_len) + body_len;
 	next_header = (next_header + 3) & ~3;
@@ -400,6 +407,7 @@ static int __init do_symlink(void)
 
 static __initdata int (*actions[])(void) = {
 	[Start]		= do_start,
+	[GotFormat]	= do_format,
 	[Collect]	= do_collect,
 	[GotHeader]	= do_header,
 	[SkipIt]	= do_skip,
-- 
1.8.1.4

