Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161102Ab3LFM75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:59:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082Ab3LFM7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/272] arm/arm64: KVM: Fix hyp mappings of vmalloc regions
Date: Fri,  6 Dec 2013 12:55:07 +0000
Message-Id: <1386334761-25517-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Dall <christoffer.dall@linaro.org>

commit 40c2729bab48e2832b17c1fa8af9db60e776131b upstream.

Using virt_to_phys on percpu mappings is horribly wrong as it may be
backed by vmalloc.  Introduce kvm_kaddr_to_phys which translates both
types of valid kernel addresses to the corresponding physical address.

At the same time resolves a typing issue where we were storing the
physical address as a 32 bit unsigned long (on arm), truncating the
physical address for addresses above the 4GB limit.  This caused
breakage on Keystone.

Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kvm/mmu.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 0988d9e..b91a68b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -307,6 +307,17 @@ out:
 	return err;
 }
 
+static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
+{
+	if (!is_vmalloc_addr(kaddr)) {
+		BUG_ON(!virt_addr_valid(kaddr));
+		return __pa(kaddr);
+	} else {
+		return page_to_phys(vmalloc_to_page(kaddr)) +
+		       offset_in_page(kaddr);
+	}
+}
+
 /**
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
@@ -318,16 +329,27 @@ out:
  */
 int create_hyp_mappings(void *from, void *to)
 {
-	unsigned long phys_addr = virt_to_phys(from);
+	phys_addr_t phys_addr;
+	unsigned long virt_addr;
 	unsigned long start = KERN_TO_HYP((unsigned long)from);
 	unsigned long end = KERN_TO_HYP((unsigned long)to);
 
-	/* Check for a valid kernel memory mapping */
-	if (!virt_addr_valid(from) || !virt_addr_valid(to - 1))
-		return -EINVAL;
+	start = start & PAGE_MASK;
+	end = PAGE_ALIGN(end);
 
-	return __create_hyp_mappings(hyp_pgd, start, end,
-				     __phys_to_pfn(phys_addr), PAGE_HYP);
+	for (virt_addr = start; virt_addr < end; virt_addr += PAGE_SIZE) {
+		int err;
+
+		phys_addr = kvm_kaddr_to_phys(from + virt_addr - start);
+		err = __create_hyp_mappings(hyp_pgd, virt_addr,
+					    virt_addr + PAGE_SIZE,
+					    __phys_to_pfn(phys_addr),
+					    PAGE_HYP);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 /**
-- 
1.8.3.2

