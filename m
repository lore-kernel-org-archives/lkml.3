Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab3GRO4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab3GRO4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:56:52 -0400
Date: Thu, 18 Jul 2013 16:51:37 +0200
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
Subject: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing
	event_file/call in inode->i_private
Message-ID: <20130718145137.GA6014@redhat.com>
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com> <20130717145148.GB7358@redhat.com> <51E750F4.5070200@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E750F4.5070200@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Masami Hiramatsu wrote:
>
> (2013/07/17 23:51), Oleg Nesterov wrote:
> > Well, perhaps you are right... But this TRACE_EVENT_FL_REF_MASK code
> > is new too, it is not that we only need a small fixlets to finish it.
>
> Would you mean that TRACE_EVENT_FL_REF_MASK may also have some problems?

It was you who initially pointed that it does have problems ;)

And, _afaics_ your patch which tries to fix this problem is not
exactly correct.

It removes trace_array_get/put from tracing_open_generic_file() and
tracing_release_generic_file(). This assumes that "call->flags++" is
enough, but it is not.

Yes, the next patch adds the "flags & TRACE_EVENT_FL_REF_MASK" check
into trace_remove_event_call() path. But this is still racy wrt
instance_delete() unless I missed something.

IOW, I believe that either .open() should do trace_array_get(), or
__trace_remove_event_dirs() needs another for-each-file loop which
checks file->call->flags & TRACE_EVENT_FL_REF_MASK.


> > So I think that it makes sense to discuss the alternatives before we
> > decide what exactly we should do.
>
> Your approach is also interesting for me, indeed. However, it is so
> different from current one. I think you should clarify what bug you
> would like to solve and how.

The same bugs which Steven's 1/4 tries to solve ;)

Oleg.

