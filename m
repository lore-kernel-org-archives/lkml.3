Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaCCSdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:33:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:60558 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752755AbaCCSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:33:32 -0500
Date: Mon, 3 Mar 2014 13:33:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Romain Izard <romain.izard.pro@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: module: Maintain a valid user count
Message-ID: <20140303133330.7031b2cb@gandalf.local.home>
In-Reply-To: <1393870652-7304-1-git-send-email-romain.izard.pro@gmail.com>
References: <1393870652-7304-1-git-send-email-romain.izard.pro@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Mar 2014 19:17:32 +0100
Romain Izard <romain.izard.pro@gmail.com> wrote:

> The replacement of the 'count' variable by two variables 'incs' and
> 'decs' to resolve some race conditions during module unloading was done
> in parallel with some cleanup in the trace subsystem, and was integrated
> as a merge.
> 
> Unfortunately, the formula for this replacement was wrong in the tracing
> code, and the refcount in the traces was not usable as a result.
> 
> Use 'count = incs - decs' to compute the user count.
> 
> Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
> ---
>  include/trace/events/module.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> index 161932737416..1228d963b6d1 100644
> --- a/include/trace/events/module.h
> +++ b/include/trace/events/module.h
> @@ -78,7 +78,8 @@ DECLARE_EVENT_CLASS(module_refcnt,
>  
>  	TP_fast_assign(
>  		__entry->ip	= ip;
> -		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
> +		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) -
> +			__this_cpu_read(mod->refptr->decs);

I know this breaks the 80 column rule, but please keep it on one line.
Look at the above. The line you are removing is much easier to read
than the one you replaced it with.

Or if it is too big, what about:

		__entry->refcnt	=
		  __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);

Thanks,

-- Steve

>  		__assign_str(name, mod->name);
>  	),
>  

