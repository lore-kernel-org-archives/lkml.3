Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3GHPYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3GHPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:24:45 -0400
Date: Mon, 8 Jul 2013 16:25:33 +0200
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
Message-ID: <20130708142533.GA23749@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <51D56E74.3090404@hitachi.com> <20130704184813.GA2695@redhat.com> <51D6351A.2000206@hitachi.com> <20130705172655.GA18576@redhat.com> <51DA25BF.6000701@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DA25BF.6000701@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08, Masami Hiramatsu wrote:
>
> (2013/07/06 2:26), Oleg Nesterov wrote:
> (Perhaps, uprobes too.)

Sure, uprobes needs all the same fixes, lets ignore it for now.

> >> A safe way is to wait rcu always right after disable_*probe
> >> in disable_trace_probe. If we have an unused link, we can
> >> free it after that.
> >
> > Aaaah... I am starting to understand... Even if kprobe_perf_func()
> > is fine, synchronize_sched() is calles _before_ disable_kprobe()
> > and thus it can't synchronize with the handlers which hit this probe
> > after we start synchronize_sched().
> >
> > Did you mean this or I misssed something else?
>
> Right, thus perf path also need to be synchronized.

kprobe_perf_func() looks fine. This path can't use anything which
can be freed by trace_remove_event_call(). We are going to free
tp / tp->call but only after unregister_kprobe().

Afaics. But even if I am right, I agree it would be safer to not
rely on this and simply do synchronize_sched() after disable as
you suggested.

Thanks,

Oleg.

