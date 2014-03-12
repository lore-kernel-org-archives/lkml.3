Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaCLPVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbaCLPVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:21:52 -0400
Date: Wed, 12 Mar 2014 11:54:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        gleb@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix cr8 intercept window
Message-ID: <20140312145441.GA30707@amt.cnet>
References: <1394561478-8815-1-git-send-email-rkrcmar@redhat.com>
 <20140312010513.GA8131@amt.cnet>
 <20140312104047.GA7488@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140312104047.GA7488@potion.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:40:48AM +0100, Radim Krčmář wrote:
> 2014-03-11 22:05-0300, Marcelo Tosatti:
> > On Tue, Mar 11, 2014 at 07:11:18PM +0100, Radim Krčmář wrote:
> > > We always disable cr8 intercept in its handler, but only re-enable it
> > > if handling KVM_REQ_EVENT, so there can be a window where we do not
> > > intercept cr8 writes, which allows an interrupt to disrupt a higher
> > > priority task.
> > > 
> > > Fix this by disabling intercepts in the same function that re-enables
> > > them when needed. This fixes BSOD in Windows 2008.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > > ---
> > >  arch/x86/kvm/svm.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index 64d9bb9..f676c18 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -3003,10 +3003,8 @@ static int cr8_write_interception(struct vcpu_svm *svm)
> > >  	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
> > >  	/* instruction emulation calls kvm_set_cr8() */
> > >  	r = cr_interception(svm);
> > > -	if (irqchip_in_kernel(svm->vcpu.kvm)) {
> > > -		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
> > > +	if (irqchip_in_kernel(svm->vcpu.kvm))
> > >  		return r;
> > > -	}
> > >  	if (cr8_prev <= kvm_get_cr8(&svm->vcpu))
> > >  		return r;
> > >  	kvm_run->exit_reason = KVM_EXIT_SET_TPR;
> > > @@ -3568,6 +3566,8 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> > >  	if (is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
> > >  		return;
> > >  
> > > +	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
> > > +
> > >  	if (irr == -1)
> > >  		return;
> > 
> > Shouldnt IRR be injected if TPR < IRR ? (via KVM_REQ_EVENT).
> > 
> > 1) IRR has interrupt 10.
> > 2) TPR now 9 due to CR8 write.
> > 3) 10 should be injected.
> 
> Definitely should, and we will set KVM_REQ_EVENT through kvm_set_cr8()
> if we lower the TPR.
> (I checked that the bug isn't in apic_update_ppr().)

Yep.

> > Also not clearing the intercept can cause continuous CR8 writes to 
> > exit until KVM_REQ_EVENT ? 
> 
> It is intended, I suppose this is because we run with V_INTR_MASKING, so
> writes to CR8 only affect V_TPR register; guest then raises it once more
> and APIC incorrectly gives us low priority interrupt.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

