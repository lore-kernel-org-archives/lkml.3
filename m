Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaI0SKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 14:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaI0SKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 14:10:37 -0400
Date: Sat, 27 Sep 2014 20:07:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] fork.c: copy_process(): fix cleanup WRT
	perf_event_free_task()
Message-ID: <20140927180725.GA15594@redhat.com>
References: <20140926210652.GA27199@erable>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926210652.GA27199@erable>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26, Sylvain 'ythier' Hitier wrote:
>
>     retval = sched_fork(clone_flags, p);
>     if (retval)
> //                                      // mustn't perf_event_free_task()
>         goto bad_fork_cleanup_policy;

Agreed, this is wrong. Good catch.

but, unless I missed something,

>     retval = perf_event_init_task(p);
>     if (retval)
> //                                      // mustn't perf_event_free_task()
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

this is not right and thus the patch is not right too.

Suppose that perf_event_init_task() -> perf_event_init_context(ctxn => 0)
succeeds and then perf_event_init_context(ctxn => 1) fails, we need
perf_event_free_task() to cleanup ->perf_event_ctxp[0].

So if perf_event_init_task() fails, we still need "goto bad_fork_cleanup_perf".

No?

Or, probably better, we need to change perf_event_init_context() to call
perf_event_free_task() on failure.

Or. We can simply move memset(child->perf_event_ctxp, 0, ...) from
perf_event_init_context() up. This reminds that we really need to cleanup
copy_process(), in particular I think it asks for the new copy_xxx() helper
which should do misc simple initializations which can't fail.

What do you think?

Oleg.

