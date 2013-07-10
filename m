Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3GJLQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:16:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35125 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3GJLQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:16:37 -0400
Date: Wed, 10 Jul 2013 12:16:27 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130710111627.GC15989@e103687>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <51DC414F.5050900@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51DC414F.5050900@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Jul 2013 11:16:32.0766 (UTC) FILETIME=[EED509E0:01CE7D5E]
X-MC-Unique: 113071012163405301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 05:58:55PM +0100, Arjan van de Ven wrote:
> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> > Hi,
> >
> > This patch set is an initial prototype aiming at the overall power-aware
> > scheduler design proposal that I previously described
> > <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
> >
> > The patch set introduces a cpu capacity managing 'power scheduler' which lives
> > by the side of the existing (process) scheduler. Its role is to monitor the
> > system load and decide which cpus that should be available to the process
> > scheduler. Long term the power scheduler is intended to replace the currently
> > distributed uncoordinated power management policies and will interface a
> > unified platform specific power driver obtain power topology information and
> > handle idle and P-states. The power driver interface should be made flexible
> > enough to support multiple platforms including Intel and ARM.
> >
> I quickly browsed through it but have a hard time seeing what the
> real interface is between the scheduler and the hardware driver.
> What information does the scheduler give the hardware driver exactly?
> e.g. what does it mean?
> 
> If the interface is "go faster please" or "we need you to be at fastest now",
> that doesn't sound too bad.
> But if the interface is "you should be at THIS number" that is pretty bad and
> not going to work for us.

It is the former.

The current power driver interface (which is far from complete)
basically allows the power scheduler to get the current P-state, the
maximum available P-state, and provide P-state change hints. The current
P-state is not the instantaneous P-state, but an average over some
period of time. Since last query would work. (I should have called it
avg instead of curr.) Knowing that and also the maximum available
P-state at that point in time (may change over time due to thermal or
power budget constraints) allows the power scheduler to reason about the
spare capacity of the cpus and decide whether a P-state change is enough
or if the load must be spread across more cpus.

The P-state change request allows the power scheduler to ask the power
driver to go faster or slower. I was initially thinking about having a
simple up/down interface, but realized that it would not be sufficient
as the power driver wouldn't necessarily know how much it should go up or
down. When the cpu load is decreasing the power scheduler should be able
to determine fairly accurately how much compute capacity that is needed.
So I think it makes sense to pass this information to the power driver.

For some platforms the power driver may use the P-state hint directly to
choose the next P-state. The schedpower cpufreq wrapper governor is an
example of this. Others may have much more sophisticated power drivers
that take platform specific constraints into account and select whatever
P-state they like. The intention is that the P-state request will return
the actual P-state selected by the power driver so the power scheduler
can act accordingly.

The power driver interface uses a cpu_power-like P-state abstraction to
avoid dealing with frequencies in the power scheduler.

> 
> also, it almost looks like there is a fundamental assumption in the code
> that you can get the current effective P state to make scheduler decisions on;
> on Intel at least that is basically impossible... and getting more so with every generation
> (likewise for AMD afaics)
> 
> (you can get what you ran at on average over some time in the past, but not
> what you're at now or going forward)
> 

As described above, it is not a strict assumption. From a scheduler
point of view we somehow need to know if the cpus are truly fully
utilized (at their highest P-state) so we need to throw more cpus at the
problem (assuming that we have more than one task per cpu) or if we can
just go to a higher P-state. We don't need a strict guarantee that we
get exactly the P-state that we request for each cpu. The power
scheduler generates hints and the power driver gives us feedback on what
we can roughly expect to get.

> I'm rather nervous about calculating how many cores you want active as a core scheduler feature.
> I understand that for your big.LITTLE architecture you need this due to the asymmetry,
> but as a general rule for more symmetric systems it's known to be suboptimal by quite a
> real percentage. For a normal Intel single CPU system it's sort of the worst case you can do
> in that it leads to serializing tasks that could have run in parallel over multiple cores/threads.
> So at minimum this kind of logic must be enabled/disabled based on architecture decisions.

Packing clearly has to take power topology into account and do the right
thing for the particular platform. It is not in place yet, but will be
addressed. I believe it would make sense for dual cpu Intel systems to
pack at socket level? I fully understand that it won't make sense for
single cpu Intel systems or inside each cpu in dual cpu Intel system.

For ARM it depends on the particular implemention. For big.LITTLE where
you have two cpu clusters (big and little), which may have different
C-states. It may make sense to pack between clusters and inside one
cluster, but not the other. The power scheduler must be able to handle
this. The power driver should provide the necessary platform information
as part of the power topology.

