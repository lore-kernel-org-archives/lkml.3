Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3CKRUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab3CKRUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:20:37 -0400
Date: Mon, 11 Mar 2013 19:20:34 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311172034.GR31619@redhat.com>
References: <20130310153540.GL24444@redhat.com>
 <513CC08B.2040800@redhat.com>
 <20130310181035.GM24444@redhat.com>
 <513DAE8F.3050102@redhat.com>
 <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
 <20130311115144.GG31619@redhat.com>
 <513DDCC2.9070807@redhat.com>
 <20130311135441.GN31619@redhat.com>
 <513DE9F3.9000802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DE9F3.9000802@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 03:28:03PM +0100, Paolo Bonzini wrote:
> Il 11/03/2013 14:54, Gleb Natapov ha scritto:
> >> Setting the mp_state to INIT_RECEIVED is that interface, and it already
> >> works, for APs at least.  This patch extends it to work for the BSP as well.
> >
> > It does not for AP either. If AP has vmx on mp_sate should not be set to
> > INIT_RECEIVED. mp_sate is a state as you can see from its name and we
> > already had a discussion on the generic device API about importance of
> > separating sending commands from setting state. There is a difference
> > between setting mp_state during migration and signaling INIT#.
> 
> What does migration have to do with this?
> 
get|set_mpstate is used by migration. Actually this is primary reason
for this interface existence.

> >> In the corresponding userspace patch, I don't need to touch the CPU
> >> state at all.  I can just signal the kernel.  If I touch the CPU, I'll
> >> break the nested case, no matter how it is implemented.  So far, the
> >> userspace did not have to worry about nested, and that's something that
> >> should be kept that way.
> > We are discussing two different things here. I'll try to separate them.
> > 1. BSP is broken WRT #INIT
> > 2. nested is broken WRT #INIT
> > 
> > You are fixing 1 with your patches, for that I proposed much easier
> > solution (at last from kernel point of view): if BSP reset it in
> > userspace and make it runnable. Nested virt is still broken, but this is
> > not what you are fixing.
> 
> It's not what I'm fixing, but I don't want to make the fix for nested
What are you fixing then?

> virt unnecessarily more complicated.  Nested virt needs to know about
> INIT and SIPI; redefining the meaning of INIT_RECEIVED and SIPI_RECEIVED
> makes it more complicated to reflect these events to L1.
> 
> > For 2 much more involved fix is needed. Jan fixes it and it will require
> > signaling INIT# from userspace by other means than mp_sate because
> > signaling INIT# does not automatically means that mp_sate changes to
> > INIT_RECEIVED.
> 
> In your interpretation of INIT_RECEIVED, no.  In mine, yes...
> 
Your code shows different. With your patch setting mp_state to
INIT_RECEIVED makes vcpu non tunable. This is incorrect if INIT_RECEIVED
is "INIT# is triggered" interface.

> >> If we move away from the INIT_RECEIVED and SIPI_RECEIVED states for
> >> in-kernel APIC -> VCPU communication, then the KVM_SET_MP_STATE ioctl
> >> will have to convert them to the right bits in the requests field or in
> >> the APIC state.  But I'm starting to see less benefit from moving away
> >> from mp_state.
> >>
> > We are not moving away from mp_state, we are moving away from using
> > mp_state for signaling
> 
> That's what I meant; sorry for the unclear abbreviation.
Then we disagree.

> 
> > because with nested virt INIT does not always
> > change mp_state
> 
> Why not?
Because mp_state is the current state the vcpu is in. It can be
uninitialized, runnable, halted or wait for sipi. SDM says that
if nested virt is enabled vcpu does not enter wait for sipi state
on INIT#.

>          It does change mp_state, it changes how you react to the
> change.
How does it? CPU was runnable before it is still runnable after.

>          Which is why it's good to have the reset done in kernel space,
> not in user space.
> 
Without nested virt it does not really matter and if it is does not
really matter you do not add code to the kernel just because it is good.
With nested virt INIT# processing needs to go to the kernel. In some
cases INIT will cause reset, but you do not "do reset in kernel space",
you do "INIT# handling in kernel space".

--
			Gleb.
