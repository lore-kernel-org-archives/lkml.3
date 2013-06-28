Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3F1OnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:43:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12039 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3F1OnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:43:08 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hiWpaoTxlJ8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PWZO2ReTHSMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=W5DFm9JJLDaVtgCTV0sA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372430586.18733.332.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing/kprobe: Recover old array if fails to enable
 kprobe
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 10:43:06 -0400
In-Reply-To: <20130628142744.GA19278@redhat.com>
References: <51CD25A6.2030907@hitachi.com>
	 <20130628130452.1132.85665.stgit@mhiramat-M0-7522>
	 <20130628142744.GA19278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 16:27 +0200, Oleg Nesterov wrote:
> On 06/28, Masami Hiramatsu wrote:
> >
> > @@ -232,19 +246,21 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
> >  		rcu_assign_pointer(tp->files, new);
> >  		tp->flags |= TP_FLAG_TRACE;
> >  
> > +		ret = __enable_trace_probe(tp);
> > +		if (ret < 0) {
> > +			/* Write back the old list */
> > +			rcu_assign_pointer(tp->files, old);
> > +			old = new;	/* "new" must be freed */
> > +		}
> > +
> >  		if (old) {
> >  			/* Make sure the probe is done with old files */
> >  			synchronize_sched();
> >  			kfree(old);
> >  		}
> 
> Ah, but this conflicts with the other changes I sent. They have
> your acks, and iiuc Steven is going to apply them.

I'll see if I can solve any conflicts. I need to get my -rt versions out
and start on the new 3.6 stable today. Then after that, I plan on going
though and getting all the tracing patches settled.

Thanks,

-- Steve

> 
> Besides, this fix is not complete afaics, we should also clear
> TP_FLAG_TRACE/PROFILE if __enable_trace_probe() fails.
> 
> Perhaps you can do this later, on top of the pending changes?
> 
> Or. Given that this patch assumes that enable_kprobe() must succed,
> can't we make a minimal change for now?
> 
> -------------------------------------------------------------------------------
> [PATCH] tracing/kprobe: WARN() if enable_kprobe() fails.
> 
> enable_trace_probe() doesn't recover tp->files/flags if enable_kprobe()
> fails, this looks confusing.
> 
> However, enable_kprobe() must not fail at this time except for unknown
> bug or changing the implementation of enable_kprobe(), because usual
> failure cases (not registered or gone) are already filtered.
> 
> So this patch simply adds WARN_ON(ret) to document this fact, even if
> it makes sense to cleanup the logic anyway later.
> 
> Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_kprobe.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 5c070db..bb608b5 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -220,6 +220,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
>  			ret = enable_kretprobe(&tp->rp);
>  		else
>  			ret = enable_kprobe(&tp->rp.kp);
> +		WARN_ON(ret);
>  	}
>   out:
>  	return ret;


