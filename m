Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab3GOQ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:56:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57399 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GOQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:56:19 -0400
Subject: [PATCH 06/11] pstore: Provide decompression support to pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:26:06 +0530
Message-ID: <20130715165606.1520.76699.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-0260-0000-0000-0000034FEEE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the flag 'compressed' set or not, pstore will decompress the
data returning a plain text file. If decompression fails for a particular
record it will have the compressed data in the file which can be
decompressed with 'openssl' command line tool.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   59 -------------------------
 fs/pstore/platform.c                   |   77 ++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 1ddc266..78c6f45 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -539,65 +539,6 @@ static int zip_oops(size_t text_len)
 }
 
 #ifdef CONFIG_PSTORE
-/* Derived from logfs_uncompress */
-int nvram_decompress(void *in, void *out, size_t inlen, size_t outlen)
-{
-	int err, ret;
-
-	ret = -EIO;
-	err = zlib_inflateInit(&stream);
-	if (err != Z_OK)
-		goto error;
-
-	stream.next_in = in;
-	stream.avail_in = inlen;
-	stream.total_in = 0;
-	stream.next_out = out;
-	stream.avail_out = outlen;
-	stream.total_out = 0;
-
-	err = zlib_inflate(&stream, Z_FINISH);
-	if (err != Z_STREAM_END)
-		goto error;
-
-	err = zlib_inflateEnd(&stream);
-	if (err != Z_OK)
-		goto error;
-
-	ret = stream.total_out;
-error:
-	return ret;
-}
-
-static int unzip_oops(char *oops_buf, char *big_buf)
-{
-	struct oops_log_info *oops_hdr = (struct oops_log_info *)oops_buf;
-	u64 timestamp = oops_hdr->timestamp;
-	char *big_oops_data = NULL;
-	char *oops_data_buf = NULL;
-	size_t big_oops_data_sz;
-	int unzipped_len;
-
-	big_oops_data = big_buf + sizeof(struct oops_log_info);
-	big_oops_data_sz = big_oops_buf_sz - sizeof(struct oops_log_info);
-	oops_data_buf = oops_buf + sizeof(struct oops_log_info);
-
-	unzipped_len = nvram_decompress(oops_data_buf, big_oops_data,
-					oops_hdr->report_length,
-					big_oops_data_sz);
-
-	if (unzipped_len < 0) {
-		pr_err("nvram: decompression failed; returned %d\n",
-								unzipped_len);
-		return -1;
-	}
-	oops_hdr = (struct oops_log_info *)big_buf;
-	oops_hdr->version = OOPS_HDR_VERSION;
-	oops_hdr->report_length = (u16) unzipped_len;
-	oops_hdr->timestamp = timestamp;
-	return 0;
-}
-
 static int nvram_pstore_open(struct pstore_info *psi)
 {
 	/* Reset the iterator to start reading partitions again */
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index b1faf25..119db58 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -198,6 +198,59 @@ static char *allocate_buf_for_compression(unsigned long big_buf_sz)
 
 	return big_buf;
 }
+
+static char *allocate_buf_for_decompression(unsigned long size)
+{
+	char *big_buf;
+
+	big_buf = kmalloc(size, GFP_KERNEL);
+	if (big_buf) {
+		stream.workspace = kmalloc(zlib_inflate_workspacesize(),
+								GFP_KERNEL);
+		if (!stream.workspace) {
+			pr_err("pstore: No memory for decompression workspace; "
+				"skipping decompression\n");
+			kfree(big_buf);
+			big_buf = NULL;
+		}
+	} else {
+		pr_err("No memory for decompressed data; "
+			"skipping decompression\n");
+		stream.workspace = NULL;
+	}
+
+	return big_buf;
+}
+
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
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -398,12 +451,14 @@ void pstore_get_records(int quiet)
 {
 	struct pstore_info *psi = psinfo;
 	char			*buf = NULL;
-	ssize_t			size;
+	char			*big_buf = NULL;
+	ssize_t			size, big_buf_sz;
 	u64			id;
 	int			count;
 	enum pstore_type_id	type;
 	struct timespec		time;
 	int			failed = 0, rc;
+	int			unzipped_len = -1;
 	bool			compressed;
 
 	if (!psi)
@@ -415,10 +470,30 @@ void pstore_get_records(int quiet)
 
 	while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
 				psi)) > 0) {
+		if (compressed && (type == PSTORE_TYPE_DMESG)) {
+			big_buf_sz = (psinfo->bufsize * 100) / 45;
+			big_buf = allocate_buf_for_decompression(big_buf_sz);
+
+			if (big_buf || stream.workspace)
+				unzipped_len = pstore_decompress(buf, big_buf,
+							size, big_buf_sz);
+
+			if (unzipped_len > 0) {
+				buf = big_buf;
+				size = unzipped_len;
+			} else {
+				pr_err("pstore: decompression failed;"
+					"returned %d\n", unzipped_len);
+			}
+		}
 		rc = pstore_mkfile(type, psi->name, id, count, buf,
 				  (size_t)size, time, psi);
 		kfree(buf);
+		kfree(stream.workspace);
+		kfree(big_buf);
 		buf = NULL;
+		stream.workspace = NULL;
+		big_buf = NULL;
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
 	}

