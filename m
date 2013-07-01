Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3GATud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab3GATuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:50:32 -0400
Date: Mon, 1 Jul 2013 21:45:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] tracing/kprobes: Don't pass addr=ip to
	perf_trace_buf_submit()
Message-ID: <20130701194555.GA31476@redhat.com>
References: <20130620173811.GA13161@redhat.com> <1372704916.22688.12.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372704916.22688.12.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Steven Rostedt wrote:
>
> On Thu, 2013-06-20 at 19:38 +0200, Oleg Nesterov wrote:
> > kprobe_perf_func() and kretprobe_perf_func() pass addr=ip to
> > perf_trace_buf_submit() for no reason.
> >
> > This sets perf_sample_data->addr for PERF_SAMPLE_ADDR, we already
> > have perf_sample_data->ip initialized if PERF_SAMPLE_IP.
>
> This change log is confusing. I have no idea what this is trying to fix.
> Can you explain what is the issue here and what this change fixes.

Sorry for confusion, this fixes nothing.

Just there is no reason to pass "addr = kp.addr", we report it in entry.

Note also that kprobes is the last user perf_trace_buf_submit(addr != 0),
perhaps we can kill this arg and __perf_addr().

See also 32520b2c6 "Don't pass addr=ip to perf_trace_buf_submit()".

> Thanks,
> 
> -- Steve
> 
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  kernel/trace/trace_kprobe.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > index 3432652..141c682 100644
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -1163,8 +1163,7 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
> >  	entry->ip = (unsigned long)tp->rp.kp.addr;
> >  	memset(&entry[1], 0, dsize);
> >  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> > -	perf_trace_buf_submit(entry, size, rctx,
> > -					entry->ip, 1, regs, head, NULL);
> > +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
> >  }
> >  
> >  /* Kretprobe profile handler */
> > @@ -1197,8 +1196,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
> >  	entry->func = (unsigned long)tp->rp.kp.addr;
> >  	entry->ret_ip = (unsigned long)ri->ret_addr;
> >  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
> > -	perf_trace_buf_submit(entry, size, rctx,
> > -					entry->ret_ip, 1, regs, head, NULL);
> > +	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
> >  }
> >  #endif	/* CONFIG_PERF_EVENTS */
> >  
> 
> 

