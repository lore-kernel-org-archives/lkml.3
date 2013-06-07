Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3FGIwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:52:00 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43042 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3FGIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:51:51 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 1/6] KVM: MMU: retain more available bits on mmio spte
Date: Fri,  7 Jun 2013 16:51:23 +0800
Message-Id: <1370595088-3315-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060708-8256-0000-0000-000007D497EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let mmio spte only use bit62 and bit63 on upper 32 bits, then bit 52 ~ bit 61
can be used for other purposes

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c | 4 ++--
 arch/x86/kvm/x86.c | 8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 260a919..78ee123 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4176,10 +4176,10 @@ static void ept_set_mmio_spte_mask(void)
 	/*
 	 * EPT Misconfigurations can be generated if the value of bits 2:0
 	 * of an EPT paging-structure entry is 110b (write/execute).
-	 * Also, magic bits (0xffull << 49) is set to quickly identify mmio
+	 * Also, magic bits (0x3ull << 62) is set to quickly identify mmio
 	 * spte.
 	 */
-	kvm_mmu_set_mmio_spte_mask(0xffull << 49 | 0x6ull);
+	kvm_mmu_set_mmio_spte_mask((0x3ull << 62) | 0x6ull);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6402951..54059ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5263,7 +5263,13 @@ static void kvm_set_mmio_spte_mask(void)
 	 * Set the reserved bits and the present bit of an paging-structure
 	 * entry to generate page fault with PFER.RSV = 1.
 	 */
-	mask = ((1ull << (62 - maxphyaddr + 1)) - 1) << maxphyaddr;
+	 /* Mask the reserved physical address bits. */
+	mask = ((1ull << (51 - maxphyaddr + 1)) - 1) << maxphyaddr;
+
+	/* Bit 62 is always reserved for 32bit host. */
+	mask |= 0x3ull << 62;
+
+	/* Set the present bit. */
 	mask |= 1ull;
 
 #ifdef CONFIG_X86_64
-- 
1.8.1.4

