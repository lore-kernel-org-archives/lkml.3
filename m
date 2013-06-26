Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3FZCvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:51:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54140 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064Ab3FZCpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.585208248@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [05/26] KVM: x86: remove vcpu's CPL check in host-invoked XCR set
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/x86.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -551,8 +551,6 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu,
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
 	xcr0 = xcr;
-	if (kvm_x86_ops->get_cpl(vcpu) != 0)
-		return 1;
 	if (!(xcr0 & XSTATE_FP))
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
@@ -566,7 +564,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu,
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (__kvm_set_xcr(vcpu, index, xcr)) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}

