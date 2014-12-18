Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaLRDPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:15:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:35600 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaLRDPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:15:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,598,1413270000"; 
   d="scan'208";a="649568512"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Topic: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
Thread-Index: AQHQGiD0lOD9GQH6kUSYRNw+5OxzD5yUq/Bg
Date: Thu, 18 Dec 2014 03:14:59 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002307C4A@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-26-git-send-email-feng.wu@intel.com>
 <5491C0A2.7040503@redhat.com>
In-Reply-To: <5491C0A2.7040503@redhat.com>
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



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paolo Bonzini
> Sent: Thursday, December 18, 2014 1:43 AM
> To: Wu, Feng; Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org;
> Gleb Natapov; Paolo Bonzini; dwmw2@infradead.org; joro@8bytes.org; Alex
> Williamson; Jiang Liu
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; KVM list;
> Eric Auger
> Subject: Re: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
> 
> 
> 
> On 12/12/2014 16:14, Feng Wu wrote:
> > Currently, we don't support urgent interrupt, all interrupts
> > are recognized as non-urgent interrupt, so we cannot send
> > posted-interrupt when 'SN' is set.
> 
> Can this happen?  If the vcpu is in guest mode, it cannot have been
> scheduled out, and that's the only case when SN is set.
> 
> Paolo

Currently, the only place where SN is set is vCPU is preempted and waiting for
the next scheduling in the runqueue. But I am not sure whether we need to
set SN for other purpose in future. Adding SN checking here is just to follow
the Spec. non-urgent interrupts are suppressed when SN is set.

Thanks,
Feng

> 
> > Signed-off-by: Feng Wu
> <feng.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  arch/x86/kvm/vmx.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index a1c83a2..0aee151 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -4401,15 +4401,22 @@ static int vmx_vm_has_apicv(struct kvm *kvm)
> >  static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int
> vector)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > -	int r;
> > +	int r, sn;
> >
> >  	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
> >  		return;
> >
> > +	/*
> > +	 * Currently, we don't support urgent interrupt, all interrupts
> > +	 * are recognized as non-urgent interrupt, so we cannot send
> > +	 * posted-interrupt when 'SN' is set.
> > +	 */
> > +	sn = pi_test_sn(&vmx->pi_desc);
> > +
> >  	r = pi_test_and_set_on(&vmx->pi_desc);
> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> >  #ifdef CONFIG_SMP
> > -	if (!r && (vcpu->mode == IN_GUEST_MODE))
> > +	if (!r && !sn && (vcpu->mode == IN_GUEST_MODE))
> >  		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
> >  				POSTED_INTR_VECTOR);
> >  	else
> > --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
