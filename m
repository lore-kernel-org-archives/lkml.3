Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3LPXgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:36:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44154 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab3LPXgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:36:43 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Date: Tue, 17 Dec 2013 00:36:37 +0100
Message-Id: <1387236997-26975-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387236997-26975-1-git-send-email-bp@alien8.de>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Currently, running SetVirtualAddressMap() and passing the physical
address of the virtual map array was working only by a lucky coincidence
because the memory was present in the EFI page table too. Until Toshi
went and booted this on a big HP box - the krealloc() manner of resizing
the memmap we're doing did allocate from such physical addresses which
were not mapped anymore and boom:

http://lkml.kernel.org/r/1386806463.1791.295.camel@misato.fc.hp.com

One way to take care of that issue is to reimplement the krealloc thing
but with pages. We start with contiguous pages of order 1, i.e. 2 pages,
and when we deplete that memory (shouldn't happen all that often but you
know firmware) we realloc the next power-of-two pages.

Having the pages, it is much more handy and easy to map them into the
EFI page table with the already existing mapping code which we're using
for building the virtual mappings.

And, it doesn't matter all that much how much pages we've used as we're
freeing them right after they've fulfilled their purpose at the end of
the function anyway.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 57 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 51d6285701e9..39c52cc9b63a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -112,7 +112,6 @@ static int __init setup_storage_paranoia(char *arg)
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 
-
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	unsigned long flags;
@@ -775,6 +774,27 @@ void __init old_map_region(efi_memory_desc_t *md)
 		       (unsigned long long)md->phys_addr);
 }
 
+static void *realloc_pages(void *old_memmap, int old_shift)
+{
+	void *ret;
+
+	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
+	if (!ret)
+		goto out;
+
+	/*
+	 * A first-time allocation doesn't have anything to copy.
+	 */
+	if (!old_memmap)
+		return ret;
+
+	memcpy(ret, old_memmap, PAGE_SIZE << old_shift);
+
+out:
+	__free_pages(old_memmap, old_shift);
+	return ret;
+}
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, we look through the EFI memmap and map every region that
@@ -794,12 +814,13 @@ void __init old_map_region(efi_memory_desc_t *md)
  */
 void __init efi_enter_virtual_mode(void)
 {
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long size, new_memmap_left = 0;
 	efi_memory_desc_t *md, *prev_md = NULL;
+	int count = 0, new_memmap_shift = 0;
 	void *p, *new_memmap = NULL;
-	unsigned long size;
 	efi_status_t status;
 	u64 end, systab;
-	int count = 0;
 
 	efi.systab = NULL;
 
@@ -862,14 +883,19 @@ void __init efi_enter_virtual_mode(void)
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
 
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
-		if (!new_memmap)
-			goto err_out;
+		if (new_memmap_left < memmap.desc_size) {
+			new_memmap = realloc_pages(new_memmap, new_memmap_shift);
+			if (!new_memmap)
+				goto err_out;
+
+			new_memmap_shift++;
+			new_memmap_left += PAGE_SIZE << new_memmap_shift;
+		}
 
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
+
+		new_memmap_left -= memmap.desc_size;
 		count++;
 	}
 
@@ -880,6 +906,19 @@ void __init efi_enter_virtual_mode(void)
 
 	efi_dump_pagetable();
 
+	/*
+	 * It can happen that the physical address of new_memmap lands in memory
+	 * which is not mapped in the EFI page table. Therefore we need to go
+	 * and ident-map those pages containing the map before calling
+	 * phys_efi_set_virtual_address_map().
+	 */
+	if (kernel_map_pages_in_pgd(pgd, __pa(new_memmap), __pa(new_memmap),
+				    1 << new_memmap_shift, _PAGE_NX)) {
+		pr_err("Error ident-mapping new memmap (0x%lx)!\n",
+		       __pa(new_memmap));
+		goto err_out;
+	}
+
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
 		memmap.desc_size,
@@ -916,7 +955,7 @@ void __init efi_enter_virtual_mode(void)
 	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
 
-	kfree(new_memmap);
+	__free_pages(new_memmap, new_memmap_shift);
 
 	/* clean DUMMY object */
 	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-- 
1.8.4

