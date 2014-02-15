Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBOX2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:28:53 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:58934 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaBOX2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:28:52 -0500
X-Authority-Analysis: v=2.0 cv=GMaK45xK c=1 sm=0 a=2fUkqGT2UzHXw691IaMUVw==:17 a=wom5GMh1gUkA:10 a=54cEe1tTtJ4A:10 a=zz6odIEfzeQA:10 a=hvm3MZhftXEA:10 a=kj9zAlcOel0A:10 a=7kYe3NcsAAAA:8 a=KGjhK52YXX0A:10 a=ZRhbIzv3Bf0A:10 a=4GIk4wJgsx0xqaYmr6wA:9 a=CjuIK1q_8ugA:10 a=-XA83Ip703gA:10 a=2fUkqGT2UzHXw691IaMUVw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.246.46.80
Date: Sat, 15 Feb 2014 18:28:44 -0500
From: "Daniel M. Weeks" <dan@danweeks.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] initramfs: Debug detected compression method
Message-ID: <20140215232836.GA32257@dev.danweeks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can greatly aid in narrowing down the real source of initramfs
problems such as failures related to the compression of the in-kernel
initramfs when an external initramfs is in use as well. Existing errors
are ambiguous as to which initramfs is a problem and why.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
---
 init/initramfs.c | 1 +
 lib/decompress.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/init/initramfs.c b/init/initramfs.c
index 93b6139..25d88b1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -455,6 +455,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 		}
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
+		printk(KERN_DEBUG "Detected %s compressed data\n", compress_name);
 		if (decompress) {
 			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
diff --git a/lib/decompress.c b/lib/decompress.c
index 4d1cd03..fc508fd 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -17,6 +17,8 @@
 #include <linux/string.h>
 #include <linux/init.h>
 
+#include <linux/printk.h>
+
 #ifndef CONFIG_DECOMPRESS_GZIP
 # define gunzip NULL
 #endif
@@ -61,6 +63,8 @@ decompress_fn __init decompress_method(const unsigned char *inbuf, int len,
 	if (len < 2)
 		return NULL;	/* Need at least this much... */
 
+	printk(KERN_DEBUG "Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
+
 	for (cf = compressed_formats; cf->name; cf++) {
 		if (!memcmp(inbuf, cf->magic, 2))
 			break;
-- 
Daniel M. Weeks
