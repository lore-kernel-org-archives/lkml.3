Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaJYTaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:30:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:51009 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJYTaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:30:03 -0400
Date: Sat, 25 Oct 2014 21:29:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Silverman <bsilver16384@gmail.com>
cc: austin.linux@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Darren Hart <darren@dvhart.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task
 death
In-Reply-To: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
Message-ID: <alpine.DEB.2.11.1410252047570.5308@nanos>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Brian Silverman wrote:

First of all. Nice catch!

> pi_state_free and exit_pi_state_list both clean up futex_pi_state's.
> exit_pi_state_list takes the hb lock first, and most callers of
> pi_state_free do too. requeue_pi didn't, which causes lots of problems.

"causes lots of problems" is not really a good explanation of the root
cause. That wants a proper description of the race, i.e.

CPU 0  		   CPU 1
... 		   ....

I'm surely someone who is familiar with that code, but it took me
quite some time to understand whats going on. The casual reader will
just go into brain spiral mode and give up.

> +/**
> + * Must be called with the hb lock held.
> + */

Having that comment is nice, but there is nothing which enforces
it. So we really should add another argument to that function,
i.e. struct futex_hash_bucket *hb and verify that the lock is held at
least when lockdep is enabled.

>  static void free_pi_state(struct futex_pi_state *pi_state)

> @@ -1558,6 +1552,14 @@ retry_private:
>  		ret = get_futex_value_locked(&curval, uaddr1);
>  
>  		if (unlikely(ret)) {
> +			if (flags & FLAGS_SHARED && pi_state != NULL) {

Why is this dependend on "flags & FLAGS_SHARED"? The shared/private
property has nothing to do with that at all, but I might be missing
something.

> +				/*
> +				 * We will have to lookup the pi_state again, so
> +				 * free this one to keep the accounting correct.
> +				 */
> +				free_pi_state(pi_state);
> +				pi_state = NULL;

Instead of copying the same code over and over, we should change
free_pi_state() to handle being called with a NULL pointer.

Thanks,

	tglx
