Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab3COP2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:28:31 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49765 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab3COP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:28:29 -0400
Message-ID: <51433E13.4000306@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 23:28:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/5] KVM: MMU: retain more available bits available on mmio
 spte
References: <51433D98.4050605@linux.vnet.ibm.com>
In-Reply-To: <51433D98.4050605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031515-9574-0000-0000-0000070B0A49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let mmio spte only use bit62 and bit63 on upper 32 bits, then bit 52 ~ bit 61
can be used for other purposes

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |    4 ++--
 arch/x86/kvm/x86.c |    8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 17a6938..54fdb76 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4003,10 +4003,10 @@ static void ept_set_mmio_spte_mask(void)
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
index 61a5bb6..81fb3c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5197,7 +5197,13 @@ static void kvm_set_mmio_spte_mask(void)
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
1.7.7.6

