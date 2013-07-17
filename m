Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116Ab3GQXb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:31:28 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49019 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965166Ab3GQXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:31:25 -0400
Date: Thu, 18 Jul 2013 01:31:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130717233119.GA2801@somewhere>
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 06:30:05PM -0700, Paul E. McKenney wrote:
>  }
>  
>  /*
> + * Unconditionally force exit from full system-idle state.  This is
> + * invoked when a normal CPU exits idle, but must be called separately
> + * for the timekeeping CPU (tick_do_timer_cpu).  The reason for this
> + * is that the timekeeping CPU is permitted to take scheduling-clock
> + * interrupts while the system is in system-idle state, and of course
> + * rcu_sysidle_exit() has no way of distinguishing a scheduling-clock
> + * interrupt from any other type of interrupt.
> + */
> +void rcu_sysidle_force_exit(void)
> +{
> +	int oldstate = ACCESS_ONCE(full_sysidle_state);
> +	int newoldstate;
> +
> +	/*
> +	 * Each pass through the following loop attempts to exit full
> +	 * system-idle state.  If contention proves to be a problem,
> +	 * a trylock-based contention tree could be used here.
> +	 */
> +	while (oldstate > RCU_SYSIDLE_SHORT) {

I'm missing a key here.

Let's imagine that the timekeeper has finally set full_sysidle_state = RCU_SYSIDLE_FULL_NOTED
with cmpxchg, what guarantees that this CPU is not seeing a stale RCU_SYSIDLE_SHORT value
for example?
