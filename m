Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3HPNR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:17:58 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48943 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3HPNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:17:52 -0400
Subject: [RFC PATCH v2 01/11] powerpc/pseries: Remove (de)compression in
 nvram with pstore enabled
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:47:39 +0530
Message-ID: <20130816131739.3338.45669.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-2000-0000-0000-00000D572B3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(De)compression support is provided in pstore in subsequent patches which
needs an additional argument 'compressed' to determine if the data
is compressed or not. This patch will take care of removing (de)compression
in nvram with pstore which was making use of 'hsize' argument in pstore write
as 'hsize' will be removed in the subsequent patch.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |  102 ++++----------------------------
 1 file changed, 12 insertions(+), 90 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 6a5f2b1..b966458 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -539,36 +539,6 @@ static int zip_oops(size_t text_len)
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
 static int nvram_pstore_open(struct pstore_info *psi)
 {
 	/* Reset the iterator to start reading partitions again */
@@ -611,30 +581,8 @@ static int nvram_pstore_write(enum pstore_type_id type,
 	oops_hdr->report_length = (u16) size;
 	oops_hdr->timestamp = get_seconds();
 
-	if (big_oops_buf) {
-		rc = zip_oops(size);
-		/*
-		 * If compression fails copy recent log messages from
-		 * big_oops_buf to oops_data.
-		 */
-		if (rc != 0) {
-			size_t diff = size - oops_data_sz + hsize;
-
-			if (size > oops_data_sz) {
-				memcpy(oops_data, big_oops_buf, hsize);
-				memcpy(oops_data + hsize, big_oops_buf + diff,
-					oops_data_sz - hsize);
-
-				oops_hdr->report_length = (u16) oops_data_sz;
-			} else
-				memcpy(oops_data, big_oops_buf, size);
-		} else
-			err_type = ERR_TYPE_KERNEL_PANIC_GZ;
-	}
-
 	rc = nvram_write_os_partition(&oops_log_partition, oops_buf,
-		(int) (sizeof(*oops_hdr) + oops_hdr->report_length), err_type,
-		count);
+		(int) (sizeof(*oops_hdr) + size), err_type, count);
 
 	if (rc != 0)
 		return rc;
@@ -655,7 +603,7 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct oops_log_info *oops_hdr;
 	unsigned int err_type, id_no, size = 0;
 	struct nvram_os_partition *part = NULL;
-	char *buff = NULL, *big_buff = NULL;
+	char *buff = NULL;
 	int sig = 0;
 	loff_t p;
 
@@ -719,8 +667,7 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 		*id = id_no;
 
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
-		int length, unzipped_len;
-		size_t hdr_size;
+		size_t length, hdr_size;
 
 		oops_hdr = (struct oops_log_info *)buff;
 		if (oops_hdr->version < OOPS_HDR_VERSION) {
@@ -740,24 +687,6 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 			return -ENOMEM;
 		memcpy(*buf, buff + hdr_size, length);
 		kfree(buff);
-
-		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ) {
-			big_buff = kmalloc(big_oops_buf_sz, GFP_KERNEL);
-			if (!big_buff)
-				return -ENOMEM;
-
-			unzipped_len = nvram_decompress(*buf, big_buff,
-						length, big_oops_buf_sz);
-
-			if (unzipped_len < 0) {
-				pr_err("nvram: decompression failed, returned "
-					"rc %d\n", unzipped_len);
-				kfree(big_buff);
-			} else {
-				*buf = big_buff;
-				length = unzipped_len;
-			}
-		}
 		return length;
 	}
 
@@ -777,13 +706,8 @@ static int nvram_pstore_init(void)
 {
 	int rc = 0;
 
-	if (big_oops_buf) {
-		nvram_pstore_info.buf = big_oops_buf;
-		nvram_pstore_info.bufsize = big_oops_buf_sz;
-	} else {
-		nvram_pstore_info.buf = oops_data;
-		nvram_pstore_info.bufsize = oops_data_sz;
-	}
+	nvram_pstore_info.buf = oops_data;
+	nvram_pstore_info.bufsize = oops_data_sz;
 
 	rc = pstore_register(&nvram_pstore_info);
 	if (rc != 0)
@@ -802,7 +726,6 @@ static int nvram_pstore_init(void)
 static void __init nvram_init_oops_partition(int rtas_partition_exists)
 {
 	int rc;
-	size_t size;
 
 	rc = pseries_nvram_init_os_partition(&oops_log_partition);
 	if (rc != 0) {
@@ -823,6 +746,11 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
 	oops_data = oops_buf + sizeof(struct oops_log_info);
 	oops_data_sz = oops_log_partition.size - sizeof(struct oops_log_info);
 
+	rc = nvram_pstore_init();
+
+	if (!rc)
+		return;
+
 	/*
 	 * Figure compression (preceded by elimination of each line's <n>
 	 * severity prefix) will reduce the oops/panic report to at most
@@ -831,9 +759,8 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
 	big_oops_buf_sz = (oops_data_sz * 100) / 45;
 	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 	if (big_oops_buf) {
-		size = max(zlib_deflate_workspacesize(WINDOW_BITS, MEM_LEVEL),
-			zlib_inflate_workspacesize());
-		stream.workspace = kmalloc(size, GFP_KERNEL);
+		stream.workspace =  kmalloc(zlib_deflate_workspacesize(
+					WINDOW_BITS, MEM_LEVEL), GFP_KERNEL);
 		if (!stream.workspace) {
 			pr_err("nvram: No memory for compression workspace; "
 				"skipping compression of %s partition data\n",
@@ -847,11 +774,6 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
 		stream.workspace = NULL;
 	}
 
-	rc = nvram_pstore_init();
-
-	if (!rc)
-		return;
-
 	rc = kmsg_dump_register(&nvram_kmsg_dumper);
 	if (rc != 0) {
 		pr_err("nvram: kmsg_dump_register() failed; returned %d\n", rc);

