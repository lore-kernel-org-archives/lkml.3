Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaEPO0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:26:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29892 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaEPO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:26:13 -0400
Message-ID: <53761FDB.10806@oracle.com>
Date: Fri, 16 May 2014 10:25:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthreads: kill CLONE_KERNEL, change kernel_thread(kernel_init)
 to avoid CLONE_SIGHAND
References: <20140413195617.GA31819@redhat.com>
In-Reply-To: <20140413195617.GA31819@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2014 03:56 PM, Oleg Nesterov wrote:
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

Hi Oleg,

This patch triggers a hang during boot in my KVM guest. There are no
messages or anything, it just hangs right before init is supposed to
start up.

I've narrowed it down a bit, and it's the removal of CLONE_SIGHAND
that's bothering it. Removing CLONE_FS and CLONE_FILES doesn't
cause the hang on boot.


Thanks,
Sasha
