Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaEHNFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:05:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:32018 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752756AbaEHNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:05:22 -0400
Date: Thu, 8 May 2014 09:05:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix: tracepoint: use after rcu free
Message-ID: <20140508090520.2b225a94@gandalf.local.home>
In-Reply-To: <1399549669-25465-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1399549669-25465-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 May 2014 07:47:49 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> commit de7b2973903c6cc50b31ee5682a69b2219b9919d
> Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date:   Tue Apr 8 17:26:21 2014 -0400

Hi Mathieu,

Thanks for the quick fix.


> 
>     tracepoint: Use struct pointer instead of name hash for reg/unreg tracepoints
> 
> introduces a use after free by calling release_probes on the old struct

Note when talking about commits already in mainline, use the first 12
characters of the commit sha1 followed by the subject. Like so:

 Commit de7b2973903c "tracepoint: Use struct pointer instead of name
 hash for reg/unreg tracepoints" introduces a use after free ...


> tracepoint array before the newly allocated array is published with
> rcu_assign_pointer. There is a race window where tracepoints (RCU
> readers) can perform a "use-after-grace-period-after-free", which shows
> up as a GPF in stress-tests.
> 
> Link: https://lkml.org/lkml/2014/5/6/738

Also, Link tags need to point to lkml.kernel.org.

Link: http://lkml.kernel.org/r/53698021.5020108@oracle.com

Which is "lkml.kernel.org/r/" followed by the Message-ID.

We can also include a (even though it's redundant)

 Fixes: de7b2973903c "tracepoint: Use struct pointer instead of name hash for reg/unreg tracepoints"

I'll update the change log to reflect my comments and then pull this
into my urgent branch and start testing it.

Thanks,

-- Steve

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Sasha Levin <sasha.levin@oracle.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Dave Jones <davej@redhat.com>
> ---
>  kernel/tracepoint.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index ac5b23c..6620e58 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -188,7 +188,6 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  		WARN_ON_ONCE(1);
>  		return PTR_ERR(old);
>  	}
> -	release_probes(old);
>  
>  	/*
>  	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
> @@ -200,6 +199,7 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  	rcu_assign_pointer(tp->funcs, tp_funcs);
>  	if (!static_key_enabled(&tp->key))
>  		static_key_slow_inc(&tp->key);
> +	release_probes(old);
>  	return 0;
>  }
>  
> @@ -221,7 +221,6 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  		WARN_ON_ONCE(1);
>  		return PTR_ERR(old);
>  	}
> -	release_probes(old);
>  
>  	if (!tp_funcs) {
>  		/* Removed last function */
> @@ -232,6 +231,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  			static_key_slow_dec(&tp->key);
>  	}
>  	rcu_assign_pointer(tp->funcs, tp_funcs);
> +	release_probes(old);
>  	return 0;
>  }
>  

