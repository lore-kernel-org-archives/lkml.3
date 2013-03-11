Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3CKK25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab3CKK2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:28:55 -0400
Date: Mon, 11 Mar 2013 12:28:52 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311102852.GE31619@redhat.com>
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
 <20130310114646.GM11223@redhat.com>
 <513C9E82.1020304@redhat.com>
 <20130310153540.GL24444@redhat.com>
 <513CC08B.2040800@redhat.com>
 <20130310181035.GM24444@redhat.com>
 <513DAE8F.3050102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DAE8F.3050102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:14:39AM +0100, Paolo Bonzini wrote:
> Il 10/03/2013 19:10, Gleb Natapov ha scritto:
> > On Sun, Mar 10, 2013 at 06:19:07PM +0100, Paolo Bonzini wrote:
> >> Il 10/03/2013 16:35, Gleb Natapov ha scritto:
> >>>>> However, it would effectively redefine the meaning of
> >>>>> KVM_MP_STATE_INIT_RECEIVED and KVM_MP_STATE_SIPI_RECEIVED, respectively
> >>>>> to KVM_MP_STATE_WAIT_FOR_SIPI and KVM_MP_STATE_RESETTING.  I wasn't sure
> >>>>> if this is considered an API change (personally, I would treat it as one).
> >>>>>
> >>> If it is kernel module internal it definitely is not API change.
> >>> INIT/SIPI handling is a bit ad-hoc right now anyway as Jan noticed. For
> >>> instance INIT does not really resets VCPU. Only after SIPI it is really
> >>> reset, so KVM_MP_STATE_SIPI_RECEIVED is really KVM_MP_STATE_RESET_ME_RIGHT_NOW
> >>> state.
> >>
> >> Yeah, and the current definition is ambiguous (without hypervisor
> >> patches, there's no way to use it as the names would suggest), so
> >> perhaps the right thing to do is to rename the states (old names kept
> >> for backwards compatibility only) and work from there.
> >>
> > I do not see how renaming clarify things. From userspace point of view
> > KVM_MP_STATE_SIPI_RECEIVED does not exists.
> 
> Not really true---we do exit with that state and EINTR when we get a
> SIPI.  Perhaps that can be changed.
> 
That's implementation detail. We can jump to the beginning of the
function instead. Nowhere we document that entering
KVM_MP_STATE_SIPI_RECEIVED state cause KVM_RUN return with EINTR.

> > If AP is hard reset
> > userspase makes it UNINIT, if soft reset it makes it INIT_RECEIVED, if
> > BSP it makes it running no matter what type of reset.
> 
> The current name just suggests . 
> And when getting an INIT in the in-kernel LAPIC, this:
> 
> -			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> +			vcpu->arch.mp_state = kvm_vcpu_is_bsp(vcpu) ?
> +				KVM_MP_STATE_SIPI_RECEIVED :
> +				KVM_MP_STATE_INIT_RECEIVED;
> 
> makes much less sense than this:
> 
> -			vcpu->arch.mp_state = KVM_MP_STATE_WAIT_FOR_SIPI;
> +			vcpu->arch.mp_state = kvm_vcpu_is_bsp(vcpu) ?
> +				KVM_MP_STATE_RESET_NOW :
> +				KVM_MP_STATE_WAIT_FOR_SIPI;
> 
Both of them are equally incorrect. INIT should cause reset, and only if
vmx is off. An userspace reset is also completely broken in that regard.
Renaming things gives us nothing, only bring unneeded churn. If the
names were internal I wouldn't mind, but they are APIs.

> However, there's also Jan's plans for nVMX.  Peeking at his queue (see
> http://git.kiszka.org/?p=linux-kvm.git;a=commitdiff;h=037fb24ec) I think
> it's better to always reflect INITs to the hypervisor like I did in these
> patches.
> 
The commit was before we decided that we should not abuse mp_state for
signaling.

--
			Gleb.
