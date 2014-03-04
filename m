Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbaCDW2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:28:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbaCDW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:28:00 -0500
Date: Tue, 4 Mar 2014 14:27:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/48] percpu: Consistent per cpu operations V4
Message-Id: <20140304142759.a6849728754eb553b0bd33d3@linux-foundation.org>
In-Reply-To: <20140214201841.826179349@linux.com>
References: <20140214201841.826179349@linux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 14:18:41 -0600 Christoph Lameter <cl@linux.com> wrote:

> Can we please get this merged? The first patch alone would at least define
> the functions required to enable the merging of the rest in any order and
> through any tree.

This series is structured as

[patch 1]: make changes whcih trigger lots of runtime warnings
[patch 2-n]: fix up those warnings

yes?

So we're proposing adding a 48-patch bisection hole in which scary
warnings will be emitted.

I guess that's liveable with - we *could* fix it, by starting out with
do-nothing wrappers, then all the fixes and then finish up with patches
which turn do-nothing-wrapeprs into do-something-functions.  But I'm
not sure that the resulting obscuration is worth the effort.

> The kernel has never been audited to ensure that this_cpu operations are
> consistently used throughout the kernel. The code generated in many
> places can be improved through the use of this_cpu operations (which uses
> a segment register for relocation of per cpu offsets instead of
> performing address calculations).
> 
> The patch set also addresses various consistency issues in general with
> the per cpu macros.
> 
> A. The semantics of __this_cpu_ptr() differs from this_cpu_ptr only
>    because checks are skipped. This is typically shown through a raw_
>    prefix. So this patch set changes the places where __this_cpu_ptr()
>    is used to raw_cpu_ptr().
> 
> B. There has been the long term wish by some that __this_cpu operations
>    would check for preemption. However, there are cases where preemption
>    checks need to be skipped. This patch set adds raw_cpu operations that
>    do not check for preemption and then adds preemption checks to the
>    __this_cpu operations.
> 
> C. The use of __get_cpu_var is always a reference to a percpu variable
>    that can also be handled via a this_cpu operation. This patch set
>    replaces all uses of __get_cpu_var with this_cpu operations.
> 
> D. We can then use this_cpu RMW operations in various places replacing
>    sequences of instructions by a single one.
> 
> E. The use of this_cpu operations throughout will allow other arches than
>    x86 to implement optimized references and RMV operations to work with
>    per cpu local data.
> 
> F. The use of this_cpu operations opens up the possibility to
>    further optimize code that relies on synchronization through
>    per cpu data.
> 
> 
> The patch set works in a couple of stages:
> 
> I. Patch 1 adds the additional raw_cpu operations and raw_cpu_ptr().
>     Also converts the existing __this_cpu_xx_# primitive in the x86
>     code to raw_cpu_xx_#.
> 
> II. Patch 2-4 use the raw_cpu operations in places that would give
>      us false positives once they are enabled.
> 
> III. Patch 5 adds preemption checks to __this_cpu operations to allow
>     checking if preemption is properly disabled when these functions
>     are used.
> 
> IV. Patches 6-20 are patches that simply replace uses of __get_cpu_var
>    with this_cpu_ptr. They do not depend on any changes to the percpu
>    code. No preemption tests are skipped if they are applied.
> 
> V. Patches 21-46 are conversion patches that use this_cpu operations
>    in various kernel subsystems/drivers or arch code.

That all seems desirable.

> VI. Patches 47/48 remove no longer used functions (__this_cpu_ptr
>     and __get_cpu_var).  These should only be applied after all the
>     conversion patches have made it and after we have done additional
>     passes through the kernel to ensure that none of the uses of these
>     functions remain.

Yes, I'll skip those two.

In linux-next arch/arm/mach-msm/timer.c gets moved to
drivers/clocksource/qcom-timer.c, which I fixed up.  Apart from that it
all still merges OK...
