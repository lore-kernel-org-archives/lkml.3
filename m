Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030662AbaDBWHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030647AbaDBWHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:07:14 -0400
Date: Wed, 2 Apr 2014 19:05:57 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhang yanying <zhuangyanying@huawei.com>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Message-ID: <20140402220557.GA22637@amt.cnet>
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
 <5339AB59.4050906@mit.edu>
 <20140331213032.GA5866@amt.cnet>
 <CALCETrW9sBUSg8gRBEpDNC_Vcqq2oDRkVNPxTBGmehpMay9=5Q@mail.gmail.com>
 <20140401180134.GA17963@amt.cnet>
 <CALCETrVFv4dHH1_D1KR43-UsVCPcXDXhwAuUWNUF5_Wgm+kw1g@mail.gmail.com>
 <20140402002926.GB31945@amt.cnet>
 <CALCETrWEbEeZM5umHPqtLJMm21phJG4AXPQXK=h_4FR8EPJotg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWEbEeZM5umHPqtLJMm21phJG4AXPQXK=h_4FR8EPJotg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:46:34PM -0700, Andy Lutomirski wrote:
> On Tue, Apr 1, 2014 at 5:29 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Tue, Apr 01, 2014 at 12:17:16PM -0700, Andy Lutomirski wrote:
> >> On Tue, Apr 1, 2014 at 11:01 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >> > On Mon, Mar 31, 2014 at 10:33:41PM -0700, Andy Lutomirski wrote:
> >> >> On Mar 31, 2014 8:45 PM, "Marcelo Tosatti" <mtosatti@redhat.com> wrote:
> >> >> >
> >> >> > On Mon, Mar 31, 2014 at 10:52:25AM -0700, Andy Lutomirski wrote:
> >> >> > > On 03/29/2014 01:47 AM, Zhanghailiang wrote:
> >> >> > > > Hi,
> >> >> > > > I found when Guest is idle, VDSO pvclock may increase host consumption.
> >> >> > > > We can calcutate as follow, Correct me if I am wrong.
> >> >> > > >       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
> >> >> > > > In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
> >> >> > > > In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call.
> >> >> > > > When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
> >> >> > > > Both Host and Guest is linux-3.13.6.
> >> >> > > > So, whether the host cpu consumption is a problem?
> >> >> > >
> >> >> > > Does pvclock serve any real purpose on systems with fully-functional
> >> >> > > TSCs?  The x86 guest implementation is awful, so it's about 2x slower
> >> >> > > than TSC.  It could be improved a lot, but I'm not sure I understand why
> >> >> > > it exists in the first place.
> >> >> >
> >> >> > VM migration.
> >> >>
> >> >> Why does that need percpu stuff?  Wouldn't it be sufficient to
> >> >> interrupt all CPUs (or at least all cpus running in userspace) on
> >> >> migration and update the normal timing data structures?
> >> >
> >> > Are you suggesting to allow interruption of the timekeeping code
> >> > at any time to update frequency information ?
> >>
> >> I'm not sure what you mean by "interruption of the timekeeping code".
> >> I'm suggesting sending an interrupt to the guest (via a virtio device,
> >> presumably) to tell it that it has been paused and resumed.
> >>
> >> This is probably worth getting John's input if you actually want to do
> >> this.  I'm not about to :)
> >
> > Honestly, neither am i at the moment. But i'll think about it.
> >
> >> Is there any case in which the TSC is stable and the kvmclock data for
> >> different cpus is actually different?
> >
> > No. However, kvmclock_data.flags field is an interface for watchdog
> > unpause.
> >
> >> > Do you want to that as a special tsc clocksource driver ?
> >> >
> >> >> Even better: have the VM offer to invalidate the physical page
> >> >> containing the kernel's clock data on migration and interrupt one CPU.
> >> >>  If another CPU races, it'll fault and wait for the guest kernel to
> >> >> update its timing.
> >> >
> >> > Perhaps that is a good idea.
> >> >
> >> >> Does the current kvmclock stuff track CLOCK_MONOTONIC and
> >> >> CLOCK_REALTIME separately?
> >> >
> >> > No. kvmclock counting is interrupted on vm pause (the "hw" clock does not
> >> > count during vm pause).
> >>
> >> Makes sense.
> >>
> >> >
> >> >> > Can you explain why you consider it so bad ? How you think it could be
> >> >> > improved ?
> >> >>
> >> >> The second rdtsc_barrier looks unnecessary.  Even better, if rdtscp is
> >> >> available, then rdtscp can replace rdtsc_barrier, rdtsc, and the
> >> >> getcpu call.
> >> >>
> >> >> It would also be nice to avoid having two sets of rescalings of the timing data.
> >> >
> >> > Yep, probably good improvements, patches are welcome :-)
> >> >
> >>
> >> I may get to it at some point.  No guarantees.  I did just rewrite all
> >> the mapping-related code for every other x86 vdso timesource, so maybe
> >> I should try to add this to the pile.  The fact that the data is a
> >> variable number of pages makes it messy, though, and since I don't
> >> understand why there's a separate structure for each CPU, I'm hesitant
> >> to change it too much.
> >>
> >> --Andy
> >
> > kvmclock.data? Because each VCPU can have different .flags fields for
> > example.
> 
> It looks like the vdso kvmclock code only runs if
> PVCLOCK_TSC_STABLE_BIT is set, which in turn is only the case if the
> TSC is guaranteed to be monotonic across all CPUs.  If we can rely on
> the fact that that bit will only be set if tsc_to_system_mul and
> tsc_shift are the same on all CPUs and that (system_time -
> (tsc_timestamp * mul) >> shift) is the same on all CPUs, then there
> should be no reason for the vdso to read the pvclock data for anything
> but CPU 0.  That will make it a lot faster and simpler.
> 
> Can we rely on that?

In theory yes, but you would have to handle

PVCLOCK_TSC_STABLE_BIT set -> PVCLOCK_TSC_STABLE_BIT not set

Transition (and the other way around as well).

> I wonder what happens if the guest runs ntpd or otherwise uses
> adjtimex.  Presumably it starts drifting relative to the host.

It should use ntpd and adjtimex.  KVMCLOCK is the "hw" clock, 
the values returned by CLOCK_REALTIME and CLOCK_GETTIME are built
by the Linux guest timekeeping subsystem on top of the "hw" clock.

