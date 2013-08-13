Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab3HMQMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:12:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab3HMP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:25 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=MUzQBMBg0bkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wExmbGntH8cA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.616111637@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhang Haoyu <haoyu.zhang@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [06/88] KVM: x86: remove vcpus CPL check in host-invoked XCR set
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0006-KVM-x86-remove-vcpu-s-CPL-check-in-host-invoked-XCR-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>

[ Upstream commit 764bcbc5a6d7a2f3e75c9f0e4caa984e2926e346 ]

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

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Haoyu <haoyu.zhang@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[Tweaks to commit message. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7a361f..2dcd250 100644
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
1.7.10.4


