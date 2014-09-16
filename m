Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaIPUu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:50:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59576 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753210AbaIPUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:50:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/7AFz5FVXXTzEGHtGlmu+d
Date: Tue, 16 Sep 2014 13:50:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/2] pstore-ram: Allow optional mapping with
 pgprot_noncached
Message-ID: <20140916205000.GA6672@atomide.com>
References: <1410546745-919-1-git-send-email-tony@atomide.com>
 <1410546745-919-2-git-send-email-tony@atomide.com>
 <20140912231514.GB12379@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912231514.GB12379@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [140912 16:16]:
> On Fri, Sep 12, 2014 at 11:32:25AM -0700, Tony Lindgren wrote:
> > On some ARMs at least the memory can be mapped pgprot_noncached()
> > and still be working for atomic operations. As pointed out by
> > Colin Cross <ccross@android.com>, in some cases you do want to use
> > pgprot_noncached() if the SoC supports it to see a debug printk
> > just before a write hanging the system.
> > 
> > On ARMs, the atomic operations on strongly ordered memory are
> > implementation defined. So let's provide an optional kernel parameter
> > for configuring noncached memory, and use pgprot_writecombine() by
> > default.
> 
> Can we clean up this terminology please?
> 
> Writecombine memory is not cached - write combine memory bypasses the
> caches entirely.  What it doesn't bypass are store buffers, which may
> combine two writes together.  So, calling it "cached" is misleading.

Good point. I've pretty much s/cached/memtype/ and updated the
description too in the patch below.
 
> Secondly, memory returned by ioremap() is not strongly ordered, it is
> device memory.  There's three main classifications of memory on ARM:
> strongly ordered, device and normal memory.  Normal memory has attributes
> which define whether it is write combining, or cacheable in some way (and
> if so, how it's cacheable.)
> 
> Exclusives are always permitted to normal memory.  The other two are
> implementation defined.  While an implementation may offer it on
> strongly ordered, that doesn't mean that it also supports it on device
> memory.
> 
> Lastly, aliased mappings are something that ARM has always strongly
> discouraged on ARMv6+ (it was plain down-right unpredictable, but it's
> now "strongly discouraged") and remapping memory with different memory
> type should be avoided.

Yes thanks for the summary again. Maybe let's let this second patch float
on the lists for a while until we have somebody actually test it on
unbuffered memory.

Andrew, if no comments on 1/2 in this series, can you please pick it up
for fixes so we get pstore working?

Here's the updated version of the second patch for reference.

Regards,

Tony

8< -----------------
From: Tony Lindgren <tony@atomide.com>
Date: Thu, 11 Sep 2014 15:02:37 -0700
Subject: [PATCH] pstore-ram: Allow optional mapping with pgprot_noncached

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
Cc: Kees Cook <keescook@chromium.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>

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
 
 	pages = kmalloc_array(page_count, sizeof(struct page *), GFP_KERNEL);
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
