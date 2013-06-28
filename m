Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3F1S6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:58:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42009 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3F1S6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Haoyu <haoyu.zhang@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 058/105] KVM: x86: remove vcpu's CPL check in host-invoked XCR set
Date: Fri, 28 Jun 2013 11:51:20 -0700
Message-Id: <1372445527-24414-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a51121..ff74a2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -558,8 +558,6 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
 	xcr0 = xcr;
-	if (kvm_x86_ops->get_cpl(vcpu) != 0)
-		return 1;
 	if (!(xcr0 & XSTATE_FP))
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
@@ -573,7 +571,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
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

