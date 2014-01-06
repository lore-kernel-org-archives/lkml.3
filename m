Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaAFXys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:54:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbaAFWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3.12 090/144] KVM: nVMX: Unconditionally uninit the MMU on nested vmexit
Date: Mon,  6 Jan 2014 14:37:31 -0800
Message-Id: <20140106223747.943589782@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@web.de>

commit 29bf08f12b2fd72b882da0d85b7385e4a438a297 upstream.

Three reasons for doing this: 1. arch.walk_mmu points to arch.mmu anyway
in case nested EPT wasn't in use. 2. this aligns VMX with SVM. But 3. is
most important: nested_cpu_has_ept(vmcs12) queries the VMCS page, and if
one guest VCPU manipulates the page of another VCPU in L2, we may be
fooled to skip over the nested_ept_uninit_mmu_context, leaving mmu in
nested state. That can crash the host later on if nested_ept_get_cr3 is
invoked while L1 already left vmxon and nested.current_vmcs12 became
NULL therefore.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8218,8 +8218,7 @@ static void load_vmcs12_host_state(struc
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
 	kvm_set_cr4(vcpu, vmcs12->host_cr4);
 
-	if (nested_cpu_has_ept(vmcs12))
-		nested_ept_uninit_mmu_context(vcpu);
+	nested_ept_uninit_mmu_context(vcpu);
 
 	kvm_set_cr3(vcpu, vmcs12->host_cr3);
 	kvm_mmu_reset_context(vcpu);


