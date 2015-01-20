Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbbATTNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:13:49 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34396 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbbATTNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:17 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 08/11] gen_init_cpio: change size of mtime and file length to 64 bits
Date: Tue, 20 Jan 2015 14:12:57 -0500
Message-Id: <1421781180-24425-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0037-0000-0000-00000067158B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Either we keep the current field ordering, making some fields
64 bits or move the larger fields to the end.  This patch keeps
the same field ordering.

Requested-by: Rob Landley <rob@landley.net>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 usr/gen_init_cpio.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 08994d6..55dab65 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <string.h>
@@ -23,14 +24,15 @@
 
 static char *newcfmt = "%s%08X%08X%08lX%08lX%08X%08lX"
 			"%08X%08X%08X%08X%08X%08X%15$08X";
-static char *newcxfmt = "%s%08X%08X%08lX%08lX%08X%08lX"
-			"%08X%08X%08X%08X%08X%08X%08X%08X";
+static char *newcxfmt = "%s%08X%08X%08lX%08lX%08X%016llX"
+			"%016llX%08X%08X%08X%08X%08X%08X%08X";
 
 static int newcx;
 
 static unsigned int offset;
 static unsigned int ino = 721;
 static time_t default_mtime;
+static uint64_t default_mtime_usec;
 
 struct file_handler {
 	const char *type;
@@ -128,7 +130,7 @@ static void push_rest(const char *name)
 	putchar(0);
 	offset += name_len;
 
-	tmp_ofs = name_len + (newcx ? 118 : 110);
+	tmp_ofs = name_len + (newcx ? 130 : 110);
 	while (tmp_ofs & 3) {
 		putchar(0);
 		offset++;
@@ -139,7 +141,7 @@ static void push_rest(const char *name)
 static void push_hdr(const char *s)
 {
 	fputs(s, stdout);
-	offset += newcx ? 118 : 110;
+	offset += newcx ? 130 : 110;
 }
 
 static void cpio_trailer(void)
@@ -199,7 +201,8 @@ static int cpio_mkslink(const char *name, const char *target,
 		(long) uid,		/* uid */
 		(long) gid,		/* gid */
 		1,			/* nlink */
-		(long) default_mtime,	/* mtime */
+		newcx ? default_mtime_usec :
+		  (long) default_mtime,	/* mtime */
 		(unsigned)strlen(target)+1, /* filesize */
 		3,			/* major */
 		1,			/* minor */
@@ -251,7 +254,8 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 		(long) uid,		/* uid */
 		(long) gid,		/* gid */
 		2,			/* nlink */
-		(long) default_mtime,	/* mtime */
+		newcx ? default_mtime_usec :
+		  (long) default_mtime,	/* mtime */
 		0,			/* filesize */
 		3,			/* major */
 		1,			/* minor */
@@ -347,7 +351,8 @@ static int cpio_mknod(const char *name, unsigned int mode,
 		(long) uid,		/* uid */
 		(long) gid,		/* gid */
 		1,			/* nlink */
-		(long) default_mtime,	/* mtime */
+		newcx ? default_mtime_usec :
+		  (long) default_mtime,	/* mtime */
 		0,			/* filesize */
 		3,			/* major */
 		1,			/* minor */
@@ -389,7 +394,7 @@ static int cpio_mkfile(const char *name, const char *location,
 	char s[256];
 	char *filebuf = NULL;
 	struct stat buf;
-	long size;
+	uint64_t size;
 	int file = -1;
 	int retval;
 	int rc = -1;
@@ -442,7 +447,8 @@ static int cpio_mkfile(const char *name, const char *location,
 			(long) uid,		/* uid */
 			(long) gid,		/* gid */
 			nlinks,			/* nlink */
-			(long) buf.st_mtime,	/* mtime */
+			newcx ?  (uint64_t) buf.st_mtime * 1000000 :
+			  (long) buf.st_mtime,	/* mtime */
 			size,			/* filesize */
 			3,			/* major */
 			1,			/* minor */
@@ -664,6 +670,7 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	default_mtime_usec = default_mtime * 1000000;	
 	while (fgets(line, LINE_SIZE, cpio_list)) {
 		int type_idx;
 		size_t slen = strlen(line);
-- 
1.8.1.4

