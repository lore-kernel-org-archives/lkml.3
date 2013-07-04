Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3GDSxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab3GDSxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:53:10 -0400
Date: Thu, 4 Jul 2013 20:48:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
	event files are open
Message-ID: <20130704184813.GA2695@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <51D56E74.3090404@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D56E74.3090404@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04, Masami Hiramatsu wrote:
>
> (2013/07/04 12:33), Steven Rostedt wrote:
> > +	/* Will fail if probe is being used by ftrace or perf */
> > +	if (unregister_probe_event(tp))
> > +		return -EBUSY;
> > +
> >  	__unregister_trace_probe(tp);
> >  	list_del(&tp->list);
> > -	unregister_probe_event(tp);
> >
> >  	return 0;
> >  }
>
> This may cause an unexpected access violation at kprobe handler because
> unregister_probe_event frees event_call/event_files and it will be
> accessed until kprobe is *completely* disabled.

I don't think so... Please correct me.

(but yes I think the patch needs a small update, see below).

> Actually disable_kprobe() doesn't ensure to finish the current running
> kprobe handlers.

Yes. in fact disable_trace_probe(file != NULL) does, but perf doesn't.

> Thus, even if trace_probe_is_enabled() returns false,
> we must do synchronize_sched() for waiting, before unregister_probe_event().

No, I think we should simply kill trace_probe_is_enabled() here.
And synchronize_sched() _before_ unregister_probe_event() can't
help, exactly because trace_probe_is_enabled() is racy.

> OTOH, unregister_kprobe() waits for that.

Yes.

So I think we only need to move kfree(tp->call.print_fmt). In fact I
already wrote the patch assuming that trace_remove_event_call() will
be changed as we discussed.

So the sequence should be:

	if (trace_remove_event_call(...))
		return;

	/* does synchronize_sched */
	unregister_kprobe();

	kfree(everything);

Agreed?

Oleg.

