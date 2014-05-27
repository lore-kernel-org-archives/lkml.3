Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaE0OKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:10:09 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49037 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaE0OKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:10:07 -0400
From: Matt Fleming <matt.fleming@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH] mm: bootmem: Check pfn_valid() before accessing struct page
Date: Tue, 27 May 2014 15:10:02 +0100
Message-Id: <1401199802-10212-1-git-send-email-matt.fleming@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check that a pfn is valid before handing it to pfn_to_page()
since on low memory systems with CONFIG_HIGHMEM=n it's possible that a
pfn may not have a corresponding struct page.

This is in fact the case for one of Alan's machines where some of the
EFI boot services pages live in highmem, and running a kernel without
CONFIG_HIGHMEM enabled results in the following oops,

 BUG: unable to handle kernel paging request at f7f1f080
 IP: [<c17fba96>] __free_pages_bootmem+0x5a/0xb8
 *pdpt = 0000000001887001 *pde = 0000000001984067 *pte = 000000000 0000000
 Oops: 0002 [#1] SMP

[...]

 Call Trace:
  [<c17feacc>] free_bootmem_late+0x2d/0x3d
  [<c17f1013>] efi_free_boot_services+0x48/0x5b
  [<c17ddc12>] start_kernel+0x3ad/0x3cf
  [<c17dd654>] ? set_init_arg+0x49/0x49
  [<c17dd380>] i386_start_kernel+0x12e/0x131

Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 mm/bootmem.c   | 3 +++
 mm/nobootmem.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 90bd3507b413..406e9cb1d58c 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -164,6 +164,9 @@ void __init free_bootmem_late(unsigned long physaddr, unsigned long size)
 	end = PFN_DOWN(physaddr + size);
 
 	for (; cursor < end; cursor++) {
+		if (!pfn_valid(cursor))
+			continue;
+
 		__free_pages_bootmem(pfn_to_page(cursor), 0);
 		totalram_pages++;
 	}
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 04a9d94333a5..afad246688ce 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -77,6 +77,9 @@ void __init free_bootmem_late(unsigned long addr, unsigned long size)
 	end = PFN_DOWN(addr + size);
 
 	for (; cursor < end; cursor++) {
+		if (!pfn_valid(cursor))
+			continue;
+
 		__free_pages_bootmem(pfn_to_page(cursor), 0);
 		totalram_pages++;
 	}
-- 
1.9.0

