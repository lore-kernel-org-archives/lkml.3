Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695Ab3FTQsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668Ab3FTQsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:48:41 -0400
Date: Thu, 20 Jun 2013 18:43:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130620164355.GA7910@redhat.com>
References: <51BA7578.4080108@huawei.com> <20130614144442.GA1943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614144442.GA1943@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now that we finished the discussion of the similar code in kprobes,
let me summarize.

On 06/14, Oleg Nesterov wrote:
>
> On 06/14, zhangwei(Jovi) wrote:
> >
> > +		rcu_assign_pointer(tu->files, new);
> > +		tu->flags |= TP_FLAG_TRACE;
> > +
> > +		if (old) {
> > +			/* Make sure the probe is done with old files */
> > +			synchronize_sched();
> > +			kfree(old);
> > +		}
> > +	} else
> > +		tu->flags |= TP_FLAG_PROFILE;
>
> So it can set both TP_FLAG_TRACE and TP_FLAG_PROFILE, yes?
>
> If yes, this is not right. Until we change the pre-filtering at least.
> Currently TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually exclusive.

Yes. So please update this patch so that TP_FLAG_PROFILE can't be
set if TP_FLAG_TRACE is set and vice versa.

Once again, this limitation is artificial. But it was always here,
and we need more changes to remove it. I'll try to do this later.
(but if you want to play with this code - welcome ;)

Don't add the mutex, and do not use array-of-pointers (I hope you
noticed the recent discussion).

Locking. Oh, OK. Let it be rcu for now (but please do not forget
that you need rcu_read_lock, uprobe handlers run in the sleepable
context). This is sub-optimal, but this is just another indication
that uprobes API is not perfect, we can't use uprobe->register_sem.

Also. When I was reading trace_kprobes.c I notice the new (and imho
useful) feature, soft disable/enable. Perhaps you can make a 2nd
patch which adds the FTRACE_EVENT_FL_SOFT_DISABLED_BIT check?

Oleg.

