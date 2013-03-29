Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3C2Xff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 19:35:35 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56479 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3C2Xfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 19:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <1364599219.27102.56.camel@schen9-DESK>
References: <1364599219.27102.56.camel@schen9-DESK>
From: Paul Turner <pjt@google.com>
Date: Fri, 29 Mar 2013 16:35:01 -0700
Message-ID: <CAPM31RKDt+Xuo4MkmmE+R-AXSjZHGAhOT83vk4d6GrDVZtWUmA@mail.gmail.com>
Subject: Re: Load balancing behavior for sched autogroup
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>,
        Changlong Xie <changlongx.xie@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm surprised that patch would have much effect in either direction;
it changes the amortization of accounting, but not the actual numbers
-- especially for a persistent load.  We'll take a look.

<Resend since gmail "reinterpreted" my plain-text>

On Fri, Mar 29, 2013 at 4:20 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> During our testings of 3.8 kernel, we noticed that after the patch
>
> Revert "sched: Update_cfs_shares at period edge" (commit 17bc14b7),
>
> the load between the sockets or larger system can have
> large imbalance.  For example, for a 4 socket Westmere-EX
> (10 cores/socket), we notice the loadings between the sockets
> can differ by more than a factor of 4.
>
> We did a simple experiment that kicks off 29 simple
> processes that execute a tight loop.  We noticed
> socket 3 is already starting to schedule on hyperthreaded cpus
> (13 loaded cpus) while socket 1 still have lots of
> idle cores (3 loaded cpus).  Before the patch, the
> load was evenly distributed across sockets.
> If I turn off CONFIG_SCHED_AUTOGROUP,the loads are also
> distributed evenly.
>
> (load on cpus, running on 4)
> socket                    0                    1                    2                    3
> ---------------------------------------------------------------------------------------------
> cpu:    0-3               0.00                 0.00                 0.00                99.00
> cpu:    4-7               0.00                 0.00                 0.00                99.20
> cpu:    8-11              0.00                 0.00                 0.00                99.00
> cpu:   12-15             99.20                 0.00                 0.00                 0.00
> cpu:   16-19              0.00                 0.00                 0.00                99.00
> cpu:   20-23              0.00                 0.00                 0.00                 0.00
> cpu:   24-27              0.00                 0.00                 0.00                 0.00
> cpu:   28-31              0.00                 0.00                 0.00                 0.00
> cpu:   32-35             99.20                 0.00                 0.00                99.00
> cpu:   36-39             99.20                99.40                99.20                 0.00
> cpu:   40-43              0.00                99.40                99.40                99.20
> cpu:   44-47              0.00                99.40                99.40                99.20
> cpu:   48-51             99.40                 0.00                99.40                99.20
> cpu:   52-55             99.20                 0.00                99.40                99.20
> cpu:   56-59              0.00                 0.00                99.40                99.40
> cpu:   60-63              0.00                 0.00                 0.00                99.00
> cpu:   64-67              0.00                 0.00                 0.00                99.40
> cpu:   68-71              0.00                 0.00                 0.00                99.40
> cpu:   72-75             99.40                 0.00                 0.00                 0.00
> cpu:   76-79             99.40                 0.00                 0.00                 0.00
> ---------------------------------------------------------------------------------------------
> Loaded cpus                  7                    3                    6                   13
>
> Is this the intended behavior of sched autogroup? I'm a bit surprised
> that we are reserving this much cpu bandwidth for very low load
> processes (or interactive processes) in other groups.
>
> So should the sched autogroup config option be turned off by default for server
> system, when we are not concerned about interactivity but want to maximize
> throughput by balancing out the load?
>
> Thanks for clarifying.
>
> Tim
>
>
