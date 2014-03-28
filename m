Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaC1SHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:07:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaC1Rab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.4 11/13] KVM: VMX: fix use after free of vmx->loaded_vmcs
Date: Fri, 28 Mar 2014 10:32:01 -0700
Message-Id: <20140328173054.566787119@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173053.049244535@linuxfoundation.org>
References: <20140328173053.049244535@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 26a865f4aa8e66a6d94958de7656f7f1b03c6c56 upstream.

After free_loaded_vmcs executes, the "loaded_vmcs" structure
is kfreed, and now vmx->loaded_vmcs points to a kfreed area.
Subsequent free_loaded_vmcs then attempts to manipulate
vmx->loaded_vmcs.

Switch the order to avoid the problem.

https://bugzilla.redhat.com/show_bug.cgi?id=1047892

Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6281,8 +6281,8 @@ static void vmx_free_vcpu(struct kvm_vcp
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	free_vpid(vmx);
-	free_nested(vmx);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	free_nested(vmx);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);


