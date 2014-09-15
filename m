Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaIOFLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 01:11:22 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:19651 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbaIOFLR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 01:11:17 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Mon, 15 Sep 2014 13:11:14 +0800
Subject: [RFC] arm:extend the reserved mrmory for initrd to be page aligned
Thread-Topic: [RFC] arm:extend the reserved mrmory for initrd to be page
 aligned
Thread-Index: Ac/Qo3jYL9hQ0r4iTG6jLB8a3ylZFQ==
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB4915FC@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch extend the start and end address of initrd to be page aligned,
so that we can free all memory including the un-page aligned head or tail
page of initrd, if the start or end address of initrd are not page
aligned, the page can't be freed by free_initrd_mem() function.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm/mm/init.c   | 20 ++++++++++++++------
 arch/arm64/mm/init.c | 37 +++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d..6c1db07 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -288,7 +288,12 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 		phys_initrd_start = __virt_to_phys(initrd_start);
 		phys_initrd_size = initrd_end - initrd_start;
 	}
-	initrd_start = initrd_end = 0;
+
+	/* make sure the start and end address are page aligned */
+	phys_initrd_size = round_up(phys_initrd_start + phys_initrd_size, PAGE_SIZE);
+	phys_initrd_start = round_down(phys_initrd_start, PAGE_SIZE);
+	phys_initrd_size -= phys_initrd_start;
+
 	if (phys_initrd_size &&
 	    !memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
 		pr_err("INITRD: 0x%08llx+0x%08lx is not a memory region - disabling initrd\n",
@@ -301,13 +306,11 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 		       (u64)phys_initrd_start, phys_initrd_size);
 		phys_initrd_start = phys_initrd_size = 0;
 	}
-	if (phys_initrd_size) {
+	if (phys_initrd_size)
 		memblock_reserve(phys_initrd_start, phys_initrd_size);
+	else
+		initrd_start = initrd_end = 0;
 
-		/* Now convert initrd to virtual addresses */
-		initrd_start = __phys_to_virt(phys_initrd_start);
-		initrd_end = initrd_start + phys_initrd_size;
-	}
 #endif
 
 	arm_mm_memblock_reserve();
@@ -636,6 +639,11 @@ static int keep_initrd;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd) {
+		if (start == initrd_start)
+			start = round_down(start, PAGE_SIZE);
+		if (end == initrd_end)
+			end = round_up(end, PAGE_SIZE);
+
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
 		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 	}
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c24..9dfd9a6 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -138,15 +138,38 @@ static void arm64_memory_present(void)
 void __init arm64_memblock_init(void)
 {
 	phys_addr_t dma_phys_limit = 0;
-
+	phys_addr_t phys_initrd_start;
+	phys_addr_t phys_initrd_size;
 	/*
 	 * Register the kernel text, kernel data, initrd, and initial
 	 * pagetables with memblock.
 	 */
 	memblock_reserve(__pa(_text), _end - _text);
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (initrd_start)
-		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
+	if (initrd_start) {
+		phys_initrd_start = __virt_to_phys(initrd_start);
+		phys_initrd_size = initrd_end - initrd_start;
+		/* make sure the start and end address are page aligned */
+		phys_initrd_size = round_up(phys_initrd_start + phys_initrd_size, PAGE_SIZE);
+		phys_initrd_start = round_down(phys_initrd_start, PAGE_SIZE);
+		phys_initrd_size -= phys_initrd_start;
+		if (phys_initrd_size &&
+				!memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
+			pr_err("INITRD: %pa+%pa is not a memory region - disabling initrd\n",
+					&phys_initrd_start, &phys_initrd_size);
+			phys_initrd_start = phys_initrd_size = 0;
+		}
+		if (phys_initrd_size &&
+				memblock_is_region_reserved(phys_initrd_start, phys_initrd_size)) {
+			pr_err("INITRD: %pa+%pa overlaps in-use memory region - disabling initrd\n",
+					&phys_initrd_start, &phys_initrd_size);
+			phys_initrd_start = phys_initrd_size = 0;
+		}
+		if (phys_initrd_size)
+			memblock_reserve(phys_initrd_start, phys_initrd_size);
+		else
+			initrd_start = initrd_end = 0;
+	}
 #endif
 
 	if (!efi_enabled(EFI_MEMMAP))
@@ -334,8 +357,14 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd)
+	if (!keep_initrd) {
+		if (start == initrd_start)
+			start = round_down(start, PAGE_SIZE);
+		if (end == initrd_end)
+			end = round_up(end, PAGE_SIZE);
+
 		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	}
 }
 
 static int __init keepinitrd_setup(char *__unused)
-- 
2.1.0

