Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaDNNvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:51:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22717 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754883AbaDNNvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:51:33 -0400
Date: Mon, 14 Apr 2014 09:51:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthreads: kill CLONE_KERNEL, change
 kernel_thread(kernel_init) to avoid CLONE_SIGHAND
Message-ID: <20140414095131.6ce5bb14@gandalf.local.home>
In-Reply-To: <20140413195617.GA31819@redhat.com>
References: <20140413195617.GA31819@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 21:56:17 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

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
> ---

Looks fine to me.

-- Steve
