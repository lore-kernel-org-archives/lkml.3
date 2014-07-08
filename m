Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaGHWbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:31:13 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59872 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaGHWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:31:12 -0400
Message-ID: <53BC7130.1010105@gmail.com>
Date: Tue, 08 Jul 2014 17:31:12 -0500
From: Stuart Hayes <stuart.w.hayes@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: linux-kernel@vger.kernel.org, bpetkov@suse.com, matt.fleming@intel.com
Subject: [PATCH] x86: Allow kernel_map_pages_in_pgd() to work when NX is disabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function kernel_map_pages_in_pgd() will not map pages if NX is
disabled, which causes a lot of problems booting in EFI mode
(efi_map_region() and other functions depend on this).  This patch
just makes sure that the NX flag doesn't get set in the page tables
if NX is disabled, rather than not mapping the pages at all.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---
--- linux-3.16-rc3/arch/x86/mm/pageattr.c.orig	2014-07-02 12:04:49.244288159 -0400
+++ linux-3.16-rc3/arch/x86/mm/pageattr.c	2014-07-02 12:05:55.808290437 -0400
@@ -1862,10 +1862,7 @@ int kernel_map_pages_in_pgd(pgd_t *pgd,
 		.flags = 0,
 	};
 
-	if (!(__supported_pte_mask & _PAGE_NX))
-		goto out;
-
-	if (!(page_flags & _PAGE_NX))
+	if ((!(__supported_pte_mask & _PAGE_NX)) || !(page_flags & _PAGE_NX))
 		cpa.mask_clr = __pgprot(_PAGE_NX);
 
 	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);

