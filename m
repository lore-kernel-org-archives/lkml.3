Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbbALSwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:52:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbbALSaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 126/216] pstore-ram: Allow optional mapping with pgprot_noncached
Date: Mon, 12 Jan 2015 18:28:24 +0000
Message-Id: <1421087394-2712-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 027bc8b08242c59e19356b4b2c189f2d849ab660 upstream.

On some ARMs the memory can be mapped pgprot_noncached() and still
be working for atomic operations. As pointed out by Colin Cross
<ccross@android.com>, in some cases you do want to use
pgprot_noncached() if the SoC supports it to see a debug printk
just before a write hanging the system.

On ARMs, the atomic operations on strongly ordered memory are
implementation defined. So let's provide an optional kernel parameter
for configuring pgprot_noncached(), and use pgprot_writecombine() by
default.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/ramoops.txt  | 13 +++++++++++--
 fs/pstore/ram.c            | 13 +++++++++++--
 fs/pstore/ram_core.c       | 31 ++++++++++++++++++++++---------
 include/linux/pstore_ram.h |  4 +++-
 4 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 69b3cac4749d..5d8675615e59 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -14,11 +14,19 @@ survive after a restart.
 
 1. Ramoops concepts
 
-Ramoops uses a predefined memory area to store the dump. The start and size of
-the memory area are set using two variables:
+Ramoops uses a predefined memory area to store the dump. The start and size
+and type of the memory area are set using three variables:
   * "mem_address" for the start
   * "mem_size" for the size. The memory size will be rounded down to a
   power of two.
+  * "mem_type" to specifiy if the memory type (default is pgprot_writecombine).
+
+Typically the default value of mem_type=0 should be used as that sets the pstore
+mapping to pgprot_writecombine. Setting mem_type=1 attempts to use
+pgprot_noncached, which only works on some platforms. This is because pstore
+depends on atomic operations. At least on ARM, pgprot_noncached causes the
+memory to be mapped strongly ordered, and atomic operations on strongly ordered
+memory are implementation defined, and won't work on many ARMs such as omaps.
 
 The memory area is divided into "record_size" chunks (also rounded down to
 power of two) and each oops/panic writes a "record_size" chunk of
@@ -55,6 +63,7 @@ Setting the ramoops parameters can be done in 2 different manners:
 static struct ramoops_platform_data ramoops_data = {
         .mem_size               = <...>,
         .mem_address            = <...>,
+        .mem_type               = <...>,
         .record_size            = <...>,
         .dump_oops              = <...>,
         .ecc                    = <...>,
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 3b5744306ed8..5fa34243b1ae 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -61,6 +61,11 @@ module_param(mem_size, ulong, 0400);
 MODULE_PARM_DESC(mem_size,
 		"size of reserved RAM used to store oops/panic logs");
 
+static unsigned int mem_type;
+module_param(mem_type, uint, 0600);
+MODULE_PARM_DESC(mem_type,
+		"set to 1 to try to use unbuffered memory (default 0)");
+
 static int dump_oops = 1;
 module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
@@ -79,6 +84,7 @@ struct ramoops_context {
 	struct persistent_ram_zone *fprz;
 	phys_addr_t phys_addr;
 	unsigned long size;
+	unsigned int memtype;
 	size_t record_size;
 	size_t console_size;
 	size_t ftrace_size;
@@ -358,7 +364,8 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 		size_t sz = cxt->record_size;
 
 		cxt->przs[i] = persistent_ram_new(*paddr, sz, 0,
-						  &cxt->ecc_info);
+						  &cxt->ecc_info,
+						  cxt->memtype);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
@@ -388,7 +395,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 		return -ENOMEM;
 	}
 
-	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info);
+	*prz = persistent_ram_new(*paddr, sz, sig, &cxt->ecc_info, cxt->memtype);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
@@ -435,6 +442,7 @@ static int ramoops_probe(struct platform_device *pdev)
 
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
+	cxt->memtype = pdata->mem_type;
 	cxt->record_size = pdata->record_size;
 	cxt->console_size = pdata->console_size;
 	cxt->ftrace_size = pdata->ftrace_size;
@@ -564,6 +572,7 @@ static void ramoops_register_dummy(void)
 
 	dummy_data->mem_size = mem_size;
 	dummy_data->mem_address = mem_address;
+	dummy_data->mem_type = 0;
 	dummy_data->record_size = record_size;
 	dummy_data->console_size = ramoops_console_size;
 	dummy_data->ftrace_size = ramoops_ftrace_size;
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index d55fef2e21ed..8475def65880 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -380,7 +380,8 @@ void persistent_ram_zap(struct persistent_ram_zone *prz)
 	persistent_ram_update_header_ecc(prz);
 }
 
-static void *persistent_ram_vmap(phys_addr_t start, size_t size)
+static void *persistent_ram_vmap(phys_addr_t start, size_t size,
+		unsigned int memtype)
 {
 	struct page **pages;
 	phys_addr_t page_start;
@@ -392,7 +393,10 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 	page_start = start - offset_in_page(start);
 	page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
 
-	prot = pgprot_writecombine(PAGE_KERNEL);
+	if (memtype)
+		prot = pgprot_noncached(PAGE_KERNEL);
+	else
+		prot = pgprot_writecombine(PAGE_KERNEL);
 
 	pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
 	if (!pages) {
@@ -411,8 +415,11 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 	return vaddr;
 }
 
-static void *persistent_ram_iomap(phys_addr_t start, size_t size)
+static void *persistent_ram_iomap(phys_addr_t start, size_t size,
+		unsigned int memtype)
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
+	if (memtype)
+		va = ioremap(start, size);
+	else
+		va = ioremap_wc(start, size);
+
+	return va;
 }
 
 static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
-		struct persistent_ram_zone *prz)
+		struct persistent_ram_zone *prz, int memtype)
 {
 	prz->paddr = start;
 	prz->size = size;
 
 	if (pfn_valid(start >> PAGE_SHIFT))
-		prz->vaddr = persistent_ram_vmap(start, size);
+		prz->vaddr = persistent_ram_vmap(start, size, memtype);
 	else
-		prz->vaddr = persistent_ram_iomap(start, size);
+		prz->vaddr = persistent_ram_iomap(start, size, memtype);
 
 	if (!prz->vaddr) {
 		pr_err("%s: Failed to map 0x%llx pages at 0x%llx\n", __func__,
@@ -500,7 +512,8 @@ void persistent_ram_free(struct persistent_ram_zone *prz)
 }
 
 struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
-			u32 sig, struct persistent_ram_ecc_info *ecc_info)
+			u32 sig, struct persistent_ram_ecc_info *ecc_info,
+			unsigned int memtype)
 {
 	struct persistent_ram_zone *prz;
 	int ret = -ENOMEM;
@@ -511,7 +524,7 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 		goto err;
 	}
 
-	ret = persistent_ram_buffer_map(start, size, prz);
+	ret = persistent_ram_buffer_map(start, size, prz, memtype);
 	if (ret)
 		goto err;
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 9974975d40db..4af3fdc85b01 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -53,7 +53,8 @@ struct persistent_ram_zone {
 };
 
 struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
-			u32 sig, struct persistent_ram_ecc_info *ecc_info);
+			u32 sig, struct persistent_ram_ecc_info *ecc_info,
+			unsigned int memtype);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
 
@@ -76,6 +77,7 @@ ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	unsigned int	mem_type;
 	unsigned long	record_size;
 	unsigned long	console_size;
 	unsigned long	ftrace_size;
-- 
2.1.4

