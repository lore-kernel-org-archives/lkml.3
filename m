Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbaKATST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:18:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:47348 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaKATSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:18:18 -0400
Date: Sat, 1 Nov 2014 20:18:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
In-Reply-To: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
Message-ID: <alpine.DEB.2.11.1411012003390.5308@nanos>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Christoph Lameter wrote:
> The reasoning behind this function is not clear to me and removal seems

The comment above the function is clear enough.

> to have a limited impact on the system overall. Even without the
> cap to 1 second the system will be limited by the boundaries on the period
> of interrupts by various devices (in my case I ended up with a 4 second
> interval on x86 because of the limitations of periodicy of the underlying
> interupt source).

And just because it happens to do so on your machine it's not
guaranteed. 
 
> Moreover this artificial limits the impact the benefit that commit
> commit 7cc36bbddde5cd0c98f0c06e3304ab833d662565 (on-demand vmstat workers)
> should be giving us.
> 
> Without this patch timer interrupts will still occur in 1 second intervals
> but no vmstat kworker will run. On a processor where all other

And what has this to do with vmstat kworker? Nothing.

> events have been redirected to other processors nothing will be
> going on just timer interrupts that do not do much.

What the timer interrupt does is very clearly explained in the comment
above the function you want to remove.
 
> With this patch the maximum deferrability of other items will become
> evident and work can then proceed on eliminating those

What about eliminating the requirement for this function first? It's
clear what it does and it's also clear that this can be done remotely
from a housekeeping cpu when the full nohz cpu is busy looping in user
space. The function is there because nobody has tackled that problem
yet.

> (like the 4 second limit that I encountered due to the timing
> limitations of the underlying hardware)

You don't want to tackle the 4 seconds limit of the underlying
hardware. What you really want is to eliminate the [hr]timer which is
preventing the hardware timer to be shutdown completely.

But we care about that _after_ we solved the scheduler tick
requirement because that is the most evident one.

Thanks,

	tglx
