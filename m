Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaLCSpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:45:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaLCSpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:45:51 -0500
Date: Wed, 3 Dec 2014 19:45:38 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Nadav Amit <namit@cs.technion.ac.il>, hpa@linux.intel.com,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141203184537.GA27128@potion.brq.redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
 <802AF3F4-2631-4979-A8CC-46B406546062@gmail.com>
 <547F1D84.9040505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547F1D84.9040505@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-03 15:26+0100, Paolo Bonzini:
> 
> 
> On 03/12/2014 15:23, Nadav Amit wrote:
> > I think it is better just to replace the last line with:
> > 
> > *(u64 *)(dest + XSAVE_HDR_OFFSET) = xsave->xsave_hdr.xstate_bv

Yeah, or we can use this value for xstate_bv to save some copying too,

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19e5e8f..ba2b7bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3137,7 +3137,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
 	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
-	u64 xstate_bv = vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
+	u64 xstate_bv = xsave->xsave_hdr.xstate_bv;
 	u64 valid;
 
 	/*

> Right, this matches
> 
>         u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
> 	...
>         xsave->xsave_hdr.xstate_bv = xstate_bv;
> 
> in load_xsave.

Btw, we don't care about crashers from userspace?

---8<---
KVM: x86: prevent #GP with malicious xsave

XRSTORS throws #GP when XSTATE_BV isn't a subset of XCOMP_BV.
Make it so.

SDM: XRSTORS Exceptions
 #GP If a bit in the XCOMP_BV field in the XSAVE header is 0 and the
     corresponding bit in the XSTATE_BV field is 1.
(Also in SDM: 13.11 OPERATION OF XRSTORS)

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca26681..19e5e8f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3184,8 +3184,10 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 
 	/* Set XSTATE_BV and possibly XCOMP_BV.  */
 	xsave->xsave_hdr.xstate_bv = xstate_bv;
-	if (cpu_has_xsaves)
+	if (cpu_has_xsaves) {
 		xsave->xsave_hdr.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
+		xsave->xsave_hdr.xstate_bv &= xsave->xsave_hdr.xcomp_bv;
+	}
 
 	/*
 	 * Copy each region from the non-compacted offset to the
-- 
2.2.0

