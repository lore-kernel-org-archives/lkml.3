Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaKPK4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:56:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaKPK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:56:09 -0500
Date: Sun, 16 Nov 2014 02:55:54 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-2df58b6d35306e8dab48923c9fbe9e1ad17537e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        stefan.bader@canonical.com, mingo@kernel.org, jgross@suse.com
Reply-To: mingo@kernel.org, jgross@suse.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, stefan.bader@canonical.com
In-Reply-To: <1415019724-4317-7-git-send-email-jgross@suse.com>
References: <1415019724-4317-7-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use new cache mode type in arch/x86/mm/
 init_64.c
Git-Commit-ID: 2df58b6d35306e8dab48923c9fbe9e1ad17537e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2df58b6d35306e8dab48923c9fbe9e1ad17537e2
Gitweb:     http://git.kernel.org/tip/2df58b6d35306e8dab48923c9fbe9e1ad17537e2
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:52 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:25 +0100

x86: Use new cache mode type in arch/x86/mm/init_64.c

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-7-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/init_64.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ebca30f..bd42786 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -337,12 +337,15 @@ pte_t * __init populate_extra_pte(unsigned long vaddr)
  * Create large page table mappings for a range of physical addresses.
  */
 static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
-						pgprot_t prot)
+					enum page_cache_mode cache)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
+	pgprot_t prot;
 
+	pgprot_val(prot) = pgprot_val(PAGE_KERNEL_LARGE) |
+		pgprot_val(pgprot_4k_2_large(cachemode2pgprot(cache)));
 	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));
 	for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
 		pgd = pgd_offset_k((unsigned long)__va(phys));
@@ -365,12 +368,12 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 
 void __init init_extra_mapping_wb(unsigned long phys, unsigned long size)
 {
-	__init_extra_mapping(phys, size, PAGE_KERNEL_LARGE);
+	__init_extra_mapping(phys, size, _PAGE_CACHE_MODE_WB);
 }
 
 void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 {
-	__init_extra_mapping(phys, size, PAGE_KERNEL_LARGE_NOCACHE);
+	__init_extra_mapping(phys, size, _PAGE_CACHE_MODE_UC);
 }
 
 /*
