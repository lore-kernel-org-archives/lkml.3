Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbbALFFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 00:05:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbbALFFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 00:05:17 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [Patch V2 3/4] xen: use correct type for physical addresses
Date: Mon, 12 Jan 2015 06:05:09 +0100
Message-Id: <1421039110-11207-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421039110-11207-1-git-send-email-jgross@suse.com>
References: <1421039110-11207-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting a pfn to a physical address be sure to use 64 bit
wide types or convert the physical address to a pfn if possible.

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index feb6d86..410210f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -140,7 +140,7 @@ static void __init xen_del_extra_mem(u64 start, u64 size)
 unsigned long __ref xen_chk_extra_mem(unsigned long pfn)
 {
 	int i;
-	unsigned long addr = PFN_PHYS(pfn);
+	phys_addr_t addr = PFN_PHYS(pfn);
 
 	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
 		if (addr >= xen_extra_mem[i].start &&
@@ -284,7 +284,7 @@ static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
 	}
 
 	/* Update kernel mapping, but not for highmem. */
-	if ((pfn << PAGE_SHIFT) >= __pa(high_memory))
+	if (pfn >= PFN_UP(__pa(high_memory - 1)))
 		return;
 
 	if (HYPERVISOR_update_va_mapping((unsigned long)__va(pfn << PAGE_SHIFT),
-- 
2.1.2

