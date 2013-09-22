Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3IVOpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:45:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53492 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab3IVOpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:45:08 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Date: Sun, 22 Sep 2013 16:44:50 +0200
Message-Id: <1379861095-628-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379861095-628-1-git-send-email-bp@alien8.de>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add a kvm ioctl which states which system functionality kvm emulates.
The format used is that of CPUID and we return the corresponding CPUID
bits set for which we do emulate functionality.

Make sure ->padding is being passed on clean from userspace so that we
can use it for something in the future, after the ioctl gets cast in
stone.

s/kvm_dev_ioctl_get_supported_cpuid/kvm_dev_ioctl_get_cpuid/ while at
it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Documentation/virtual/kvm/api.txt | 77 +++++++++++++++++++++++++++++++++++++--
 arch/x86/include/uapi/asm/kvm.h   |  6 +--
 arch/x86/kvm/cpuid.c              | 57 ++++++++++++++++++++++++++---
 arch/x86/kvm/cpuid.h              |  5 ++-
 arch/x86/kvm/x86.c                |  9 +++--
 include/uapi/linux/kvm.h          |  2 +
 6 files changed, 139 insertions(+), 17 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 858aecf21db2..7b70d670bb28 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1122,9 +1122,9 @@ struct kvm_cpuid2 {
 	struct kvm_cpuid_entry2 entries[0];
 };
 
-#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX 1
-#define KVM_CPUID_FLAG_STATEFUL_FUNC    2
-#define KVM_CPUID_FLAG_STATE_READ_NEXT  4
+#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
+#define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
+#define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
 
 struct kvm_cpuid_entry2 {
 	__u32 function;
@@ -2661,6 +2661,77 @@ and usually define the validity of a groups of registers. (e.g. one bit
 };
 
 
+4.81 KVM_GET_EMULATED_CPUID
+
+Capability: KVM_CAP_EXT_EMUL_CPUID
+Architectures: x86
+Type: system ioctl
+Parameters: struct kvm_cpuid2 (in/out)
+Returns: 0 on success, -1 on error
+
+struct kvm_cpuid2 {
+	__u32 nent;
+	__u32 flags;
+	struct kvm_cpuid_entry2 entries[0];
+};
+
+The member 'flags' is used for passing flags from userspace.
+
+#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
+#define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
+#define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
+
+struct kvm_cpuid_entry2 {
+	__u32 function;
+	__u32 index;
+	__u32 flags;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+	__u32 padding[3];
+};
+
+This ioctl returns x86 cpuid features which are emulated by
+kvm.Userspace can use the information returned by this ioctl to query
+which features are emulated by kvm instead of being present natively.
+
+Userspace invokes KVM_GET_EMULATED_CPUID by passing a kvm_cpuid2
+structure with the 'nent' field indicating the number of entries in
+the variable-size array 'entries'. If the number of entries is too low
+to describe the cpu capabilities, an error (E2BIG) is returned. If the
+number is too high, the 'nent' field is adjusted and an error (ENOMEM)
+is returned. If the number is just right, the 'nent' field is adjusted
+to the number of valid entries in the 'entries' array, which is then
+filled.
+
+The entries returned are the set CPUID bits of the respective features
+which kvm emulates, as returned by the CPUID instruction, with unknown
+or unsupported feature bits cleared.
+
+Features like x2apic, for example, may not be present in the host cpu
+but are exposed by kvm in KVM_GET_SUPPORTED_CPUID because they can be
+emulated efficiently and thus not included here.
+
+The fields in each entry are defined as follows:
+
+  function: the eax value used to obtain the entry
+  index: the ecx value used to obtain the entry (for entries that are
+         affected by ecx)
+  flags: an OR of zero or more of the following:
+        KVM_CPUID_FLAG_SIGNIFCANT_INDEX:
+           if the index field is valid
+        KVM_CPUID_FLAG_STATEFUL_FUNC:
+           if cpuid for this function returns different values for successive
+           invocations; there will be several entries with the same function,
+           all with this flag set
+        KVM_CPUID_FLAG_STATE_READ_NEXT:
+           for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
+           the first entry to be read by a cpu
+   eax, ebx, ecx, edx: the values returned by the cpuid instruction for
+         this function/index combination
+
+
 6. Capabilities that can be enabled
 -----------------------------------
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5d9a3033b3d7..d3a87780c70b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -211,9 +211,9 @@ struct kvm_cpuid_entry2 {
 	__u32 padding[3];
 };
 
-#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX 1
-#define KVM_CPUID_FLAG_STATEFUL_FUNC    2
-#define KVM_CPUID_FLAG_STATE_READ_NEXT  4
+#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
+#define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
+#define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
 
 /* for KVM_SET_CPUID2 */
 struct kvm_cpuid2 {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b110fe6c03d4..eca357095a49 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -187,8 +187,14 @@ static bool supported_xcr0_bit(unsigned bit)
 
 #define F(x) bit(X86_FEATURE_##x)
 
-static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
-			 u32 index, int *nent, int maxnent)
+static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
+				   u32 func, u32 index, int *nent, int maxnent)
+{
+	return 0;
+}
+
+static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
+				 u32 index, int *nent, int maxnent)
 {
 	int r;
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
@@ -481,6 +487,15 @@ out:
 	return r;
 }
 
+static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 func,
+			u32 idx, int *nent, int maxnent, unsigned int type)
+{
+	if (type == KVM_GET_EMULATED_CPUID)
+		return __do_cpuid_ent_emulated(entry, func, idx, nent, maxnent);
+
+	return __do_cpuid_ent(entry, func, idx, nent, maxnent);
+}
+
 #undef F
 
 struct kvm_cpuid_param {
@@ -495,8 +510,34 @@ static bool is_centaur_cpu(const struct kvm_cpuid_param *param)
 	return boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR;
 }
 
-int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
-				      struct kvm_cpuid_entry2 __user *entries)
+static bool sanity_check_entries(struct kvm_cpuid_entry2 __user *entries,
+				 __u32 num_entries, unsigned int ioctl_type)
+{
+	int i;
+
+	if (ioctl_type != KVM_GET_EMULATED_CPUID)
+		return false;
+
+	/*
+	 * We want to make sure that ->padding is being passed clean from
+	 * userspace in case we want to use it for something in the future.
+	 *
+	 * Sadly, this wasn't enforced for KVM_GET_SUPPORTED_CPUID and so we
+	 * have to give ourselves satisfied only with the emulated side. /me
+	 * sheds a tear.
+	 */
+	for (i = 0; i < num_entries; i++) {
+		if (entries[i].padding[0] ||
+		    entries[i].padding[1] ||
+		    entries[i].padding[2])
+			return true;
+	}
+	return false;
+}
+
+int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
+			    struct kvm_cpuid_entry2 __user *entries,
+			    unsigned int type)
 {
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	int limit, nent = 0, r = -E2BIG, i;
@@ -513,6 +554,10 @@ int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 		goto out;
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		cpuid->nent = KVM_MAX_CPUID_ENTRIES;
+
+	if (sanity_check_entries(entries, cpuid->nent, type))
+		return -EINVAL;
+
 	r = -ENOMEM;
 	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
 	if (!cpuid_entries)
@@ -526,7 +571,7 @@ int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 			continue;
 
 		r = do_cpuid_ent(&cpuid_entries[nent], ent->func, ent->idx,
-				&nent, cpuid->nent);
+				&nent, cpuid->nent, type);
 
 		if (r)
 			goto out_free;
@@ -537,7 +582,7 @@ int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 		limit = cpuid_entries[nent - 1].eax;
 		for (func = ent->func + 1; func <= limit && nent < cpuid->nent && r == 0; ++func)
 			r = do_cpuid_ent(&cpuid_entries[nent], func, ent->idx,
-				     &nent, cpuid->nent);
+				     &nent, cpuid->nent, type);
 
 		if (r)
 			goto out_free;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b7fd07984888..f1e4895174b2 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -6,8 +6,9 @@
 void kvm_update_cpuid(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
-int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
-				      struct kvm_cpuid_entry2 __user *entries);
+int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
+			    struct kvm_cpuid_entry2 __user *entries,
+			    unsigned int type);
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
 			     struct kvm_cpuid_entry __user *entries);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ca72a5cdb6..8dfde7a52dab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2564,6 +2564,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
 	case KVM_CAP_SET_TSS_ADDR:
 	case KVM_CAP_EXT_CPUID:
+	case KVM_CAP_EXT_EMUL_CPUID:
 	case KVM_CAP_CLOCKSOURCE:
 	case KVM_CAP_PIT:
 	case KVM_CAP_NOP_IO_DELAY:
@@ -2673,15 +2674,17 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_GET_SUPPORTED_CPUID: {
+	case KVM_GET_SUPPORTED_CPUID:
+	case KVM_GET_EMULATED_CPUID: {
 		struct kvm_cpuid2 __user *cpuid_arg = argp;
 		struct kvm_cpuid2 cpuid;
 
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
 			goto out;
-		r = kvm_dev_ioctl_get_supported_cpuid(&cpuid,
-						      cpuid_arg->entries);
+
+		r = kvm_dev_ioctl_get_cpuid(&cpuid, cpuid_arg->entries,
+					    ioctl);
 		if (r)
 			goto out;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 99c25338ede8..bb986a1674a3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_TRACE_ENABLE          __KVM_DEPRECATED_MAIN_W_0x06
 #define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
 #define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
+#define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
 
 /*
  * Extension capability list.
@@ -668,6 +669,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IRQ_XICS 92
 #define KVM_CAP_ARM_EL1_32BIT 93
 #define KVM_CAP_SPAPR_MULTITCE 94
+#define KVM_CAP_EXT_EMUL_CPUID 95
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.8.4

