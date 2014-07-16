Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853AbaGPOv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaGPOv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:51:56 -0400
Date: Wed, 16 Jul 2014 16:51:53 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ensure guest's kvmclock never goes backwards when TSC
 jumps backward
Message-ID: <20140716165153.02d403c1@igors-macbook-pro.local>
In-Reply-To: <53C68931.7000308@redhat.com>
References: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
	<53C6517D.9090600@redhat.com>
	<20140716114100.GA7394@amt.cnet>
	<20140716155523.174a6b0e@igors-macbook-pro.local>
	<53C68931.7000308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 16:16:17 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 16/07/2014 15:55, Igor Mammedov ha scritto:
> > On Wed, 16 Jul 2014 08:41:00 -0300
> > Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> >> On Wed, Jul 16, 2014 at 12:18:37PM +0200, Paolo Bonzini wrote:
> >>> Il 16/07/2014 11:52, Igor Mammedov ha scritto:
> >>>> There are buggy hosts in the wild that advertise invariant
> >>>> TSC and as result host uses TSC as clocksource, but TSC on
> >>>> such host sometimes sporadically jumps backwards.
> >>>>
> >>>> This causes kvmclock to go backwards if host advertises
> >>>> PVCLOCK_TSC_STABLE_BIT, which turns off aggregated clock
> >>>> accumulator and returns:
> >>>>  pvclock_vcpu_time_info.system_timestamp + offset
> >>>> where 'offset' is calculated using TSC.
> >>>> Since TSC is not virtualized in KVM, it makes guest see
> >>>> TSC jumped backwards and leads to kvmclock going backwards
> >>>> as well.
> >>>>
> >>>> This is defensive patch that keeps per CPU last clock value
> >>>> and ensures that clock will never go backwards even with
> >>>> using PVCLOCK_TSC_STABLE_BIT enabled path.
> >>>
> >>> I'm not sure that a per-CPU value is enough; your patch can make
> >>> the problem much less frequent of course, but I'm not sure neither
> >>> detection nor correction are 100% reliable.  Your addition is
> >>> basically a faster but less reliable version of the last_value
> >>> logic.
> > How is it less reliable than last_value logic?
> 
> Suppose CPU 1 is behind by 3 nanoseconds
> 
>     CPU 0                      CPU 1
>     time = 100                              (at time 100)
>                                time = 99    (at time 102)
>     time = 104                              (at time 104)
>                                time = 105   (at time 108)
> 
> Your patch will not detect this.
Is it possible for each cpu to have it's own time?

> 
> >>> If may be okay to have detection that is faster but not 100%
> >>> reliable. However, once you find that the host is buggy I think
> >>> the correct thing to do is to write last_value and kill
> >>> PVCLOCK_TSC_STABLE_BIT from valid_flags.
> > that might be an option, but what value we need to store into
> > last_value?
> 
> You can write the value that was in the per-CPU variable (not perfect 
> correction)...
I'll look at this variant, it's not perfect but it doesn't involve callout
to other CPUs!

> 
> > To make sure that clock won't go back we need to track
> > it on all CPUs and store highest value to last_value, at this point
> > there is no point in switching to last_value path since we have to
> > track per CPU anyway.
> 
> ... or loop over all CPUs and find the highest value.  You would only 
> have to do this once.
> 
> >> Can we move detection to the host TSC clocksource driver ?
> >
> > I haven't looked much at host side solution yet,
> > but to detection reliable it needs to be run constantly,
> > from read_native_tsc().
> >
> > it's possible to put detection into check_system_tsc_reliable() but
> > that would increase boot time and it's not clear for how long test
> > should run to make detection reliable (in my case it takes ~5-10sec
> > to detect first failure).
> 
> Is 5-10sec the time that it takes for tsc_wrap_test tofail?
nope, for systemtap script hooked to native_read_tsc(), but it depend
on the load for example hotplugging VCPU causes imediate jumps.

tsc_wrap_test starts to fail almost imediately,

I'll check how much tries it takes to fail for the first time, if it is
not too much I guess we could add check to check_system_tsc_reliable().


> 
> > Best we could at boot time is mark TSC as unstable on affected
> > hardware, but for this we need to figure out if it's specific
> > machine or CPU issue to do it properly. (I'm in process of finding
> > out who to bug with it)
> 
> Thanks, this would be best.
> 
> > PS: it appears that host runs stably.
> >
> > but kvm_get_time_and_clockread() is affected since it uses its own
> > version of do_monotonic()->vgettsc() which will lead to cycles
> > go backwards and overflow of nano secs in timespec. We should mimic
> > vread_tsc() here so not to run into this kind of issues.
> 
> I'm not sure I understand, the code is similar:
> 
> 	arch/x86/kvm/x86.c	arch/x86/vdso/vclock_gettime.c
> 	do_monotonic		do_monotonic
> 	vgettsc			vgetsns
> 	read_tsc		vread_tsc
> 	vget_cycles
> 	__native_read_tsc	__native_read_tsc
> 
> The VDSO inlines timespec_add_ns.
I'm sorry, I haven't looked inside read_tsc() in
arch/x86/kvm/x86.c, it's the same as vread_tsc().

> 
> Paolo

