Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3HHREf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:04:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53529 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab3HHREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:04:01 -0400
Subject: [PATCH 1/2] powerpc/pseries: Fix buffer overflow when reading from
 pstore
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: mahesh@linux.vne.ibm.com
Date: Thu, 08 Aug 2013 22:33:49 +0530
Message-ID: <20130808170253.9914.25346.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080816-0260-0000-0000-00000370FED5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading from pstore there is a buffer overflow during decompression
due to the header added in unzip_oops. Remove unzip_oops and call
pstore_decompress directly in nvram_pstore_read. Allocate buffer of size
report_length of the oops header as header will not be deallocated in pstore.
Since we have 'openssl' command line tool to decompress the compressed data,
dump the compressed data in case decompression fails instead of not dumping
anything.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |   70 +++++++++++---------------------
 1 file changed, 24 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 9f8671a..893f360 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -569,35 +569,6 @@ error:
 	return ret;
 }
 
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
@@ -685,10 +656,9 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 	unsigned int err_type, id_no, size = 0;
 	struct nvram_os_partition *part = NULL;
 	char *buff = NULL, *big_buff = NULL;
-	int rc, sig = 0;
+	int sig = 0;
 	loff_t p;
 
-read_partition:
 	read_type++;
 
 	switch (nvram_type_ids[read_type]) {
@@ -749,30 +719,36 @@ read_partition:
 		*id = id_no;
 
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
+		int length, unzipped_len;
+
 		oops_hdr = (struct oops_log_info *)buff;
-		*buf = buff + sizeof(*oops_hdr);
+		length = oops_hdr->report_length;
+		*buf = kmalloc(length, GFP_KERNEL);
+		if (*buf == NULL)
+			return -ENOMEM;
+		memcpy(*buf, buff + sizeof(*oops_hdr), length);
+		time->tv_sec = oops_hdr->timestamp;
+		time->tv_nsec = 0;
+		kfree(buff);
 
 		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ) {
 			big_buff = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 			if (!big_buff)
 				return -ENOMEM;
 
-			rc = unzip_oops(buff, big_buff);
+			unzipped_len = nvram_decompress(*buf, big_buff,
+						length, big_oops_buf_sz);
 
-			if (rc != 0) {
-				kfree(buff);
+			if (unzipped_len < 0) {
+				pr_err("nvram: decompression failed, returned "
+					"rc %d\n", unzipped_len);
 				kfree(big_buff);
-				goto read_partition;
+			} else {
+				*buf = big_buff;
+				length = unzipped_len;
 			}
-
-			oops_hdr = (struct oops_log_info *)big_buff;
-			*buf = big_buff + sizeof(*oops_hdr);
-			kfree(buff);
 		}
-
-		time->tv_sec = oops_hdr->timestamp;
-		time->tv_nsec = 0;
-		return oops_hdr->report_length;
+		return length;
 	}
 
 	*buf = buff;
@@ -816,6 +792,7 @@ static int nvram_pstore_init(void)
 static void __init nvram_init_oops_partition(int rtas_partition_exists)
 {
 	int rc;
+	size_t size;
 
 	rc = pseries_nvram_init_os_partition(&oops_log_partition);
 	if (rc != 0) {
@@ -844,8 +821,9 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
 	big_oops_buf_sz = (oops_data_sz * 100) / 45;
 	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 	if (big_oops_buf) {
-		stream.workspace = kmalloc(zlib_deflate_workspacesize(
-				WINDOW_BITS, MEM_LEVEL), GFP_KERNEL);
+		size = max(zlib_deflate_workspacesize(WINDOW_BITS, MEM_LEVEL),
+			zlib_inflate_workspacesize());
+		stream.workspace = kmalloc(size, GFP_KERNEL);
 		if (!stream.workspace) {
 			pr_err("nvram: No memory for compression workspace; "
 				"skipping compression of %s partition data\n",

