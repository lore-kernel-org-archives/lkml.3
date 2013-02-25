Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3BZDKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:10:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35011 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3BZDKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:10:18 -0500
Date: Mon, 25 Feb 2013 08:32:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: False-positive RCU stall warnings on large systems...
Message-ID: <20130225163225.GA3302@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5123A984.4000704@numascale-asia.com>
 <20130219181624.GG3093@linux.vnet.ibm.com>
 <5124449D.3060808@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5124449D.3060808@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022603-2398-0000-0000-0000117C98C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:35:57AM +0800, Daniel J Blueman wrote:
> On 20/02/2013 02:16, Paul E. McKenney wrote:
> >On Wed, Feb 20, 2013 at 12:34:12AM +0800, Daniel J Blueman wrote:
> >>Hi Paul,
> >>
> >>On some of our larger servers with many hundreds of cores and when
> >>under high duress, we can see scheduler RCU stall warnings [1], so
> >>find we have to increase the hardcoded RCU_STALL_RAT_DELAY up from 2
> >>and RCU_JIFFIES_TILL_FORCE_QS up from 3.

Disabling RCU_FAST_NO_HZ will likely remove the need to adjust
RCU_JIFFIES_TILL_FORCE_QS.  Changes in my -rcu tree will likely remove the
need to adjust these two in 3.10 or 3.11, depending on how testing goes.

> >>Is there a more sustainable way to account for this to avoid it
> >>being hard-coded, such as making it and dependent timeouts a
> >>fraction of CONFIG_RCU_CPU_STALL_TIMEOUT?

Maybe...  But what this means is that your system is so heavily loaded
that the CPU in question is failing to make it to RCU's softirq handler
in two jiffies worth of time.  This is a function of workload rather
than of the number of CPUs.

> >>On the other hand, perhaps this is just caused by clock jitter (eg
> >>due to distance from a contended clock source)? So increasing these
> >>a bit may just be adequate in general...
> >
> >Hmmm...  What version of the kernel are you running?
> 
> The example below occurs with v3.8, but we see the same with
> previous kernels eg v3.5.

There is always the rcutree.rcu_cpu_stall_timeout parameter that sets
the stall timeout in seconds.  This may be specified at boot time or
via sysfs at runtime.  The default is now 21 seconds.

> Of course, when using the local TSC, you'd see no jitter relative to
> coherent transactions (eg memory writes), but when the HPET is used
> across a large system, coherent transactions to distant cores are
> just so much faster, as there's massive congestion to the shared
> HPET behind various HT and PCIe bridges. This could be where the
> jitter arises from, if I'm guessing jitter is the problem here.

Agreed, timing jitter could cause problems.  That said, the code uses
the jiffies counter to compute these timings.  Are you seeing similar
memory contention on the jiffies counter itself?

							Thanx, Paul

> Thanks,
>   Daniel
> 
> >>--- [1]
> >>
> >>[ 3939.010085] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> >>(detected by 1, t=29662 jiffies, g=3053, c=3052, q=598)
> >>[ 3939.020008] INFO: Stall ended before state dump start
> -- 
> Daniel J Blueman
> Principal Software Engineer, Numascale Asia
> 

