Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3FYSji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:39:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3FYSjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Haoyu <haoyu.zhang@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [ 03/17] KVM: x86: remove vcpus CPL check in host-invoked XCR set
Date: Tue, 25 Jun 2013 11:39:18 -0700
Message-Id: <20130625183915.835902978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -548,8 +548,6 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu,
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
 	xcr0 = xcr;
-	if (kvm_x86_ops->get_cpl(vcpu) != 0)
-		return 1;
 	if (!(xcr0 & XSTATE_FP))
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
@@ -563,7 +561,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu,
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (__kvm_set_xcr(vcpu, index, xcr)) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}


