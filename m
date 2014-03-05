Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbaCEO0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbaCEO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 088/131] KVM: VMX: fix use after free of vmx->loaded_vmcs
Date: Wed,  5 Mar 2014 14:23:32 +0000
Message-Id: <1394029455-23128-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 064d0be..aef3d79 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7142,8 +7142,8 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	free_vpid(vmx);
-	free_nested(vmx);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	free_nested(vmx);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
-- 
1.9.0

