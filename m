Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab3GSNit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3GSNis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:38:48 -0400
Date: Fri, 19 Jul 2013 15:33:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing
	event_file/call in inode->i_private
Message-ID: <20130719133327.GA21278@redhat.com>
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com> <20130717145148.GB7358@redhat.com> <51E750F4.5070200@hitachi.com> <20130718145137.GA6014@redhat.com> <51E8CCC0.7030404@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E8CCC0.7030404@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Masami Hiramatsu wrote:
>
> (2013/07/18 23:51), Oleg Nesterov wrote:
> > It removes trace_array_get/put from tracing_open_generic_file() and
> > tracing_release_generic_file(). This assumes that "call->flags++" is
> > enough, but it is not.
>
> No, it replaces trace_array_get/put with ftrace_event_file_get/put
> which calls trace_array_get/put inside.

Ah, I didn't notice your patch adds "file->tr->ref++" into
ftrace_event_file_get...

So I was wrong in any case, thanks for correcting me.

But,

> (Just one point, previous ftrace_event_file_get has a racy point
> when it does tr->ref++, it should be fixed.)

Not sure what do you mean, but unless I missed something again this
"tr->ref++" above still looks racy. instance_delete() checks tr->ref
first, then it takes event_mutex and removes/kfrees event_files.

But this doesn't really matter even if I am right, surely this can
be fixed. My only point, imho this is more complex than necessary.

In particular,

> > IOW, I believe that either .open() should do trace_array_get(), or
> > __trace_remove_event_dirs() needs another for-each-file loop which
> > checks file->call->flags & TRACE_EVENT_FL_REF_MASK.
>
> Agreed :)

Yes ;) and this makes the ref-counting even more complex, we use
different methods to avoid the races with rmdir and event_remove().

> > The same bugs which Steven's 1/4 tries to solve ;)
>
> OK, let me confirm that, would you mean we still need 2/4 - 4/4?

Yes, yes.

Oleg.

