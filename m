Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3KKSd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:33:29 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54493 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753975Ab3KKSdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:33:21 -0500
Date: Mon, 11 Nov 2013 18:31:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "l.majewski@samsung.com" <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
Message-ID: <20131111183142.GF29572@arm.com>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
 <20131111165453.GB4586@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111165453.GB4586@e103034-lin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:54:54PM +0000, Morten Rasmussen wrote:
> On Mon, Nov 11, 2013 at 11:33:45AM +0000, Catalin Marinas wrote:
> > I would rather start by defining the main goal and working backwards
> > to an algorithm. We may as well find that task packing based on this
> > patch set is sufficient but we may also get packing-like behaviour as
> > a side effect of a broader approach (better energy cost awareness). An
> > important aspect even in the mobile space is keeping the performance
> > as close as possible to the standard scheduler while saving a bit more
> 
> With the exception of big.LITTLE where we want to out-perform the
> standard scheduler while saving power.

Good point. Maybe we should start with a separate set of patches for
improving the performance on asymmetric configurations like big.LITTLE
while ignoring (deferring) the power aspect. Things like placing bigger
threads on bigger CPUs and so on (you know better what's needed here ;).

> > My understanding from the recent discussions is that the scheduler
> > should decide directly on the C-state (or rather the deepest C-state
> > possible since we don't want to duplicate the backend logic for
> > synchronising CPUs going up or down). This means that the scheduler
> > needs to know about C-state target residency, wake-up latency (I think
> > we can leave coupled C-states to the backend, there is some complex
> > synchronisation which I wouldn't duplicate).
> 
> It would be nice and simple to hide the complexity of the coupled
> C-states, but we would loose the ability to prefer waking up cpus in a
> cluster/package that already has non-idle cpus over cpus in a
> cluster/package that has entered the coupled C-state. If we just know
> the requested C-state of a cpu we can't tell the difference as it is
> now.

I agree, we can't rely on the requested C-state but the _actual_ state
and this means querying the hardware driver. Can we abstract this via
some interface which provides the cost of waking up a CPU? This could
take into account the state of the other CPUs in the cluster and the
scheduler is simply concerned with the wake-up costs.

> > Alternatively (my preferred approach), we get the scheduler to predict
> > and pass the expected residency and latency requirements down to a
> > power driver and read back the actual C-states for making task
> > placement decisions. Some of the menu governor prediction logic could
> > be turned into a library and used by the scheduler. Basically what
> > this tries to achieve is better scheduler awareness of the current
> > C-states decided by a cpuidle/power driver based on the scheduler
> > constraints.
> 
> It might be easier to deal with the couple C-states using this approach.

We already have drivers taking care of the couple C-states, so it means
passing the information back to the scheduler in some way (actual
C-state or wake-up cost).

It would be nice if we can describe the wake-up costs statically while
considering coupled C-states but it needs more thinking.

-- 
Catalin
