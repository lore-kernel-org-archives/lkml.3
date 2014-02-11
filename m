Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaBKP6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:58:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:42940 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBKP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:58:51 -0500
Date: Tue, 11 Feb 2014 16:58:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        peterz@infradead.org, benh@kernel.crashing.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V4 2/3] tick/cpuidle: Initialize hrtimer mode of
 broadcast
In-Reply-To: <52F9F896.4020402@linaro.org>
Message-ID: <alpine.DEB.2.02.1402111654190.21991@ionos.tec.linutronix.de>
References: <20140207075618.17187.20149.stgit@preeti.in.ibm.com> <20140207080632.17187.80532.stgit@preeti.in.ibm.com> <52F9F896.4020402@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Daniel Lezcano wrote:
> On 02/07/2014 09:06 AM, Preeti U Murthy wrote:
> Setting the smp affinity on the earliest timer should be handled automatically
> with the CLOCK_EVT_FEAT_DYNIRQ flag. Did you look at using this flag ?

How should this flag help? Not at all, because the hrtimer based
broadcast device cannot assign affinities.
 
> Another comment is the overall approach. We enter the cpuidle idle framework
> with a specific state to go to and it is the tick framework telling us we
> mustn't go to this state. IMO the logic is wrong, the decision to not enter
> this state should be moved somewhere else.
> 
> Why don't you create a cpuidle driver with the shallow idle states assigned to
> a cpu (let's say cpu0) and another one with all the deeper idle states for the
> rest of the cpus ? Using the multiple cpuidle driver support makes it
> possible. The timer won't be moving around and a cpu will be dedicated to act
> as the broadcast timer.
> 
> Wouldn't make sense and be less intrusive than the patchset you proposed ?

How do you arm the broadcast timer on CPU0 from CPU1? You can't!

You cannot access the cpu local timer on a different cpu. So you would
have to send an IPI over to CPU0 so that it can reevaluate and
schedule the broadcast. That's even more backwards than telling the
cpuidle code that the CPU is not in a state to go deep.

Thanks,

	tglx


