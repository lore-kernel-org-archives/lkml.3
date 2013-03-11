Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3CKSFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab3CKSFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:05:02 -0400
Date: Mon, 11 Mar 2013 20:04:58 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311180458.GV31619@redhat.com>
References: <20130310181035.GM24444@redhat.com>
 <513DAE8F.3050102@redhat.com>
 <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
 <20130311115144.GG31619@redhat.com>
 <513DDCC2.9070807@redhat.com>
 <20130311135441.GN31619@redhat.com>
 <513DE9F3.9000802@redhat.com>
 <20130311172034.GR31619@redhat.com>
 <513E16E0.2050703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E16E0.2050703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:39:44PM +0100, Paolo Bonzini wrote:
> Il 11/03/2013 18:20, Gleb Natapov ha scritto:
> > On Mon, Mar 11, 2013 at 03:28:03PM +0100, Paolo Bonzini wrote:
> >> Il 11/03/2013 14:54, Gleb Natapov ha scritto:
> >>>> Setting the mp_state to INIT_RECEIVED is that interface, and it already
> >>>> works, for APs at least.  This patch extends it to work for the BSP as well.
> >>>
> >>> It does not for AP either. If AP has vmx on mp_sate should not be set to
> >>> INIT_RECEIVED. mp_sate is a state as you can see from its name and we
> >>> already had a discussion on the generic device API about importance of
> >>> separating sending commands from setting state. There is a difference
> >>> between setting mp_state during migration and signaling INIT#.
> >>
> >> What does migration have to do with this?
> >
> > get|set_mpstate is used by migration. Actually this is primary reason
> > for this interface existence.
> 
> Does it have to be the only one?
Nope, but it does prevent it from been used as even injection mechanism.

> 
> >>>> In the corresponding userspace patch, I don't need to touch the CPU
> >>>> state at all.  I can just signal the kernel.  If I touch the CPU, I'll
> >>>> break the nested case, no matter how it is implemented.  So far, the
> >>>> userspace did not have to worry about nested, and that's something that
> >>>> should be kept that way.
> >>> We are discussing two different things here. I'll try to separate them.
> >>> 1. BSP is broken WRT #INIT
> >>> 2. nested is broken WRT #INIT
> >>>
> >>> You are fixing 1 with your patches, for that I proposed much easier
> >>> solution (at last from kernel point of view): if BSP reset it in
> >>> userspace and make it runnable. Nested virt is still broken, but this is
> >>> not what you are fixing.
> >>
> >> It's not what I'm fixing, but I don't want to make the fix for nested
> > 
> > What are you fixing then?
> 
> Nested virt is not what I am fixing, but I'm trying to keep an eye on
> that (and the other INIT race) while doing these patches.
> 
So you do fixing 1 then?

> >> virt unnecessarily more complicated.  Nested virt needs to know about
> >> INIT and SIPI; redefining the meaning of INIT_RECEIVED and SIPI_RECEIVED
> >> makes it more complicated to reflect these events to L1.
> >>
> >>> For 2 much more involved fix is needed. Jan fixes it and it will require
> >>> signaling INIT# from userspace by other means than mp_sate because
> >>> signaling INIT# does not automatically means that mp_sate changes to
> >>> INIT_RECEIVED.
> >>
> >> In your interpretation of INIT_RECEIVED, no.  In mine, yes...
> >
> > Your code shows different. With your patch setting mp_state to
> > INIT_RECEIVED makes vcpu non tunable. This is incorrect if INIT_RECEIVED
> > is "INIT# is triggered" interface.
> 
> What do you mean by "non tunable"?  In non-nested mode, the VCPU will
Sorry, it should have been "not runnable".

> reset immediately, as soon as it is re-entered.  In nested mode, the
> VCPU will eat the INIT_RECEIVED and turn it into a vmexit.
> 
It should not eat it. It should be pending until vmxoff. And processing
INIT_RECEIVED separately far away from other events that causes vmexit
is cumbersome. INIT# is just an event that can be masked, why treat it
differently from IRQs?

> At least according to AMD's docs, the VMM has to reassert INIT if it
> wants the processor to actually process it [15.20.8 INIT support].
> Intel's does not say it explicitly, but it doesn't say the opposite
> either.  It seems to be the only that makes sense.
Well [1] claims differently. Page 10 "VMX and INIT blocking".

[1] http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf 
> 
> >>>> If we move away from the INIT_RECEIVED and SIPI_RECEIVED states for
> >>>> in-kernel APIC -> VCPU communication, then the KVM_SET_MP_STATE ioctl
> >>>> will have to convert them to the right bits in the requests field or in
> >>>> the APIC state.  But I'm starting to see less benefit from moving away
> >>>> from mp_state.
> >>>>
> >>> We are not moving away from mp_state, we are moving away from using
> >>> mp_state for signaling
> >>
> >> That's what I meant; sorry for the unclear abbreviation.
> > 
> > Then we disagree.
> 
> We do.  Let's see _where_ exactly we disagree.

My guess would be this: for me mp_state is current vcpu state, for you
it is a way of passing events _and_ current vcpu state when you do not
pass events there. Correct me if I am wrong.

> 
> >>> because with nested virt INIT does not always
> >>> change mp_state
> >>
> >> Why not?
> > 
> > Because mp_state is the current state the vcpu is in. It can be
> > uninitialized, runnable, halted or wait for sipi. SDM says that
> > if nested virt is enabled vcpu does not enter wait for sipi state
> > on INIT#.
> 
> Yes, but it still has to do something (a vmexit) and go back to RUNNING.
Or go back to HALT and when you overwrote current running state how
do you know which one is that?. And how is it different from IRQs
or NMI. We do not pass them in mp_state, not because we can't, just
introduce EVENT_PENDING state, because it does not make sense.
 
>  So it needs signaling from userspace to the kernel.
> 
And do I say it does not need it? I am saying mp_state is not it.

> >>          Which is why it's good to have the reset done in kernel space,
> >> not in user space.
> >
> > Without nested virt it does not really matter and if it is does not
> > really matter you do not add code to the kernel just because it is good.
> > With nested virt INIT# processing needs to go to the kernel. In some
> > cases INIT will cause reset, but you do not "do reset in kernel space",
> > you do "INIT# handling in kernel space".
> 
> We agree on this.  What I add is: let's define the API so that it is
> nested-friendly.  This means having a signaling mechanism for userspace.
>  I think you do not want mp_state to be this signaling mechanism.  Why
> not?  Can an existing ioctl be the alternative or do we need to invent a
> new one?
> 
I explained why not above and in my previous emails. For the second question
it is implementation detail. I hope we can extend existing interface,
but if we cannot we add another one.

--
			Gleb.
