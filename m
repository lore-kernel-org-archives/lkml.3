Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaAMRGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:06:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbaAMRGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:06:13 -0500
Date: Mon, 13 Jan 2014 18:06:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] lockdep: Kill held_lock->check and "int check" arg
	of __lock_acquire()
Message-ID: <20140113170609.GA9873@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140112094041.GB31809@gmail.com> <20140112174532.GA12147@redhat.com> <20140112174554.GB12147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112174554.GB12147@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Oleg Nesterov wrote:
>
> The "int check" argument of lock_acquire() and held_lock->check
> are misleading and unneeded. This is only used as a boolean, 2
> denotes "true", everything else is "false". And this boolean is
> always equal to prove_locking.
>
> The only exception is __lockdep_no_validate__ which should make
> this condition "false" in validate_chain().

And I missed mark_irqflags(),

> @@ -3136,7 +3130,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  	hlock->holdtime_stamp = lockstat_clock();
>  #endif
>
> -	if (check == 2 && !mark_irqflags(curr, hlock))
> +	if (prove_locking && !mark_irqflags(curr, hlock))
>  		return 0;

This change is not right, at least it is not equivalent.

And I just realized that rcu_lock_acquire() does lock_acquire(check => 1).
Probably we can mark rcu_lock_map's as __lockdep_no_validate__.

Anything else I missed?

Oleg.

