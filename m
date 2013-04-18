Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923Ab3DRAfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:35:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:15533 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934752Ab3DRAfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:35:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,496,1363158000"; 
   d="scan'208";a="287784008"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@infradead.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: RE: [patch] x86, kvm: fix build failure with CONFIG_SMP disabled
Thread-Topic: [patch] x86, kvm: fix build failure with CONFIG_SMP disabled
Thread-Index: AQHOO8kNpk9rq341F0a3pajUBgR7+ZjbILNw
Date: Thu, 18 Apr 2013 00:35:14 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E09A13B08@SHSMSX101.ccr.corp.intel.com>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au>
 <516EE5AB.4080201@infradead.org>
 <alpine.DEB.2.02.1304171555030.10112@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1304171609580.5541@chino.kir.corp.google.com>
 <516F37FF.8040703@infradead.org>
 <alpine.DEB.2.02.1304171707090.24494@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304171707090.24494@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote on 2013-04-18:
> On Wed, 17 Apr 2013, Randy Dunlap wrote:
> 
>> On 04/17/13 16:12, David Rientjes wrote:
>>> The build fails when CONFIG_SMP is disabled:
>>> 
>>> 	arch/x86/kvm/vmx.c: In function 'vmx_deliver_posted_interrupt':
>>> 	arch/x86/kvm/vmx.c:3950:3: error: 'apic' undeclared (first use in
>>> this function)
>>> 
>>> Fix it by including the necessary header.
>> 
>> Sorry, i386 build still fails with the same error message plus this one:
>> 
>> ERROR: "apic" [arch/x86/kvm/kvm-intel.ko] undefined!
>> 
> 
> Ahh, that's because you don't have CONFIG_X86_LOCAL_APIC as you already
> mentioned.  So it looks like this error can manifest in two different ways
> and we got different reports.
> 
> This failure came from "KVM: VMX: Add the deliver posted interrupt
> algorithm", so adding Yang to the cc to specify the dependency this has on
> apic and how it can be protected without CONFIG_X86_LOCAL_APIC on i386.
How about the follow patch?

commit a49dd819f502c1029c5a857e87201ef25ec06ce6
Author: Yang Zhang <yang.z.zhang@Intel.com>
Date:   Wed Apr 17 05:34:07 2013 -0400

    KVM: x86: Don't sending posted interrupt if not config CONFIG_SMP

    In UP, posted interrupt logic will not work. So we should not send
    posted interrupt and let vcpu to pick the pending interrupt before
    vmentry.

    Signed-off-by: Yang Zhang <yang.z.zhang@Intel.com>

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 52b21da..d5c6b95 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3946,10 +3946,12 @@ static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)

        r = pi_test_and_set_on(&vmx->pi_desc);
        kvm_make_request(KVM_REQ_EVENT, vcpu);
+#ifdef CONFIG_SMP
        if (!r && (vcpu->mode == IN_GUEST_MODE))
                apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
                                POSTED_INTR_VECTOR);
        else
+#endif
                kvm_vcpu_kick(vcpu);
 }

Best regards,
Yang


