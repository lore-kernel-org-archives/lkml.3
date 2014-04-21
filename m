Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaDUTUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaDUTUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:20:30 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Check for host supported fields in shadow vmcs
Date: Mon, 21 Apr 2014 15:20:14 -0400
Message-ID: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We track shadow vmcs fields through two static lists,
one for read only and another for r/w fields. However, with
addition of new vmcs fields, not all fields may be supported on
all hosts. If so, copy_vmcs12_to_shadow() trying to vmwrite on
unsupported hosts will result in a vmwrite error. For example, commit
36be0b9deb23161 introduced GUEST_BNDCFGS, which is not supported
by all processors. Filter out host unsupported fields before
letting guests use shadow vmcs

Signed-off-by: Bandan Das <bsd@redhat.com>
---
v2:
  - Just compress the original lists instead of creating new ones
  - Change commit message slightly to reflect this change

 arch/x86/kvm/vmx.c | 54 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7bed3e3..26a632f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -503,7 +503,7 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 				[number##_HIGH] = VMCS12_OFFSET(name)+4
 
 
-static const unsigned long shadow_read_only_fields[] = {
+static unsigned long shadow_read_only_fields[] = {
 	/*
 	 * We do NOT shadow fields that are modified when L0
 	 * traps and emulates any vmx instruction (e.g. VMPTRLD,
@@ -526,10 +526,10 @@ static const unsigned long shadow_read_only_fields[] = {
 	GUEST_LINEAR_ADDRESS,
 	GUEST_PHYSICAL_ADDRESS
 };
-static const int max_shadow_read_only_fields =
+static int max_shadow_read_only_fields =
 	ARRAY_SIZE(shadow_read_only_fields);
 
-static const unsigned long shadow_read_write_fields[] = {
+static unsigned long shadow_read_write_fields[] = {
 	GUEST_RIP,
 	GUEST_RSP,
 	GUEST_CR0,
@@ -558,7 +558,7 @@ static const unsigned long shadow_read_write_fields[] = {
 	HOST_FS_SELECTOR,
 	HOST_GS_SELECTOR
 };
-static const int max_shadow_read_write_fields =
+static int max_shadow_read_write_fields =
 	ARRAY_SIZE(shadow_read_write_fields);
 
 static const unsigned short vmcs_field_to_offset_table[] = {
@@ -3009,6 +3009,42 @@ static void free_kvm_area(void)
 	}
 }
 
+static void init_vmcs_shadow_fields(void)
+{
+	int i, j;
+
+	/* No checks for read only fields yet */
+
+	for (i = j = 0; i < max_shadow_read_write_fields; i++) {
+
+		switch (shadow_read_write_fields[i]) {
+		case GUEST_BNDCFGS:
+			if (!vmx_mpx_supported())
+				continue;
+			break;
+		default:
+			break;
+		}
+
+		if (j < i)
+			shadow_read_write_fields[j] =
+				shadow_read_write_fields[i];
+		j++;
+	}
+	max_shadow_read_write_fields = j;
+
+	/* shadowed fields guest access without vmexit */
+	for (i = 0; i < max_shadow_read_write_fields; i++) {
+		clear_bit(shadow_read_write_fields[i],
+			  vmx_vmwrite_bitmap);
+		clear_bit(shadow_read_write_fields[i],
+			  vmx_vmread_bitmap);
+	}
+	for (i = 0; i < max_shadow_read_only_fields; i++)
+		clear_bit(shadow_read_only_fields[i],
+			  vmx_vmread_bitmap);
+}
+
 static __init int alloc_kvm_area(void)
 {
 	int cpu;
@@ -3039,6 +3075,8 @@ static __init int hardware_setup(void)
 		enable_vpid = 0;
 	if (!cpu_has_vmx_shadow_vmcs())
 		enable_shadow_vmcs = 0;
+	if (enable_shadow_vmcs)
+		init_vmcs_shadow_fields();
 
 	if (!cpu_has_vmx_ept() ||
 	    !cpu_has_vmx_ept_4levels()) {
@@ -8817,14 +8855,6 @@ static int __init vmx_init(void)
 
 	memset(vmx_vmread_bitmap, 0xff, PAGE_SIZE);
 	memset(vmx_vmwrite_bitmap, 0xff, PAGE_SIZE);
-	/* shadowed read/write fields */
-	for (i = 0; i < max_shadow_read_write_fields; i++) {
-		clear_bit(shadow_read_write_fields[i], vmx_vmwrite_bitmap);
-		clear_bit(shadow_read_write_fields[i], vmx_vmread_bitmap);
-	}
-	/* shadowed read only fields */
-	for (i = 0; i < max_shadow_read_only_fields; i++)
-		clear_bit(shadow_read_only_fields[i], vmx_vmread_bitmap);
 
 	/*
 	 * Allow direct access to the PC debug port (it is often used for I/O
-- 
1.8.3.1

