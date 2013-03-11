Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3CKLvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab3CKLvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:51:47 -0400
Date: Mon, 11 Mar 2013 13:51:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311115144.GG31619@redhat.com>
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
 <20130310114646.GM11223@redhat.com>
 <513C9E82.1020304@redhat.com>
 <20130310153540.GL24444@redhat.com>
 <513CC08B.2040800@redhat.com>
 <20130310181035.GM24444@redhat.com>
 <513DAE8F.3050102@redhat.com>
 <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DBF45.9030803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:25:57PM +0100, Paolo Bonzini wrote:
> Il 11/03/2013 11:28, Gleb Natapov ha scritto:
> >> Not really true---we do exit with that state and EINTR when we get a
> >> SIPI.  Perhaps that can be changed.
> >
> > That's implementation detail. We can jump to the beginning of the
> > function instead. Nowhere we document that entering
> > KVM_MP_STATE_SIPI_RECEIVED state cause KVM_RUN return with EINTR.
> 
> Yes, that would be nice.
> 
That's not performance critical path, so I guess no one bothered.

> >>> If AP is hard reset
> >>> userspase makes it UNINIT, if soft reset it makes it INIT_RECEIVED, if
> >>> BSP it makes it running no matter what type of reset.
> >>
> >> The current name just suggests . 
> >> And when getting an INIT in the in-kernel LAPIC, this:
> >>
> >> -			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> >> +			vcpu->arch.mp_state = kvm_vcpu_is_bsp(vcpu) ?
> >> +				KVM_MP_STATE_SIPI_RECEIVED :
> >> +				KVM_MP_STATE_INIT_RECEIVED;
> >>
> >> makes much less sense than this:
> >>
> >> -			vcpu->arch.mp_state = KVM_MP_STATE_WAIT_FOR_SIPI;
> >> +			vcpu->arch.mp_state = kvm_vcpu_is_bsp(vcpu) ?
> >> +				KVM_MP_STATE_RESET_NOW :
> >> +				KVM_MP_STATE_WAIT_FOR_SIPI;
> >>
> > Both of them are equally incorrect. INIT should cause reset, and only if
> > vmx is off. An userspace reset is also completely broken in that regard.
> > Renaming things gives us nothing, only bring unneeded churn. If the
> > names were internal I wouldn't mind, but they are APIs.
> > 
> >> However, there's also Jan's plans for nVMX.  Peeking at his queue (see
> >> http://git.kiszka.org/?p=linux-kvm.git;a=commitdiff;h=037fb24ec) I think
> >> it's better to always reflect INITs to the hypervisor like I did in these
> >> patches.
> >>
> > The commit was before we decided that we should not abuse mp_state for
> > signaling.
> 
> Agreed, but we still have the problem of how to signal from userspace.
> For that do you have any other suggestion than mp_state?  And if we keep
> mp_state to signal from userspace, giving INIT_RECEIVED the
> "wait-for-SIPI" semantics would be wrong.
> 
I don't see how can we use mp_state for signaling from userspace either.
Currently soft reset always reset vcpus, so it is OK for userspace to
generate reset vcpu state and put it into kernel, mp_state is just one
of the updated states, but when INIT will be just another signal that
may or may not reset cpu or have other side effects like #vmexit this
will not longer work. We will have to have another interface for
injecting INIT from userspace and userspace soft-reset will use it
instead of doing reset by itself.

--
			Gleb.
