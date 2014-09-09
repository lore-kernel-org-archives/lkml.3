Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaIIQws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:52:48 -0400
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:51974
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbaIIQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:52:46 -0400
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc: peter.maydell@linaro.org, christoffer.dall@linaro.org,
        jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com,
        marc.zyngier@arm.com, bp@suse.de, pbonzini@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] KVM: fix api documentation of KVM_GET_EMULATED_CPUID
Date: Tue,  9 Sep 2014 17:27:19 +0100
Message-Id: <1410280039-2823-3-git-send-email-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410280039-2823-1-git-send-email-alex.bennee@linaro.org>
References: <1410280039-2823-1-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like when this was initially merged it got accidentally included
in the following section. I've just moved it back in the correct section
and re-numbered it as other ioctls have been added since.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 723d3f3..60c1582 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2620,6 +2620,76 @@ When debug events exit the main run loop with the reason
 KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
 structure containing architecture specific debug information.
 
+4.88 KVM_GET_EMULATED_CPUID
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
 5. The kvm_run structure
 ------------------------
 
@@ -2918,76 +2988,6 @@ and usually define the validity of a groups of registers. (e.g. one bit
 };
 
 
-4.81 KVM_GET_EMULATED_CPUID
-
-Capability: KVM_CAP_EXT_EMUL_CPUID
-Architectures: x86
-Type: system ioctl
-Parameters: struct kvm_cpuid2 (in/out)
-Returns: 0 on success, -1 on error
-
-struct kvm_cpuid2 {
-	__u32 nent;
-	__u32 flags;
-	struct kvm_cpuid_entry2 entries[0];
-};
-
-The member 'flags' is used for passing flags from userspace.
-
-#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
-#define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
-#define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
-
-struct kvm_cpuid_entry2 {
-	__u32 function;
-	__u32 index;
-	__u32 flags;
-	__u32 eax;
-	__u32 ebx;
-	__u32 ecx;
-	__u32 edx;
-	__u32 padding[3];
-};
-
-This ioctl returns x86 cpuid features which are emulated by
-kvm.Userspace can use the information returned by this ioctl to query
-which features are emulated by kvm instead of being present natively.
-
-Userspace invokes KVM_GET_EMULATED_CPUID by passing a kvm_cpuid2
-structure with the 'nent' field indicating the number of entries in
-the variable-size array 'entries'. If the number of entries is too low
-to describe the cpu capabilities, an error (E2BIG) is returned. If the
-number is too high, the 'nent' field is adjusted and an error (ENOMEM)
-is returned. If the number is just right, the 'nent' field is adjusted
-to the number of valid entries in the 'entries' array, which is then
-filled.
-
-The entries returned are the set CPUID bits of the respective features
-which kvm emulates, as returned by the CPUID instruction, with unknown
-or unsupported feature bits cleared.
-
-Features like x2apic, for example, may not be present in the host cpu
-but are exposed by kvm in KVM_GET_SUPPORTED_CPUID because they can be
-emulated efficiently and thus not included here.
-
-The fields in each entry are defined as follows:
-
-  function: the eax value used to obtain the entry
-  index: the ecx value used to obtain the entry (for entries that are
-         affected by ecx)
-  flags: an OR of zero or more of the following:
-        KVM_CPUID_FLAG_SIGNIFCANT_INDEX:
-           if the index field is valid
-        KVM_CPUID_FLAG_STATEFUL_FUNC:
-           if cpuid for this function returns different values for successive
-           invocations; there will be several entries with the same function,
-           all with this flag set
-        KVM_CPUID_FLAG_STATE_READ_NEXT:
-           for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
-           the first entry to be read by a cpu
-   eax, ebx, ecx, edx: the values returned by the cpuid instruction for
-         this function/index combination
-
 
 6. Capabilities that can be enabled on vCPUs
 --------------------------------------------
-- 
2.1.0

