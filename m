Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3F0IdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:33:17 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55443 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3F0IdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:33:14 -0400
Subject: [PATCH v2 2/3] powerpc/pseries: Re-organise the oops compression
 code
To: tony.luck@intel.com, keescook@chromium.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        paulus@samba.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        cbouatmailru@gmail.com, anton@samba.org, ccross@android.com
Date: Thu, 27 Jun 2013 14:03:04 +0530
Message-ID: <20130627083304.16749.96648.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
References: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-3568-0000-0000-000003D7060C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nvram_compress() and zip_oops() is used by the nvram_pstore_write
API to compress oops messages hence re-organise the functions
accordingly to avoid forward declarations.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |  104 ++++++++++++++++----------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 3f0e7d6..588bab5 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -486,6 +486,58 @@ static int clobbering_unread_rtas_event(void)
 						NVRAM_RTAS_READ_TIMEOUT);
 }
 
+/* Derived from logfs_compress() */
+static int nvram_compress(const void *in, void *out, size_t inlen,
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
+/* Compress the text from big_oops_buf into oops_buf. */
+static int zip_oops(size_t text_len)
+{
+	struct oops_log_info *oops_hdr = (struct oops_log_info *)oops_buf;
+	int zipped_len = nvram_compress(big_oops_buf, oops_data, text_len,
+								oops_data_sz);
+	if (zipped_len < 0) {
+		pr_err("nvram: compression failed; returned %d\n", zipped_len);
+		pr_err("nvram: logging uncompressed oops/panic report\n");
+		return -1;
+	}
+	oops_hdr->version = OOPS_HDR_VERSION;
+	oops_hdr->report_length = (u16) zipped_len;
+	oops_hdr->timestamp = get_seconds();
+	return 0;
+}
+
 #ifdef CONFIG_PSTORE
 static int nvram_pstore_open(struct pstore_info *psi)
 {
@@ -759,58 +811,6 @@ int __init pSeries_nvram_init(void)
 }
 
 
-/* Derived from logfs_compress() */
-static int nvram_compress(const void *in, void *out, size_t inlen,
-							size_t outlen)
-{
-	int err, ret;
-
-	ret = -EIO;
-	err = zlib_deflateInit2(&stream, COMPR_LEVEL, Z_DEFLATED, WINDOW_BITS,
-						MEM_LEVEL, Z_DEFAULT_STRATEGY);
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
-	err = zlib_deflate(&stream, Z_FINISH);
-	if (err != Z_STREAM_END)
-		goto error;
-
-	err = zlib_deflateEnd(&stream);
-	if (err != Z_OK)
-		goto error;
-
-	if (stream.total_out >= stream.total_in)
-		goto error;
-
-	ret = stream.total_out;
-error:
-	return ret;
-}
-
-/* Compress the text from big_oops_buf into oops_buf. */
-static int zip_oops(size_t text_len)
-{
-	struct oops_log_info *oops_hdr = (struct oops_log_info *)oops_buf;
-	int zipped_len = nvram_compress(big_oops_buf, oops_data, text_len,
-								oops_data_sz);
-	if (zipped_len < 0) {
-		pr_err("nvram: compression failed; returned %d\n", zipped_len);
-		pr_err("nvram: logging uncompressed oops/panic report\n");
-		return -1;
-	}
-	oops_hdr->version = OOPS_HDR_VERSION;
-	oops_hdr->report_length = (u16) zipped_len;
-	oops_hdr->timestamp = get_seconds();
-	return 0;
-}
-
 /*
  * This is our kmsg_dump callback, called after an oops or panic report
  * has been written to the printk buffer.  We want to capture as much

