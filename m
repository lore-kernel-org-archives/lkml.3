Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3HPNSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:18:38 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37053 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3HPNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:18:32 -0400
Subject: [RFC PATCH v2 06/11] pstore: Add decompression support to pstore
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:48:21 +0530
Message-ID: <20130816131821.3338.27923.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-3864-0000-0000-0000099F5ED6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the flag 'compressed' set or not, pstore will decompress the
data returning a plain text file. If decompression fails for a particular
record it will have the compressed data in the file which can be
decompressed with 'openssl' command line tool.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/platform.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 6418eb7..0195cca0 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -162,6 +162,36 @@ error:
 	return ret;
 }
 
+/* Derived from logfs_uncompress */
+int pstore_decompress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+	err = zlib_inflateInit(&stream);
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
+	err = zlib_inflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_inflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	ret = stream.total_out;
+error:
+	return ret;
+}
+
 static void allocate_buf_for_compression(void)
 {
 	size_t size;
@@ -429,6 +459,7 @@ void pstore_get_records(int quiet)
 	struct timespec		time;
 	int			failed = 0, rc;
 	bool			compressed;
+	int			unzipped_len = -1;
 
 	if (!psi)
 		return;
@@ -439,10 +470,28 @@ void pstore_get_records(int quiet)
 
 	while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
 				psi)) > 0) {
+		if (compressed && (type == PSTORE_TYPE_DMESG)) {
+			if (big_oops_buf)
+				unzipped_len = pstore_decompress(buf,
+							big_oops_buf, size,
+							big_oops_buf_sz);
+
+			if (unzipped_len > 0) {
+				buf = big_oops_buf;
+				size = unzipped_len;
+			} else {
+				pr_err("pstore: decompression failed;"
+					"returned %d\n", unzipped_len);
+			}
+		}
 		rc = pstore_mkfile(type, psi->name, id, count, buf,
 				  (size_t)size, time, psi);
-		kfree(buf);
-		buf = NULL;
+		if (unzipped_len < 0) {
+			/* Free buffer other than big oops */
+			kfree(buf);
+			buf = NULL;
+		} else
+			unzipped_len = -1;
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
 	}

