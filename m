Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaFZBHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:07:03 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:31829
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757489AbaFZBHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:01 -0400
Date: Wed, 25 Jun 2014 19:45:51 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/2 v2] ARM: KVM: user_mem_abort: support stage 2 MMIO page
 mapping
Message-ID: <20140625194551.a6443252bf913023159d25fd@freescale.com>
In-Reply-To: <53A9556D.3000003@arm.com>
References: <1395785294-2545-1-git-send-email-kim.phillips@linaro.org>
	<1395785294-2545-2-git-send-email-kim.phillips@linaro.org>
	<20140506180448.GH3066@lvm>	<87bnvaotei.fsf@approximate.cambridge.arm.com>
	<20140507145557.GJ3066@lvm>	<20140624102327.GA9121@arm.com>
	<53A9556D.3000003@arm.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(46102001)(69596002)(99396002)(87286001)(19580405001)(83322001)(87936001)(6806004)(88136002)(100306002)(20776003)(81542001)(81342001)(89996001)(68736004)(44976005)(50466002)(19580395003)(47776003)(104166001)(92566001)(21056001)(102836001)(92726001)(4396001)(85852003)(76482001)(26826002)(80022001)(50986999)(79102001)(93916002)(46406003)(76176999)(50226001)(86362001)(36756003)(93886003)(77982001)(74502001)(74662001)(31966008)(83072002)(95666004)(81156004)(104016002)(97736001)(105606002)(85306003)(23726002)(77156001)(33646001)(64706001)(84676001)(62966002)(106466001)(107046002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB091;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02543CD7CD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kim Phillips <kim.phillips@linaro.org>

A userspace process can map device MMIO memory via VFIO or /dev/mem,
e.g., for platform device passthrough support in QEMU.

During early development, we found the PAGE_S2 memory type being used
for MMIO mappings.  This patch corrects that by using the more strongly
ordered memory type for device MMIO mappings: PAGE_S2_DEVICE.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Hi, here's a v2, upon request:

- rebased onto today's mainline ToT
- mmu.o-build tested only (ToT build doesn't complete)
- made commit text less terse
- added Christoffer's ack

Cheers,

Kim

 arch/arm/kvm/mmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 16f8049..69af021 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -748,6 +748,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
 	pfn_t pfn;
+	pgprot_t mem_type = PAGE_S2;
 
 	write_fault = kvm_is_write_fault(kvm_vcpu_get_hsr(vcpu));
 	if (fault_status == FSC_PERM && !write_fault) {
@@ -798,6 +799,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_pfn(pfn))
 		return -EFAULT;
 
+	if (kvm_is_mmio_pfn(pfn))
+		mem_type = PAGE_S2_DEVICE;
+
 	spin_lock(&kvm->mmu_lock);
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -805,7 +809,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
 	if (hugetlb) {
-		pmd_t new_pmd = pfn_pmd(pfn, PAGE_S2);
+		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
 		new_pmd = pmd_mkhuge(new_pmd);
 		if (writable) {
 			kvm_set_s2pmd_writable(&new_pmd);
@@ -814,13 +818,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		coherent_cache_guest_page(vcpu, hva & PMD_MASK, PMD_SIZE);
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
-		pte_t new_pte = pfn_pte(pfn, PAGE_S2);
+		pte_t new_pte = pfn_pte(pfn, mem_type);
 		if (writable) {
 			kvm_set_s2pte_writable(&new_pte);
 			kvm_set_pfn_dirty(pfn);
 		}
 		coherent_cache_guest_page(vcpu, hva, PAGE_SIZE);
-		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, false);
+		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte,
+				     mem_type == PAGE_S2_DEVICE);
 	}
 
 
-- 
2.0.0

