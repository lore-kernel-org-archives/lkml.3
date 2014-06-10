Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaFJVHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaFJVHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:07:46 -0400
Date: Tue, 10 Jun 2014 18:06:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andi Kleen <ak@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org, gleb@kernel.org,
        pbonzini@redhat.com, eranian@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140610210654.GA16344@amt.cnet>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <20140610180448.GA9485@amt.cnet>
 <20140610192207.GC8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610192207.GC8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:22:07PM -0700, Andi Kleen wrote:
> On Tue, Jun 10, 2014 at 03:04:48PM -0300, Marcelo Tosatti wrote:
> > On Thu, May 29, 2014 at 06:12:07PM -0700, Andi Kleen wrote:
> > >  {
> > >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > > @@ -407,6 +551,20 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >  			return 0;
> > >  		}
> > >  		break;
> > > +	case MSR_IA32_DS_AREA:
> > > +		pmu->ds_area = data;
> > > +		return 0;
> > > +	case MSR_IA32_PEBS_ENABLE:
> > > +		if (data & ~0xf0000000fULL)
> > > +			break;
> > 
> > Bit 63 == PS_ENABLE ?
> 
> PEBS_EN is [3:0] for each counter, but only one bit on Silvermont.
> LL_EN is [36:32], but currently unused.
> 
> > 
> > >  void kvm_handle_pmu_event(struct kvm_vcpu *vcpu)
> > > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > > index 33e8c02..4f39917 100644
> > > --- a/arch/x86/kvm/vmx.c
> > > +++ b/arch/x86/kvm/vmx.c
> > > @@ -7288,6 +7288,12 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >  	atomic_switch_perf_msrs(vmx);
> > >  	debugctlmsr = get_debugctlmsr();
> > >  
> > > +	/* Move this somewhere else? */
> > 
> > Unless you hook into vcpu->arch.pmu.ds_area and perf_get_ds_area()
> > writers, it has to be at every vcpu entry.
> > 
> > Could compare values in MSR save area to avoid switch.
> 
> Ok.
> 
> > 
> > > +	if (vcpu->arch.pmu.ds_area)
> > > +		add_atomic_switch_msr(vmx, MSR_IA32_DS_AREA,
> > > +				      vcpu->arch.pmu.ds_area,
> > > +				      perf_get_ds_area());
> > 
> > Should clear_atomic_switch_msr before 
> > add_atomic_switch_msr.
> 
> Ok.
> 
> BTW how about general PMU migration? As far as I can tell there 
> is no code to save/restore the state for that currently, right?
> 
> -Andi

Paolo wrote support for it, recently. Paolo?

