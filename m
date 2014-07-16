Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaGPNzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933772AbaGPNz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:55:27 -0400
Date: Wed, 16 Jul 2014 15:55:23 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ensure guest's kvmclock never goes backwards when TSC
 jumps backward
Message-ID: <20140716155523.174a6b0e@igors-macbook-pro.local>
In-Reply-To: <20140716114100.GA7394@amt.cnet>
References: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
	<53C6517D.9090600@redhat.com>
	<20140716114100.GA7394@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 08:41:00 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Wed, Jul 16, 2014 at 12:18:37PM +0200, Paolo Bonzini wrote:
> > Il 16/07/2014 11:52, Igor Mammedov ha scritto:
> > >There are buggy hosts in the wild that advertise invariant
> > >TSC and as result host uses TSC as clocksource, but TSC on
> > >such host sometimes sporadically jumps backwards.
> > >
> > >This causes kvmclock to go backwards if host advertises
> > >PVCLOCK_TSC_STABLE_BIT, which turns off aggregated clock
> > >accumulator and returns:
> > >  pvclock_vcpu_time_info.system_timestamp + offset
> > >where 'offset' is calculated using TSC.
> > >Since TSC is not virtualized in KVM, it makes guest see
> > >TSC jumped backwards and leads to kvmclock going backwards
> > >as well.
> > >
> > >This is defensive patch that keeps per CPU last clock value
> > >and ensures that clock will never go backwards even with
> > >using PVCLOCK_TSC_STABLE_BIT enabled path.
> > 
> > I'm not sure that a per-CPU value is enough; your patch can make the
> > problem much less frequent of course, but I'm not sure neither
> > detection nor correction are 100% reliable.  Your addition is
> > basically a faster but less reliable version of the last_value
> > logic.
How is it less reliable than last_value logic?

Alternatively, we can panic in case of backward jump here, so that guest
won't hang in random place in case of error. There might not be OOPs
but at least coredump will point to a right place.

> > 
> > If may be okay to have detection that is faster but not 100%
> > reliable. However, once you find that the host is buggy I think the
> > correct thing to do is to write last_value and kill
> > PVCLOCK_TSC_STABLE_BIT from valid_flags.
that might be an option, but what value we need to store into
last_value?
To make sure that clock won't go back we need to track
it on all CPUs and store highest value to last_value, at this point
there is no point in switching to last_value path since we have to
track per CPU anyway.

What this patch doesn't cover is switching from master_clock mode to
last_value mode (it happens at CPU hotplug time), I'd need to add
what was described above as second patch on top of this one.

> > 
> > Did you check that the affected host has the latest microcode?
> > Alternatively, could we simply blacklist some CPU steppings?  I'm
> > not sure who we could ask at AMD :( but perhaps there is an erratum.
I haven't found anything in this direction yet. I'm still trying to
find someone from AMD to look at the issue.

> > 
> > Paolo
> 
> Igor,
> 
> Can we move detection to the host TSC clocksource driver ?
I haven't looked much at host side solution yet,
but to detection reliable it needs to be run constantly,
from read_native_tsc().

it's possible to put detection into check_system_tsc_reliable() but
that would increase boot time and it's not clear for how long test
should run to make detection reliable (in my case it takes ~5-10sec
to detect first failure).

Best we could at boot time is mark TSC as unstable on affected hardware,
but for this we need to figure out if it's specific machine or CPU issue
to do it properly. (I'm in process of finding out who to bug with it)

> 
> Because it is responsability of the host system to provide a non
> backwards clock_gettime() interface as well.
vdso_clock_gettime() is not affected since it will use last highest
tsc value in case of jump due to usage of vread_tsc().
PS: it appears that host runs stably. 

but kvm_get_time_and_clockread() is affected since it uses its own
version of do_monotonic()->vgettsc() which will lead to cycles
go backwards and overflow of nano secs in timespec. We should mimic
vread_tsc() here so not to run into this kind of issues.

> 
> How did you prove its the host TSC in fact going backwards?
> Is it cross-CPU detection?
I've checked with several methods, 
1. patched pvclock_clocksource_read() in guest with VCPUs pinned to host
CPUs.
2.Ingo's tsc_wrap_test, which fails miserably on affected host.
3 sytemtap script hooked to read_native_tsc(), for source see
https://bugzilla.redhat.com/show_bug.cgi?id=1115795#c12


> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

