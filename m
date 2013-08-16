Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3HPNSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:18:21 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53608 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3HPNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:18:15 -0400
Subject: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:48:05 +0530
Message-ID: <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-9574-0000-0000-00000935D569
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
 fs/pstore/platform.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 139 insertions(+), 9 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 20fa686..56218cb 100644
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
@@ -65,6 +66,15 @@ struct pstore_info *psinfo;
 
 static char *backend;
 
+/* Compression parameters */
+#define COMPR_LEVEL 6
+#define WINDOW_BITS 12
+#define MEM_LEVEL 4
+static struct z_stream_s stream;
+
+static char *big_oops_buf;
+static size_t big_oops_buf_sz;
+
 /* How much of the console log to snapshot */
 static unsigned long kmsg_bytes = 10240;
 
@@ -117,6 +127,91 @@ bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
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
+static void allocate_buf_for_compression(void)
+{
+	size_t size;
+
+	big_oops_buf_sz = (psinfo->bufsize * 100) / 45;
+	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
+	if (big_oops_buf) {
+		size = max(zlib_deflate_workspacesize(WINDOW_BITS, MEM_LEVEL),
+			zlib_inflate_workspacesize());
+		stream.workspace = kmalloc(size, GFP_KERNEL);
+		if (!stream.workspace) {
+			pr_err("pstore: No memory for compression workspace; "
+				"skipping compression\n");
+			kfree(big_oops_buf);
+			big_oops_buf = NULL;
+		}
+	} else {
+		pr_err("No memory for uncompressed data; "
+			"skipping compression\n");
+		stream.workspace = NULL;
+	}
+
+}
+
+/*
+ * Called when compression fails, since the printk buffer
+ * would be fetched for compression calling it again when
+ * compression fails would have moved the iterator of
+ * printk buffer which results in fetching old contents.
+ * Copy the recent messages from big_oops_buf to psinfo->buf
+ */
+static size_t copy_kmsg_to_buffer(int hsize, size_t len)
+{
+	size_t total_len;
+	size_t diff;
+
+	total_len = hsize + len;
+
+	if (total_len > psinfo->bufsize) {
+		diff = total_len - psinfo->bufsize + hsize;
+		memcpy(psinfo->buf, big_oops_buf, hsize);
+		memcpy(psinfo->buf + hsize, big_oops_buf + diff,
+					psinfo->bufsize - hsize);
+		total_len = psinfo->bufsize;
+	} else
+		memcpy(psinfo->buf, big_oops_buf, total_len);
+
+	return total_len;
+}
+
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -148,23 +243,56 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		char *dst;
 		unsigned long size;
 		int hsize;
+		int zipped_len = -1;
 		size_t len;
-		bool compressed = false;
+		bool compressed;
+		size_t total_len;
 
-		dst = psinfo->buf;
-		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part);
-		size = psinfo->bufsize - hsize;
-		dst += hsize;
+		if (big_oops_buf) {
+			dst = big_oops_buf;
+			hsize = sprintf(dst, "%s#%d Part%d\n", why,
+							oopscount, part);
+			size = big_oops_buf_sz - hsize;
 
-		if (!kmsg_dump_get_buffer(dumper, true, dst, size, &len))
-			break;
+			if (!kmsg_dump_get_buffer(dumper, true, dst + hsize,
+								size, &len))
+				break;
+
+			zipped_len = pstore_compress(dst, psinfo->buf,
+						hsize + len, psinfo->bufsize);
+
+			if (zipped_len > 0) {
+				compressed = true;
+				total_len = zipped_len;
+			} else {
+				pr_err("pstore: compression failed for Part %d"
+					" returned %d\n", part, zipped_len);
+				pr_err("pstore: Capture uncompressed"
+					" oops/panic report of Part %d\n", part);
+				compressed = false;
+				total_len = copy_kmsg_to_buffer(hsize, len);
+			}
+		} else {
+			dst = psinfo->buf;
+			hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount,
+									part);
+			size = psinfo->bufsize - hsize;
+			dst += hsize;
+
+			if (!kmsg_dump_get_buffer(dumper, true, dst,
+								size, &len))
+				break;
+
+			compressed = false;
+			total_len = hsize + len;
+		}
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
-				    oopscount, compressed, hsize + len, psinfo);
+				    oopscount, compressed, total_len, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
 
-		total += hsize + len;
+		total += total_len;
 		part++;
 	}
 	if (pstore_cannot_block_path(reason)) {
@@ -262,6 +390,8 @@ int pstore_register(struct pstore_info *psi)
 		return -EINVAL;
 	}
 
+	allocate_buf_for_compression();
+
 	if (pstore_is_mounted())
 		pstore_get_records(0);
 

