Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaKDRji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:39:38 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35136 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:39:35 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tiejun.chen@intel.com
Subject: [PATCH] kvm: x86: vmx: avoid returning bool to distinguish success from error
Date: Tue,  4 Nov 2014 18:33:14 +0100
Message-Id: <1415122394-31986-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error code instead, and WARN() when we should be covering
the entire 2-bit space of vmcs_field_type's return value.  For increased
robustness, add a BUILD_BUG_ON checking the range of vmcs_field_to_offset.

Suggested-by: Tiejun Chen <tiejun.chen@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 12f6f9a8dd8d..0ee148f1687f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -720,12 +720,15 @@ static const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
 };
-static const int max_vmcs_field = ARRAY_SIZE(vmcs_field_to_offset_table);
 
 static inline short vmcs_field_to_offset(unsigned long field)
 {
-	if (field >= max_vmcs_field || vmcs_field_to_offset_table[field] == 0)
-		return -1;
+	BUILD_BUG_ON(ARRAY_SIZE(vmcs_field_to_offset_table) > SHRT_MAX);
+
+	if (field >= ARRAY_SIZE(vmcs_field_to_offset_table) ||
+	    vmcs_field_to_offset_table[field] == 0)
+		return -ENOENT;
+
 	return vmcs_field_to_offset_table[field];
 }
 
@@ -6492,58 +6495,60 @@ static inline int vmcs_field_readonly(unsigned long field)
  * some of the bits we return here (e.g., on 32-bit guests, only 32 bits of
  * 64-bit fields are to be returned).
  */
-static inline bool vmcs12_read_any(struct kvm_vcpu *vcpu,
-					unsigned long field, u64 *ret)
+static inline int vmcs12_read_any(struct kvm_vcpu *vcpu,
+				  unsigned long field, u64 *ret)
 {
 	short offset = vmcs_field_to_offset(field);
 	char *p;
 
 	if (offset < 0)
-		return 0;
+		return offset;
 
 	p = ((char *)(get_vmcs12(vcpu))) + offset;
 
 	switch (vmcs_field_type(field)) {
 	case VMCS_FIELD_TYPE_NATURAL_WIDTH:
 		*ret = *((natural_width *)p);
-		return 1;
+		return 0;
 	case VMCS_FIELD_TYPE_U16:
 		*ret = *((u16 *)p);
-		return 1;
+		return 0;
 	case VMCS_FIELD_TYPE_U32:
 		*ret = *((u32 *)p);
-		return 1;
+		return 0;
 	case VMCS_FIELD_TYPE_U64:
 		*ret = *((u64 *)p);
-		return 1;
+		return 0;
 	default:
-		return 0; /* can never happen. */
+		WARN_ON(1);
+		return -ENOENT;
 	}
 }
 
 
-static inline bool vmcs12_write_any(struct kvm_vcpu *vcpu,
-				    unsigned long field, u64 field_value){
+static inline int vmcs12_write_any(struct kvm_vcpu *vcpu,
+				   unsigned long field, u64 field_value){
 	short offset = vmcs_field_to_offset(field);
 	char *p = ((char *) get_vmcs12(vcpu)) + offset;
 	if (offset < 0)
-		return false;
+		return offset;
 
 	switch (vmcs_field_type(field)) {
 	case VMCS_FIELD_TYPE_U16:
 		*(u16 *)p = field_value;
-		return true;
+		return 0;
 	case VMCS_FIELD_TYPE_U32:
 		*(u32 *)p = field_value;
-		return true;
+		return 0;
 	case VMCS_FIELD_TYPE_U64:
 		*(u64 *)p = field_value;
-		return true;
+		return 0;
 	case VMCS_FIELD_TYPE_NATURAL_WIDTH:
 		*(natural_width *)p = field_value;
-		return true;
+		return 0;
 	default:
-		return false; /* can never happen. */
+		WARN_ON(1);
+		return -ENOENT;
 	}
 
 }
@@ -6576,6 +6581,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 		case VMCS_FIELD_TYPE_NATURAL_WIDTH:
 			field_value = vmcs_readl(field);
 			break;
+		default:
+			WARN_ON(1);
+			continue;
 		}
 		vmcs12_write_any(&vmx->vcpu, field, field_value);
 	}
@@ -6621,6 +6629,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 			case VMCS_FIELD_TYPE_NATURAL_WIDTH:
 				vmcs_writel(field, (long)field_value);
 				break;
+			default:
+				WARN_ON(1);
+				break;
 			}
 		}
 	}
@@ -6659,7 +6670,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 	/* Read the field, zero-extended to a u64 field_value */
-	if (!vmcs12_read_any(vcpu, field, &field_value)) {
+	if (vmcs12_read_any(vcpu, field, &field_value) < 0) {
 		nested_vmx_failValid(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 		skip_emulated_instruction(vcpu);
 		return 1;
-- 
1.8.3.1

