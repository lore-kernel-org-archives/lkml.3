Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300Ab3LTOAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:00:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58211 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030189Ab3LTOAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:00:53 -0500
Date: Fri, 20 Dec 2013 15:00:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: dietmar.eggemann@arm.com
Cc: mingo@redhat.com, vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        chris.redpath@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] change scheduler domain hierarchy set-up
Message-ID: <20131220140046.GU16438@laptop.programming.kicks-ass.net>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:11:20PM +0000, dietmar.eggemann@arm.com wrote:
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> 
> This patch-set cleans up the scheduler domain level initialization code.
> It is based on the idea of Peter Zijlstra to use a single scheduler domain
> init function sketched here: https://lkml.org/lkml/2013/11/5/239 
> 
> What does the patch-set try to achieve:
> 
> 1) Let the arch define the conventional (here defined to all levels except
>    the NUMA levels) scheduler domain hierarchy.  The arch specifies per
>    scheduler domain the pointer to the getter function of the
>    corresponding cpu mask as well as the topology related scheduler
>    domain flags.
> 
> 2) Unify the set-up code for conventional and NUMA scheduler domains.
>    All scheduler domain topology levels are now allocated in the same
>    function and the scheduler does not rely on a default scheduler
>    domain topology array any more.  All scheduler domains now use a
>    common initialization function which makes the existing SD_FOO_INIT
>    macros redundant.

Yeah, still a tad confused on what you did there, need to look in more
detail.

> 3) The arch is no longer limited to the existing scheduler domain levels
>    (SMT, MC, BOOK, CPU) but can easily define additional levels.
> 
> 4) Prepare the mechanics to make it easier to integrate the provision of
>    additional topology related data (e.g. energy information) to the
>    scheduler.

Right, I was hoping you'd have a little more on that, but we'll get
there I suppose ;-)

> Current limitations:
> 
> 1) The arch interface for scheduler domain set-up is only implemented for
>    the ARM and the x86 arch and tested on an ARM TC2 (2 clusters, one with
>    2 Cortex A15 and the other with 3 Cortex A7) and an Intel i5-520M (2
>    cores with 2 threads each) platform.   
> 
> 2) For other archs it has only been compile tested for certain
>    configurations (powerpc: chroma_defconfig, mips: ip27_defconfig,
>    s390: defconfig, tile: tilegx_defconfig).  Obviously, linking these
>    kernels doesn't succeed due to the missing arch interface for
>    scheduler domain set-up implementation (undefined reference to
>    arch_sched_domain_info).
> 
> 3) It does not delete the arch specific SD_FOO_INIT macros for ia64,
>    metag, s390 and tile arch.
> 
> 4) It does not delete the arch_sd_sibling_asym_packing function which
>    will be redundant once the arch interface for scheduler domain set-up
>    has been implemented for powerpc arch.
> 
> 5) There is no default set-up any more.  Each arch has to define a
>    arch_sched_domain_info array, a circumstance which might not be
>    desirable.

Yeah, that's sad, I think we want to keep the default thing to limit the
amount of pointless duplication for all archs that are not special.

Also, like you point out above, breaking all archs isn't nice :-)

> 6) It has to be specified what happens when an arch specifies an
>    arch_sched_domain_info array with only a { NULL, } entry.

Crash hard on boot :-) Although I suppose since its all compile time
constants we could try and be smart and make the build fail somehow.

The one thing I do dislike is that you mixed SDTL_flags and SD_flags
into a single variable. Don't do that its bound to collide and give
weird results at some point, and its not like any of these structures
are space critical in any way shape or form.
