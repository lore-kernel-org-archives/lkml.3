Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022AbaEMO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:58:59 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:49299 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964997AbaEMO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:51 -0400
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, mimu@linux.vnet.ibm.com
Subject: [PATCH v1 RFC 2/6] KVM: s390: split SIE state guest prefix field
Date: Tue, 13 May 2014 16:58:30 +0200
Message-Id: <1399993114-15333-3-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051314-0542-0000-0000-000008F959B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the SIE state guest prefix at offset 4
into a prefix bit field. Additionally it provides the
access functions:

 - kvm_s390_get_prefix()
 - kvm_s390_set_prefix()

to access the prefix per vcpu.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/kvm/diag.c             |  2 +-
 arch/s390/kvm/gaccess.h          |  8 ++++----
 arch/s390/kvm/kvm-s390.c         | 10 ++++++----
 arch/s390/kvm/kvm-s390.h         |  8 +++++++-
 arch/s390/kvm/priv.c             |  3 +--
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95f3dd4..38d487a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -82,7 +82,9 @@ struct sca_block {
 
 struct kvm_s390_sie_block {
 	atomic_t cpuflags;		/* 0x0000 */
-	__u32	prefix;			/* 0x0004 */
+	__u32 : 1;			/* 0x0004 */
+	__u32 prefix : 18;
+	__u32 : 13;
 	__u8	reserved08[4];		/* 0x0008 */
 #define PROG_IN_SIE (1<<0)
 	__u32	prog0c;			/* 0x000c */
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 004d385..0161675 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -23,7 +23,7 @@
 static int diag_release_pages(struct kvm_vcpu *vcpu)
 {
 	unsigned long start, end;
-	unsigned long prefix  = vcpu->arch.sie_block->prefix;
+	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
 
 	start = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
 	end = vcpu->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + 4096;
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 68db43e..a07ee08 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -30,7 +30,7 @@
 static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 						 unsigned long gra)
 {
-	unsigned long prefix = vcpu->arch.sie_block->prefix;
+	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
 
 	if (gra < 2 * PAGE_SIZE)
 		gra += prefix;
@@ -99,7 +99,7 @@ static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
 	unsigned long __gpa;					\
 								\
 	__gpa = (unsigned long)(gra);				\
-	__gpa += __vcpu->arch.sie_block->prefix;		\
+	__gpa += kvm_s390_get_prefix(__vcpu);			\
 	kvm_write_guest(__vcpu->kvm, __gpa, &__x, sizeof(__x));	\
 })
 
@@ -124,7 +124,7 @@ static inline __must_check
 int write_guest_lc(struct kvm_vcpu *vcpu, unsigned long gra, void *data,
 		   unsigned long len)
 {
-	unsigned long gpa = gra + vcpu->arch.sie_block->prefix;
+	unsigned long gpa = gra + kvm_s390_get_prefix(vcpu);
 
 	return kvm_write_guest(vcpu->kvm, gpa, data, len);
 }
@@ -150,7 +150,7 @@ static inline __must_check
 int read_guest_lc(struct kvm_vcpu *vcpu, unsigned long gra, void *data,
 		  unsigned long len)
 {
-	unsigned long gpa = gra + vcpu->arch.sie_block->prefix;
+	unsigned long gpa = gra + kvm_s390_get_prefix(vcpu);
 
 	return kvm_read_guest(vcpu->kvm, gpa, data, len);
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5dff316..01a5212 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -846,7 +846,7 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long address)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		/* match against both prefix pages */
-		if (vcpu->arch.sie_block->prefix == (address & ~0x1000UL)) {
+		if (kvm_s390_get_prefix(vcpu) == (address & ~0x1000UL)) {
 			VCPU_EVENT(vcpu, 2, "gmap notifier for %lx", address);
 			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 			exit_sie_sync(vcpu);
@@ -1110,7 +1110,7 @@ retry:
 	if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu)) {
 		int rc;
 		rc = gmap_ipte_notify(vcpu->arch.gmap,
-				      vcpu->arch.sie_block->prefix,
+				      kvm_s390_get_prefix(vcpu),
 				      PAGE_SIZE * 2);
 		if (rc)
 			return rc;
@@ -1413,7 +1413,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	kvm_run->psw_mask     = vcpu->arch.sie_block->gpsw.mask;
 	kvm_run->psw_addr     = vcpu->arch.sie_block->gpsw.addr;
-	kvm_run->s.regs.prefix = vcpu->arch.sie_block->prefix;
+	kvm_run->s.regs.prefix = kvm_s390_get_prefix(vcpu);
 	memcpy(&kvm_run->s.regs.crs, &vcpu->arch.sie_block->gcr, 128);
 
 	if (vcpu->sigset_active)
@@ -1432,6 +1432,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long gpa)
 {
 	unsigned char archmode = 1;
+	unsigned int px;
 	u64 clkcomp;
 	int rc;
 
@@ -1450,8 +1451,9 @@ int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long gpa)
 			      vcpu->run->s.regs.gprs, 128);
 	rc |= write_guest_abs(vcpu, gpa + offsetof(struct save_area, psw),
 			      &vcpu->arch.sie_block->gpsw, 16);
+	px = kvm_s390_get_prefix(vcpu);
 	rc |= write_guest_abs(vcpu, gpa + offsetof(struct save_area, pref_reg),
-			      &vcpu->arch.sie_block->prefix, 4);
+			      &px, 4);
 	rc |= write_guest_abs(vcpu,
 			      gpa + offsetof(struct save_area, fp_ctrl_reg),
 			      &vcpu->arch.guest_fpregs.fpc, 4);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 62a5cb4..066fdbc 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -61,9 +61,15 @@ static inline int kvm_is_ucontrol(struct kvm *kvm)
 #endif
 }
 
+#define GUEST_PREFIX_SHIFT 13
+static inline u32 kvm_s390_get_prefix(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.sie_block->prefix << GUEST_PREFIX_SHIFT;
+}
+
 static inline void kvm_s390_set_prefix(struct kvm_vcpu *vcpu, u32 prefix)
 {
-	vcpu->arch.sie_block->prefix = prefix & 0x7fffe000u;
+	vcpu->arch.sie_block->prefix = prefix >> GUEST_PREFIX_SHIFT;
 	vcpu->arch.sie_block->ihcpu  = 0xffff;
 	kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 }
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index a4e5d86..19f3475 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -120,8 +120,7 @@ static int handle_store_prefix(struct kvm_vcpu *vcpu)
 	if (operand2 & 3)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	address = vcpu->arch.sie_block->prefix;
-	address = address & 0x7fffe000u;
+	address = kvm_s390_get_prefix(vcpu);
 
 	/* get the value */
 	rc = write_guest(vcpu, operand2, &address, sizeof(address));
-- 
1.8.3.1

