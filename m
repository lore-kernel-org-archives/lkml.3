Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbbATTNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:13:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46236 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbATTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:15 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 03/11] initramfs: add extended attribute support
Date: Tue, 20 Jan 2015 14:12:52 -0500
Message-Id: <1421781180-24425-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0033-0000-0000-000003647547
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch writes out the extended attributes included in the cpio file.
As the "security.ima" xattr needs to be written after the file data,
this patch separates extracting and setting the xattrs by defining two
new states "GotXattrs" and "SetXattrs".

Changelog:
- "way too trusting of input data" - Rob Landley. Added some checking...

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 init/initramfs.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 10 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 5dd93ca..8917065 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -52,6 +52,7 @@ static void __init error(char *x)
 /* link hash */
 
 #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
+#define X_ALIGN(len) ((len + 3) & ~3)
 
 static __initdata struct hash {
 	int ino, minor, major;
@@ -154,20 +155,21 @@ static __initdata time_t mtime;
 
 static __initdata unsigned long ino, major, minor, nlink;
 static __initdata umode_t mode;
-static __initdata unsigned long body_len, name_len;
+static __initdata unsigned long body_len, name_len, xattr_buflen;
 static __initdata uid_t uid;
 static __initdata gid_t gid;
 static __initdata unsigned rdev;
+static __initdata int newcx;
 
 static void __init parse_header(char *s)
 {
-	unsigned long parsed[12];
+	unsigned long parsed[13];
 	char buf[9];
 	int ret;
 	int i;
 
 	buf[8] = '\0';
-	for (i = 0, s += 6; i < 12; i++, s += 8) {
+	for (i = 0; i < (!newcx ? 12 : 13); i++, s += 8) {
 		memcpy(buf, s, 8);
 		ret = kstrtoul(buf, 16, &parsed[i]);
 		if (ret)
@@ -184,6 +186,7 @@ static void __init parse_header(char *s)
 	minor = parsed[8];
 	rdev = new_encode_dev(MKDEV(parsed[9], parsed[10]));
 	name_len = parsed[11];
+	xattr_buflen = newcx ? parsed[12] : 0;
 }
 
 /* FSM */
@@ -195,7 +198,9 @@ static __initdata enum state {
 	GotHeader,
 	SkipIt,
 	GotName,
+	GotXattrs,
 	CopyFile,
+	SetXattrs,
 	GotSymlink,
 	Reset
 } state, next_state;
@@ -212,6 +217,8 @@ static inline void __init eat(unsigned n)
 }
 
 static __initdata char *vcollected;
+static __initdata char *ncollected;
+static __initdata u8 *xcollected;
 static __initdata char *collected;
 static long remains __initdata;
 static __initdata char *collect;
@@ -230,7 +237,7 @@ static void __init read_into(char *buf, unsigned size, enum state next)
 	}
 }
 
-static __initdata char *header_buf, *symlink_buf, *name_buf;
+static __initdata char *header_buf, *symlink_buf, *name_buf, *xattr_buf;
 
 static int __init do_start(void)
 {
@@ -254,22 +261,26 @@ static int __init do_collect(void)
 
 static int __init do_format(void)
 {
+	newcx = 0;
 	if (memcmp(collected, "070707", 6)==0) {
 		error("incorrect cpio method used: use -H newc option");
 		return 1;
 	}
-	if (memcmp(collected, "070701", 6)) {
+	if (memcmp(collected, "070703", 6) == 0)
+		newcx = 1;
+	else if (memcmp(collected, "070701", 6)) {
 		error("no cpio magic");
 		return 1;
 	}
-	read_into(header_buf, 104, GotHeader);
+	read_into(header_buf, !newcx ? 104: 112, GotHeader);
 	return 0;
 }
 
 static int __init do_header(void)
 {
 	parse_header(collected);
-	next_header = this_header + N_ALIGN(name_len) + body_len;
+	next_header = this_header + N_ALIGN(name_len) + X_ALIGN(xattr_buflen)
+	    + body_len;
 	next_header = (next_header + 3) & ~3;
 	state = SkipIt;
 	if (name_len <= 0 || name_len > PATH_MAX)
@@ -331,8 +342,64 @@ static void __init clean_path(char *path, umode_t fmode)
 	}
 }
 
-static __initdata int wfd;
+static int __init do_xattrs(void)
+{
+	state = next_state;
+	xcollected = kmalloc(xattr_buflen, GFP_KERNEL);
+	if (!xcollected)
+		panic("can't allocate xattr buffer");
+	memcpy(xcollected, collected, xattr_buflen);
+	return 0;
+}
+
+static int __init do_setxattrs(void)
+{
+	char *xattr_name = NULL;
+	int i, offset = 8, num_xattrs = 0;
+	unsigned xattr_value_size;
+	u8 *buf = xcollected;
+	u8 *bufend = buf + xattr_buflen - 1;
+
+	state = SkipIt;
+	next_state = Reset;
+
+	if (!newcx || xattr_buflen == 0 || !buf)
+		return 0;
+
+	*bufend = '\0';
+	sscanf(buf, "%08X", &num_xattrs);
+
+	/* xattr format: name value-len value */
+	for (i = 0; i < num_xattrs || buf + offset > bufend; i++) {
+		u8 *xattr_buf;
+		int ret;
 
+		xattr_name = buf + offset;
+		offset += (strlen(xattr_name) + 1);
+		if (buf + offset + 8 > bufend) {
+			error("malformed xattrs");
+			break;
+		}
+
+		ret = sscanf(buf + offset, "%08X", &xattr_value_size);
+		xattr_buf = buf + offset + 8;
+		if (ret != 1 || xattr_buf + xattr_value_size > bufend) {
+			error("malformed xattrs");
+			break;
+		}
+
+		ret = sys_setxattr(ncollected, xattr_name, xattr_buf,
+				   xattr_value_size, 0);
+		pr_debug("%s: %s size: %u (ret: %d)\n", ncollected, xattr_name,
+			xattr_value_size, ret);
+		offset += (8 + xattr_value_size);
+	}
+	kfree(ncollected);
+	kfree(xcollected);
+	return 0;
+}
+
+static __initdata int wfd;
 static int __init do_name(void)
 {
 	state = SkipIt;
@@ -373,6 +440,12 @@ static int __init do_name(void)
 			do_utime(collected, mtime);
 		}
 	}
+
+	if (xattr_buflen > 0) {
+		ncollected = kstrdup(collected, GFP_KERNEL);
+		next_state = (state == SkipIt) ? SetXattrs : state;
+		read_into(xattr_buf, X_ALIGN(xattr_buflen), GotXattrs);
+	}
 	return 0;
 }
 
@@ -385,7 +458,7 @@ static int __init do_copy(void)
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
 		eat(body_len);
-		state = SkipIt;
+		state = (newcx && xattr_buflen > 0)? SetXattrs : SkipIt;
 		return 0;
 	} else {
 		if (xwrite(wfd, victim, byte_count) != byte_count)
@@ -415,7 +488,9 @@ static __initdata int (*actions[])(void) = {
 	[GotHeader]	= do_header,
 	[SkipIt]	= do_skip,
 	[GotName]	= do_name,
+	[GotXattrs]	= do_xattrs,
 	[CopyFile]	= do_copy,
+	[SetXattrs]	= do_setxattrs,
 	[GotSymlink]	= do_symlink,
 	[Reset]		= do_reset,
 };
@@ -464,9 +539,10 @@ static char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	const char *compress_name;
 	static __initdata char msg_buf[64];
 
-	header_buf = kmalloc(110, GFP_KERNEL);
+	header_buf = kmalloc(118, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
 	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
+	xattr_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!header_buf || !symlink_buf || !name_buf)
 		panic("can't allocate buffers");
@@ -513,6 +589,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned long len)
 		len -= my_inptr;
 	}
 	dir_utime();
+	kfree(xattr_buf);
 	kfree(name_buf);
 	kfree(symlink_buf);
 	kfree(header_buf);
-- 
1.8.1.4

