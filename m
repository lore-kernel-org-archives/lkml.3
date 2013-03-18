Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3CRVy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:54:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3CRVG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 40/75] powerpc: Rename USER_ESID_BITS* to ESID_BITS*
Date: Mon, 18 Mar 2013 14:07:03 -0700
Message-Id: <20130318210513.108569433@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit af81d7878c641629f2693ae3fdaf74b4af14dfca upstream.

Now we use ESID_BITS of kernel address to build proto vsid. So rename
USER_ESIT_BITS to ESID_BITS

Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/mmu-hash64.h |   16 ++++++++--------
 arch/powerpc/kernel/exceptions-64s.S  |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c |    4 ++--
 arch/powerpc/mm/pgtable_64.c          |    2 +-
 arch/powerpc/mm/slb_low.S             |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -378,12 +378,12 @@ extern void slb_set_size(u16 size);
  */
 
 #define CONTEXT_BITS		19
-#define USER_ESID_BITS		18
-#define USER_ESID_BITS_1T	6
+#define ESID_BITS		18
+#define ESID_BITS_1T		6
 
 /*
  * 256MB segment
- * The proto-VSID space has 2^(CONTEX_BITS + USER_ESID_BITS) - 1 segments
+ * The proto-VSID space has 2^(CONTEX_BITS + ESID_BITS) - 1 segments
  * available for user + kernel mapping. The top 4 contexts are used for
  * kernel mapping. Each segment contains 2^28 bytes. Each
  * context maps 2^46 bytes (64TB) so we can support 2^19-1 contexts
@@ -396,15 +396,15 @@ extern void slb_set_size(u16 size);
  * doesn't overflow 64 bits. It should also be co-prime to vsid_modulus
  */
 #define VSID_MULTIPLIER_256M	ASM_CONST(12538073)	/* 24-bit prime */
-#define VSID_BITS_256M		(CONTEXT_BITS + USER_ESID_BITS)
+#define VSID_BITS_256M		(CONTEXT_BITS + ESID_BITS)
 #define VSID_MODULUS_256M	((1UL<<VSID_BITS_256M)-1)
 
 #define VSID_MULTIPLIER_1T	ASM_CONST(12538073)	/* 24-bit prime */
-#define VSID_BITS_1T		(CONTEXT_BITS + USER_ESID_BITS_1T)
+#define VSID_BITS_1T		(CONTEXT_BITS + ESID_BITS_1T)
 #define VSID_MODULUS_1T		((1UL<<VSID_BITS_1T)-1)
 
 
-#define USER_VSID_RANGE	(1UL << (USER_ESID_BITS + SID_SHIFT))
+#define USER_VSID_RANGE	(1UL << (ESID_BITS + SID_SHIFT))
 
 /*
  * This macro generates asm code to compute the VSID scramble
@@ -540,9 +540,9 @@ static inline unsigned long get_vsid(uns
 		return 0;
 
 	if (ssize == MMU_SEGSIZE_256M)
-		return vsid_scramble((context << USER_ESID_BITS)
+		return vsid_scramble((context << ESID_BITS)
 				     | (ea >> SID_SHIFT), 256M);
-	return vsid_scramble((context << USER_ESID_BITS_1T)
+	return vsid_scramble((context << ESID_BITS_1T)
 			     | (ea >> SID_SHIFT_1T), 1T);
 }
 
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1288,7 +1288,7 @@ _GLOBAL(do_stab_bolted)
 	addi	r9,r9,(MAX_USER_CONTEXT + 1)@l
 
 	srdi	r10,r11,SID_SHIFT
-	rldimi  r10,r9,USER_ESID_BITS,0 /* proto vsid */
+	rldimi  r10,r9,ESID_BITS,0 /* proto vsid */
 	ASM_VSID_SCRAMBLE(r10, r9, 256M)
 	rldic	r9,r10,12,16	/* r9 = vsid << 12 */
 
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -326,8 +326,8 @@ int kvmppc_mmu_init(struct kvm_vcpu *vcp
 	vcpu3s->context_id[0] = err;
 
 	vcpu3s->proto_vsid_max = ((vcpu3s->context_id[0] + 1)
-				  << USER_ESID_BITS) - 1;
-	vcpu3s->proto_vsid_first = vcpu3s->context_id[0] << USER_ESID_BITS;
+				  << ESID_BITS) - 1;
+	vcpu3s->proto_vsid_first = vcpu3s->context_id[0] << ESID_BITS;
 	vcpu3s->proto_vsid_next = vcpu3s->proto_vsid_first;
 
 	kvmppc_mmu_hpte_init(vcpu);
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -61,7 +61,7 @@
 #endif
 
 #ifdef CONFIG_PPC_STD_MMU_64
-#if TASK_SIZE_USER64 > (1UL << (USER_ESID_BITS + SID_SHIFT))
+#if TASK_SIZE_USER64 > (1UL << (ESID_BITS + SID_SHIFT))
 #error TASK_SIZE_USER64 exceeds user VSID range
 #endif
 #endif
--- a/arch/powerpc/mm/slb_low.S
+++ b/arch/powerpc/mm/slb_low.S
@@ -232,7 +232,7 @@ _GLOBAL(slb_allocate_user)
  * r3 = EA, r9 = context, r10 = ESID, r11 = flags, clobbers r9, cr7 = <> PAGE_OFFSET
  */
 slb_finish_load:
-	rldimi  r10,r9,USER_ESID_BITS,0
+	rldimi  r10,r9,ESID_BITS,0
 	ASM_VSID_SCRAMBLE(r10,r9,256M)
 	/*
 	 * bits above VSID_BITS_256M need to be ignored from r10
@@ -301,7 +301,7 @@ _GLOBAL(slb_compare_rr_to_size)
  */
 slb_finish_load_1T:
 	srdi	r10,r10,(SID_SHIFT_1T - SID_SHIFT)	/* get 1T ESID */
-	rldimi  r10,r9,USER_ESID_BITS_1T,0
+	rldimi  r10,r9,ESID_BITS_1T,0
 	ASM_VSID_SCRAMBLE(r10,r9,1T)
 	/*
 	 * bits above VSID_BITS_1T need to be ignored from r10


