Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbbAGKUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:20:36 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49700 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbAGKUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:20:33 -0500
Date: Wed, 7 Jan 2015 11:20:24 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, drjones@redhat.com, dzickus@redhat.com,
        mingo@kernel.org, uobergfe@redhat.com, chaiw.fnst@cn.fujitsu.com,
        cl@linu.com, fabf@skynet.be, atomlin@redhat.com, benzh@chromium.org,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH 2/2] powerpc: add running_clock for powerpc to prevent
 spurious softlockup warnings
Message-ID: <20150107112024.76aa9217@mschwide>
In-Reply-To: <1420512241.2910.41.camel@cyril>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
	<1419224764-11384-3-git-send-email-cyrilbur@gmail.com>
	<20150105141013.946b5d15c5d003de8238951c@linux-foundation.org>
	<1420512241.2910.41.camel@cyril>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010710-0017-0000-0000-000002854201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 13:44:01 +1100
Cyril Bur <cyrilbur@gmail.com> wrote:

> On Mon, 2015-01-05 at 14:10 -0800, Andrew Morton wrote:
> > On Mon, 22 Dec 2014 16:06:04 +1100 Cyril Bur <cyrilbur@gmail.com> wrote:
> > 
> > > On POWER8 virtualised kernels the VTB register can be read to have a view of
> > > time that only increases while the guest is running. This will prevent guests
> > > from seeing time jump if a guest is paused for significant amounts of time.
> > > 
> > > On POWER7 and below virtualised kernels stolen time is subtracted from
> > > sched_clock as a best effort approximation. This will not eliminate spurious
> > > warnings in the case of a suspended guest but may reduce the occurance in the
> > > case of softlockups due to host over commit.
> > > 
> > > Bare metal kernels should avoid reading the VTB as KVM does not restore sane
> > > values when not executing. sched_clock is returned in this case.
> > > 
> > > --- a/arch/powerpc/kernel/time.c
> > > +++ b/arch/powerpc/kernel/time.c
> > > @@ -621,6 +621,30 @@ unsigned long long sched_clock(void)
> > >  	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
> > >  }
> > >  
> > > +unsigned long long running_clock(void)
> > 
> > Non-kvm kernels don't need this code.  Is there some appropriate
> > "#ifdef CONFIG_foo" we can wrap this in?
> CONFIG_PSERIES would work, having said that typical compilation for a
> powernv kernel almost always includes CONFIG_PSERIES (although it
> doesn't need to)... still, your point is valid, will add in v2.
> > 
> > 
> > > +{
> > > +	/*
> > > +	 * Don't read the VTB as a host since KVM does not switch in host timebase
> > > +	 * into the VTB when it takes a guest off the CPU, reading the VTB would
> > > +	 * result in reading 'last switched out' guest VTB.
> > > +	 */
> > > +
> > > +	if (firmware_has_feature(FW_FEATURE_LPAR)) {
> > > +		if (cpu_has_feature(CPU_FTR_ARCH_207S))
> > > +			return mulhdu(get_vtb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
> > > +
> > > +		/* This is a next best approximation without a VTB. */
> > > +		return sched_clock() - cputime_to_nsecs(kcpustat_this_cpu->cpustat[CPUTIME_STEAL]);
> > 
> > Why is this result dependent on FW_FEATURE_LPAR?  It's all generic code.
> Good point, the reason it ended up there is because I wanted to avoid
> behaviour changes.
> > 
> > In fact the kernel/sched/clock.c default implementation of
> > running_clock() could use this expression.  Would that be good or bad? :)
> For power I'm almost certain it would be fine, on platforms which don't
> do stolen time cpustat[CPUTIME_STEAL] should always be zero and if not
> then the value should always be sane (although as mentioned in the
> comment, not as accurate as using the VTB).
> 
> Putting it in the default implementation could cause behavioural changes
> for x86 and s390, I would want their views on doing that.

I would prefer to make sched_clock do all the work. We have been thinking
about steal time vs sched_clock as well, our solution would be to exchange
the time source. Right now sched_clock is based on the TOD clock, the code
that takes steal time into account would use the CPU timer instead.
With the subtraction of kcpustat_this_cpu->cpustat[CPUTIME_STEAL] in
common code we would have to add the same value in the sched_clock
implementation as the steal time is already included in the CPU timer
deltas.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

