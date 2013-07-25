Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3GYNa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:30:59 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37979 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3GYNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:30:51 -0400
Date: Thu, 25 Jul 2013 15:30:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, michael@ellerman.id.au, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, rjw@sisk.pl,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 4/5] cpuidle/ppc: CPU goes tickless if there are no
 arch-specific constraints
Message-ID: <20130725133044.GA7400@somewhere>
References: <20130725090016.12500.28888.stgit@preeti.in.ibm.com>
 <20130725090302.12500.42998.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725090302.12500.42998.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 02:33:02PM +0530, Preeti U Murthy wrote:
> In the current design of timer offload framework, the broadcast cpu should
> *not* go into tickless idle so as to avoid missed wakeups on CPUs in deep idle states.
> 
> Since we prevent the CPUs entering deep idle states from programming the lapic of the
> broadcast cpu for their respective next local events for reasons mentioned in
> PATCH[3/5], the broadcast CPU checks if there are any CPUs to be woken up during
> each of its timer interrupt programmed to its local events.
> 
> With tickless idle, the broadcast CPU might not get a timer interrupt till after
> many ticks which can result in missed wakeups on CPUs in deep idle states. By
> disabling tickless idle, worst case, the tick_sched hrtimer will trigger a
> timer interrupt every period to check for broadcast.
> 
> However the current setup of tickless idle does not let us make the choice
> of tickless on individual cpus. NOHZ_MODE_INACTIVE which disables tickless idle,
> is a system wide setting. Hence resort to an arch specific call to check if a cpu
> can go into tickless idle.

Hi Preeti,

I'm not exactly sure why you can't enter the broadcast CPU in dynticks idle mode.
I read in the previous patch that's because in dynticks idle mode the broadcast
CPU deactivates its lapic so it doesn't receive the IPI. But may be I misunderstood.
Anyway that's not good for powersaving.

Also when an arch wants to prevent a CPU from entering dynticks idle mode, it typically
use arch_needs_cpu(). May be that could fit for you as well?

Thanks.
