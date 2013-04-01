Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3DAD3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:29:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52024 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3DAD3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:29:06 -0400
Date: Sun, 31 Mar 2013 20:25:07 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 2/3] pstore/ram: Allow specifying ecc parameters in platform
 data
Message-ID: <20130401032507.GB17424@lizard>
References: <20130401032256.GA13801@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130401032256.GA13801@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Allow specifying ecc parameters in platform data

Signed-off-by: Arve Hjønnevåg <arve@android.com>
[jstultz: Tweaked commit subject & add commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
---
 fs/pstore/ram.c            | 15 ++++++-----
 fs/pstore/ram_core.c       | 64 ++++++++++++++++++++++++----------------------
 include/linux/pstore_ram.h | 14 +++++++---
 3 files changed, 52 insertions(+), 41 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 38babb3..a5ee252 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -83,7 +83,7 @@ struct ramoops_context {
 	size_t console_size;
 	size_t ftrace_size;
 	int dump_oops;
-	int ecc_size;
+	struct persistent_ram_ecc_info ecc_info;
 	unsigned int max_dump_cnt;
 	unsigned int dump_write_cnt;
 	unsigned int dump_read_cnt;
@@ -322,7 +322,8 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 	for (i = 0; i < cxt->max_dump_cnt; i++) {
 		size_t sz = cxt->record_size;
 
-		cxt->przs[i] = persistent_ram_new(*paddr, sz, 0, cxt->ecc_size);
+		cxt->przs[i] = persistent_ram_new(*paddr, sz, 0,
+						  &cxt->ecc_info);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
@@ -352,7 +353,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 		return -ENOMEM;
 	}
 
-	*prz = persistent_ram_new(*paddr, sz, sig, cxt->ecc_size);
+	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
@@ -406,7 +407,7 @@ static int ramoops_probe(struct platform_device *pdev)
 	cxt->console_size = pdata->console_size;
 	cxt->ftrace_size = pdata->ftrace_size;
 	cxt->dump_oops = pdata->dump_oops;
-	cxt->ecc_size = pdata->ecc_size;
+	cxt->ecc_info = pdata->ecc_info;
 
 	paddr = cxt->phys_addr;
 
@@ -464,9 +465,9 @@ static int ramoops_probe(struct platform_device *pdev)
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
-	pr_info("attached 0x%lx@0x%llx, ecc: %d\n",
+	pr_info("attached 0x%lx@0x%llx, ecc: %d/%d\n",
 		cxt->size, (unsigned long long)cxt->phys_addr,
-		cxt->ecc_size);
+		cxt->ecc_info.ecc_size, cxt->ecc_info.block_size);
 
 	return 0;
 
@@ -538,7 +539,7 @@ static void ramoops_register_dummy(void)
 	 * For backwards compatibility ramoops.ecc=1 means 16 bytes ECC
 	 * (using 1 byte for ECC isn't much of use anyway).
 	 */
-	dummy_data->ecc_size = ramoops_ecc == 1 ? 16 : ramoops_ecc;
+	dummy_data->ecc_info.ecc_size = ramoops_ecc == 1 ? 16 : ramoops_ecc;
 
 	dummy = platform_device_register_data(NULL, "ramoops", -1,
 			dummy_data, sizeof(struct ramoops_platform_data));
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index e5afa22..c6f641c 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -82,12 +82,12 @@ static void notrace persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
 	uint8_t *data, size_t len, uint8_t *ecc)
 {
 	int i;
-	uint16_t par[prz->ecc_size];
+	uint16_t par[prz->ecc_info.ecc_size];
 
 	/* Initialize the parity buffer */
 	memset(par, 0, sizeof(par));
 	encode_rs8(prz->rs_decoder, data, len, par, 0);
-	for (i = 0; i < prz->ecc_size; i++)
+	for (i = 0; i < prz->ecc_info.ecc_size; i++)
 		ecc[i] = par[i];
 }
 
@@ -95,9 +95,9 @@ static int persistent_ram_decode_rs8(struct persistent_ram_zone *prz,
 	void *data, size_t len, uint8_t *ecc)
 {
 	int i;
-	uint16_t par[prz->ecc_size];
+	uint16_t par[prz->ecc_info.ecc_size];
 
-	for (i = 0; i < prz->ecc_size; i++)
+	for (i = 0; i < prz->ecc_info.ecc_size; i++)
 		par[i] = ecc[i];
 	return decode_rs8(prz->rs_decoder, data, par, len,
 				NULL, 0, NULL, 0, NULL);
@@ -110,15 +110,15 @@ static void notrace persistent_ram_update_ecc(struct persistent_ram_zone *prz,
 	uint8_t *buffer_end = buffer->data + prz->buffer_size;
 	uint8_t *block;
 	uint8_t *par;
-	int ecc_block_size = prz->ecc_block_size;
-	int ecc_size = prz->ecc_size;
-	int size = prz->ecc_block_size;
+	int ecc_block_size = prz->ecc_info.block_size;
+	int ecc_size = prz->ecc_info.ecc_size;
+	int size = ecc_block_size;
 
-	if (!prz->ecc_size)
+	if (!ecc_size)
 		return;
 
 	block = buffer->data + (start & ~(ecc_block_size - 1));
-	par = prz->par_buffer + (start / ecc_block_size) * prz->ecc_size;
+	par = prz->par_buffer + (start / ecc_block_size) * ecc_size;
 
 	do {
 		if (block + ecc_block_size > buffer_end)
@@ -133,7 +133,7 @@ static void persistent_ram_update_header_ecc(struct persistent_ram_zone *prz)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
 
-	if (!prz->ecc_size)
+	if (!prz->ecc_info.ecc_size)
 		return;
 
 	persistent_ram_encode_rs8(prz, (uint8_t *)buffer, sizeof(*buffer),
@@ -146,14 +146,14 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 	uint8_t *block;
 	uint8_t *par;
 
-	if (!prz->ecc_size)
+	if (!prz->ecc_info.ecc_size)
 		return;
 
 	block = buffer->data;
 	par = prz->par_buffer;
 	while (block < buffer->data + buffer_size(prz)) {
 		int numerr;
-		int size = prz->ecc_block_size;
+		int size = prz->ecc_info.block_size;
 		if (block + size > buffer->data + prz->buffer_size)
 			size = buffer->data + prz->buffer_size - block;
 		numerr = persistent_ram_decode_rs8(prz, block, size, par);
@@ -166,45 +166,49 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 				block);
 			prz->bad_blocks++;
 		}
-		block += prz->ecc_block_size;
-		par += prz->ecc_size;
+		block += prz->ecc_info.block_size;
+		par += prz->ecc_info.ecc_size;
 	}
 }
 
 static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
-				   int ecc_size)
+				   struct persistent_ram_ecc_info *ecc_info)
 {
 	int numerr;
 	struct persistent_ram_buffer *buffer = prz->buffer;
 	int ecc_blocks;
 	size_t ecc_total;
-	int ecc_symsize = 8;
-	int ecc_poly = 0x11d;
 
-	if (!ecc_size)
+	if (!ecc_info || !ecc_info->ecc_size)
 		return 0;
 
-	prz->ecc_block_size = 128;
-	prz->ecc_size = ecc_size;
+	prz->ecc_info.block_size = ecc_info->block_size ?: 128;
+	prz->ecc_info.ecc_size = ecc_info->ecc_size ?: 16;
+	prz->ecc_info.symsize = ecc_info->symsize ?: 8;
+	prz->ecc_info.poly = ecc_info->poly ?: 0x11d;
 
-	ecc_blocks = DIV_ROUND_UP(prz->buffer_size - prz->ecc_size,
-				  prz->ecc_block_size + prz->ecc_size);
-	ecc_total = (ecc_blocks + 1) * prz->ecc_size;
+	ecc_blocks = DIV_ROUND_UP(prz->buffer_size - prz->ecc_info.ecc_size,
+				  prz->ecc_info.block_size +
+				  prz->ecc_info.ecc_size);
+	ecc_total = (ecc_blocks + 1) * prz->ecc_info.ecc_size;
 	if (ecc_total >= prz->buffer_size) {
 		pr_err("%s: invalid ecc_size %u (total %zu, buffer size %zu)\n",
-		       __func__, prz->ecc_size, ecc_total, prz->buffer_size);
+		       __func__, prz->ecc_info.ecc_size,
+		       ecc_total, prz->buffer_size);
 		return -EINVAL;
 	}
 
 	prz->buffer_size -= ecc_total;
 	prz->par_buffer = buffer->data + prz->buffer_size;
-	prz->par_header = prz->par_buffer + ecc_blocks * prz->ecc_size;
+	prz->par_header = prz->par_buffer +
+			  ecc_blocks * prz->ecc_info.ecc_size;
 
 	/*
 	 * first consecutive root is 0
 	 * primitive element to generate roots = 1
 	 */
-	prz->rs_decoder = init_rs(ecc_symsize, ecc_poly, 0, 1, prz->ecc_size);
+	prz->rs_decoder = init_rs(prz->ecc_info.symsize, prz->ecc_info.poly,
+				  0, 1, prz->ecc_info.ecc_size);
 	if (prz->rs_decoder == NULL) {
 		pr_info("persistent_ram: init_rs failed\n");
 		return -EINVAL;
@@ -392,11 +396,11 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 }
 
 static int persistent_ram_post_init(struct persistent_ram_zone *prz, u32 sig,
-				    int ecc_size)
+				    struct persistent_ram_ecc_info *ecc_info)
 {
 	int ret;
 
-	ret = persistent_ram_init_ecc(prz, ecc_size);
+	ret = persistent_ram_init_ecc(prz, ecc_info);
 	if (ret)
 		return ret;
 
@@ -445,7 +449,7 @@ void persistent_ram_free(struct persistent_ram_zone *prz)
 }
 
 struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
-					       u32 sig, int ecc_size)
+			u32 sig, struct persistent_ram_ecc_info *ecc_info)
 {
 	struct persistent_ram_zone *prz;
 	int ret = -ENOMEM;
@@ -460,7 +464,7 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 	if (ret)
 		goto err;
 
-	ret = persistent_ram_post_init(prz, sig, ecc_size);
+	ret = persistent_ram_post_init(prz, sig, ecc_info);
 	if (ret)
 		goto err;
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index cb6ab5f..9974975 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -26,6 +26,13 @@
 struct persistent_ram_buffer;
 struct rs_control;
 
+struct persistent_ram_ecc_info {
+	int block_size;
+	int ecc_size;
+	int symsize;
+	int poly;
+};
+
 struct persistent_ram_zone {
 	phys_addr_t paddr;
 	size_t size;
@@ -39,15 +46,14 @@ struct persistent_ram_zone {
 	struct rs_control *rs_decoder;
 	int corrected_bytes;
 	int bad_blocks;
-	int ecc_block_size;
-	int ecc_size;
+	struct persistent_ram_ecc_info ecc_info;
 
 	char *old_log;
 	size_t old_log_size;
 };
 
 struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
-					       u32 sig, int ecc_size);
+			u32 sig, struct persistent_ram_ecc_info *ecc_info);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
 
@@ -74,7 +80,7 @@ struct ramoops_platform_data {
 	unsigned long	console_size;
 	unsigned long	ftrace_size;
 	int		dump_oops;
-	int		ecc_size;
+	struct persistent_ram_ecc_info ecc_info;
 };
 
 #endif
-- 
1.8.1.4

