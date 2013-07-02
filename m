Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3GBLId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3GBLI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Haoyu <haoyu.zhang@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 29/50] KVM: x86: remove vcpu's CPL check in host-invoked XCR set
Date: Tue,  2 Jul 2013 12:07:17 +0100
Message-Id: <1372763258-20664-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>

commit 764bcbc5a6d7a2f3e75c9f0e4caa984e2926e346 upstream.

__kvm_set_xcr function does the CPL check when set xcr. __kvm_set_xcr is
called in two flows, one is invoked by guest, call stack shown as below,

  handle_xsetbv(or xsetbv_interception)
    kvm_set_xcr
      __kvm_set_xcr

the other one is invoked by host, for example during system reset:

  kvm_arch_vcpu_ioctl
    kvm_vcpu_ioctl_x86_set_xcrs
      __kvm_set_xcr

The former does need the CPL check, but the latter does not.

Signed-off-by: Zhang Haoyu <haoyu.zhang@huawei.com>
[Tweaks to commit message. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7c8796..671e5df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -555,8 +555,6 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
 	xcr0 = xcr;
-	if (kvm_x86_ops->get_cpl(vcpu) != 0)
-		return 1;
 	if (!(xcr0 & XSTATE_FP))
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
@@ -570,7 +568,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (__kvm_set_xcr(vcpu, index, xcr)) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
-- 
1.8.1.2

