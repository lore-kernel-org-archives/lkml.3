Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaDNLFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:05:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50575 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaDNLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:05:14 -0400
Date: Mon, 14 Apr 2014 13:05:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthreads: kill CLONE_KERNEL, change
 kernel_thread(kernel_init) to avoid CLONE_SIGHAND
Message-ID: <20140414110504.GH11096@twins.programming.kicks-ass.net>
References: <20140413195617.GA31819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413195617.GA31819@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 09:56:17PM +0200, Oleg Nesterov wrote:
> 1. Remove CLONE_KERNEL, it has no users and it is dangerous.
> 
>    The (old) comment says "List of flags we want to share for kernel
>    threads" but this is not true, we do not want to share ->sighand by
>    default. This flag can only be used if the caller is sure that both
>    parent/child will never play with signals (say, allow_signal/etc).
> 
> 2. Change rest_init() to clone kernel_init() without CLONE_SIGHAND.
> 
>    In this case CLONE_SIGHAND does not really hurt, and it looks like
>    optimization because copy_sighand() can avoid kmem_cache_alloc().
> 
>    But in fact this only adds the minor pessimization. kernel_init()
>    is going to exec the init process, and de_thread() will need to
>    unshare ->sighand and do kmem_cache_alloc(sighand_cachep) anyway,
>    but it needs to do more work and take tasklist_lock and siglock.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Seems good;

Acked-by: Peter Zijlstra <peterz@infradead.org>

I'm thinking the idea was for Andrew to pick this up?
