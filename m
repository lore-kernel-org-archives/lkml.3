Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaILScm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:32:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61503 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaILScj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:32:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+awwLceq+BIgfm/HC26BmR
From: Tony Lindgren <tony@atomide.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/2] pstore-ram: Allow optional mapping with pgprot_noncached
Date: Fri, 12 Sep 2014 11:32:25 -0700
Message-Id: <1410546745-919-2-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410546745-919-1-git-send-email-tony@atomide.com>
References: <1410546745-919-1-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARMs at least the memory can be mapped pgprot_noncached()
and still be working for atomic operations. As pointed out by
Colin Cross <ccross@android.com>, in some cases you do want to use
pgprot_noncached() if the SoC supports it to see a debug printk
just before a write hanging the system.

On ARMs, the atomic operations on strongly ordered memory are
implementation defined. So let's provide an optional kernel parameter
for configuring noncached memory, and use pgprot_writecombine() by
default.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 Documentation/ramoops.txt  | 12 ++++++++++--
 fs/pstore/ram.c            | 13 +++++++++++--
 fs/pstore/ram_core.c       | 31 ++++++++++++++++++++++---------
 include/linux/pstore_ram.h |  4 +++-
 4 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 69b3cac..2dab135 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -14,11 +14,18 @@ survive after a restart.
 
 1. Ramoops concepts
 
-Ramoops uses a predefined memory area to store the dump. The start and size of
-the memory area are set using two variables:
+Ramoops uses a predefined memory area to store the dump. The start and size
+and type of the memory area are set using three variables:
   * "mem_address" for the start
   * "mem_size" for the size. The memory size will be rounded down to a
   power of two.
+  * "mem_cached" to specifiy if the memory is cached or not.
+
+Note disabling "mem_cached" may not be supported on all architectures as
+pstore depends on atomic operations. At least on ARM, clearing "mem_cached"
+will cause the memory to be mapped strongly ordered. And atomic operations
+on strongly ordered memory are implementation defined, and won't work on
+many ARMs such as omap.
 
 The memory area is divided into "record_size" chunks (also rounded down to
 power of two) and each oops/panic writes a "record_size" chunk of
@@ -55,6 +62,7 @@ Setting the ramoops parameters can be done in 2 different manners:
 static struct ramoops_platform_data ramoops_data = {
         .mem_size               = <...>,
         .mem_address            = <...>,
+        .mem_cached             = <...>,
         .record_size            = <...>,
         .dump_oops              = <...>,
         .ecc                    = <...>,
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 3b57443..53ddcb2 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -61,6 +61,11 @@ module_param(mem_size, ulong, 0400);
 MODULE_PARM_DESC(mem_size,
 		"size of reserved RAM used to store oops/panic logs");
 
+static unsigned int mem_cached = 1;
+module_param(mem_cached, uint, 0600);
+MODULE_PARM_DESC(mem_cached,
+		"set to 1 to use cached memory, 0 to use uncached (default 1)");
+
 static int dump_oops = 1;
 module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
@@ -79,6 +84,7 @@ struct ramoops_context {
 	struct persistent_ram_zone *fprz;
 	phys_addr_t phys_addr;
 	unsigned long size;
+	unsigned int cached;
 	size_t record_size;
 	size_t console_size;
 	size_t ftrace_size;
@@ -358,7 +364,8 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 		size_t sz = cxt->record_size;
 
 		cxt->przs[i] = persistent_ram_new(*paddr, sz, 0,
-						  &cxt->ecc_info);
+						  &cxt->ecc_info,
+						  cxt->cached);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
@@ -388,7 +395,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 		return -ENOMEM;
 	}
 
-	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info);
+	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info, cxt->cached);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
@@ -435,6 +442,7 @@ static int ramoops_probe(struct platform_device *pdev)
 
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
+	cxt->cached = pdata->mem_cached;
 	cxt->record_size = pdata->record_size;
 	cxt->console_size = pdata->console_size;
 	cxt->ftrace_size = pdata->ftrace_size;
@@ -564,6 +572,7 @@ static void ramoops_register_dummy(void)
 
 	dummy_data->mem_size = mem_size;
 	dummy_data->mem_address = mem_address;
+	dummy_data->mem_cached = 1;
 	dummy_data->record_size = record_size;
 	dummy_data->console_size = ramoops_console_size;
 	dummy_data->ftrace_size = ramoops_ftrace_size;
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 24f94b0..ae34cf6 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -380,7 +380,8 @@ void persistent_ram_zap(struct persistent_ram_zone *prz)
 	persistent_ram_update_header_ecc(prz);
 }
 
-static void *persistent_ram_vmap(phys_addr_t start, size_t size)
+static void *persistent_ram_vmap(phys_addr_t start, size_t size,
+		unsigned int cached)
 {
 	struct page **pages;
 	phys_addr_t page_start;
@@ -392,7 +393,10 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 	page_start = start - offset_in_page(start);
 	page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
 
-	prot = pgprot_writecombine(PAGE_KERNEL);
+	if (cached)
+		prot = pgprot_writecombine(PAGE_KERNEL);
+	else
+		prot = pgprot_noncached(PAGE_KERNEL);
 
 	pages = kmalloc_array(page_count, sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
@@ -411,8 +415,11 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 	return vaddr;
 }
 
-static void *persistent_ram_iomap(phys_addr_t start, size_t size)
+static void *persistent_ram_iomap(phys_addr_t start, size_t size,
+		unsigned int cached)
 {
+	void *va;
+
 	if (!request_mem_region(start, size, "persistent_ram")) {
 		pr_err("request mem region (0x%llx@0x%llx) failed\n",
 			(unsigned long long)size, (unsigned long long)start);
@@ -422,19 +429,24 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
 	buffer_start_add = buffer_start_add_locked;
 	buffer_size_add = buffer_size_add_locked;
 
-	return ioremap_wc(start, size);
+	if (cached)
+		va = ioremap_wc(start, size);
+	else
+		va = ioremap(start, size);
+
+	return va;
 }
 
 static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
-		struct persistent_ram_zone *prz)
+		struct persistent_ram_zone *prz, int cached)
 {
 	prz->paddr = start;
 	prz->size = size;
 
 	if (pfn_valid(start >> PAGE_SHIFT))
-		prz->vaddr = persistent_ram_vmap(start, size);
+		prz->vaddr = persistent_ram_vmap(start, size, cached);
 	else
-		prz->vaddr = persistent_ram_iomap(start, size);
+		prz->vaddr = persistent_ram_iomap(start, size, cached);
 
 	if (!prz->vaddr) {
 		pr_err("%s: Failed to map 0x%llx pages at 0x%llx\n", __func__,
@@ -500,7 +512,8 @@ void persistent_ram_free(struct persistent_ram_zone *prz)
 }
 
 struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
-			u32 sig, struct persistent_ram_ecc_info *ecc_info)
+			u32 sig, struct persistent_ram_ecc_info *ecc_info,
+			unsigned int cached)
 {
 	struct persistent_ram_zone *prz;
 	int ret = -ENOMEM;
@@ -511,7 +524,7 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 		goto err;
 	}
 
-	ret = persistent_ram_buffer_map(start, size, prz);
+	ret = persistent_ram_buffer_map(start, size, prz, cached);
 	if (ret)
 		goto err;
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 9974975..5cbbae6 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -53,7 +53,8 @@ struct persistent_ram_zone {
 };
 
 struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
-			u32 sig, struct persistent_ram_ecc_info *ecc_info);
+			u32 sig, struct persistent_ram_ecc_info *ecc_info,
+			unsigned int cached);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
 
@@ -76,6 +77,7 @@ ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	unsigned int	mem_cached;
 	unsigned long	record_size;
 	unsigned long	console_size;
 	unsigned long	ftrace_size;
-- 
2.1.0

