Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbbAHRBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:01:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698AbbAHRBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:01:35 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 3/3] xen: use correct type for physical addresses
Date: Thu,  8 Jan 2015 18:01:30 +0100
Message-Id: <1420736490-15351-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420736490-15351-1-git-send-email-jgross@suse.com>
References: <1420736490-15351-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting a pfn to a physical address be sure to use 64 bit
wide types.

Also avoid invalidating memory for zero sized non-aligned extra
memory regions.

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/setup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index feb6d86..8839d7b 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -140,7 +140,7 @@ static void __init xen_del_extra_mem(u64 start, u64 size)
 unsigned long __ref xen_chk_extra_mem(unsigned long pfn)
 {
 	int i;
-	unsigned long addr = PFN_PHYS(pfn);
+	u64 addr = PFN_PHYS(pfn);
 
 	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
 		if (addr >= xen_extra_mem[i].start &&
@@ -160,6 +160,8 @@ void __init xen_inv_extra_mem(void)
 	int i;
 
 	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
+		if (!xen_extra_mem[i].size)
+			continue;
 		pfn_s = PFN_DOWN(xen_extra_mem[i].start);
 		pfn_e = PFN_UP(xen_extra_mem[i].start + xen_extra_mem[i].size);
 		for (pfn = pfn_s; pfn < pfn_e; pfn++)
@@ -284,7 +286,7 @@ static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
 	}
 
 	/* Update kernel mapping, but not for highmem. */
-	if ((pfn << PAGE_SHIFT) >= __pa(high_memory))
+	if (PFN_PHYS(pfn) >= (u64)(__pa(high_memory)))
 		return;
 
 	if (HYPERVISOR_update_va_mapping((unsigned long)__va(pfn << PAGE_SHIFT),
-- 
2.1.2

