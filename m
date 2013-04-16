Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919Ab3DPOBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:01:07 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60710 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935114Ab3DPOBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:01:05 -0400
Date: Tue, 16 Apr 2013 09:01:01 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130416140101.GS3658@sgi.com>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416120624.GO3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +{
> > > +	/* The boot cpu is always logical cpu 0 */
> > > +	int reboot_cpu_id = 0;
> > > +
> > > +	/* Make certain the cpu I'm about to reboot on is online */
> > > +	if (!cpu_online(reboot_cpu_id))
> > > +		reboot_cpu_id = smp_processor_id();
> > 
> > Shouldn't we pick the first online CPU instead, to make it deterministic?
> 
> Done.
> 
> 		reboot_cpu_id = cpumask_first(cpu_online_mask);
> 
> > Also, does this codepath prevent hotplug from going on in parallel?
> 
> Not sure.  I have not considered hotplug.  I will look that over when I
> am in the office.

OK.  I have been mulling this over for a bit and I don't think I
understand what you are asking.

I would expect that if an architecture depends upon a certain cpu for
shutdown/reboot/halt/suspend/hibernate and that support has been compiled
in, then the arch should be preventing that cpu from being removed.
I do not know how that would work and think that is far beyond the scope
of the initial problem I have been trying to solve.  If that is your
question, I certainly do not know how to address it.  I get the feeling
this is off your mark due to the "parallel" wording above.

The other question I think you might be asking is something about the
shutdown/reboot/halt task trying to migrate to a cpu which is in the
process of being off-lined.  I believe the code will "work" in that
we will have selected a cpu to migrate to, that migration may fail,
in which case our task remains on the current cpu, may succeed and the
cpu is immediately offlined, in which case the hotplug code should move
us to another cpu, or we complete the shutdown before the hotplug code
gets a chance to run, in which case it is irrelevant.

Have I addressed your concern?  Are you asking me to look into a method
for preventing the arch from hot removing the shutdown/reboot cpu?

Thanks,
Robin
