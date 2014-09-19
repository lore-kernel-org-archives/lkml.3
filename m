Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaISVK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700AbaISVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:10:25 -0400
Date: Fri, 19 Sep 2014 23:10:17 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Liang Chen <liangchen.linux@gmail.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: x86: directly use kvm_make_request again
Message-ID: <20140919211013.GB29990@potion.brq.redhat.com>
References: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com>
 <1411058317-23646-3-git-send-email-liangchen.linux@gmail.com>
 <541BC949.4050602@linux.vnet.ibm.com>
 <20140919122502.GA29990@potion.brq.redhat.com>
 <541C313C.8060402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541C313C.8060402@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-19 21:35+0800, Xiao Guangrong:
> On 09/19/2014 08:25 PM, Radim Krčmář wrote:
> >>>   * Returns 1 to let __vcpu_run() continue the guest execution loop without
> >>>   * exiting to the userspace.  Otherwise, the value will be returned to the
> >>> @@ -6018,8 +6024,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >>>  		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
> >>>  			kvm_mmu_sync_roots(vcpu);
> >>>  		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
> >>> -			++vcpu->stat.tlb_flush;
> >>> -			kvm_x86_ops->tlb_flush(vcpu);
> >>> +			kvm_vcpu_flush_tlb(vcpu);
> >>
> >> NACK!
> >>
> >> Do not understand why you have to introduce a meaningful name
> >> here - it's used just inner a function, which can not help to
> >> improve a readability of the code at all.
> > 
> > I prefer the new hunk
> >  - it makes the parent function simpler (not everyone wants to read how
> >    we do tlb flushes when looking at vcpu_enter_guest)
> 
> Using one line instead of two lines does not simplify parent function much.

(Don't forget braces!)

There might come a patch that pushes the length above a readability
threshold.  With our development process, I think it is quite likely
that new function won't get created then;
and preventing this situation makes the function nicer now as well.

(Most of my thinking that is about cases that will never happen.)

> >  - the function is properly named
> 
> kvm_x86_ops->tlb_flush(vcpu) is also a good hit to tell the reader it is
> doing tlb flush. :)

Yep.  (The surprise was leaked by KVM_REQ_TLB_FLUSH.)

It was more like safety check -- if we wanted a new function, it should
be called like that.

> >  - we do a similar thing with kvm_gen_kvmclock_update
> 
> I understand this raw-bit-set style is largely used in current kvm code,
> however, it does not mean it's a best way do it. It may be turned off
> someday as it is be used in more and more places.
> 
> Anyway, the meaningful name wrapping raw-bit-set is a right direction
> and let's keep this right direction.

Agreed, it would be nice to have an indirection that hides the
underlying request-mechanic from higher-level code.

(More below.)

> > My issues with kvm_mmu_flush_tlb:
> > 
> >  - 'kvm_flush_remote_tlbs()' calls tlb request directly;
> >     our wrapper thus cannot be extended with features, which makes it a
> >     poor abstraction
> 
> kvm_flush_remote_tlbs does not only set tlb request but also handles memory
> order and syncs the tlb state.
> 
> I guess you wanted to say kvm_mmu_flush_tlb here, it is a API name and let
> it be easily used in other files. It's not worth committing a patch doing
> nothing except reverting the meaningful name.

(I really meant kvm_flush_remote_tlbs().)

When we change kvm_mmu_flush_tlb(), it doesn't get propagated to
"remote" TLB flushes => we might have a false sense of API and
the code is harder to work with because of that.

(I don't consider kvm_mmu_flush_tlb() a step in the right direction ...
 close, like all bugs.)

> >  - we don't do this for other requests
> 
> See above.

(Below is here.)

Between half-new half-old and unmixed API, I'm leaning towards the
latter option ...
(My arguments for this are weak though; not enough experience.)

> >  - direct request isn't absolutely horrible to read and write
> >    (I totally agree that it is bad.)
> >  - we call one function 'kvm_mmu_flush_tlb()' and the second one
> >    'kvm_flush_remote_tlbs()' and I'd need to look why
> 
> Yeah, this is why i suggested to rename kvm_mmu_flush_tlb since which clarifies
> things better:
> - kvm_flush_remote_tlbs: flush tlb in all vcpus
> - kvm_vcpu_flush_tlb: only flush tlb on the vcpu specified by @vcpu.

(I am confused about "mmu" in names -- kvm_flush_remote_tlbs is shared
 through host.h, which is probably why it didn't get "mmu".)

> > Which is why just removing it solves more problems for me :)
> 
> Thank you for raising this question and letting me know the patch's history. :)

Thanks for the reply, I hope I have understood you correctly,
now just to find a person to write all the good code :)
