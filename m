Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3IMQN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:13:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:37637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3IMQN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:13:58 -0400
Date: Fri, 13 Sep 2013 18:13:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
In-Reply-To: <20130913025253.GA17218@Krystal>
Message-ID: <alpine.DEB.2.02.1309131803360.4089@ionos.tec.linutronix.de>
References: <20130913025253.GA17218@Krystal>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> [...]
> > Yep, that's good. I suppose if there's multiple use sites we can jump
> > through another few hoops to get rid of the specific struct foo
> > assumptions by storing sizeof() whatever we do use and playing pointer
> > math games.
> > 
> > But for now with the time stuff as only user this looks ok.
> 
> OK! Here is the full implementation of the idea against Linux
> timekeeper, ntp, and PPS. It appears that ntp and PPS were relying on
> the timekeeper seqlock too. And guess what, after booting my laptop with
> this kernel there still no smoke coming out of it after a good 5 minutes
> of testing. ;-)
> 
> Comments are welcome.

First of all this needs to be split into several patches.

>  static void update_wall_time(void)
 ...
> -	write_seqcount_begin(&timekeeper_seq);
>  	/* Update clock->cycle_last with the new value */
>  	clock->cycle_last = tk->cycle_last;
> -	/*
> -	 * Update the real timekeeper.
> -	 *
> -	 * We could avoid this memcpy by switching pointers, but that
> -	 * requires changes to all other timekeeper usage sites as
> -	 * well, i.e. move the timekeeper pointer getter into the
> -	 * spinlocked/seqcount protected sections. And we trade this
> -	 * memcpy under the timekeeper_seq against one before we start
> -	 * updating.
> -	 */
> -	memcpy(real_tk, tk, sizeof(*tk));
> -	timekeeping_update(real_tk, action);

So you're dropping the timekeeping_update() call here. I wonder how
this works.

> +	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
> +	*tk = *prev;

Do we really need to do the copy on all call sites, instead of doing
it in timekeeper_write_begin() ?

Thanks,

	tglx
