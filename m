Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaLDQlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:41:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbaLDQlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:41:45 -0500
Date: Thu, 4 Dec 2014 17:41:38 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Nadav Amit <nadav.amit@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] kvm: cpuid: fix the size of xsaves area
Message-ID: <20141204164137.GB18651@potion.brq.redhat.com>
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
 <1417691470-5221-2-git-send-email-wanpeng.li@linux.intel.com>
 <20141204131454.GA17050@potion.brq.redhat.com>
 <54808276.9090309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54808276.9090309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 16:49+0100, Paolo Bonzini:
> On 04/12/2014 14:14, Radim Krčmář wrote:
> > 2014-12-04 19:11+0800, Wanpeng Li:
> >> The the value of EBX should represent the size of XCR0 related XSAVE
> >> area since IA32_XSS is not used currently.
> > 
> > True, but 'supported' is not the state of XCR0, just its supremum.
> > EBX should be set in kvm_update_cpuid(), like [3/4] does.
> > (We can safely drop [2/4].)
> 
> Still, it's nice to be consistent and return a plausible value to
> userspace for KVM_GET_SUPPORTED_CPUID.

Ok.  To avoid inconsistencies, this patch should be applied too:
(It's also a small fix for ECX, but that side isn't as important :)
---8<---
KVM: x86: sanitize CPUID 0xD.0:EBX,ECX

We reused host EBX and ECX, but KVM might not support all features;
emulated XSAVE size should be smaller.

EBX depends on unknown XCR0, so we default to ECX.

SDM CPUID (EAX = 0DH, ECX = 0):
 EBX Bits 31-00: Maximum size (bytes, from the beginning of the
     XSAVE/XRSTOR save area) required by enabled features in XCR0. May
     be different than ECX if some features at the end of the XSAVE save
     area are not enabled.

 ECX Bit 31-00: Maximum size (bytes, from the beginning of the
     XSAVE/XRSTOR save area) of the XSAVE/XRSTOR save area required by
     all supported features in the processor, i.e all the valid bit
     fields in XCR0.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7d5bdb4..9da9249 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -464,6 +464,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		u64 supported = kvm_supported_xcr0();
 
 		entry->eax &= supported;
+		entry->ebx = xstate_required_size(supported, false);
+		entry->ecx = entry->ebx;
 		entry->edx &= supported >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		if (!supported)
