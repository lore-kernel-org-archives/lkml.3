Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbbATTPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:15:49 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46242 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbbATTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:15 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 04/11] initramfs: change size of mtime and file length to 64 bits
Date: Tue, 20 Jan 2015 14:12:53 -0500
Message-Id: <1421781180-24425-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0033-0000-0000-000003647548
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Either we keep the current field ordering, making some fields
64 bits, or move the larger fields to the end.  This patch keeps
the same field ordering.

Requested-by: Rob Landley <rob@landley.net>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 init/initramfs.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 8917065..cec6fe1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -155,7 +155,8 @@ static __initdata time_t mtime;
 
 static __initdata unsigned long ino, major, minor, nlink;
 static __initdata umode_t mode;
-static __initdata unsigned long body_len, name_len, xattr_buflen;
+static __initdata uint64_t body_len;
+static __initdata unsigned long name_len, xattr_buflen;
 static __initdata uid_t uid;
 static __initdata gid_t gid;
 static __initdata unsigned rdev;
@@ -164,14 +165,21 @@ static __initdata int newcx;
 static void __init parse_header(char *s)
 {
 	unsigned long parsed[13];
-	char buf[9];
-	int ret;
+	uint64_t parsed64[2];
+	char buf[17];
+	bool ull = 0;
+	int ret = 0;
 	int i;
 
-	buf[8] = '\0';
-	for (i = 0; i < (!newcx ? 12 : 13); i++, s += 8) {
-		memcpy(buf, s, 8);
-		ret = kstrtoul(buf, 16, &parsed[i]);
+	buf[16] = '\0';
+	for (i = 0; i < (!newcx ? 12 : 13); i++, s += (ull ? 16 : 8)) {
+		ull = newcx && (i == 5 || i == 6);
+		
+		buf[8] = '\0';
+		memcpy(buf, s, ull ? 16 : 8);
+
+		ret = ull ?  kstrtoull(buf, 16, &parsed64[i - 5]) :
+			kstrtoul(buf, 16, &parsed[i]);
 		if (ret)
 			pr_err("invalid cpio header field (%d)", ret);
 	}
@@ -180,8 +188,8 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
-	mtime = parsed[5];
-	body_len = parsed[6];
+	mtime = !newcx ? parsed[5] : parsed64[0] / 1000000;
+	body_len = !newcx ? parsed[6] : parsed64[1];
 	major = parsed[7];
 	minor = parsed[8];
 	rdev = new_encode_dev(MKDEV(parsed[9], parsed[10]));
@@ -272,7 +280,7 @@ static int __init do_format(void)
 		error("no cpio magic");
 		return 1;
 	}
-	read_into(header_buf, !newcx ? 104: 112, GotHeader);
+	read_into(header_buf, !newcx ? 104: 128, GotHeader);
 	return 0;
 }
 
@@ -539,7 +547,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned long len)
 	const char *compress_name;
 	static __initdata char msg_buf[64];
 
-	header_buf = kmalloc(118, GFP_KERNEL);
+	header_buf = kmalloc(128, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
 	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
 	xattr_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-- 
1.8.1.4

