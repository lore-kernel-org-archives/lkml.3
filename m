Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaAHMbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:31:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56491 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaAHMbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:31:41 -0500
Date: Wed, 8 Jan 2014 13:31:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: mingo@kernel.org, rjw@rjwysocki.net, markgross@thegnar.org,
        vincent.guittot@linaro.org, catalin.marinas@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [5/11] issue 5: Frequency and uarch invariant task load
Message-ID: <20140108123118.GS30183@twins.programming.kicks-ass.net>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-6-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389111587-5923-6-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 04:19:41PM +0000, Morten Rasmussen wrote:
> Potential solution: Frequency invariance has been proposed before [1]
> where the task load is scaled by the cur/max freq ratio. Another
> possibility is to use hardware counters if such are available on the
> platform.
> 
> [1] https://lkml.org/lkml/2013/4/16/289

Right, I just had a look at those patches.. they're not horrible but I
think they're missing a few opportunities.

My main objection to them is that I think the newly introduced
max_capacity is exactly what the current cpu_power thing is -- then
again, I still haven't let the entire thing sink in well enough.

Not to mention we need to fix some of the cpu_power abuse -- like the
correlation to capacity, which as stated in previous emails should be
sorted using utilization.

So DVFS certainly makes sense, and would indeed be required in order to
make sensible decisions in the face of P states. Even in the face of
funny hardware like Intel which pretty much ignores whatever you tell it
and does it own merry thing.


A few random thoughts:

 - I think for SMP-nice we want to migrate from /max_capacity to
   /curr_capacity; because SMP-nice cares about 100% utilization
   regardless of the actual P state. If we're somehow forced into a
   lower P state (thermal or otherwise) fairness is best served by
   normalizing at the rate we're actually running at, not the potential
   maximal.

 - We need to re-think SMT and turbo-bins in general; I think we can
   think of those two as the same effective thing. This does mean Intel
   chips will have a dual layer of this goo, and we can currently barely
   deal with the 1 SMT layer, let alone do something sensible with 2.

   To clarify, a single SMT thread will generally go 'faster' on its own
   since it doesn't need to compete with the other thread(s) for core
   resources, but together they might better utilize the core resources
   giving an over-all throughput win.

   Similar for turbo bins, a single core can go faster on its own since
   it doesn't have competition for energy and thermal constraints, but
   together cores can probably achieve greater throughput.

   So we need a better way to describe this capacity dependency and
   variability.

   I'm fairly sure ARM doesn't do SMT, but they certainly suffer from
   thermal caps and can thus have effective turbo bins, even though
   they're not explicit and magic like with Intel.

   And of course the honorary mention goes to Power7 which has
   asymmetric bins -- lets hope they fix it and nobody else things them
   a great idea.

 - For hardware without P state controls, or hardware that pretty much
   ignores them, we need means of obtaining the max and curr capacity.

   Intel has the APERF, MPERF registers which resp. count at actual
   frequency and fixed frequency. Using them is a bit tricky since
   APERF doesn't count when idle, but when filtering out the idle time
   they do provide a current performance ratio.

   From that we could obtain a max performance ratio by using a wide
   window max on the current value or somesuch.

   Again, SMT and turbo-bins will complicate matters..

   Other CPUs that have magic P state control might not provide such
   registers which would require PMU resources, which would completely
   blow :/


