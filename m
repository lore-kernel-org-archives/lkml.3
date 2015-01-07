Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbbAGUzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:55:47 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44784 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbbAGUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:53:15 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 4/9] gen_init_cpio: define new CPIO format to support xattrs
Date: Wed,  7 Jan 2015 15:52:55 -0500
Message-Id: <1420663980-20842-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010720-0033-0000-0000-0000033DA3BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a new CPIO method 070703 for including xattrs.
The new format extends the existing NEWC header to include the
buffer size containing the number of xattrs, the xattr(s) name,
data size, and data.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 usr/gen_init_cpio.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index ee35361..0d9c6e8 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -21,7 +21,11 @@
 #define str(s) xstr(s)
 
 static char *newcfmt = "%s%08X%08X%08lX%08lX%08X%08lX"
-			"%08X%08X%08X%08X%08X%08X%08X";
+			"%08X%08X%08X%08X%08X%08X%15$08X";
+static char *newcxfmt = "%s%08X%08X%08lX%08lX%08X%08lX"
+			"%08X%08X%08X%08X%08X%08X%08X%08X";
+
+static int newcx;
 
 static unsigned int offset;
 static unsigned int ino = 721;
@@ -58,7 +62,7 @@ static void push_rest(const char *name)
 	putchar(0);
 	offset += name_len;
 
-	tmp_ofs = name_len + 110;
+	tmp_ofs = name_len + (newcx ? 118 : 110);
 	while (tmp_ofs & 3) {
 		putchar(0);
 		offset++;
@@ -69,7 +73,7 @@ static void push_rest(const char *name)
 static void push_hdr(const char *s)
 {
 	fputs(s, stdout);
-	offset += 110;
+	offset += newcx ? 118 : 110;
 }
 
 static void cpio_trailer(void)
@@ -77,8 +81,8 @@ static void cpio_trailer(void)
 	char s[256];
 	const char name[] = "TRAILER!!!";
 
-	sprintf(s, newcfmt,
-		"070701",		/* magic */
+	sprintf(s, newcx ? newcxfmt : newcfmt,
+		newcx ? "070703": "070701",/* magic */
 		0,			/* ino */
 		0,			/* mode */
 		(long) 0,		/* uid */
@@ -91,6 +95,7 @@ static void cpio_trailer(void)
 		0,			/* rmajor */
 		0,			/* rminor */
 		(unsigned)strlen(name)+1, /* namesize */
+		0,			/* xattrs-size */
 		0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
@@ -108,8 +113,8 @@ static int cpio_mkslink(const char *name, const char *target,
 
 	if (name[0] == '/')
 		name++;
-	sprintf(s, newcfmt,
-		"070701",		/* magic */
+	sprintf(s, newcx ? newcxfmt : newcfmt,
+		newcx ? "070703": "070701",/* magic */
 		ino++,			/* ino */
 		S_IFLNK | mode,		/* mode */
 		(long) uid,		/* uid */
@@ -122,6 +127,7 @@ static int cpio_mkslink(const char *name, const char *target,
 		0,			/* rmajor */
 		0,			/* rminor */
 		(unsigned)strlen(name) + 1,/* namesize */
+		0,			/* xattrs-size */
 		0);			/* chksum */
 	push_hdr(s);
 	push_string(name);
@@ -156,8 +162,8 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 
 	if (name[0] == '/')
 		name++;
-	sprintf(s, newcfmt,
-		"070701",		/* magic */
+	sprintf(s, newcx ? newcxfmt : newcfmt,
+		newcx ? "070703": "070701",/* magic */
 		ino++,			/* ino */
 		mode,			/* mode */
 		(long) uid,		/* uid */
@@ -170,6 +176,7 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 		0,			/* rmajor */
 		0,			/* rminor */
 		(unsigned)strlen(name) + 1,/* namesize */
+		0,			/* xattrs-size */
 		0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
@@ -249,8 +256,8 @@ static int cpio_mknod(const char *name, unsigned int mode,
 
 	if (name[0] == '/')
 		name++;
-	sprintf(s, newcfmt,
-		"070701",		/* magic */
+	sprintf(s, newcx ? newcxfmt : newcfmt,
+		newcx ? "070703": "070701",/* magic */
 		ino++,			/* ino */
 		mode,			/* mode */
 		(long) uid,		/* uid */
@@ -263,6 +270,7 @@ static int cpio_mknod(const char *name, unsigned int mode,
 		maj,			/* rmajor */
 		min,			/* rminor */
 		(unsigned)strlen(name) + 1,/* namesize */
+		0,			/* xattrs-size */
 		0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
@@ -338,8 +346,8 @@ static int cpio_mkfile(const char *name, const char *location,
 		if (name[0] == '/')
 			name++;
 		namesize = strlen(name) + 1;
-		sprintf(s, newcfmt,
-			"070701",		/* magic */
+		sprintf(s, newcx ? newcxfmt : newcfmt,
+			newcx ? "070703": "070701",/* magic */
 			ino,			/* ino */
 			mode,			/* mode */
 			(long) uid,		/* uid */
@@ -352,6 +360,7 @@ static int cpio_mkfile(const char *name, const char *location,
 			0,			/* rmajor */
 			0,			/* rminor */
 			namesize,		/* namesize */
+			0,			/* xattrs-size */
 			0);			/* chksum */
 		push_hdr(s);
 		push_string(name);
-- 
1.8.1.4

