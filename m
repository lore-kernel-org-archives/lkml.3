Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaKYKgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:36:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaKYKgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:36:45 -0500
Message-ID: <54745BB0.8080304@redhat.com>
Date: Tue, 25 Nov 2014 11:36:32 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, namit@cs.technion.ac.il,
        hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <20141125101331.GA28985@kernel>
In-Reply-To: <20141125101331.GA28985@kernel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/11/2014 11:13, Wanpeng Li wrote:
> Hi Paolo,
> On Mon, Nov 24, 2014 at 05:43:32PM +0100, Paolo Bonzini wrote:
>> The first patch ensures that XSAVES is not exposed in the guest until
>> we emulate MSR_IA32_XSS.  The second exports XSAVE data in the correct
>> format.
>>
>> I tested these on a non-XSAVES system so they should not be completely
>> broken, but I need some help.  I am not even sure which XSAVE states
>> are _not_ enabled, and thus compacted, in Linux.
>>
>> Note that these patches do not add support for XSAVES in the guest yet,
>> since MSR_IA32_XSS is not emulated.
>>
>> If they fix the bug Nadav reported, I'll add Reported-by and commit.
> 
> I test this patchset w/ your "KVM: x86: export get_xsave_addr" patch on 
> Skylake and guest hang during boot. The guest screen show "Probing EDD 
> (edd=off to disable)... ok", and no more dump.

Anything in dmesg?  Can you try this patch on top?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 373b0ab9a32e..ca26681455c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6955,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
 		return err;

 	fpu_finit(&vcpu->arch.guest_fpu);
+	if (cpu_has_xsaves)
+		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
+			host_xcr0 | XSTATE_COMPACTION_ENABLED;

 	/*
 	 * Ensure guest xcr0 is valid for loading

Paolo
