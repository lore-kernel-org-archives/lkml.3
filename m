Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbaHYXPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:15:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29848 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933648AbaHYXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:15:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/hj1irikwMn37oQWcWGE5D
Date: Mon, 25 Aug 2014 16:14:50 -0700
From: Tony Lindgren <tony@atomide.com>
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robherring2@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH] pstore/ram_core: Fix hang on ARMs because of pgprot_noncached
Message-ID: <20140825231449.GS17254@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently trying to use pstore on ARMs can hang as we're mapping the
peristent RAM with pgprot_noncached(). On ARMs, this will actually
make the memory strongly ordered, and as the atomic operations pstore
uses are implementation defined for strongly ordered memory, they
may not work.

An earlier fix was done by Rob Herring <robherring2@gmail.com> to
change the mapping to be pgprot_writecombine() instead as that's often
defined as pgprot_noncached() anyways. However, as pointed out by
Colin Cross <ccross@android.com>, in some cases you do want to use
pgprot_noncached() on ARMs if the SoC supports it to see a debug
printk just before a write hanging the system.

So let's fix this issue by adding a module parameter for mem_cached,
and default to having it set. This fixes pstore at least for omaps,
and does not change the default for x86. And people debugging system
hangs can set the mem_cached to zero as needed.

Cc: Rob Herring <robherring2@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>

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
 
-	prot = pgprot_noncached(PAGE_KERNEL);
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
 
-	return ioremap(start, size);
+	if (cached)
+		va = ioremap(start, size);
+	else
+		va = ioremap_wc(start, size);
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
