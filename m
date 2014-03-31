Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaCaSu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbaCaSu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:50:27 -0400
Date: Mon, 31 Mar 2014 21:50:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, gleb@kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] kvm: support any-length wildcard ioeventfd
Message-ID: <1396291468-12120-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is sometimes benefitial to ignore IO size, and only match on address.
In hindsight this would have been a better default than matching length
when KVM_IOEVENTFD_FLAG_DATAMATCH is not set, In particular, this kind
of access can be optimized on VMX: there no need to do page lookups.
This can currently be done with many ioeventfds but in a suboptimal way.

However we can't change kernel/userspace ABI without risk of breaking
some applications.
Use len = 0 to mean "ignore length for matching" in a more optimal way.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/kvm.h |  3 ++-
 arch/x86/kvm/x86.c       |  1 +
 virt/kvm/eventfd.c       | 27 ++++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 932d7f2..d73007e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -464,7 +464,7 @@ enum {
 struct kvm_ioeventfd {
 	__u64 datamatch;
 	__u64 addr;        /* legal pio/mmio address */
-	__u32 len;         /* 1, 2, 4, or 8 bytes    */
+	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
 	__s32 fd;
 	__u32 flags;
 	__u8  pad[36];
@@ -675,6 +675,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_SPAPR_MULTITCE 94
 #define KVM_CAP_EXT_EMUL_CPUID 95
 #define KVM_CAP_HYPERV_TIME 96
+#define KVM_CAP_IOEVENTFD_NO_LENGTH 97
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6218b..8ae1ff5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2602,6 +2602,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_IRQFD:
 	case KVM_CAP_IOEVENTFD:
+	case KVM_CAP_IOEVENTFD_NO_LENGTH:
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index abe4d60..9eadb59 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -600,7 +600,15 @@ ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
 {
 	u64 _val;
 
-	if (!(addr == p->addr && len == p->length))
+	if (addr != p->addr)
+		/* address must be precise for a hit */
+		return false;
+
+	if (!p->length)
+		/* length = 0 means only look at the address, so always a hit */
+		return true;
+
+	if (len != p->length)
 		/* address-range must be precise for a hit */
 		return false;
 
@@ -671,9 +679,11 @@ ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
 
 	list_for_each_entry(_p, &kvm->ioeventfds, list)
 		if (_p->bus_idx == p->bus_idx &&
-		    _p->addr == p->addr && _p->length == p->length &&
-		    (_p->wildcard || p->wildcard ||
-		     _p->datamatch == p->datamatch))
+		    _p->addr == p->addr &&
+		    (!_p->length || !p->length ||
+		     (_p->length == p->length &&
+		      (_p->wildcard || p->wildcard ||
+		       _p->datamatch == p->datamatch))))
 			return true;
 
 	return false;
@@ -697,8 +707,9 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	int                       ret;
 
 	bus_idx = ioeventfd_bus_from_flags(args->flags);
-	/* must be natural-word sized */
+	/* must be natural-word sized, or 0 to ignore length */
 	switch (args->len) {
+	case 0:
 	case 1:
 	case 2:
 	case 4:
@@ -716,6 +727,12 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	if (args->flags & ~KVM_IOEVENTFD_VALID_FLAG_MASK)
 		return -EINVAL;
 
+	/* ioeventfd with no length can't be combined with DATAMATCH */
+	if (!args->len &&
+	    args->flags & (KVM_IOEVENTFD_FLAG_PIO |
+			   KVM_IOEVENTFD_FLAG_DATAMATCH))
+		return -EINVAL;
+
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
-- 
MST

