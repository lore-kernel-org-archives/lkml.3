Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbbATTPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:15:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46239 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbbATTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:15 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 07/11] gen_init_cpio: include the file extended attributes
Date: Tue, 20 Jan 2015 14:12:56 -0500
Message-Id: <1421781180-24425-8-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0033-0000-0000-00000364754E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reads the xattr(s), creating a buffer containing the
number of xattrs, the xattr(s) name, data size, and data. The
resulting buffer size is included in the CPIO header and the
buffer data is written after the file name.

This patch also defines the '-x' option to enable the inclusion
of the xattrs.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 usr/gen_init_cpio.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 100 insertions(+), 7 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 0d9c6e8..08994d6 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -9,6 +9,7 @@
 #include <errno.h>
 #include <ctype.h>
 #include <limits.h>
+#include <attr/xattr.h>
 
 /*
  * Original work by Jeff Garzik
@@ -36,6 +37,71 @@ struct file_handler {
 	int (*handler)(const char *line);
 };
 
+#define MAX_XATTRNAMES_SIZE 500
+static char xattr_names[MAX_XATTRNAMES_SIZE];
+static char xattr_header[8];	/* number xattrs */
+static ssize_t xattr_nameslen;
+static unsigned int xattrs_buflen;
+
+static char xattr_buf[1000];
+static unsigned int get_xattrs(const char *name)
+{
+    	char xattr_num[9];
+    	char *xname, *buf, *bufend;
+	int xattrsize = 0, num_xattrs = 0;
+
+	xattr_nameslen = listxattr(name, NULL, 0);
+	if (xattr_nameslen <= 0 || xattr_nameslen > MAX_XATTRNAMES_SIZE)
+		return 0;
+
+	xattr_names[xattr_nameslen] = 0;
+	xattr_nameslen = listxattr(name, xattr_names, xattr_nameslen);
+	if (xattr_nameslen <= 0)
+		return 0;
+
+	/* xattr format: name value-len value */
+	buf = xattr_buf + sizeof xattr_header;
+	bufend = xattr_buf + sizeof xattr_buf;
+
+	for (xname = xattr_names; xname < (xattr_names + xattr_nameslen);
+		xname += strlen(xname) + 1) {
+		char sizebuf[9];
+		int offset;
+
+		/* skip security.evm as it is file system specific */
+		if (strcmp(xname, "security.evm") == 0)
+			continue;
+
+		offset = strlen(xname) + 1 + 8;
+		xattrsize = getxattr(name, xname, NULL, 0);
+		if (buf + offset + xattrsize > bufend) {
+			fprintf(stderr, "%s: xattrs too large \n", name);
+			return 0;
+		}
+
+		xattrsize = getxattr(name, xname, buf + offset,
+				     bufend - (buf + offset));
+		if (xattrsize <= 0)
+			continue;
+		
+		num_xattrs++;
+		fprintf(stderr, "%s: %s %x (%d)\n", name, xname, xattrsize,
+			num_xattrs);
+		strcpy(buf, xname);
+		buf += strlen(xname) + 1;
+		sprintf(sizebuf, "%08X", (int)xattrsize); 
+		memcpy(buf, sizebuf, 8);
+		buf += (8 + xattrsize);
+	}
+
+	*buf = 0;
+	buf++;
+	sprintf(xattr_num, "%08X", num_xattrs);
+	memcpy(xattr_buf, xattr_num, 8);
+
+	return buf - xattr_buf;
+}
+
 static void push_string(const char *name)
 {
 	unsigned int name_len = strlen(name) + 1;
@@ -106,11 +172,24 @@ static void cpio_trailer(void)
 	}
 }
 
+static void include_xattrs(void)
+{
+	if (!xattrs_buflen)
+		return;
+	
+	if (fwrite(xattr_buf, xattrs_buflen, 1, stdout) != 1)
+		fprintf(stderr, "writing xattrs failed\n");
+	offset += xattrs_buflen;
+
+	push_pad();
+}
+
 static int cpio_mkslink(const char *name, const char *target,
 			 unsigned int mode, uid_t uid, gid_t gid)
 {
 	char s[256];
 
+	xattrs_buflen = newcx ? get_xattrs(name) : 0;
 	if (name[0] == '/')
 		name++;
 	sprintf(s, newcx ? newcxfmt : newcfmt,
@@ -127,13 +206,15 @@ static int cpio_mkslink(const char *name, const char *target,
 		0,			/* rmajor */
 		0,			/* rminor */
 		(unsigned)strlen(name) + 1,/* namesize */
-		0,			/* xattrs-size */
+		xattrs_buflen,		/* xattrs-size */
 		0);			/* chksum */
 	push_hdr(s);
 	push_string(name);
 	push_pad();
 	push_string(target);
 	push_pad();
+	if (newcx)
+		include_xattrs();
 	return 0;
 }
 
@@ -160,6 +241,7 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 {
 	char s[256];
 
+	xattrs_buflen = newcx ? get_xattrs(name) : 0;
 	if (name[0] == '/')
 		name++;
 	sprintf(s, newcx ? newcxfmt : newcfmt,
@@ -176,10 +258,12 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 		0,			/* rmajor */
 		0,			/* rminor */
 		(unsigned)strlen(name) + 1,/* namesize */
-		0,			/* xattrs-size */
+		xattrs_buflen,		/* xattrs-size */
 		0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
+	if (newcx)
+		include_xattrs();
 	return 0;
 }
 
@@ -339,9 +423,14 @@ static int cpio_mkfile(const char *name, const char *location,
 	}
 
 	size = 0;
+	xattrs_buflen = 0;
 	for (i = 1; i <= nlinks; i++) {
 		/* data goes on last link */
-		if (i == nlinks) size = buf.st_size;
+		if (i == nlinks) {
+			size = buf.st_size;
+			if (newcx)
+				xattrs_buflen = get_xattrs(location);
+		}
 
 		if (name[0] == '/')
 			name++;
@@ -360,12 +449,13 @@ static int cpio_mkfile(const char *name, const char *location,
 			0,			/* rmajor */
 			0,			/* rminor */
 			namesize,		/* namesize */
-			0,			/* xattrs-size */
+			xattrs_buflen,		/* xattrs-size */
 			0);			/* chksum */
 		push_hdr(s);
 		push_string(name);
 		push_pad();
-
+		if (newcx)
+			include_xattrs();
 		if (size) {
 			if (fwrite(filebuf, size, 1, stdout) != 1) {
 				fprintf(stderr, "writing filebuf failed\n");
@@ -458,7 +548,7 @@ static int cpio_mkfile_line(const char *line)
 static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
-		"\t%s [-t <timestamp>] <cpio_list>\n"
+		"\t%s [-t <timestamp>] [-x] <cpio_list>\n"
 		"\n"
 		"<cpio_list> is a file containing newline separated entries that\n"
 		"describe the files to be included in the initramfs archive:\n"
@@ -535,7 +625,7 @@ int main (int argc, char *argv[])
 
 	default_mtime = time(NULL);
 	while (1) {
-		int opt = getopt(argc, argv, "t:h");
+		int opt = getopt(argc, argv, "t:h:x");
 		char *invalid;
 
 		if (opt == -1)
@@ -550,6 +640,9 @@ int main (int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'x':
+			newcx = 1;
+			break;
 		case 'h':
 		case '?':
 			usage(argv[0]);
-- 
1.8.1.4

