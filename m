Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LPVFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:05:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3LPVFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:05:32 -0500
Date: Mon, 16 Dec 2013 22:05:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
	task->pid and task->tgid
Message-ID: <20131216210558.GA8565@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com> <20130822190848.GA25053@redhat.com> <20130826220711.GA21098@madcap2.tricolour.ca> <20131216173547.GA21582@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216173547.GA21582@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Sorry, I already forgot the context, not sure I understand your email
correctly.

On 12/16, Richard Guy Briggs wrote:
> On 13/08/26, Richard Guy Briggs wrote:
> > On Thu, Aug 22, 2013 at 09:08:48PM +0200, Oleg Nesterov wrote:
> > > On 08/20, Richard Guy Briggs wrote:
> > > >
> > > >  static inline int is_global_init(struct task_struct *tsk)
> > > >  {
> > > > -	return tsk->pid == 1;
> > > > +	return task_pid_nr(tsk) == 1;
> > > >  }
> > >
> > > Probably it would be better to simply kill it. Almost every usage is
> > > wrong.
> >
> > Can you be more clear?  I don't follow.  It should instead return a
> > boolean.  Usage of is_global_init() or task_pid_nr()?
> >
> > If is_global_init(), is that because they could be unaware of pid
> > namespaces?
> >
> > If task_pid_nr(), is that for the same reason?
>
> Oleg,  I still don't understand your comment above.  Kill what,
> "is_global_init()"?  If so, how is almost every usage of it wrong?

Because is_global_init() is only true for the main thread of /sbin/init.

Just look at oom_unkillable_task(). It tries to not kill init. But, say,
select_bad_process() can happily find a sub-thread of is_global_init()
and still kill it.

> There are a number of functions that call is_global_init().  Might any
> of them be called from inside the namespace context of a container and
> hence should return true?

Not sure I understand, but certainly some callers should check ->child_reaper
or SIGNAL_UNKILLABLE instead. Say, unhandled_signal().

> > > >  static inline bool is_idle_task(const struct task_struct *p)
> > > >  {
> > > > -	return p->pid == 0;
> > > > +	return task_pid(p) == &init_struct_pid;
> > > >  }
> > >
> > > hmm. there should be a simpler check for this...
> >
> > Other than the original, this one is pretty simple.  What did you have
> > in mind?
>
> I vaguely remember a clarification to this, but don't remember and can't
> find it.  What sort of simplification did you have in mind?

I do not remember ;) Most probably, I meant "it would be nice to find a
simpler check".

Oleg.

