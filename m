Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3GRPcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:32:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3GRPcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:32:23 -0400
Date: Thu, 18 Jul 2013 17:27:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] tracing: fix open/delete fixes
Message-ID: <20130718152701.GB6588@redhat.com>
References: <20130716185658.GA21167@redhat.com> <51E6032B.7070907@hitachi.com> <20130717144357.GA7358@redhat.com> <51E7A4CF.2050404@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7A4CF.2050404@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Masami Hiramatsu wrote:
>
> (2013/07/17 23:43), Oleg Nesterov wrote:
> > Once again, I am still not sure and I am asking for your review.
>
> OK,

Good ;)

> > 	- If we kill .open/release, we do not need the nontrivial
> > 	  refcounting. Everything becomes simple, no need to keep
> > 	  the state "in between".
>
> That also means to refrain checking existence under locking mutex
> in all operations.

Speaking of event_enable_write() it needs the same mutex anyway.

> And we have to check it, which I actually concern.
> refcounting is not so small and itself is complex, but it just
> needs to inc/dec on open/close.

And this inc/dec needs event_mutex too, and the code is not trivial.

But yes, sure, I am not saying that it is always a win performance-wise.
In particular, with the patches I sent event/format holds event_mutex
between .start and .stop. But again, this is only to make the patch
simple. We can narrow the scope of this lock, we can switch to i_mutex
(needs the trivial change in invalidate_event_files) which should not
be contended.

And of course, sometimes it is better to do the "hard work" in .open()
and make .read/write as fast/simple as possible. But not in event/*
case, I think.

> > 	- This also simplifies trace_remove_event_call() paths, we
> > 	  know that once it takes event_mutex nobody can play with
> > 	  ftrace_event_file/ftrace_event_call we are going to free.
>
> Hmm, it seems that we can remove only refcount check, or more?

But this check is not necessarily trivial too.

And to remind, personally I do not really like the fact that the
opened file blocks rmdir or unregister_probe_event().



To summarise. I believe that this approach is better (and simpler)
in general. But I understand that "better" is subjective, so I won't
argue. Not to mention, it can be simply wrong so I will heavily rely
on your/Steven's review anyway.

Oleg.

