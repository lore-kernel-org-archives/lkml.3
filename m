Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab3GOQ4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:56:00 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39041 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GOQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:55:58 -0400
Subject: [PATCH 04/11] pstore: Add compression support to pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:25:48 +0530
Message-ID: <20130715165548.1520.92409.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-2000-0000-0000-00000CE59879
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compression support to pstore which will help in capturing more data.
Initially, pstore will make a call to kmsg_dump with a bigger buffer
and will pass the size of bigger buffer to kmsg_dump and then compress
the data to registered buffer of registered size.

In case compression fails, pstore will capture the uncompressed
data by making a call again to kmsg_dump with registered_buffer
of registered size.

Pstore will indicate the data is compressed or not with a flag
in the write callback.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/platform.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 115 insertions(+), 9 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 20fa686..5b95524 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -26,6 +26,7 @@
 #include <linux/console.h>
 #include <linux/module.h>
 #include <linux/pstore.h>
+#include <linux/zlib.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
@@ -65,6 +66,12 @@ struct pstore_info *psinfo;
 
 static char *backend;
 
+/* Compression parameters */
+#define COMPR_LEVEL 6
+#define WINDOW_BITS 12
+#define MEM_LEVEL 4
+static struct z_stream_s stream;
+
 /* How much of the console log to snapshot */
 static unsigned long kmsg_bytes = 10240;
 
@@ -117,6 +124,80 @@ bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
 }
 EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
 
+/* Derived from logfs_compress() */
+static int pstore_compress(const void *in, void *out, size_t inlen,
+							size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+	err = zlib_deflateInit2(&stream, COMPR_LEVEL, Z_DEFLATED, WINDOW_BITS,
+						MEM_LEVEL, Z_DEFAULT_STRATEGY);
+	if (err != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	err = zlib_deflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_deflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	if (stream.total_out >= stream.total_in)
+		goto error;
+
+	ret = stream.total_out;
+error:
+	return ret;
+}
+
+/* Compress the text from dst into psinfo->buf. */
+static int zip_data(char *dst, size_t text_len)
+{
+	int zipped_len = pstore_compress(dst, psinfo->buf, text_len,
+							 psinfo->bufsize);
+
+	kfree(dst);
+	kfree(stream.workspace);
+	if (zipped_len < 0) {
+		pr_err("pstore: compression failed; returned %d\n", zipped_len);
+		pr_err("pstore: logging uncompressed oops/panic report\n");
+		return -1;
+	}
+
+	return zipped_len;
+}
+
+static char *allocate_buf_for_compression(unsigned long big_buf_sz)
+{
+	char *big_buf;
+
+	big_buf = kmalloc(big_buf_sz, GFP_KERNEL);
+	if (big_buf) {
+		stream.workspace = kmalloc(zlib_deflate_workspacesize(
+					WINDOW_BITS, MEM_LEVEL), GFP_KERNEL);
+		if (!stream.workspace) {
+			pr_err("pstore: No memory for compression workspace; "
+				"skipping compression\n");
+			kfree(big_buf);
+			big_buf = NULL;
+		}
+	} else {
+		pr_err("No memory for uncompressed data; "
+			"skipping compression\n");
+		stream.workspace = NULL;
+	}
+
+	return big_buf;
+}
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -146,18 +227,43 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	oopscount++;
 	while (total < kmsg_bytes) {
 		char *dst;
-		unsigned long size;
-		int hsize;
+		unsigned long size, big_buf_sz;
+		int hsize = 0;
+		int zipped_len = -1;
 		size_t len;
-		bool compressed = false;
+		bool compressed;
+
+		big_buf_sz = (psinfo->bufsize * 100) / 45;
+		dst = allocate_buf_for_compression(big_buf_sz);
 
-		dst = psinfo->buf;
-		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part);
-		size = psinfo->bufsize - hsize;
-		dst += hsize;
+		if (dst) {
+			hsize = sprintf(dst, "%s#%d Part%d\n", why,
+							oopscount, part);
+			size = big_buf_sz - hsize;
+			dst += hsize;
 
-		if (!kmsg_dump_get_buffer(dumper, true, dst, size, &len))
-			break;
+			if (!kmsg_dump_get_buffer(dumper, true, dst,
+								size, &len))
+				break;
+
+			zipped_len = zip_data(dst, hsize + len);
+		}
+
+		if (zipped_len < 0) {
+			dst = psinfo->buf;
+			hsize = sprintf(dst, "%s#%d Part%d\n",
+					why, oopscount, part);
+			size = psinfo->bufsize - hsize;
+			dst += hsize;
+			compressed = false;
+
+			if (!kmsg_dump_get_buffer(dumper, true, dst,
+								size, &len))
+				break;
+		} else {
+			compressed = true;
+			len = zipped_len;
+		}
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
 				    oopscount, compressed, hsize + len, psinfo);

